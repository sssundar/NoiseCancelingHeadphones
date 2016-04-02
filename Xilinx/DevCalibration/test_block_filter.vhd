-- test_block_filter.vhd         			       
--
-- Operation
--  I wrote a function that generated sinusoidal input of fixed frequency relative to the simulated global clock frequency.
--  I wrote a function that simulated an FIR filter (a time delay) acting on the output from the filter as it travelled to the ear.
--  I wrote a function that simulated an FIR filter (a time delay) acting on the input to the filter as it traveled to the ear.
--  Then, I ran the filter block forward in time, simply passing inputs and calculating 'error' as input + output at the ear.
--  I let the filter block process this stream and update the filter roughly 400 times.

-- Normally a block testbench would be based on fixed inputs/outputs, or at least a s/w implementation with assertions.
-- However, I intentionally unit-tested each part of the filter block and various interconnections, before this point. 
-- This testbench was therefore designed as a visual aid, to let me see the filter-flow and look for oddities. 
-- It helped me unearthed one logic bug in the one interface I had not connected in isolation beforehand (see revision history).

-- Sanity Checks --
-- If I do not let the filter block update from its reset state, the error is just a shifted version of the input (for the simulated delay filter)
-- Well before a new trigger, every FSM is already waiting (timing estimates & clock counts for filter block correct).
-- Initially, when all filters  update from 0, they're very, very small on the order of 2^-8. If inputs are not in this range, the accumulator (and output) are 0 or 128 (level shifted 0).
-- The residual update adds the absolute value of the error input
-- When updating a filter the filter with the lowest residual is taken (for s/w generated inputs, errors).
-- When stepping through the filter update works as designed - only after the filter is copied to the convolution block do the working coefficients update.
-- Coefficient/Input multiplication works as expected - exactly the right number of shifts, and shift-multiplication stops exactly when designed. Negation also works as expected.
-- Finally, the accumulator, taken step-by-step through an entire multiply-accum cycle, was arithmetically correct. 

-- Conclusion --
-- In light of unit tests preceding this testbench, and given that all the sanity checks passed, and I am confident that the filter-block matches my design.

--  Revision History:
--     29 Sep 2015 Sushant Sundaresh created testbench.
--     29 Sep 2015 Sushant Sundaresh found bug in interface between convolution filter coefficient/history registers. missed because unit tested separately.
--     30 Sep 2015 Sushant Sundaresh still noticing the weird 'array elements turn to U' issue but I've tested this in earlier testbenches and I'm confident it's an artifact.
--     30 Sep 2015 Sushant Sundaresh all tests passed. 

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;   
use IEEE.MATH_REAL.all; 
use WORK.MAGIC_NUMBERS.all;

entity test_block_filter is
end test_block_filter;

architecture test_block_filter_pair_TbArch of test_block_filter is

	component block_filter_pair
		 port (
			-- Inputs -- 
			-- active high control signals
			reset : in std_logic;
			sys_clk : in std_logic;
			may_update_filter : in std_logic;
			trigger_convolution : in std_logic;
			
			-- ADC output register
			left_mic_sample_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));
			left_mic_error_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));		
			right_mic_sample_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));
			right_mic_error_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));		
			-- End Inputs -- 
			
			-- Outputs --
			-- DAC input register
			left_spk_dac_input : out std_logic_vector(0 to (ADC_DATA_BITS-1));		
			right_spk_dac_input : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			-- End Outputs -- 
			
			-- Test Outputs: leave open --
			left_best_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			right_best_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			left_working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			right_working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY				
		 );
	end component;
	
	component kBitCounter
		generic (
			k : integer := 3 							
		);
		port (	
			sys_clk : in std_logic; 				
			clear : in std_logic; 					
			run : in std_logic; 						
			count : out std_logic_vector(0 to (k-1));
			finalCarry : out std_logic 					
		);
	end component;
	 
	 
	signal sys_clk : std_logic; 	 
	signal END_SIM : BOOLEAN := FALSE;
	
	-- Test these for equivalence and noise-canceling effectiveness in Matlab
	signal left_best_coeffs : COEFFICIENT_REGISTER_ARRAY;
	signal right_best_coeffs : COEFFICIENT_REGISTER_ARRAY;
	signal left_working_coeffs : COEFFICIENT_REGISTER_ARRAY;
	signal right_working_coeffs : COEFFICIENT_REGISTER_ARRAY;
	
	-- Test these for equivalence
	signal left_filter_out : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal right_filter_out : std_logic_vector(0 to (ADC_DATA_BITS-1));
	
	-- Generated by kBitCounter
	signal trigger_convolution : std_logic;
	
	-- Control Signals Available to Testbench
	signal reset : std_logic;
	signal may_update_filter : std_logic;
	signal mic_sample_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal mic_error_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));
	
	-- Sample Counter Timing - bits required in kBitCounter to trigger at roughly 40KHz from a 20MHz base clock (1/500 division).
	constant SAMPLING_40KHz_TRIGGER_BITS : integer := 9; -- 2^9 = 512
	
	--------------------------------
	-- Simulated Headphone System --
	--------------------------------
	subtype ADCData is std_logic_vector(0 to (ADC_DATA_BITS-1));
	-- Simulated output filter is a time delay of 8 samples. Index 0 is latest, 7 is at the target.
	constant OUTPUT_SAMPLE_MEMORY : integer := 8;
	type SIM_OUTPUT_HISTORY is array (0 to (OUTPUT_SAMPLE_MEMORY-1)) of ADCData; 
	-- Simulated input filter is a time delay of 10 samples. Index 0 is the latest, 9 is at the target.
	constant INPUT_SAMPLE_MEMORY : integer := 10;
	type SIM_INPUT_HISTORY is array (0 to (INPUT_SAMPLE_MEMORY-1)) of ADCData; 
	
	function updateOutputHistory (outputHistory : SIM_OUTPUT_HISTORY; newOutput : ADCData ) return SIM_OUTPUT_HISTORY is 		
		variable temp : SIM_OUTPUT_HISTORY;
	begin
		for i in 0 to (OUTPUT_SAMPLE_MEMORY-2) loop
			temp(i+1) := outputHistory(i);
		end loop;
		-- subtract 2^(ADC_DATA_BITS-1) to remove DC component of this output (speaker would do this)
		if (newOutput(0) = '1') then
			temp(0) := '0' & newOutput(1 to (ADC_DATA_BITS-1));
		else 
			temp(0) := '1' & newOutput(1 to (ADC_DATA_BITS-1));
		end if;
		return temp;
	end updateOutputHistory;   
	
	function updateInputHistory (inputHistory : SIM_INPUT_HISTORY; newInput : ADCData ) return SIM_INPUT_HISTORY is 		
		variable temp : SIM_INPUT_HISTORY;
	begin
		for i in 0 to (INPUT_SAMPLE_MEMORY-2) loop
			temp(i+1) := inputHistory(i);
		end loop;
		temp(0) := newInput;
		return temp;
	end updateInputHistory;  	
	
	-- Takes a simulation time in nanoseconds, and returns a signed integer value in -2^(ADC_DATA_BITS-1) to +2^(ADC_DATA_BITS-1)-1, as a std_logic_vector.
	function getInputAtExternalMic (simTime : integer) return ADCData is		
		-- Hz1 = 400 Hz -> roughly 1/100 our trigger rate
		-- Hz2 = 4000 Hz -> roughly 1/10 our trigger rage
		-- sin(2 pi f t) so if f = 400/s -> 4E-7 / ns and t = ns
		constant frequency1 : real := Real(4)/Real(1000000);		
		constant amplitude1 : real := Real(63.9);
		constant frequency2 : real := Real(4)/Real(10000000);
		constant amplitude2 : real := Real(62.9);				
		 
		variable result : integer; 	
		variable output : ADCData;
	begin
		result := Integer(ROUND(amplitude1 * sin(Real(2) * MATH_PI * frequency1 * Real(simTime)) + amplitude2 * sin(Real(2) * MATH_PI * frequency2 * Real(simTime)))); 		
		output := std_logic_vector(to_signed(result, output'length));		
		return output; 
	end getInputAtExternalMic;   
		
	function getError (outputHistory : SIM_OUTPUT_HISTORY; inputHistory : SIM_INPUT_HISTORY ) return ADCData is		
		variable outAtEar : ADCData;
		variable inAtEar : ADCData;
		variable result : integer;
	begin
		outAtEar := outputHistory(OUTPUT_SAMPLE_MEMORY-1);
		inAtEar := inputHistory(INPUT_SAMPLE_MEMORY-1);
		result := to_integer(signed(outAtEar)) + to_integer(signed(inAtEar));
		if ( result > 2**(ADC_DATA_BITS-1)-1 ) then 
			return "0" & (1 to (ADC_DATA_BITS-1) => '1');
		elsif ( result < -2**(ADC_DATA_BITS-1) ) then
			return "1" & (1 to (ADC_DATA_BITS-1) => '0');
		else 
			return std_logic_vector(to_signed(result,inAtEar'length));
		end if;				
	end getError;   	 

begin
	
	UUT: block_filter_pair
		 port map (			
			reset => reset,
			sys_clk => sys_clk, 
			may_update_filter => may_update_filter, 
			trigger_convolution => trigger_convolution,			
			left_mic_sample_adc_output => mic_sample_adc_output,
			left_mic_error_adc_output => mic_error_adc_output,
			right_mic_sample_adc_output => mic_sample_adc_output,
			right_mic_error_adc_output => mic_error_adc_output,
			left_spk_dac_input => left_filter_out,
			right_spk_dac_input => right_filter_out,				
			left_best_filter_coefficients => left_best_coeffs,
			right_best_filter_coefficients => right_best_coeffs,
			left_working_filter_coefficients => left_working_coeffs,
			right_working_filter_coefficients => right_working_coeffs
		 );
		
	sampleCounter: kBitCounter
		generic map ( k => SAMPLING_40KHz_TRIGGER_BITS )
		port map (	
			sys_clk => sys_clk,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => trigger_convolution
			);
		
	process	
		constant triggerCountLimit : integer := 400; 
		variable triggerCount : integer := 0;
		variable inputHistory : SIM_INPUT_HISTORY;
		variable outputHistory : SIM_OUTPUT_HISTORY;
	begin  
		-- Reset Block State
		reset <= '1';		
		wait for 50 ns;
		reset <= '0';

		-- Clear input history and output history
		for i in 0 to (INPUT_SAMPLE_MEMORY-1) loop
			inputHistory(i) := (0 to (ADC_DATA_BITS-1) => '0');
		end loop;
		for i in 0 to (OUTPUT_SAMPLE_MEMORY-1) loop
			outputHistory(i) := '1' & (1 to (ADC_DATA_BITS-1) => '0'); 	-- make it maximal so we don't set the error for the cleared coeff state as very low. in reality error here would not be low.
		end loop;
		
		mic_sample_adc_output <= (0 to (ADC_DATA_BITS-1) => '0');
		mic_error_adc_output <= '1' & (1 to (ADC_DATA_BITS-1) => '0');  -- make it maximal so we don't set the error for the cleared coeff state as very low. in reality error here would not be low.
		may_update_filter <= '0';
		
		-- Keep idle via may_update_filter to allow the LFSR to relax 
		wait for 50000 ns;
		may_update_filter <= '1';	 
		
		while (triggerCount < triggerCountLimit) loop
			wait until (rising_edge(sys_clk) and (trigger_convolution = '1'));
			mic_error_adc_output <= getError(outputHistory, inputHistory);			
			inputHistory := updateInputHistory (inputHistory, getInputAtExternalMic(now / 1 ns));
			outputHistory := updateOutputHistory (outputHistory, left_filter_out);
			mic_sample_adc_output <= inputHistory(0);
			
			triggerCount := triggerCount + 1;							
			
			wait for 5 ns;			
		end loop;						
		
		for i in 0 to (FILTER_FIR_LENGTH-1) loop			
         report "left_best_coeffs("&integer'image(i)&") = "&integer'image(to_integer(unsigned(left_best_coeffs(i))));						
      end loop; 
	
		END_SIM <= TRUE;
		wait;

	end process;

    
	Clock_ArbSpeed : process	
	begin
		if END_SIM = FALSE then
			sys_clk <= '0';
			wait for 25 ns;
		else
			wait;
		end if;

		if END_SIM = FALSE then
			sys_clk <= '1';
			wait for 25 ns;
		else
			wait;
		end if;
	end process;


end test_block_filter_pair_TbArch; 
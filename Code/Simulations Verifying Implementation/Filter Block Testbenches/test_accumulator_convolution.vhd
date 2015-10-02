-- test_accumulator_convolution.vhd         			       
--
-- This testbench unit tests the filter accumulator, and output register level shifting/truncation logic.
--
--  Revision History:
--     27 Sep 2015 Sushant Sundaresh created testbench.
--     27 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.
--

-- IEEE library
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_accumulator_convolution is
end test_accumulator_convolution;

architecture test_accumulator_convolution_TbArch of test_accumulator_convolution is

	component accumulator_convolution is
	 port(	  
			sys_clk : in std_logic;
			product : in std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1));
			accumulate : in std_logic;
			clear_accumulator : in std_logic;
			clear_output_register : in std_logic;
			write_output_register : in std_logic;			
			register_filter_output : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			accumulator_state : out std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1))
		  );                                               
	end component;
    	
	signal clock : std_logic; 
	signal product : std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1));
	signal accumulate : std_logic;
	signal clear_accumulator : std_logic;
	signal clear_output_register : std_logic;
	signal write_output_register : std_logic;			
	signal register_filter_output : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal accumulator_state : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1));
	 	 
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
	ACCUM: accumulator_convolution
	port map (
		sys_clk => clock,
		product => product,
		accumulate => accumulate, 
		clear_accumulator => clear_accumulator, 
		clear_output_register => clear_output_register,
		write_output_register => write_output_register, 
		register_filter_output => register_filter_output, 
		accumulator_state => accumulator_state
	); 
    
    
	process		
	begin  		
		accumulate <= '0';
		write_output_register <= '0';
		
		-- Clear registers, check.
		clear_accumulator <= '1';
		clear_output_register <= '1';			
		wait for 100 ns;
		clear_accumulator <= '0';
		clear_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Clear failed"
			severity  ERROR; 
		
		-- Set input to +1, Accumulate
		accumulate <= '1';
		product <= (0 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & product) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Add +1 failed"
			severity  ERROR; 
		
		-- Set input to -1, Accumulate
		accumulate <= '1';
		product <= (0 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Add -1 failed"
			severity  ERROR; 

		-- Accumulator is at 0. Set input to 1-2^(ADC_DATA_BITS-1), accumulate, then write output register.
		accumulate <= '1';
		write_output_register <= '0';
		product <= '1' & (1 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS => '1') & (1 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0') ) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-2) => '0') & '1'))
			report  "Add 1-2^(ADC_DATA_BITS-1) failed"
			severity  ERROR; 
	
		-- Accumulator is at 1-2^(ADC_DATA_BITS-1) Set input to 2^(ADC_DATA_BITS-1)-1, accumulate (should be 0), then write output register (should be 2^(ADC_DATA_BITS-1))
		accumulate <= '1';
		write_output_register <= '0';
		product <= '0' & (1 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, '1' & (1 to (ADC_DATA_BITS-1) => '0')))
			report  "Add 2^(ADC_DATA_BITS-1)-1 failed"
			severity  ERROR; 
			
			
		-- Accumulator is at 0. Set input to 2^(ADC_DATA_BITS-1)-1, accumulate, then write output register (should be 2^(ADC_DATA_BITS)-1)
		accumulate <= '1';
		write_output_register <= '0';
		product <= '0' & (1 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & product) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '1')))
			report  "Add 2^(ADC_DATA_BITS-1)-1 (second time) failed"
			severity  ERROR; 
		
		-- Accumulator is at 2^(ADC_DATA_BITS-1)-1. Set input to +1, accumulate, then write output register (should be 2^(ADC_DATA_BITS)-1, an overflow truncation).
		accumulate <= '1';
		write_output_register <= '0';
		product <= '0' & (1 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '1' & (1 to (ADC_DATA_BITS-1) => '0') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '1')))
			report  "Add +1 (second time) failed"
			severity  ERROR; 
		
		-- Clear acc, not output register, check.
		clear_accumulator <= '1';
		clear_output_register <= '0';			
		wait for 100 ns;
		clear_accumulator <= '0';
		clear_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '1')))
			report  "Acc Clear, Out Hold failed"
			severity  ERROR; 
		
		-- Clear acc and output register, check.
		clear_accumulator <= '1';
		clear_output_register <= '1';			
		wait for 100 ns;
		clear_accumulator <= '0';
		clear_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Acc Clear, Out Clear failed"
			severity  ERROR; 		
			
		-- Set input to -2^(ADC_DATA_BITS-1). Add. Set input to -1. Add.  Accumulator is -129, Write out : is it 0, negative truncation?
		accumulate <= '1';
		write_output_register <= '0';
		product <= '1' & (1 to (ADC_DATA_BITS-1) => '0') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		product <= (0 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '1') & '0' & (1 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Accumulate to -2^(ADC_DATA_BITS-1)-1 and negative underflow truncation failed"
			severity  ERROR; 		
		
		-- Clear acc and output register, check.
		clear_accumulator <= '1';
		clear_output_register <= '1';			
		wait for 100 ns;
		clear_accumulator <= '0';
		clear_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0')) and std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Acc Clear, Out Hold failed"
			severity  ERROR; 
			
		-- Input 1/2 and accumulate. Check that output is written as 128. Then add 1/2 to make sure fractions aren't being tossed entirely. Output should now be 129.
		accumulate <= '1';
		write_output_register <= '0';
		product <= (0 to (ADC_DATA_BITS-1) => '0') & '1' & (1 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;		
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & product) and std_match(register_filter_output, '1' & (1 to (ADC_DATA_BITS-1) => '0')))
			report  "Fractional truncation by level-shifter failed."
			severity  ERROR; 		
		accumulate <= '1';
		product <= (0 to (ADC_DATA_BITS-1) => '0') & '1' & (1 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
		wait for 100 ns;		
		accumulate <= '0';
		write_output_register <= '1';
		wait for 100 ns;
		write_output_register <= '0';
		assert (std_match(accumulator_state, (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(register_filter_output, '1' & (1 to (ADC_DATA_BITS-2) => '0') & '1'))
			report  "Fractional truncation by level-shifter failed (second attempt)"
			severity  ERROR; 	
		END_SIM <= TRUE;
		wait;

	end process; -- end of stimulus process
	 
	 
	 
	CLOCK_clk : process

	begin

	  -- this process generates a 100 ns period, 50% duty cycle clock

	  -- only generate clock while still have stimulus vectors

	  if END_SIM = FALSE then
			clock <= '0';
			wait for 50 ns;
	  else
			wait;
	  end if;

	  if END_SIM = FALSE then
			clock <= '1';
			wait for 50 ns;
	  else
			wait;
	  end if;

	end process;    -- end of clock process


end test_accumulator_convolution_TbArch; 



configuration TESTBENCH_FOR_test_accumulator_convolution of test_accumulator_convolution is
    for test_accumulator_convolution_TbArch
        for ACCUM : accumulator_convolution
           use entity work.accumulator_convolution(dataflow);
        end for;		  
    end for;
end TESTBENCH_FOR_test_accumulator_convolution;

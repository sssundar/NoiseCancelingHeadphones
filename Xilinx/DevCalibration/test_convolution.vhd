-- test_convolution.vhd         			       
--
-- This testbench unit brings together the pieces of our filter-convolution block (accumulator, input/filter copies for shift-multiplication, multiply/accumulate fsms)
-- It does not test them exhaustively. It is just a sanity check as a prelude to the thorough, computer-generated system test.
-- 
-- This testbench currently requires ADC_DATA_BITS >= 8 and FILTER_COEFFICIENT_BITS >= 9.
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

entity test_convolution is
end test_convolution;

architecture test_convolution_TbArch of test_convolution is

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
	
	component fsm_convolution is
    port (
		reset : in std_logic; -- active high
		sys_clk : in std_logic; -- active high edge		

      trigger_convolution : in std_logic; -- active high			
		
		multiply_shift_request : out std_logic; -- active high
		multiply_negate_request : out std_logic; -- active high
		trigger_fsm_filter_update : out std_logic; -- active high
		accumulator_shift_request : out std_logic; -- active high
		accumulator_clear_request : out std_logic; -- active high
		accumulate_add_request : out std_logic; -- active high
		write_output_register_request : out std_logic -- active high
    );
	end component;
    
	component register_convolution_input is
    port(	  
			reset : in std_logic; 							-- active high clear to '0's
			sys_clk : in std_logic; 						-- clock input
			
			load_sample : in std_logic;  					-- active high, load a sample from the input history register block. must clear register beforehand.
			load_data : in std_logic_vector(0 to (ADC_DATA_BITS-1)); 
			
			shift_to_accumulator : in std_logic; 		-- active high, shift without sign extension using serial input for MSB.
			serial_in : in std_logic; 						-- shift input from the left for shift_to_accumulator cycles.			
			serial_out : out std_logic;				 	-- shift output to the right for shift_to_accumulator cycles.			
			
			shift_to_multiply : in std_logic; 			-- active high, local right shift with sign extension at MSB, if filter coefficient multiplying is not zero.			
			load_negation : in std_logic;	 				-- active high, negate own contents (only guaranteed without overflow after a shift_to_multiply cycle)
			filterCoefficientIsZero : in std_logic; 	-- active high, flag from linked filter coefficient entity			
			
			register_state : out std_logic_vector(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1));
			sign_bit : out std_logic 						-- to help external logic calculate whether we should negate ourselves
        );                                               
	end component;
	
	component register_convolution_filter_coefficient is
    port(	  
			sys_clk : in std_logic;										
			
			load_req : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			is_load_data_zero : in std_logic;
			
			shift_req : in std_logic; 
			negate_req : in std_logic;

			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic;
			shift_input : out std_logic;
			negate_input : out std_logic
        );                                               
	end component;
	
	
	-- accumulator control signals	
	signal register_filter_output : std_logic_vector(0 to (ADC_DATA_BITS-1));	
	signal product : std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1));
	
	-- fsm control signals, active high
	signal reset : std_logic;
	signal trigger_convolution : std_logic;
	signal multiply_shift_request : std_logic; 
	signal multiply_negate_request : std_logic;
	signal accumulator_shift_request : std_logic;
	signal accumulator_clear_request : std_logic;
	signal accumulate_add_request : std_logic; 
	signal write_output_register_request : std_logic; 
	
	-- input history control signals
	signal load_input_data : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal load : std_logic;
	signal serial_ins : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
	signal reset_history : std_logic;
	
	-- coefficient control signals
	signal load_filter_data : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));	
	signal is_load_data_zero : std_logic;
	signal coef0, shiftctrl, negctrl : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));	
	
	-- clock signal
	signal clock : std_logic; 
	-- Signal used to stop clock signal generators
	signal END_SIM : BOOLEAN := FALSE;


begin
	
	ACCUM: accumulator_convolution
	port map (
		sys_clk => clock,
		product => product,
		accumulate => accumulate_add_request, 
		clear_accumulator => accumulator_clear_request, 
		clear_output_register => '0', 
		write_output_register => write_output_register_request, 
		register_filter_output => register_filter_output, 
		accumulator_state => open
	); 
   
	FSM: fsm_convolution
   port map (
		reset => reset, 
		sys_clk => clock, 
      trigger_convolution => trigger_convolution, 
		multiply_shift_request => multiply_shift_request, 
		multiply_negate_request => multiply_negate_request,
		trigger_fsm_filter_update => open, 
		accumulator_shift_request => accumulator_shift_request,
		accumulator_clear_request => accumulator_clear_request,
		accumulate_add_request => accumulate_add_request, 
		write_output_register_request => write_output_register_request
    );	
	
	InHistoryFinal: register_convolution_input 
	port map (
		reset => reset_history,
		sys_clk => clock,
		
		load_sample => load,
		load_data => load_input_data, 
		
		shift_to_accumulator => accumulator_shift_request,
		serial_in => serial_ins(FILTER_FIR_LENGTH-1),
		serial_out => open,
		
		shift_to_multiply => shiftctrl(FILTER_FIR_LENGTH-1),
		load_negation => negctrl(FILTER_FIR_LENGTH-1),
		filterCoefficientIsZero => coef0(FILTER_FIR_LENGTH-1),
		
		register_state => product,
		sign_bit => open
	);	
	IncrementorGen:
	for i in 1 to (FILTER_FIR_LENGTH-2) generate
	  InHistoryX: register_convolution_input 
		port map (
			reset => reset_history,
			sys_clk => clock,
			
			load_sample => load,
			load_data => load_input_data, 
			
			shift_to_accumulator => accumulator_shift_request,
			serial_in => serial_ins(i),
			serial_out => serial_ins(i+1),
			
			shift_to_multiply => shiftctrl(i),
			load_negation => negctrl(i),
			filterCoefficientIsZero => coef0(i),
			
			register_state => open,
			sign_bit => open
		);
	end generate;	 
	InHistoryFirst: register_convolution_input 
	port map (
		reset => reset_history,
		sys_clk => clock,
		
		load_sample => load,
		load_data => load_input_data, 
		
		shift_to_accumulator => accumulator_shift_request,
		serial_in => '0',
		serial_out => serial_ins(1),
		
		shift_to_multiply => shiftctrl(0),
		load_negation => negctrl(0),
		filterCoefficientIsZero => coef0(0),
		
		register_state => open,
		sign_bit => open
	);	
	
	
	CoeffGen:
	for i in 0 to (FILTER_FIR_LENGTH-1) generate
	  CoeffX: register_convolution_filter_coefficient 
		port map ( 
			sys_clk => clock, 
			
			load_req => load, 
			load_data => load_filter_data,
			is_load_data_zero => is_load_data_zero,
			
			shift_req => multiply_shift_request,
			negate_req => multiply_negate_request,

			coefficient => open,
			coefficientIsZero => coef0(i),
			shift_input => shiftctrl(i),
			negate_input => negctrl(i)
	  );       
	end generate;	 
	
	 
	process		
		constant totalClocksRequiredForConvolution : integer := 1+ (FILTER_COEFFICIENT_BITS-1) + 2 + 1 + ((FILTER_FIR_LENGTH-1)*(FILTER_CONVOLUTION_ACCUMULATE_SHIFT_COUNTER_TARGET+2)) + 1 + 2; -- counting up FSM state trantisions until convolution terminates (clocks) 
		constant totalDelay : time := totalClocksRequiredForConvolution * 100 ns; -- ns per clock		 	
	begin  		
		
		reset <= '0';	
		reset_history <= '0';
		load_filter_data <= (0 to (FILTER_COEFFICIENT_BITS-1) => '0');
		is_load_data_zero <= '1';
		load_input_data <= (0 to (ADC_DATA_BITS-1) => '0');
		load <= '0';
		trigger_convolution <= '0';
		
		reset <= '1';
		reset_history <= '1';
		wait for 100 ns;
		reset <= '0';
		reset_history <= '0';
				
		-- Load Common Input, Filter: +2^(ADC_DATA_BITS-1)-1, +0.5		
		load_input_data <= '0' & (1 to (ADC_DATA_BITS-1) => '1');
		load_filter_data <= '0' & '1' & (2 to (FILTER_COEFFICIENT_BITS-1) => '0');
		is_load_data_zero <= '0';		
		load <= '1';
		trigger_convolution <= '1';		
		wait for 100 ns;
		load <= '0';
		trigger_convolution <= '0';			
		wait for totalDelay;
		
		assert (std_match(register_filter_output, (0 to (ADC_DATA_BITS-1) => '1')))
			report  "First Convolution Overflow Test Failed"
			severity  ERROR; 
	
		-- Load Common Input, Filter: -2^(ADC_DATA_BITS-1), -1/64
		load_input_data <= '1' & (1 to (ADC_DATA_BITS-1) => '0');
		load_filter_data <= '1' & "000001" & (7 to (FILTER_COEFFICIENT_BITS-1) => '0');
		is_load_data_zero <= '0';		
		load <= '1';
		trigger_convolution <= '1';		
		wait for 100 ns;
		load <= '0';
		trigger_convolution <= '0';			
		wait for totalDelay;
		
		assert (std_match(register_filter_output, "11" & (2 to (ADC_DATA_BITS-1) => '0')))
			report  "Second Convolution Test Failed"
			severity  ERROR; 
	

		END_SIM <= TRUE;
		wait;

	end process; -- end of stimulus process
	 
	 
	 
	CLOCK_clk : process

	begin

	  -- this process generates a 10 MHz, 100 ns period, 50% duty cycle clock

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


end test_convolution_TbArch; 
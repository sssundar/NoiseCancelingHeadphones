-- test_register_convolution_input.vhd         			       
--
-- This testbench unit tests the convolution input register clear, parallel load, accumulator-shift, multiplier-shift, negation, and misc. control flags.
-- It assumes FILTER_SHIFT_MULTIPLIER_PRECISION_BITS = 3.
--
--  Revision History:
--     24 Sep 2015 Sushant Sundaresh created testbench.
--     25 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_register_convolution_input is
end test_register_convolution_input;

architecture test_register_convolution_input_TbArch of test_register_convolution_input is

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


    -- Stimulus signals - signals mapped to the input and inout ports of tested entity   	
	 signal clock : std_logic; 
	 signal reset : std_logic;
    signal load_sample : std_logic;
	 signal shift_to_accumulator : std_logic;
	 signal shift_to_multiply : std_logic;
	 signal load_negation : std_logic;
	 signal filterCoefficientIsZero : std_logic;
	 signal serial_middle, serial_ignore : std_logic;
	 signal sample_1, sample_2 : std_logic_vector(0 to (ADC_DATA_BITS-1));
	 signal output_1, output_2 : std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1)); 
	 signal sign_bit_1, sign_bit_2 : std_logic;
	
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    REG1: register_convolution_input
    port map (	  
			reset => reset,
			sys_clk => clock,
			load_sample => load_sample,
			load_data => sample_1,		
			shift_to_accumulator => shift_to_accumulator,
			serial_in => '0',
			serial_out => serial_middle,			
			shift_to_multiply => shift_to_multiply,
			load_negation => load_negation,
			filterCoefficientIsZero => filterCoefficientIsZero,
			register_state => output_1,
			sign_bit => sign_bit_1
        );    

    REG2: register_convolution_input
    port map (	  
			reset => reset,
			sys_clk => clock,
			load_sample => load_sample,
			load_data => sample_2,		
			shift_to_accumulator => shift_to_accumulator,
			serial_in => serial_middle,
			serial_out => serial_ignore,			
			shift_to_multiply => shift_to_multiply,
			load_negation => load_negation,
			filterCoefficientIsZero => filterCoefficientIsZero,
			register_state => output_2,
			sign_bit => sign_bit_2
        );   
	 
    process
    begin  

		-- Reset
		load_sample <= '0';
		shift_to_accumulator <= '0';
		shift_to_multiply <= '0';
		load_negation <= '0';
		filterCoefficientIsZero <= '0';
		reset <= '1';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
		
		-- Check if state cleared by reset		
		assert (std_match(output_1, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')))
			report  "Convolution register not cleared on reset"
			severity  ERROR; 		
		
		sample_1 <= (0 to (ADC_DATA_BITS-1) => '1');
		sample_2 <= (0 to (ADC_DATA_BITS-2) => '0') & '1';
		load_sample <= '1';
		
		wait for 100 ns;
		
		load_sample <= '0';
			
		-- Check if state loaded
		assert (std_match(output_1, (0 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')))
			report  "Convolution register not loaded properly"
			severity  ERROR; 		
			
		shift_to_accumulator <= '1';
		wait for 100 ns;
		shift_to_accumulator <= '0';
		-- Check if state shifted right once without sign extension		
		assert (std_match(output_1, '0' & (0 to (ADC_DATA_BITS-1) => '1') & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-2) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS-1) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-2) => '0')))
			report  "Convolution register not accumulator-shifted properly"
			severity  ERROR; 		
		
		load_negation <= '1';
		wait for 100 ns;
		load_negation <= '0';
		
		-- Check if state negated
		assert (std_match(output_1, '1' & (0 to (ADC_DATA_BITS-2) => '0') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-2) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS-1) => '1') & '1' & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-2) => '0')))
			report  "Convolution register not negated properly"
			severity  ERROR; 		
		
		shift_to_multiply <= '1';
		wait for 100 ns;
		wait for 100 ns;
		shift_to_multiply <= '0';	
		-- Shift twice with sign extension - are we really sign extending?
				
		assert (std_match(output_1, "111" & (0 to (ADC_DATA_BITS-2) => '0') & '1'))
			report  "Convolution register not sign extended properly"
			severity  ERROR; 								
		
		shift_to_multiply <= '1';
		filterCoefficientIsZero <= '1';
		wait for 100 ns;
		shift_to_multiply <= '0';
		filterCoefficientIsZero <= '0';
		-- Shift with sign extension & filter zero (should clear)
		assert (std_match(output_1, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')))
			report  "Convolution register not cleared properly if filter coefficient is zero"
			severity  ERROR; 								
		
		load_negation <= '1';
		wait for 100 ns;
		load_negation <= '0';
		-- load negation - is result still zero?
		assert (std_match(output_1, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')) and std_match(output_2, (0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0')))
			report  "Convolution register not negated properly if operand is zero"
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


end test_register_convolution_input_TbArch; 



configuration TESTBENCH_FOR_test_register_convolution_input of test_register_convolution_input is
    for test_register_convolution_input_TbArch        
        for REG1 : register_convolution_input
            use entity work.register_convolution_input(dataflow);
        end for; 
			for REG2 : register_convolution_input
            use entity work.register_convolution_input(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_test_register_convolution_input;

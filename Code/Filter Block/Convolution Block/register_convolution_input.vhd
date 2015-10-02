----------------------------------------------------------------------------
--
--  An (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS)-bit register 
--  designed to support negative-powers-of-two multiplication when linked to 
--  a register_convolution_filter_coefficient. 

--  Supports:
--   serial right shift straight through the register 
--   serial local right shift with sign extension
--   parallel clearing
--   parallel load of integer values of ADC_DATA_BITS with fractional precision extended to FILTER_SHIFT_MULTIPLIER_PRECISION_BITS 
--   two's complement negation of the contents of the register
--   
--  Other than reset, control inputs are requried to be exclusive.
--
--  Entities included are:
--  register_convolution_input
--
--  Revision History:
--  09/24/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_convolution_input} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_convolution_input is
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
end register_convolution_input;

--}} End of automatically maintained section

architecture  dataflow  of  register_convolution_input  is                                                
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	
	signal this_register : std_logic_vector(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1)); 
	signal negation : std_logic_vector(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1)); 
	signal carrys : std_logic_vector(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1)); 
begin           
	-- Create two's complement negator - subtract self from zero. carry-in at LSB is 1.
	-- This is only guaranteed to work without overflow after a shift_to_multiply cycle,
	-- because currently filter coefficients that multiply us are strictly <= 1/2.
	-- That is, if we were working in 8 bits, we would never be asked to negate something like -128 in -128..127, because we'd only ever see -64.
	NegatorFinal: AddSub port map ('0', this_register(ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1), '1', '1', negation(ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1), carrys(ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1));
	NegatorGen:
	for i in 0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 2) generate
	  NegatorX: AddSub port map ('0', this_register(i), '1', carrys(i+1), negation(i), carrys(i));
	end generate;	 
  
	register_state <= this_register;
	sign_bit <= this_register(0);
	serial_out <= this_register(ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1);
	
	update_ci_register: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
	  			
			if (  (reset = '1') or ( (shift_to_multiply = '1') and (filterCoefficientIsZero = '1') )  ) then
				this_register <= (0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1) => '0');          
				-- clear 
			end if;
							
			if ( (reset = '0') and (shift_to_multiply = '1') and (filterCoefficientIsZero = '0') ) then
				 this_register <= this_register(0) & this_register(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 2));
				 -- shift right once with sign extension
			end if;

			if ( (reset = '0') and (load_negation = '1') ) then
				 this_register <= negation;
				 -- negate myself
			end if;						
			
			if ( (reset = '0') and (shift_to_accumulator = '1') ) then
				 this_register <= serial_in & this_register(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 2));
				 -- shift right once, through
			end if;
			
			if ( (reset = '0') and (load_sample = '1') ) then
				 this_register <= load_data & (0 to (FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1) => '0');
				 -- parallel load	with fractional precision extension
			end if;
							 			
			-- otherwise persist			
	  end if;                                
	end process update_ci_register;		 
end  dataflow;
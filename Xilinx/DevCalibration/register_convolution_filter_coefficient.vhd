----------------------------------------------------------------------------
--
--  This entity represents a single filter coefficient which can be shifted for powers-of-two multiplication during convolution.
--
--  It has FILTER_COEFFICIENT_BITS bits. The MSB is a sign bit (0 +, 1 -) that is preserved during shift operations.
--  The rest of the bits should be interpreted as +2^-1 2^-2 ...
--  It is guaranteed that whatever controls this entity will only load powers of two into it. 
--
--  This entity remembers two things about its load coefficient - the sign (MSB) and whether the coefficient is zero.
--  It modifies and passes on two other control signals: shift_req, negate_req. 
--  These are modified in the following way before being passed to an associated register_convolution_input:

--  If I am not zero, my last shift did not left-shift a 1 out of me, and a shift was requested, my input register may shift right.
--  If I am not zero, my sign bit is 1 (negative), and a negate of my input register was requested, it may negate. 
--  
--
--  Inputs
--  shift_req 				active high
--  negate_req 			active high
--  load_req 			   active high
--  load_data 				0 to (FILTER_COEFFICIENT_BITS-1) with MSB(0) as sign bit and rest with a single set bit, interpreted as a positive power of two.
--  is_load_data_zero   active high
--  sys_clk 			 	system clock
--
--  shift, negate, and load are mutually exclusive requests from an external FSM. 
--
--  Outputs
--  coefficientIsZero  active high flag
--  shift_input 		  active high ctrl line
--  negate_input 		  active high ctrl line
--  coefficient 		  register contents, for testing
--
--  Entities included are:
--  register_convolution_filter_coefficient
--
--  Revision History:
--  09/25/2015 SSundaresh created
--  09/29/2015 SSundaresh fixed bug where if coeff = 0, doesn't ask conv-input to shift (so conv input doesn't clear on multiply cycles)
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_convolution_filter_coefficient} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_convolution_filter_coefficient is
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
end register_convolution_filter_coefficient;

--}} End of automatically maintained section

architecture  dataflow  of  register_convolution_filter_coefficient  is                                                                 
	signal this_register : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-2));	 -- registered (does not include sign bit)
	signal iAmZero : std_logic; 						-- registered 
	signal last_shifted_bit_was_set : std_logic; -- registered 
	signal sb : std_logic; 								-- registered	
	
	signal shift_ctrl : std_logic; -- combinational
	
begin             
	coefficient <= sb & this_register;		
	coefficientIsZero <= iAmZero;
	shift_ctrl <= '1' when ( (not (last_shifted_bit_was_set = '1')) and (shift_req = '1') ) else '0';
	shift_input <= shift_ctrl;
	negate_input <= '1' when ( (not (iAmZero = '1')) and (sb = '1') and (negate_req = '1') ) else '0';

	
	conv_filt_coeff_updater: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then						

			if (shift_ctrl = '1') then
				last_shifted_bit_was_set <= this_register(0);
				this_register <= this_register(1 to (FILTER_COEFFICIENT_BITS-2)) & '0';				
			end if;
			
			if (load_req = '1') then
				this_register <= load_data(1 to (FILTER_COEFFICIENT_BITS-1));
				sb <= load_data(0);
				iAmZero <= is_load_data_zero;
				last_shifted_bit_was_set <= '0';
			end if;
			
			-- else 
				-- persist						
	  end if;                                
	end process conv_filt_coeff_updater;		 
end  dataflow;
----------------------------------------------------------------------------
--
--  This entity represents a single filter coefficient. 
--
--  It has FILTER_COEFFICIENT_BITS bits. The MSB is a sign bit (0 +, 1 -).
--  The rest of the bits should be interpreted as 2^-1 2^-2 ...
--  It is guaranteed that whatever controls this entity
--  will only load powers of two into it. Then, it is guaranteed
--  that this entity remains a power of two in +/- 2^-1 .. 2^-(FILTER_COEFFICIENT_BITS-1)
--  thereafter.
--
--  Here's the picture of the space this filter coefficient is walking in, supposing FILTER_COEFFICIENT_BITS = 9.
--  +2^-1 .... +2^-8 0 -2^-8 ... -2^-1   where <-- LEFT RIGHT -->
--  In reality, the bits look like
--  SB B0 (MSB) B1 B2 B3 ... (LSB)
--  So "LEFT" and "RIGHT" steps, in the visual number-line above, map to "left" and "right" shifts depending on the sign. 
--  For example, a negative number stepping "RIGHT" actually shifts "left",
--  and a positive number stepping "right" actually shifts "right".  
-- 
--  Therefore the numbers in MSB .. LSB, excluding the SB, are always "positive" and at most one bit is set.
--
--  Inputs
--  Load 					active high control signal to load a coefficient from an external register.
--  Load_Data 				the register to load
--  Update Coefficient 	active high control signal to update this coefficient using two LFSR bits to determine which direction to shift (to retain power of two in random walk).
--  unifrnd0, unifrnd1 	two bits from our pseudo-random number generator
--  sys_clk 			 	system clock
--  reset 					active high control signal, clears this coefficient			
--
--  Load and Update Coefficient are guaranteed exclusive. Reset can happen anytime and takes priority.
--
--  Outputs
--  coefficientIsZero  active high flag
--  coefficient 		  register contents
--
--  Entities included are:
--  register_filter_coefficient
--
--  Revision History:
--  09/25/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_filter_coefficient} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_filter_coefficient is
    port(	  
			sys_clk : in std_logic;							
			reset : in std_logic; 							

			update_coefficient : in std_logic; 			
			load : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			
			unifrnd0 : in std_logic; 					-- if 0, do nothing on update. if 1, attempt to shift if no overflow would occur.
			unifrnd1 : in std_logic; 		 			-- if 0, shift positive numbers left and negative numbers right. if 1, shift positive numbers right and negative numbers left.

			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic					
        );                                               
end register_filter_coefficient;

--}} End of automatically maintained section

architecture  dataflow  of  register_filter_coefficient  is                                                                 
	signal this_register : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1)); 
	
	signal msb, sb, shift_direction : std_logic;
	
	signal shouldUpdate: std_logic;
	
	signal flagOverflowPositive : std_logic; -- if +2^-1 and unifrnd defines left shift
	signal flagOverflowNegative : std_logic; -- if -2^-1 and unifrnd defines right shift
	
	signal coefficientIsZeroFlag : std_logic;
begin             
	coefficient <= this_register;	
	coefficientIsZeroFlag <= '1' when std_match(this_register(1 to (FILTER_COEFFICIENT_BITS-1)), (1 to (FILTER_COEFFICIENT_BITS-1) => '0')) else '0'; -- zero sign irrelevant
	coefficientIsZero <= coefficientIsZeroFlag;
	
	msb <= this_register(1); -- most significant bit, 2^-1 precision
	sb <= this_register(0); -- sign bit
	shift_direction <= unifrnd1 xor sb; -- physical direction (left, right) to shift bits, if a shift is required. 0 = left, 1 = right.
	
	flagOverflowPositive <= '1' when ( (sb = '0') and (msb = '1') and (unifrnd0 = '1') and (unifrnd1 = '0') ) else '0';
	flagOverflowNegative <= '1' when ( (sb = '1') and (msb = '1') and (unifrnd0 = '1') and (unifrnd1 = '1') ) else '0';
	
	shouldUpdate <= '1' when ( (update_coefficient = '1') and (not (flagOverflowPositive = '1')) and (not (flagOverflowNegative = '1')) and (unifrnd0 = '1') ) else '0';
	
	filt_coeff_updater: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
			if (reset = '1') then
				this_register <= (0 to (FILTER_COEFFICIENT_BITS-1) => '0');          
				-- clear 
			else
				if (load = '1') then
					 this_register <= load_data;
				end if;
				
				if (shouldUpdate = '1') then
					if (coefficientIsZeroFlag = '1') then
						this_register <= unifrnd1 & this_register(2 to (FILTER_COEFFICIENT_BITS-1)) & '1'; -- shift 1 into lsb from left, and set sb by unifrnd1
					else
						if (shift_direction = '0') then
							this_register <= this_register(0) & this_register(2 to (FILTER_COEFFICIENT_BITS-1)) & '0'; 		-- shift left
						else  	
							this_register <= this_register(0) & '0' & this_register(1 to (FILTER_COEFFICIENT_BITS-2)); 		-- shift right
						end if;
					end if;				
				end if;
				
				-- else 
					-- persist			
			end if;	
	  end if;                                
	end process filt_coeff_updater;		 
end  dataflow;
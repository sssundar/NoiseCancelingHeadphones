----------------------------------------------------------------------------
--
--  Remembers one out coefficient from the best FIR filter seen so far. FILTER_RESIDUAL_ACCUMULATOR_BITS bits.
--  Can be loaded from the current filter if we've found a better filter, or reset to 0s.
--
--
--  Entities included are:
--  register_best_filter_coefficient
--
--  Revision History:
--  09/27/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_best_filter_coefficient} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_best_filter_coefficient is
    port(	  
			reset : in std_logic; 							-- active high, sets to '0's
			sys_clk : in std_logic; 						-- clock input
			
			load_coefficient : in std_logic; -- active high, load from the working coefficient array
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1)); 
						
			best_coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS - 1))
        );                                               
end register_best_filter_coefficient;

--}} End of automatically maintained section

architecture  dataflow  of  register_best_filter_coefficient  is                                                
	signal this_register : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS - 1));
begin           	
	best_coefficient <= this_register;
	
	update_rbfc_register: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
	  			
			if (reset = '1') then
				this_register <= (0 to (FILTER_COEFFICIENT_BITS - 1) => '0');
				-- reset 
			end if;
							
			if ( (reset = '0') and (load_coefficient = '1') ) then
				 this_register <= load_data;				 
			end if;
			
			-- otherwise persist			
	  end if;                                
	end process update_rbfc_register;		 
end  dataflow;
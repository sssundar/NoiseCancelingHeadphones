----------------------------------------------------------------------------
--
--  Remembers the best residual so far. FILTER_RESIDUAL_ACCUMULATOR_BITS bits.
--  Can be loaded from the residual accumulator, or reset to the maximum value.
--  Unsigned.

--
--  Entities included are:
--  register_best_residual
--
--  Revision History:
--  09/27/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_best_residual} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_best_residual is
    port(	  
			reset : in std_logic; 							-- active high, sets to '1's
			sys_clk : in std_logic; 						-- clock input
			
			load_residual_accumulator : in std_logic; -- active high, load the residual accumulator into this register
			load_data : in std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
						
			best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 1))
        );                                               
end register_best_residual;

--}} End of automatically maintained section

architecture  dataflow  of  register_best_residual  is                                                
	signal this_register : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 1));
begin           	
	best_residual <= this_register;
	
	update_rbr_register: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
	  			
			if (reset = '1') then
				this_register <= (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 1) => '1');
				-- reset to maximum
			end if;
							
			if ( (reset = '0') and (load_residual_accumulator = '1') ) then
				 this_register <= load_data;				 
			end if;
			
			-- otherwise persist			
	  end if;                                
	end process update_rbr_register;		 
end  dataflow;
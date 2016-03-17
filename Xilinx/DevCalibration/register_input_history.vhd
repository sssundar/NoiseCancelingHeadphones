----------------------------------------------------------------------------
--
--  ADC_DATA_BITS-bit right shift register with synchronous load, shift, and global_reset.
-- 
--  Shift and Load are guaranteed exclusive.
--  reset takes precedence over them both.
--
--  Entities included are:
--  register_input_history
--
--  Revision History:
--  09/23/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {register_input_history} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity register_input_history is
    port(	  
			reset : in std_logic; 							-- active high

			shift : in std_logic; 									-- right shift control signal, active high
			load : in std_logic; 									-- load control signal, active high

			serial_in : in std_logic; 								-- shift input from the left 
			load_in : in std_logic_vector(0 to (ADC_DATA_BITS-1)); 		-- load input from ADC output register

			sys_clk : in std_logic; 								-- clock input

			register_out : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			serial_out : out std_logic					
        );                                               
end register_input_history;

--}} End of automatically maintained section

architecture  dataflow  of  register_input_history  is                                                                 
	signal this_register : std_logic_vector(0 to (ADC_DATA_BITS-1)); -- set default value for testing, to avoid global reset.
begin             
	register_out <= this_register;
	serial_out <= this_register(ADC_DATA_BITS-1);
	
	update_input_history_register: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
			if (reset = '1') then
				this_register <= (0 to (ADC_DATA_BITS-1) => '0');          
				-- clear 
			elsif (shift = '1') then
				 this_register <= serial_in & this_register(0 to (ADC_DATA_BITS-2));
				 -- shift right once
			elsif (load = '1') then
				 this_register <= load_in;
				 -- parallel load			
		-- else 
				 -- persist
			end if;			
	  end if;                                
	end process update_input_history_register;		 
end  dataflow;
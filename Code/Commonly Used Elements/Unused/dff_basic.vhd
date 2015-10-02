----------------------------------------------------------------------------
--
--  A barebones DFF with synchronous reset.
--
--  Entities included are:
--  dff_basic
--
--  Revision History:
--  09/23/2015 SSundaresh created
----------------------------------------------------------------------------


--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {dff_basic} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dff_basic is 
port (
	reset : in std_logic; -- synchronous clear, active high
	d : in std_logic; -- data input
	
	sys_clk : in std_logic; -- clock input
	
	q : out std_logic := '0' -- q output		
	);
end dff_basic;

--}} End of automatically maintained section

architecture dataflow of dff_basic is
begin
	process (sys_clk) 
	begin
		if rising_edge(sys_clk) then
			if (reset = '1') then
				q <= '0';
			else
				q <= d; 
			end if;
		end if;
	end process;
end dataflow;

----------------------------------------------------------------------------
--
--  n-counter with synchronous reset, run-enable control line, and clock inputs.
--  Flags when it hits the target count, n.

--  Entities included are:
--  nCounter
--
--  Revision History:
--  01/06/2015 SSundaresh updated
--  01/19/2015 SSundaresh updated all synchronous
--  09/27/2015 SSundaresh added hit-target flag
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {nCounter} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity nCounter is 
generic (
	n : integer := 8  -- counter max value
);
port (	
	clk : in std_logic; -- clock input
	clr : in std_logic; -- asynchronous clear
	run : in std_logic; -- run enable 
	count : out integer range 0 to n; 	-- the count value
	hitTarget : out std_logic 		-- active high
	);
end nCounter;

--}} End of automatically maintained section

architecture dataflow of nCounter is 
	signal internal_count : integer range 0 to n;
begin 
	count <= internal_count;
	hitTarget <= '1' when (internal_count = n) else '0';
	
	process (clk) 
	begin	
		if (rising_edge(clk)) then
			if (clr = '1') then
				internal_count <= 0;
			elsif (run = '1') then			
				if (internal_count = n) then
					internal_count <= 0;
				else
					internal_count <= internal_count + 1;
				end if;
			end if;
		end if;
	end process;
end dataflow;

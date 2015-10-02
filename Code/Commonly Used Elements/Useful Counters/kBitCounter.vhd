----------------------------------------------------------------------------
--
--  k bit counter with synchronous reset, run-enable control line, and clock inputs.
--
--  Entities included are:
--  kBitCounter
--
--  Revision History:
--  09/23/2015 SSundaresh created
--  09/27/2015 SSundaresh added carry out as an output for simpler counter-FSM logic
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {kBitCounter} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity kBitCounter is 
	generic (
		k : integer := 3 							-- number of bits in counter
	);
	port (	
		sys_clk : in std_logic; 				-- clock input
		clear : in std_logic; 					-- synchronous clear, active high
		run : in std_logic; 						-- increment enable, active high
		count : out std_logic_vector(0 to (k-1));  -- the counter state
		finalCarry : out std_logic 					-- combinational carry out of the counter
		);
end kBitCounter;

--}} End of automatically maintained section

architecture dataflow of kBitCounter is 
	
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	
	signal internal_count : std_logic_vector(0 to (k-1));
	signal carrys : std_logic_vector(0 to (k-1));
	signal Sum : std_logic_vector(0 to (k-1));
begin 
	count <= internal_count;
	finalCarry <= carrys(0);
	
	-- Create k-bit incrementor
	IncrementorFinal: AddSub port map (internal_count(k-1), '0', '0', '1', Sum(k-1), carrys(k-1));
	IncrementorGen:
	for i in 0 to (k-2) generate
	  IncrementorX: AddSub port map (internal_count(i), '0', '0', carrys(i+1), Sum(i), carrys(i));
	end generate;	 
	
	process (sys_clk) 
	begin	
		if (rising_edge(sys_clk)) then
			if (clear = '1') then
				internal_count <= (0 to (k-1) => '0');
			elsif (run = '1') then							
				internal_count <= Sum;
			end if;			
		end if;
	end process;
end dataflow;
-- lfsr_maximal_xnor_64_bit.vhd
--
-- A 64-bit maximal length LFSR. 

-- Input
--		sys_clk 			system clock
--		reset 			active high global reset to all '0', a non-stuck state
-- 
-- Output
--		random_64mer	a random 64-mer that defines the next step in the random walk for updating our filter coefficients
--
-- Operation
-- 	Bits are indexed 0..63. XNOR taps are at 59, 60, 62, 63.
-- 	Stuck state is all '1'. 
-- 	If parity of these four taps is even (0,2,4 are 1) then the feedback bit to bit[0] is 1. Otherwise it is 0.
-- 	Updates every sys_clk.
--
--  Revision History:
--     09/24/2015 SSundaresh created

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.MAGIC_NUMBERS.ALL;

entity lfsr_maximal_xnor_64_bit is
    port (
        sys_clk  : in   std_logic; 
        reset : in  std_logic; 		-- active high
		  random_64mer : out std_logic_vector(0 to 63) 
    );
end lfsr_maximal_xnor_64_bit;

architecture dataflow of lfsr_maximal_xnor_64_bit is
	signal current_state : std_logic_vector(0 to 63);		
begin		
	random_64mer <= current_state;
	process(sys_clk)
	begin
		if  (rising_edge(sys_clk))  then			
			if (reset = '1') then
				current_state <= (0 to 63 => '0');
			else 
				current_state(1 to 63) <= current_state(0 to 62);						 
				current_state(0) <= current_state(59) xnor current_state(60) xnor current_state(62) xnor current_state(63);			
			end if;
		end if;
	end process;

end dataflow;
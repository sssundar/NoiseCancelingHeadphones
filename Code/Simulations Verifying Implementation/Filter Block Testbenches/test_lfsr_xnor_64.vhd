-- test_input_history_shift.vhd         			       
--
-- This testbench unit tests the xnor-feedback 64-bit lfsr and its reset.
--
--  Revision History:
--     24 Sep 2015 Sushant Sundaresh created testbench.
--     24 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.
-- 											 noticed on observing bit patterns that long runs of similar numbers occur, sometimes. good thing we only update on this every 2*FILTER_LEN sample-cycles

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_lfsr_xnor_64 is
end test_lfsr_xnor_64;

architecture test_lfsr_xnor_64_TbArch of test_lfsr_xnor_64 is

	component lfsr_maximal_xnor_64_bit is
		 port (
			  sys_clk  : in   std_logic; 
			  reset : in  std_logic; 		-- active high
			  random_64mer : out lfsr_state_64_bit 
		 );
	end component;


    -- Stimulus signals - signals mapped to the input and inout ports of tested entity   	
	 signal clock : std_logic; 
	 signal clear : std_logic;
    signal random_64mer : lfsr_state_64_bit;	 	 	 	
	
	 -- s/w lfsr xnor-feedback with taps at 59, 60, 62, 63 for generating testvectors	 
	function lfsr_update (current_state : lfsr_state_64_bit) return lfsr_state_64_bit is
		variable curr_state : lfsr_state_64_bit;
		variable next_state : lfsr_state_64_bit;
		variable temp : std_logic;
	begin
	  curr_state := current_state;
	  temp := curr_state(59) xnor curr_state(60) xnor curr_state(62) xnor curr_state(63);
	  next_state(1 to 63) := curr_state(0 to 62);
	  next_state(0) := temp;
	  return next_state;	  
	end lfsr_update;   
	
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- LFSR UUT
    LFSR: lfsr_maximal_xnor_64_bit port map  (clock, clear, random_64mer);
	 
    -- now generate the stimulus and test the design by simulating it with our test program
    process
		variable i : integer;
		variable next_state : lfsr_state_64_bit;
    begin  -- of stimulus process

		-- Reset
		clear <= '1';
		wait for 95 ns;		
				
		clear <= '0';
		wait for 5 ns;
		
		-- Check if state cleared by reset		
		assert (std_match(random_64mer, (0 to 63 => '0')))
			report  "LFSR not cleared on reset"
			severity  ERROR; 		
		
		for i in 1 to 1000 loop
			next_state := lfsr_update(random_64mer);			
			wait for 100 ns;
			assert (std_match(random_64mer, next_state))
				report "LFSR state update failed."
				severity ERROR;		
		end loop;
					
		END_SIM <= TRUE;
		wait;
		
    end process; -- end of stimulus process

    
    CLOCK_clk : process

    begin

        -- this process generates a 100 ns period, 50% duty cycle clock

        -- only generate clock while still have stimulus vectors

        if END_SIM = FALSE then
            clock <= '0';
            wait for 50 ns;
        else
            wait;
        end if;

        if END_SIM = FALSE then
            clock <= '1';
            wait for 50 ns;
        else
            wait;
        end if;

    end process;    -- end of clock process


end test_lfsr_xnor_64_TbArch; 



configuration TESTBENCH_FOR_test_lfsr_xnor_64 of test_lfsr_xnor_64 is
    for test_lfsr_xnor_64_TbArch        
        for LFSR : lfsr_maximal_xnor_64_bit
            use entity work.lfsr_maximal_xnor_64_bit(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_test_lfsr_xnor_64;

-- test_generator_sine.vhd         			       
--
-- This testbench simply runs the sine generator and tests its reset.
-- It's a visual test. 
--
--  Revision History:
--   13 February 2016 Sushant Sundaresh created testbench
--   13 February 2016 Sushant Sundaresh passes visual screen

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    

entity test_generator_sine is
end test_generator_sine;

architecture test_generator_sine_TbArch of test_generator_sine is

	component generator_sine is
		Port (					
			sample : out std_logic_vector(0 to 7);	
			sample_tick : in std_logic; 	
			reset : in std_logic;  			
			sys_clk : in std_logic
		);
	end component;

    -- Stimulus signals 
	 signal clock : std_logic; 
	 signal reset : std_logic;    
	 signal sample_tick : std_logic; 
	 
	 -- Test system state visibility
	 signal sample : std_logic_vector(0 to 7);
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- UUT
    UUT: generator_sine port map  (sample, sample_tick, reset, clock);
	    
    -- Let's reset, run for a while, and show that sample_tick acts like a clock enable.	 
    process		
    begin  

		-- Reset, enabling generator
		sample_tick <= '1';
		reset <= '1';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
		
		-- Check if state cleared by reset		
		assert (std_match(sample, (0 to 7 => '0')))
			report  "Generator not cleared on reset."
			severity ERROR; 		
		
		-- Visually watch state evolution oscillate
		for i in 1 to 1000 loop
			wait for 100 ns;			
		end loop;
			
      -- Demonstrate oscillation disable			
		sample_tick <= '0';
		wait for 1000 ns;
		
		END_SIM <= TRUE;
		wait;
		
    end process; 

	 -- this process generates a 100 ns period, 50% duty cycle clock        
    CLOCK_clk : process
    begin        
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
    end process;

end test_generator_sine_TbArch; 



configuration TESTBENCH_FOR_generator_sine of test_generator_sine is
    for test_generator_sine_TbArch        
        for UUT : generator_sine
            use entity work.generator_sine(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_generator_sine;

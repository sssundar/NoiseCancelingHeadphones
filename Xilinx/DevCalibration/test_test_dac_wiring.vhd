-- test_test_dac_wiring.vhd
--
-- This testbench checks connectivity of test_dac_wiring.
--
--  Revision History:
--   14 February 2016 Sushant Sundaresh created testbench, visually passes

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    

entity test_test_dac_wiring is
end test_test_dac_wiring;

architecture test_dac_wiring_TbArch of test_test_dac_wiring is

	component  test_dac_wiring  is
		 port (		
			-- User Buttons, to be synchronized -- 		
			reset : in std_logic;		 					-- Switch 5, active high
			oe : in std_logic;								-- Switch 6, active high
							
			-- a DAC (output) data line.
			out_dac : out std_logic;
			
			-- System Clock
			sys_clk : in std_logic
		 );
	end  component;

    -- Stimulus signals 
	 signal clock : std_logic; 
	 signal reset : std_logic;    
	 signal oe : std_logic;	 
	 
	 -- UUT Output
	 signal out_dac : std_logic;	 
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;
	 
begin
	
    -- UUT
    UUT: test_dac_wiring port map  (reset, oe, out_dac, clock);
	        
    process		
    begin  
		-- Reset, OE
		reset <= '1';
		oe <= '1';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
				
		for i in 1 to 100000 loop
			wait for 100 ns;			
		end loop;		
		
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

end test_dac_wiring_TbArch; 



configuration TESTBENCH_FOR_dac_wiring of test_test_dac_wiring is
    for test_dac_wiring_TbArch
        for UUT : test_dac_wiring
            use entity work.test_dac_wiring(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_dac_wiring;

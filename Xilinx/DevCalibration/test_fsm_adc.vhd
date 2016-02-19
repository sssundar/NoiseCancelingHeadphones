-- test_generator_sine.vhd         			       
--
-- This testbench simply runs the fsm_adc with nInt always low 
-- and with all buttons off. It's a sanity check of timing.
--
--  Revision History:
--   16 February 2016 Sushant Sundaresh 	created testbench
--  													visual screen with nInt low, zero buttons, passes
-- 													nInt responsiveness confirmed.
-- 													button responsiveness confirmed
-- 													level shifting, LED load confirmed.
-- 													ready to load to FPGA for HW test.
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    

entity test_fsm_adc is
end test_fsm_adc;

architecture test_fsm_adc_TbArch of test_fsm_adc is

	component  fsm_adc  is
    port (
		sys_clk 		: in std_logic;	--20 MHz
		sample_tick : in std_logic;	--active high
		reset 		: in std_logic;	--active high		
		nInt 			: in std_logic;	--interrupt, active low, asynchronous
		buttons 		: in std_logic_vector(0 to 3); --	active high buttons, asynchronous
		databus  	: in std_logic_vector(0 to 7); --   adc data bus (low 8 bits, 0 is MSB here but mapped to DB7 from ADC, the MSB).

		nRD 			: out std_logic;	--active low read
		nSH			: out std_logic;	--active low sample (active high hold)
		vin0 			: out std_logic_vector(0 to 7);	-- samples, 8 bit signed and level shifted down by 128
		vin1			: out std_logic_vector(0 to 7);
		vin2			: out std_logic_vector(0 to 7);
		vin3 			: out std_logic_vector(0 to 7);
		leds 			: out std_logic_vector(0 to 7);	-- active high led array (0 to 7)
		s0 			: out std_logic;		
		s1 			: out std_logic	-- active high sample selectors, (s1s0, 00 = 0, .., 11 = 3)
    );
	end  component;

    -- Stimulus signals 
	 signal clock : std_logic; 
	 signal sample_tick : std_logic; 
	 signal reset : std_logic;    
	 signal nInt : std_logic;
	 
	 -- Test system state visibility
	 signal nRD, nSH, s0, s1 : std_logic;
	 signal vin0, vin1, vin2, vin3, leds : std_logic_vector(0 to 7);
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- UUT    	   
	UUT: fsm_adc 
    port map (
		clock,
		sample_tick,
		reset,
		nInt,
		"0100",
		"11111111",
		nRD,
		nSH,
		vin0,
		vin1,
		vin2,
		vin3,
		leds,
		s0, 
		s1
    );	

    -- Let's reset, run for a while, and show that sample_tick acts like a clock enable.	 
    process		
    begin  

		-- Reset, enabling generator
		sample_tick <= '1';
		reset <= '1';
		nInt <= '1';
		wait for 95 ns;		
				
		reset <= '0';		
		wait for 5 ns;
		
		wait for 100 ns;
		sample_tick <= '0';
				
		-- Visually watch state evolution oscillate through 4 samples
		-- Check that system waits for nInt before proceeding. C
		-- Check that button 1 is responded to - so sample 1 (2nd sample) loads at the right time.
		for i in 1 to 30 loop
			wait for 100 ns;			
		end loop;
		
		nInt <= '0';
		wait for 100 ns;
		nInt <= '1';
		
		for i in 1 to 40 loop
			wait for 100 ns;			
		end loop;
		
		nInt <= '0';
		wait for 100 ns;
		nInt <= '1';
		
		for i in 1 to 40 loop
			wait for 100 ns;			
		end loop;
		
		nInt <= '0';
		wait for 100 ns;
		nInt <= '1';
		
		for i in 1 to 40 loop
			wait for 100 ns;			
		end loop;

		nInt <= '0';
		wait for 100 ns;
		nInt <= '1';
		
		for i in 1 to 40 loop
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

end test_fsm_adc_TbArch; 



configuration TESTBENCH_FOR_fsm_adc of test_fsm_adc is
    for test_fsm_adc_TbArch        
        for UUT : fsm_adc
            use entity work.fsm_adc(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_fsm_adc;

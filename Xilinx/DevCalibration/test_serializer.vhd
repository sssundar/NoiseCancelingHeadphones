-- test_serializer.vhd         			       
--
-- This testbench simply runs the debugging serializer.
-- It's a visual test. 
--
--  Revision History:
-- 	29 March 2016 Sushant Sundaresh created

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all; 

entity test_serializer is
end test_serializer;

architecture test_serializer_TbArch of test_serializer is

	component block_serializer
    port (
		reset : in std_logic;
		sys_clk : in std_logic;		
		sample_tick : in std_logic;				
		end_serialization : out std_logic;
		ddr_serial_clock : out std_logic;
		
		input_register_1 : in std_logic_vector(0 to toSerialize);		
		input_register_2 : in std_logic_vector(0 to toSerialize);		
		input_register_3 : in std_logic_vector(0 to toSerialize);		
		input_register_4 : in std_logic_vector(0 to toSerialize);		
		
		serial_1 : out std_logic;
		serial_2 : out std_logic;
		serial_3 : out std_logic;
		serial_4 : out std_logic
    );
	end component;

    -- Stimulus signals 
	 signal clock : std_logic; 
	 signal reset : std_logic;    
	 signal sample_tick : std_logic;
	 signal serial_clock : std_logic;
	 signal output : std_logic; 
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- UUT
    UUT: block_serializer port map  (reset, clock, sample_tick, open, serial_clock, "010101" & (6 to toSerialize => '0'), (0 to toSerialize => '1'), (0 to toSerialize => '1'), (0 to toSerialize => '1'), output, open, open, open);
	    
    -- Let's reset, run for a while, and show that sample_tick latches new data in, which shows up exactly one clock later
    process		
    begin  

		-- Reset, enabling generator
		sample_tick <= '0';		
		reset <= '1';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
		
		-- Visually watch state evolution
		for i in 1 to 100 loop
			wait for 100 ns;			
		end loop;
			
      -- Latch in a new sample, watch it shift out
		sample_tick <= '1';
		wait for 95 ns;
		sample_tick <= '0';
		wait for 5 ns;
		
		for i in 1 to 512 loop
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

end test_serializer_TbArch; 



configuration TESTBENCH_FOR_serializer of test_serializer is
    for test_serializer_TbArch        
        for UUT : block_serializer
            use entity work.block_serializer(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_serializer;

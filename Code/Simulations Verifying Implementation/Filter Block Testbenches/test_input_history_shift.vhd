-- test_input_history_shift.vhd         			       
--
-- This testbench unit tests the input history register reset, load, and shift,
-- and the input history register shift controller. 
--
--  Revision History:
--     23 Sep 2015 Sushant Sundaresh created testbench.
--     23 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.
--

-- IEEE library
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_input_history_shift is
end test_input_history_shift;

architecture test_input_history_shift_TbArch of test_input_history_shift is

	component  fsm_input_history_shift  is
		 port (
			reset : in std_logic; -- active high
			shift_input_history : in std_logic; -- active high
			sys_clk : in std_logic; -- active high edge		
			shift : out std_logic -- active high
		 );	
	end component;
	
	component register_input_history is
		 port(	  
			reset : in std_logic; 							-- reset, active high
			shift : in std_logic; 									-- right shift control signal, active high
			load : in std_logic; 									-- load control signal, active high
			serial_in : in std_logic; 								-- shift input from the left 
			load_in : in std_logic_vector(0 to (ADC_DATA_BITS-1)); 		-- load input from ADC output register
			sys_clk : in std_logic; 								-- clock input
			register_out : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			serial_out : out std_logic					
		  );                                               
	end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal shift_input_history : std_logic;
	 
	 signal clock : std_logic; 
	 signal clear : std_logic := '1';
    signal shift : std_logic;                                 
    signal load  : std_logic;                                 
	  
	 signal serial_in_2 : std_logic;
	 signal serial_out_2 : std_logic;
	 signal load_in_1 : std_logic_vector(0 to (ADC_DATA_BITS-1));
	 signal load_in_2 : std_logic_vector(0 to (ADC_DATA_BITS-1));
	 
	 signal register_out_1 : std_logic_vector(0 to (ADC_DATA_BITS-1));
	 signal register_out_2 : std_logic_vector(0 to (ADC_DATA_BITS-1));
	 	 
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- Input History Register port map
    REG1: register_input_history port map  (clear, shift, load, '0', load_in_1, clock, register_out_1, serial_in_2);
	 REG2: register_input_history port map  (clear, shift, load, serial_in_2, load_in_2, clock, register_out_2, serial_out_2);

    -- Input History Shift Controller port map
    CTRL: fsm_input_history_shift port map  (clear, shift_input_history, clock, shift);        

    -- now generate the stimulus and test the design by simulating it with our test program
    process
		variable i : integer;
    begin  -- of stimulus process

		-- Reset
		clear <= '1';
		wait for 300 ns;
		
		shift_input_history <= '0';				
		load <= '0';
		wait for 90 ns;
		clear <= '0';
		wait for 5 ns;
		
		-- Check if cleared by reset		
		assert (std_match(register_out_1, (0 to (ADC_DATA_BITS-1) => '0')) and std_match(register_out_2, (0 to (ADC_DATA_BITS-1) => '0')))
			report  "Registers not cleared by default."
			severity  ERROR; 
								  
		-- load values into registers		
		-- wait a clock, then check register state		
		load_in_1 <= (0 to (ADC_DATA_BITS-1) => '1');
		load_in_2 <= '0' & (1 to (ADC_DATA_BITS-1) => '1');
		wait for 5 ns;
		
		load <= '1';
		wait for 95 ns;		
		
		assert (std_match(register_out_1,(0 to (ADC_DATA_BITS-1) => '1')) and std_match(register_out_2,'0' & (1 to (ADC_DATA_BITS-1) => '1')))
			report  "Load failed."
			severity  ERROR; 		
			
		-- start shift controller 
		load <= '0';		
		wait for 5 ns;
		shift_input_history <= '1';
		wait for 95 ns;
		
		shift_input_history <= '0';		
		
		for i in 1 to 8 loop
			wait for 100 ns;
		end loop;
		
		-- confirm that after ADC_DATA_BITS clocks the final state of the registers is shifted ADC_DATA_BITS places (the registers shift one over)
		assert (std_match(register_out_1,(0 to (ADC_DATA_BITS-1) => '0')) and std_match(register_out_2,(0 to (ADC_DATA_BITS-1) => '1')))
			report  "FSM failed."
			severity  ERROR; 
		
		for i in 1 to 8 loop
			wait for 100 ns;
		end loop;
		
		-- confirm nothing more happens after this (returned to waiting state).
		-- confirm that after ADC_DATA_BITS clocks the final state of the registers is shifted ADC_DATA_BITS places (the registers shift one over)
		assert (std_match(register_out_1,(0 to (ADC_DATA_BITS-1) => '0')) and std_match(register_out_2,(0 to (ADC_DATA_BITS-1) => '1')))
			report  "FSM failed."
			severity  ERROR; 
			
		-- start fsm again
		shift_input_history <= '1';
		wait for 95 ns;
		shift_input_history <= '0';
		wait for 5 ns;
		for delayCount in 1 to 8 loop
			wait for 100 ns;
		end loop;
		-- confirm that after ADC_DATA_BITS clocks the registers are both cleared.
		assert (std_match(register_out_1,(0 to (ADC_DATA_BITS-1) => '0')) and std_match(register_out_2,(0 to (ADC_DATA_BITS-1) => '0')))
			report  "FSM failed."
			severity  ERROR; 

		wait for 500 ns;		
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


end test_input_history_shift_TbArch; 



configuration TESTBENCH_FOR_test_input_history_shift of test_input_history_shift is
    for test_input_history_shift_TbArch
        for REG1 : register_input_history
           use entity work.register_input_history(dataflow);
        end for;
		  for REG2 : register_input_history
            use entity work.register_input_history(dataflow);
        end for;
        for CTRL : fsm_input_history_shift
            use entity work.fsm_input_history_shift(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_test_input_history_shift;

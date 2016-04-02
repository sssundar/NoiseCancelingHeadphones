-- test_test_block_filter_in_system.vhd         			       
--
-- This testbench simply runs the block filter with minimal
-- system wiring, to try and replicate the "best residual is 0"
-- bug found in the hardware implementation. 
--
--
--  Revision History:
-- 	01 April 2016 Sushant Sundaresh created

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all; 

entity test_test_block_filter_in_system is
end test_test_block_filter_in_system;

architecture test_bfis_TbArch of test_test_block_filter_in_system is

	component test_block_filter_in_system 
    port (					
		reset : in std_logic;		 				
		async_oe : in std_logic;					
		async_ae : in std_logic; 										
		sys_clk_20 : in std_logic;		
		observe_ticks : out std_logic;
		left_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		left_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		left_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		left_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE
    );
	end component;

	-- Stimulus signals 
	signal clock : std_logic; 
	signal reset : std_logic;    	 	 	 
	signal oe, ae : std_logic;
	
	signal sample_tick : std_logic;
	
	signal left_best_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal right_best_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal left_working_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal right_working_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));

	signal left_current_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	signal right_current_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;

	signal left_next_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	signal right_next_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;

	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    -- UUT
    UUT: test_block_filter_in_system 
		 port map (					
			reset => reset,
			async_oe => oe,
			async_ae => ae,
			sys_clk_20 => clock,
			observe_ticks => sample_tick,
			left_best_residual => left_best_residual,
			right_best_residual => right_best_residual,
			left_working_residual => left_working_residual,
			right_working_residual => right_working_residual,
			left_current_fsm_state => left_current_fsm_state,
			right_current_fsm_state => right_current_fsm_state,
			left_next_fsm_state => left_next_fsm_state,
			right_next_fsm_state => right_next_fsm_state
		 );	
	        
    process		
    begin  
		
		-- Sanity Checks Attempted
		-- Reset toggle with oe, ae inactive -> after on tick, best residuals are high
		-- Reset with oe, ae active -> after one tick, best residuals are high
		-- Reset with oe, ae active -> after 65 ticks, best residuals are 64 (errors fixed at 1)
		-- Reset with oe, ae inactive -> after 65 ticks, best residuals are high, unchanged, working residuals are 0
		-- Reset with oe, ae inactive, then at the end just before we'd hit an update interval, activate them - best residuals stay high
		
		-- It seems quite unlikely to me that an error mic would see ALL zero inputs for 64 samples straight, on both filter blocks.
		-- That's silly. 
		
		-- Try running the current code with reset toggled on with oe/ae active from the start
		-- Try swapping the input, error mics, just to see what happens with a stronger signal
		-- Do this a few times, with a noise source NEAR the mics. HUM if you need to.
		-- Try synchronizing the reset input line
		-- Make sure the outputs are at least different between the left, right filters
		-- Serialize the input error, too
		-- Try toggling the reset while capturing - with luck you'll catch the zero-best happening, and can sanity-check whether it's SUPPOSED to be happening given the inputs
		
		-- Write a simple "count runs of 0 error in's module" and serialize the output on sample_ticks.
		
		reset <= '1';
		oe <= '0';
		ae <= '0';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
		
		-- Visually watch state evolution for a sample tick
		for i in 1 to 512*64 loop
			wait for 100 ns;			
		end loop;
		
		oe <= '1';
		ae <= '1';
		
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

end test_bfis_TbArch; 



configuration TESTBENCH_FOR_bfis of test_test_block_filter_in_system is
    for test_bfis_TbArch        
        for UUT : test_block_filter_in_system
            use entity work.test_block_filter_in_system(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_bfis;
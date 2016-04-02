-- test_fsm_update_filter.vhd         			       
--
-- A test of the update-filter block controller and internal state registers.
--
--  Revision History:
--     29 Sep 2015 Sushant Sundaresh created testbench.
--     29 Sep 2015 Sushant Sundaresh all tests passed. Noticed strange glitch where working_filter looks uninitialized but actually is. This testbench represents a unit test going forward.

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_fsm_update_filter is
end test_fsm_update_filter;

architecture test_fsm_update_filter_TbArch of test_fsm_update_filter is

	component  fsm_update_filter 
		 port (
			reset : in std_logic; 
			sys_clk : in std_logic; 
			trigger : in std_logic; 
			shouldUpdate : in std_logic; 
			working_filter : in COEFFICIENT_REGISTER_ARRAY; 
			inputError : in std_logic_vector(0 to (ADC_DATA_BITS-1));
			
			reset_working_to_best_filter : out std_logic;
			update_working_filter : out std_logic; 
			best_filter : out COEFFICIENT_REGISTER_ARRAY;
			the_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
			current_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
			myPresentState : out FSM_FILTER_UPDATE_BLOCK_STATE;
			myNextState : out FSM_FILTER_UPDATE_BLOCK_STATE
		 );	
	end  component;
	
	component register_filter_coefficient
    port(	  
			sys_clk : in std_logic;							
			reset : in std_logic; 							

			update_coefficient : in std_logic; 			
			load : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			
			unifrnd0 : in std_logic; 					-- if 0, do nothing on update. if 1, attempt to shift if no overflow would occur.
			unifrnd1 : in std_logic; 		 			-- if 0, shift positive numbers left and negative numbers right. if 1, shift positive numbers right and negative numbers left.

			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic					
        );                                               
	end component;



   -- Stimulus signals - signals mapped to the input and inout ports of tested entity   	
	signal clock, reset, trigger, shouldUpdate : std_logic; 	
	signal inputError : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal init_update : std_logic;
	
	signal best_filter, working_filter : COEFFICIENT_REGISTER_ARRAY; 		
	signal best_residual, current_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));	
	signal reset_working_to_best_filter, update_working_filter: std_logic;			 
	signal update_coefficient : std_logic; 
	signal PresentState, NextState : FSM_FILTER_UPDATE_BLOCK_STATE;		 
   -- Signal used to start/stop clock signal generators
   signal END_SIM : BOOLEAN := FALSE;	

begin
		
	 update_coefficient <= update_working_filter or init_update;
	 
	 -- set up working filter with update parameters fixed at 'shift left is positive, shift right if negative'
	 REGGen: for i in 0 to (FILTER_FIR_LENGTH-1) generate 
		REGx: register_filter_coefficient
		 port map (	  
				sys_clk => clock,
				reset => reset,
				update_coefficient => update_coefficient,
				load => reset_working_to_best_filter,
				load_data => best_filter(i),
				unifrnd0 => '1',
				unifrnd1 => '1',
				coefficient => working_filter(i),
				coefficientIsZero => open				
			  );        	 
	 end generate;
    
	 
	 FSM: fsm_update_filter 
		 port map (
			reset => reset,
			sys_clk => clock, 
			trigger => trigger,
			shouldUpdate => shouldUpdate,
			working_filter => working_filter, 
			inputError => inputError,			
			reset_working_to_best_filter => reset_working_to_best_filter,
			update_working_filter => update_working_filter, 
			best_filter => best_filter, 
			the_best_residual => best_residual, 
			current_residual => current_residual,
			myPresentState => PresentState,
			myNextState => NextState
		 );	
	 
   process
   begin  
		
	-- Reset	
	trigger <= '0';
	shouldUpdate <= '0';	
	inputError <= (0 to (ADC_DATA_BITS-1) => '0');
	init_update <= '0';	
	reset <= '0';
	wait for 5 ns;
	
	reset <= '1';
	wait for 90 ns;
	reset <= '0';	
	
	-- Set working filter to -2^-8 by asking coefficients to update. 
	init_update <= '1';
	wait for 100 ns;
	init_update <= '0';
	
	-- Check working residual, best residual, first coeff for best filter all reset (low, high, low).
	-- Check first coefficient in working filter set appropriately to -2^-8	
	assert (std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '0')) and std_match(best_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '1')) )
		report  "Failure 1"
		severity  ERROR; 		
	assert (std_match(best_filter(0), (0 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(working_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1') )
		report  "Failure 2"
		severity  ERROR; 			
		
	-- Add in three input errors, one zero, one positive, one negative. Trigger with updates allowed. Check working residual updated properly. 
	shouldUpdate <= '1';		
	trigger <= '1';		
	
	inputError <= (0 to (ADC_DATA_BITS-1) => '0');
	wait for 300 ns; -- 3 state transitions to add and return to waiting state	
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '0')) )
		report  "Failure 3"
		severity  ERROR; 		
		
	inputError <= (0 to (ADC_DATA_BITS-2) => '0') & '1';
	wait for 300 ns;
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-2) => '0') & '1') )
		report  "Failure 4"
		severity  ERROR; 		
	
	inputError <= '1' & (1 to (ADC_DATA_BITS-2) => '0') & '1'; 
	wait for 300 ns;
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '1' & (1 to (ADC_DATA_BITS-1) => '0')) )
		report  "Failure 5"
		severity  ERROR; 		
	
	-- Trigger without allowing an update. Wait two clocks, check working residual wiped, working filter is best filter (cleared).
	shouldUpdate <= '0';	
	trigger <= '1';		
	wait for 200 ns;
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '0' & (1 to (ADC_DATA_BITS-1) => '0')) )
		report  "Failure 6"
		severity  ERROR; 		
	assert (std_match(best_filter(0), (0 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(working_filter(0), best_filter(0)) and std_match(working_filter(1), best_filter(1)) )
		report  "Failure 7"
		severity  ERROR; 			
		
	-- Update working filter again, manually.	
	trigger <= '0';
	-- Set working filter to -2^-(ADC_DATA_BITS) by asking coefficients to update. 
	init_update <= '1';
	wait for 100 ns;
	init_update <= '0';

	-- Add in FILTER_UPDATE_INTERVAL errors, all the same and large (max negative value possible), and confirm best_residual changes, accumulator wiped, and best_filter is working_filter (-2^-(ADC_DATA_BITS), all), and working filter is -2^-(ADC_DATA_BITS-1), all (updated)
	inputError <= '1' & (1 to (ADC_DATA_BITS-1) => '0');  
	shouldUpdate <= '1';
	trigger <= '1';
	for i in 0 to (FILTER_UPDATE_INTERVAL-1) loop
		wait for 300 ns;
	end loop;
	-- now should be at CMP state with next state update best
	assert (std_match(PresentState, FSM_FUB_CMP) and std_match(NextState, FSM_FUB_UPD_BEST))
		report  "Failure 8"
		severity  ERROR; 			
	wait for 400 ns;
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '0' & (1 to (ADC_DATA_BITS-1) => '0')) )
		report  "Failure 9"
		severity  ERROR; 		
	assert (std_match(best_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1') and std_match(working_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-3) => '0') & "10") )
		report  "Failure 10" 
		severity  ERROR; 			
	assert ( std_match(best_residual, '1' & (1 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '0' & (1 to (ADC_DATA_BITS-1) => '0')) )
		-- largest power of two in ADC_DATA_BITS added exactly FILTER_UPDATE_INTERVAL times should set top bit in ACCUMULATOR_OVERFLOW_BITS
		report  "Failure 11"
		severity  ERROR; 		
	
	-- Let it just keep running again. This time the error will be identical - no update will occur. The working filter at the end of things will remain the same. 
	for i in 0 to (FILTER_UPDATE_INTERVAL-1) loop
		wait for 300 ns;
		-- This confirms the glitch in ISE Simulator that shows most of the working_filters as U is just.. a glitch. They're set properly, throughout.
		for j in 0 to (FILTER_FIR_LENGTH-1) loop
			assert (std_match(working_filter(j), '1' & (1 to (FILTER_COEFFICIENT_BITS-3) => '0') & "10") )
				report  "Failure 12a" 
				severity  ERROR; 				
		end loop;
	end loop;	
	wait for 300 ns;	
	assert (std_match(best_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1') and std_match(working_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-3) => '0') & "10") )
		report  "Failure 12b" 
		severity  ERROR; 				
		
		
	-- Add in another round, this time smaller, at one half the errors above in magnitude. Confirm at the end best_filter is updated to -2^-(ADC_DATA_BITS-1), working register is -2^-(ADC_DATA_BITS-2) (updated off itself), and accumulator is wiped. 
	inputError <= "01" & (2 to (ADC_DATA_BITS-1) => '0');  
	shouldUpdate <= '1';
	trigger <= '1';
	for i in 0 to (FILTER_UPDATE_INTERVAL-1) loop
		wait for 300 ns;
	end loop;
	-- now should be at CMP state with next state update best
	assert (std_match(PresentState, FSM_FUB_CMP) and std_match(NextState, FSM_FUB_UPD_BEST))
		report  "Failure 13" 
		severity  ERROR; 			
	wait for 400 ns;
	assert ( std_match(current_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '0' & (1 to (ADC_DATA_BITS-1) => '0')) )
		report  "Failure 14"
		severity  ERROR; 		
	assert (std_match(best_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-3) => '0') & "10") and std_match(working_filter(0), '1' & (1 to (FILTER_COEFFICIENT_BITS-4) => '0') & "100") )
		report  "Failure 15" 
		severity  ERROR; 			
	assert ( std_match(best_residual, "01" & (2 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '0' & (1 to (ADC_DATA_BITS-1) => '0')) )		
		report  "Failure 16"
		severity  ERROR; 		
	
	trigger <= '0';
	shouldUpdate <= '0';
	
	END_SIM <= TRUE;
	wait;
		
	end process; 

    
	CLOCK_clk : process

	begin

	  -- this process generates a 100 ns period, 50% duty cycle clock	  	
	  
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


end test_fsm_update_filter_TbArch; 
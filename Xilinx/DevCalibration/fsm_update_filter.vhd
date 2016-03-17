---------------------------------------------------------------------------
--
--  fsm_update_filter
--
--  The control logic for updating the working residual accumulator and updating the best filter based on this residual.
--
--  Inputs:
--		trigger  	- active high signal to process a new error signal
-- 	shouldUpdate - active high signal 
--  	sys_clk     - clock input (active positive edge)
--		reset 		- active high
-- 	working_filter - array of registers (filter coefficients)
--		inputError 		- signed ADC_DATA_BITS error signal. residual is its absolute value.
-- 
--  Outputs:
--       reset_working_to_best_filter - active high
-- 	   update_working_filter - active high
-- 		best_filter - array of best_filter_coefficient registers
--			best and current residual, to open up these signals to unit tests
--
--  Entities included are:
--     fsm_update_filter
--
--
--  Revision History:
--     09/27/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fsm_update_filter} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  fsm_update_filter  is
    port (
		-- Inputs
		reset : in std_logic; 
		sys_clk : in std_logic; 
      trigger : in std_logic; 
		shouldUpdate : in std_logic; 
		working_filter : in COEFFICIENT_REGISTER_ARRAY; 
		inputError : in std_logic_vector(0 to (ADC_DATA_BITS-1));
		
		-- Outputs To Other Blocks
		reset_working_to_best_filter : out std_logic;
		update_working_filter : out std_logic; 
		best_filter : out COEFFICIENT_REGISTER_ARRAY;
		
		-- Outputs to Test Benches (will be left unconnected in final wiring)
		the_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		current_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		myPresentState : out FSM_FILTER_UPDATE_BLOCK_STATE;
		myNextState : out FSM_FILTER_UPDATE_BLOCK_STATE
    );	
end  fsm_update_filter;

	
--}} End of automatically maintained section

architecture  dataflow  of  fsm_update_filter  is

	component kBitCounter
		generic (
			k : integer := 3 -- number of bits in counter
		);
		port (	
			sys_clk : in std_logic; 				-- clock input
			clear : in std_logic; 					-- synchronous clear
			run : in std_logic; 						-- increment enable 
			count : out std_logic_vector(0 to (k-1)); -- the counter state
			finalCarry : out std_logic 			-- combinational carry out of the internal incrementor
			);
	end component;

	component register_best_filter_coefficient
    port(	  
			reset : in std_logic; 							-- active high, sets to '0's
			sys_clk : in std_logic; 						-- clock input
			
			load_coefficient : in std_logic; -- active high, load from the working coefficient array
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1)); 
						
			best_coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS - 1))
        );                                               
	end component;
	
	component register_best_residual
    port(	  
			reset : in std_logic; 							-- active high, sets to '1's
			sys_clk : in std_logic; 						-- clock input
			
			load_residual_accumulator : in std_logic; -- active high, load the residual accumulator into this register
			load_data : in std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
						
			best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 1))
        );                                               
	end component;
	
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	

	-- states
	signal PresentState, NextState : FSM_FILTER_UPDATE_BLOCK_STATE; 																						
	
	-- control signals, active high
	signal clearErrorSampleCounter : std_logic;
	signal incrementErrorSampleCounter : std_logic;
	signal isErrorSampleCounterDone : std_logic;
	
	-- best filter state holder
	signal bestFilterCoefficients : COEFFICIENT_REGISTER_ARRAY;
	signal isBestFilterStillBest : std_logic;
	signal bestResidual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	
	-- positive-sign extended absolute value of error input
	signal abs_error : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
	signal abs_carrys : std_logic_vector(0 to (ADC_DATA_BITS-1)); 
	signal abs_sum : std_logic_vector(0 to (ADC_DATA_BITS-1)); 
	
	-- residual accumulator
	signal residual_accumulated : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
	signal res_carrys : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
	signal res_sum : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
	signal clearResAccum : std_logic;
	
	-- best residual register control lines
	signal load_residual_accumulator : std_logic;
	
	-- comparison carry/sum holders
	signal cmp_carrys : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1)); 
	
begin	
	-- Wire outputs
	best_filter <= bestFilterCoefficients;
	the_best_residual <= bestResidual;
	current_residual <= residual_accumulated;
	myPresentState <= PresentState;
	myNextState <= NextState; 

	-- registered absolute value of error signal, sign extended positive.
	NegatorFinal: AddSub port map ('0', inputError(ADC_DATA_BITS-1), inputError(0), inputError(0), abs_sum(ADC_DATA_BITS-1), abs_carrys(ADC_DATA_BITS-1));
	NegatorGen:
	for i in 0 to (ADC_DATA_BITS - 2) generate
	  NegatorX: AddSub port map ('0', inputError(i), inputError(0), abs_carrys(i+1), abs_sum(i), abs_carrys(i));
	end generate;	
	abs_error_latching: process (sys_clk, PresentState)
	begin		
		if rising_edge(sys_clk) then	
			if (PresentState(FSM_FUB_ABS_INDEX) = '1') then 
				abs_error <= (0 to (FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & abs_sum;								
			end if;
		end if;
	end process abs_error_latching;
	
	-- registered residual accumulator
	ResAccumFinal: AddSub port map (residual_accumulated(FILTER_RESIDUAL_ACCUMULATOR_BITS-1), abs_error(FILTER_RESIDUAL_ACCUMULATOR_BITS-1), '0', '0', res_sum(FILTER_RESIDUAL_ACCUMULATOR_BITS-1), res_carrys(FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	ResAccumGen:
	for i in 0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 2) generate
	  ResAccumX: AddSub port map (residual_accumulated(i), abs_error(i), '0', res_carrys(i+1), res_sum(i), res_carrys(i));
	end generate;	
	res_accum_latching: process (sys_clk, PresentState)
	begin		
		if rising_edge(sys_clk) then	
			if (clearResAccum = '1') then 
				residual_accumulated <= (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '0');
			else
				if (PresentState(FSM_FUB_ADD_INDEX) = '1') then
					residual_accumulated <= res_sum;
				end if;
			end if;
		end if;
	end process res_accum_latching;	
	
	-- comparison of best residual so far to current residual. sign extended implicitly one bit (residuals guaranteed positive) to avoid overflow. 
	-- if comparison (accum - best > 0), accum > best and best is still best.
	-- a-b sign extended one bit is 0a - 0b = 0a + 1!b + 1 so if MSB carry out of a + !b + 1 is 1, accum > best, and if 0, best > accum.
	CmpFinal: AddSub port map (residual_accumulated(FILTER_RESIDUAL_ACCUMULATOR_BITS-1), bestResidual(FILTER_RESIDUAL_ACCUMULATOR_BITS-1), '1', '1', open, cmp_carrys(FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	CmpGen:
	for i in 0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS - 2) generate
	  CmpX: AddSub port map (residual_accumulated(i), bestResidual(i), '1', cmp_carrys(i+1), open, cmp_carrys(i));
	end generate;	
	isBestFilterStillBest <= '1' when (cmp_carrys(0) = '1') else '0';
	
	errorSampleCounter: kBitCounter
		generic map ( k => FILTER_UPDATE_INTERVAL_COUNTER_BITS )
		port map (	
			sys_clk => sys_clk,
			clear => clearErrorSampleCounter,
			run => incrementErrorSampleCounter,
			count => open,
			finalCarry => isErrorSampleCounterDone
			);
	bestRes: register_best_residual
    port map (	  
			reset => reset,
			sys_clk => sys_clk, 			
			load_residual_accumulator => load_residual_accumulator,
			load_data => residual_accumulated,						
			best_residual => bestResidual
        );                                               	

	BestCoeffUpdater: for i in 0 to (FILTER_FIR_LENGTH-1) generate
		bestCoeffX: register_best_filter_coefficient
		port map (
			reset => reset,
			sys_clk => sys_clk,			
			load_coefficient => load_residual_accumulator,
			load_data => working_filter(i),
			best_coefficient => bestFilterCoefficients(i)
		);
	end generate;
	
	-- synchronous state update
	fsm_filtupdate_StateUpdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then					
			PresentState <= NextState;											
		end if;
	end process fsm_filtupdate_StateUpdate;
	
	-- combinational NextState calculation and control signal generation	
	clearErrorSampleCounter <= '1' when ((reset = '1') or (PresentState(FSM_FUB_WIPE_INDEX) = '1') ) else '0';
	incrementErrorSampleCounter <= '1' when (PresentState(FSM_FUB_ADD_INDEX) = '1') else '0';
	reset_working_to_best_filter <= '1' when (PresentState(FSM_FUB_WIPE_INDEX) = '1') else '0';
	update_working_filter <= '1' when (PresentState(FSM_FUB_STEP_INDEX) = '1') else '0';
	clearResAccum <= '1' when ( (reset = '1') or (PresentState(FSM_FUB_WIPE_INDEX) = '1') ) else '0';
	load_residual_accumulator <= '1' when (PresentState(FSM_FUB_UPD_BEST_INDEX) = '1') else '0';
	
	-- Please see Block Diagrams in Electronic Submission for State Transitions --
	fsm_filter_update_NextStateCalc: process (PresentState, isErrorSampleCounterDone, trigger, reset, shouldUpdate, isBestFilterStillBest)
	begin		
		NextState <= FSM_FUB_WAIT; -- by default.	 
		
		if ( (PresentState(FSM_FUB_WAIT_INDEX) = '1') and (trigger = '1') and (reset = '0') and (shouldUpdate = '1') ) then
			NextState <= FSM_FUB_ABS;
		end if;
		
		if ( (PresentState(FSM_FUB_WAIT_INDEX) = '1') and (trigger = '1') and (reset = '0') and (shouldUpdate = '0') ) then
			NextState <= FSM_FUB_WIPE;
		end if;
		
		if ( (PresentState(FSM_FUB_ABS_INDEX) = '1') and (reset = '0') ) then
			NextState <= FSM_FUB_ADD;
		end if;
		
		if ( (PresentState(FSM_FUB_ADD_INDEX) = '1') and (reset = '0') and (isErrorSampleCounterDone = '1') ) then			
			NextState <= FSM_FUB_CMP;			
		end if;
		
		if ( (PresentState(FSM_FUB_CMP_INDEX) = '1') and (reset = '0') ) then
			if (isBestFilterStillBest = '1') then			
				NextState <= FSM_FUB_WIPE;			
			else 
				NextState <= FSM_FUB_UPD_BEST;			
			end if;
		end if;
		
		if ( (PresentState(FSM_FUB_UPD_BEST_INDEX) = '1') and (reset = '0') ) then			
			NextState <= FSM_FUB_WIPE;						
		end if;
				
		if ( (PresentState(FSM_FUB_WIPE_INDEX) = '1') and (reset = '0') and (shouldUpdate = '1') ) then			
			NextState <= FSM_FUB_STEP;						
		end if;
		
	end process fsm_filter_update_NextStateCalc;

end  dataflow;
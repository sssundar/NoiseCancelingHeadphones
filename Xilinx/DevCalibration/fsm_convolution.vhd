---------------------------------------------------------------------------
--
--  Convolution Multiply and Accumulate Controllers
--
--  This entity contains two FSMs. The first waits for a signal to multiply filter coefficients with input history.
--  The second waits for a signal from the first, to accumulate then truncate the results.
--  Both have synchronous reset via the global reset.
--
--  Inputs:
-- 	from fsm_input_history_update entity
--			trigger_convolution  	- active high signal to change fsm state to shifting for log2(n) cycles.
--
--    global
--     	sys_clk     				- clock input (active positive edge)
-- 		reset 						- active high
--
--  Outputs:
--      shift     					- active high signal to the input history register block
--
--  Entities included are:
--     fsm_convolution
--
--
--  Revision History:
--     09/27/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fsm_convolution} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  fsm_convolution  is

    port (
		reset : in std_logic; -- active high
		sys_clk : in std_logic; -- active high edge		

      trigger_convolution : in std_logic; -- active high			
		
		multiply_shift_request : out std_logic; -- active high
		multiply_negate_request : out std_logic; -- active high
		trigger_fsm_filter_update : out std_logic; -- active high
		accumulator_shift_request : out std_logic; -- active high
		accumulator_clear_request : out std_logic; -- active high
		accumulate_add_request : out std_logic; -- active high
		write_output_register_request : out std_logic -- active high
    );
	
end  fsm_convolution;

	
--}} End of automatically maintained section

architecture  dataflow  of  fsm_convolution  is

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
	
	component nCounter
		generic (
			n : integer := 8  -- counter max value
		);
		port (	
			clk : in std_logic; -- clock input
			clr : in std_logic; -- asynchronous clear
			run : in std_logic; -- run enable 
			count : out integer range 0 to n; 	-- the count value
			hitTarget : out std_logic 		-- active high
			);
	end component;

	-- states
	signal PresentState_Multiplier, NextState_Multiplier : FSM_CONVOLUTION_MULTIPLY_STATE; 																				
	signal PresentState_Accumulator, NextState_Accumulator : FSM_CONVOLUTION_ACCUMULATE_STATE; 																				

	-- counter related, all active high combinational signals
	signal clearAccumulatorSampleCounter : std_logic;
	signal incrementAccumulatorSampleCounter : std_logic;
	signal isAccumulatorSampleCounterDone : std_logic;
	
	signal clearAccumulatorShiftCounter : std_logic;
	signal incrementAccumulatorShiftCounter : std_logic;
	signal isAccumulatorShiftCounterDone : std_logic;
	
	signal clearMultiplyShiftCounter : std_logic;
	signal incrementMultiplyShiftCounter : std_logic;
	signal isMultiplyShiftCounterDone : std_logic;	

begin

	multiplierShiftCounter: kBitCounter
		generic map ( k => FILTER_COEFFICIENT_SHIFT_MULTIPLY_COUNTER_BITS )
		port map (	
			sys_clk => sys_clk,
			clear => clearMultiplyShiftCounter,
			run => incrementMultiplyShiftCounter,
			count => open,
			finalCarry => isMultiplyShiftCounterDone
			);

	accumulatorSampleCounter: kBitCounter
		generic map ( k => FILTER_CONVOLUTION_ACCUMULATE_SAMPLE_COUNTER_BITS )
		port map (	
			sys_clk => sys_clk,
			clear => clearAccumulatorSampleCounter,
			run => incrementAccumulatorSampleCounter,
			count => open,
			finalCarry => isAccumulatorSampleCounterDone
			);
			
	accumulatorShiftCounter: nCounter
		generic map ( n => FILTER_CONVOLUTION_ACCUMULATE_SHIFT_COUNTER_TARGET )		
		port map (	
			clk => sys_clk,
			clr => clearAccumulatorShiftCounter,
			run => incrementAccumulatorShiftCounter,
			count => open,
			hitTarget => isAccumulatorShiftCounterDone
			);
				
	-- synchronous state update
	fsm_multiply_StateUpdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then					
			PresentState_Multiplier <= NextState_Multiplier;											
		end if;
	end process fsm_multiply_StateUpdate;
	
	fsm_accumulate_StateUpdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then		
			PresentState_Accumulator <= NextState_Accumulator;											
		end if;
	end process fsm_accumulate_StateUpdate;

	-- combinational NextState calculation and control signal generation	
	clearAccumulatorSampleCounter <= '1' when ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT) ) else '0';
	incrementAccumulatorSampleCounter <= '1' when ( PresentState_Accumulator(FSM_CAS_ADD_HOT_INDEX) = '1' ) else '0';
	
	clearAccumulatorShiftCounter <= '1' when ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT) ) else '0';
	incrementAccumulatorShiftCounter <= '1' when ( PresentState_Accumulator(FSM_CAS_SHIFT_HOT_INDEX) = '1' ) else '0';
	
	clearMultiplyShiftCounter <= '1' when ( std_match(PresentState_Multiplier,FSM_CONVOLUTION_MULTIPLY_STATE_WAIT) ) else '0';
	incrementMultiplyShiftCounter <= '1' when ( PresentState_Multiplier(FSM_CMS_SHIFT_HOT_INDEX) = '1' ) else '0';
	
	multiply_shift_request <= '1' when ( PresentState_Multiplier(FSM_CMS_SHIFT_HOT_INDEX) = '1' ) else '0';
	multiply_negate_request <= '1' when ( PresentState_Multiplier(FSM_CMS_NEGATE_HOT_INDEX) = '1' ) else '0';
	trigger_fsm_filter_update <= '1' when (PresentState_Multiplier(FSM_CMS_TRIGGER_HOT_INDEX) = '1') else '0';
	
	accumulate_add_request <= '1' when ( PresentState_Accumulator(FSM_CAS_ADD_HOT_INDEX) = '1' ) else '0';
	accumulator_shift_request <= '1' when ( PresentState_Accumulator(FSM_CAS_SHIFT_HOT_INDEX) = '1' ) else '0';
	accumulator_clear_request <= '1' when ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT) ) else '0';
	write_output_register_request <= '1' when (PresentState_Accumulator(FSM_CAS_OUTPUT_HOT_INDEX) = '1') else '0';
	
	
	-- Please see Block Diagrams in Electronic Submission for State Transitions --
	fsm_multiply_NextStateCalc: process (PresentState_Multiplier, isMultiplyShiftCounterDone, trigger_convolution, reset)
	begin		
		NextState_Multiplier <= FSM_CONVOLUTION_MULTIPLY_STATE_WAIT; -- by default.	 
		
		if ( std_match(PresentState_Multiplier,FSM_CONVOLUTION_MULTIPLY_STATE_WAIT) and (trigger_convolution = '1') and (reset = '0') ) then
			NextState_Multiplier <= FSM_CONVOLUTION_MULTIPLY_STATE_SHIFT;
		end if;
		
		if ( std_match(PresentState_Multiplier,FSM_CONVOLUTION_MULTIPLY_STATE_SHIFT) and (reset = '0') ) then
			if (isMultiplyShiftCounterDone = '1') then
				NextState_Multiplier <= FSM_CONVOLUTION_MULTIPLY_STATE_NEGATE;
			else
				NextState_Multiplier <= FSM_CONVOLUTION_MULTIPLY_STATE_SHIFT;
			end if;			
		end if;		

		if ( std_match(PresentState_Multiplier,FSM_CONVOLUTION_MULTIPLY_STATE_NEGATE) and (reset = '0') ) then
			NextState_Multiplier <= FSM_CONVOLUTION_MULTIPLY_STATE_TRIGGER_ACCUMULATOR_AND_FILTER_UPDATE;			
		end if;				
				
	end process fsm_multiply_NextStateCalc;
	
	
	-- Please see Block Diagrams in Electronic Submission for State Transitions --
	fsm_accum_NextStateCalc: process (PresentState_Accumulator, PresentState_Multiplier, isAccumulatorShiftCounterDone, isAccumulatorSampleCounterDone)
	begin		
		NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT; -- by default.	 

		if ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT) and (PresentState_Multiplier(FSM_CMS_TRIGGER_HOT_INDEX) = '1') and (reset = '0') ) then
			NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_ADD;
		end if;
		
		if ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_ADD) and (reset = '0') ) then
			if (isAccumulatorSampleCounterDone = '1') then
				NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_OUTPUT;
			else
				NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_SHIFT;
			end if;
		end if;
		
		if ( std_match(PresentState_Accumulator,FSM_CONVOLUTION_ACCUMULATE_STATE_SHIFT) and (reset = '0') ) then
			if (isAccumulatorShiftCounterDone = '1') then
				NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_ADD;
			else
				NextState_Accumulator <= FSM_CONVOLUTION_ACCUMULATE_STATE_SHIFT;
			end if;				
		end if;
		
	end process fsm_accum_NextStateCalc;

end  dataflow;
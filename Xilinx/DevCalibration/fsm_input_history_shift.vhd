---------------------------------------------------------------------------
--
--  Input History Register Block Shift Controller
--
--  This is an FSM that waits for a signal to shift the input history register block
--  to prepare for a new input from the ADC block. 
--
--  Inputs:
-- 	from fsm_input_history_update entity
--			shift_input_history  	- active high signal to change fsm state to shifting for log2(n) cycles.
--
--    global
--     	sys_clk     				- clock input (active positive edge)
-- 		reset 						- active high
--
--  Outputs:
--      shift     					- active high signal to the input history register block
--
--  Entities included are:
--     fsm_input_history_shift
--
--
--  Revision History:
--     09/23/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fsm_input_history_shift} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  fsm_input_history_shift  is

    port (
		reset : in std_logic; -- active high
      shift_input_history : in std_logic; -- active high
		sys_clk : in std_logic; -- active high edge		
		shift : out std_logic -- active high
    );
	
end  fsm_input_history_shift;

--}} End of automatically maintained section

architecture  dataflow  of  fsm_input_history_shift  is

	component kBitCounter
		generic (
			k : integer := 3 -- number of bits in counter
		);
		port (	
			sys_clk : in std_logic; 				-- clock input
			clear : in std_logic; 					-- synchronous clear
			run : in std_logic; 						-- increment enable 
			count : out std_logic_vector(0 to (k-1));  -- the counter state
			finalCarry :  out  std_logic       --  carry out
			);
	end component;

	-- states
	signal PresentState, NextState : FSM_INPUT_HISTORY_SHIFT_STATE; 																				

	-- counter related
	signal clearShiftCounter : std_logic;
	signal incrementShiftCounter : std_logic;	
	signal shiftCount : std_logic_vector(0 to (FILTER_INPUT_HISTORY_SHIFT_COUNTER_BITS-1));	
	signal isCountAtMax : std_logic;  

begin

	shiftCounter: kBitCounter
		generic map ( k => FILTER_INPUT_HISTORY_SHIFT_COUNTER_BITS )
		port map (	
			sys_clk => sys_clk,
			clear => clearShiftCounter,
			run => incrementShiftCounter,
			count => shiftCount,
			finalCarry => isCountAtMax
			);

	-- synchronous state update
	fsm_input_history_shift_StateUpdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then		
			PresentState <= NextState;											
		end if;
	end process fsm_input_history_shift_StateUpdate;

	-- combinational NextState calculation and control signal generation	
	clearShiftCounter <= '1' when (PresentState = FSM_INPUT_HISTORY_SHIFT_STATE_WAIT) else '0';
	incrementShiftCounter <= '1' when (PresentState = FSM_INPUT_HISTORY_SHIFT_STATE_SHIFT) else '0';
	shift <= incrementShiftCounter;
	
	-- Please see Block Diagrams in Electronic Submission for State Transitions --
	fsm_input_history_shift_NextStateCalc: process (PresentState, isCountAtMax, shift_input_history, reset)
	begin		
		NextState <= FSM_INPUT_HISTORY_SHIFT_STATE_WAIT; -- by default.	 
		
		if ( (PresentState = FSM_INPUT_HISTORY_SHIFT_STATE_WAIT) and (shift_input_history = '1') and (reset = '0') ) then
			NextState <= FSM_INPUT_HISTORY_SHIFT_STATE_SHIFT; 
		end if;

		if ( (PresentState = FSM_INPUT_HISTORY_SHIFT_STATE_SHIFT) and (isCountAtMax = '0') and (reset = '0') ) then
			NextState <= FSM_INPUT_HISTORY_SHIFT_STATE_SHIFT; 			
		end if;		
	end process fsm_input_history_shift_NextStateCalc;

end  dataflow;
---------------------------------------------------------------------------
--
--  FSM to load next samples/errors from ADC block, then copy working input history/filter coefficients to 
--  convolution block, then trigger filter update block and convolution.
--
--  Inputs: 	
--     	sys_clk     				- clock input (active positive edge)
-- 		reset 						- active high
-- 		getData				 		- active high
--
--  Outputs:
-- 		triggerAdaptiveFilter 	- active high (also copies working input/filter to convolution input/filter registers).
-- 		getADCOutputRegisters  	- active high (also clears convolution input history registers)
-- 		copyFilters 
--
--  Entities included are:
--     fsm_load_next_samples
--
--
--  Revision History:
--     09/29/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fsm_load_next_samples} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  fsm_load_next_samples  is

    port (
		reset : in std_logic; -- active high      
		sys_clk : in std_logic; -- active high edge		
		getData : in std_logic; -- active high
		getADCOutputRegisters : out std_logic; -- active high
		triggerAdaptiveFilter : out std_logic -- active high
    );
	
end  fsm_load_next_samples;

--}} End of automatically maintained section

architecture  dataflow  of  fsm_load_next_samples  is	

	-- states
	signal PresentState, NextState : FSM_GDT_STATE; 																				

begin

	-- synchronous state update
	fsm_gdt_StateUpdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then		
			PresentState <= NextState;											
		end if;
	end process fsm_gdt_StateUpdate;

	-- combinational NextState calculation and control signal generation	
	getADCOutputRegisters <= '1' when (PresentState(FSM_GDT_GET_INDEX) = '1') else '0';
	triggerAdaptiveFilter <= '1' when (PresentState(FSM_GDT_CONV_INDEX) = '1') else '0';
	
	-- Please see Block Diagrams in Electronic Submission for State Transitions --
	fsm_gdt_NextStateCalc: process (PresentState, getData, reset)
	begin		
		NextState <= FSM_GDT_STATE_WAIT; -- by default.	 
		
		if ( (PresentState(FSM_GDT_WAIT_INDEX) = '1') and (reset = '0') and (getData = '1') ) then
			NextState <= FSM_GDT_STATE_GET_DATA;
		end if;
		
		if ( (PresentState(FSM_GDT_GET_INDEX) = '1') and (reset = '0') ) then
			NextState <= FSM_GDT_STATE_SETUP_CONV;
		end if;
		
	end process fsm_gdt_NextStateCalc;

end  dataflow;
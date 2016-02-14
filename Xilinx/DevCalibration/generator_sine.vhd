-- This entity is a 8-bit unsigned "sine" wave sample generator. 
-- It actually generates a square wave from 0-255, 
-- incrementing by +5 or decrementing by +5 every sample tick.
-- If sample ticks are 40 kHz this yields a 400 Hz wave.
--
-- It takes as input 
--  a global clock
--  an active high, synchronous sample tick
--  an active high, synchronous reset
--
-- It outputs 8 sample bits, always.
--  These change on the clock following
--  a sample tick.
--
-- Reset sets the state machine to "Increment"
-- and the current sample to 0.
--
-- Operation
--  Internally we have a state machine with two states:
--   Increment, Decrement
--  where Inc -> Inc, Dec
--  and   Dec -> Dec, Inc
--  These output an asynchronous inc/dec signal to a +/-5 adder
--  which operates on a sign extension of the current sample.
--  On a sample tick, we update state. 
--
--  When the current sample + 5 would yield 255, on the next 
--  tick we latch in the sample + 5, but switch to the dec state.
--  When the current sample - 5 would yield 0, on the next
--  tick we latch in the sample - 5, but switch to the inc state.
--
-- Last Revised: 12 Feb 2016 by Sushant Sundaresh. designed, tested

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generator_sine is
	Port (		
	 	-- Outputs
		sample : out std_logic_vector(0 to 7);	-- synchronous
		
		-- Inputs
		sample_tick : in std_logic; 	-- active high, synchronous
		reset : in std_logic;  			-- active high, synchronous
		
		-- Global Clock
		sys_clk : in std_logic
	);
end generator_sine;

architecture dataflow of generator_sine is
	-- Asynchronous adder
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	
	-- Internal State, Registered, 9 bit signed, implicit sign bit in adder
	signal wave_sample	: std_logic_vector(0 to 7);	 

	-- Internal Adder Wiring, Asynchronous 
	signal wave_next    : std_logic_vector(0 to 7); 
	signal carries      : std_logic_vector(0 to 7);

	-- State Constants	
	subtype FSM_WAVE_STATE is std_logic;
	constant INCREMENTING : FSM_WAVE_STATE := '0';	
	constant DECREMENTING : FSM_WAVE_STATE := '1';	
	
	-- State
	signal PresentState, NextState : FSM_WAVE_STATE;
	
	-- Control Signals, Active High, Asynchronous
	signal transition : std_logic;

	-- Adder Constants, 9 bit signed.
	constant SG_POSITIVE_FIVE : std_logic_vector(0 to 7) := "00000101";
	constant SG_ZERO 		  : std_logic_vector(0 to 7) := "00000000";
	constant SG_MAX 		  : std_logic_vector(0 to 7) := "11111111";

begin
	-- Output
	sample <= wave_sample;	

	-- FSM Control Signals
	transition <= '1' when ( std_match(wave_next,SG_MAX) ) or ( std_match(wave_next,SG_ZERO) ) else '0';
	
	NextState <= INCREMENTING when ( (std_match(PresentState,INCREMENTING) and (transition = '0')) or (std_match(PresentState,DECREMENTING) and (transition = '1')) ) else DECREMENTING;

	process (sys_clk, reset, PresentState, NextState, sample_tick, wave_next) 
	begin	
		if rising_edge(sys_clk) then
			if ((sample_tick = '1') and (reset = '0')) then			
				PresentState <= NextState;		
				wave_sample <= wave_next;			
			elsif (reset = '1') then			
				PresentState <= INCREMENTING;		
				wave_sample <= SG_ZERO;
			end if;
		end if;
	end process;

	-- Addition Wiring
	SGInitial: AddSub port map (wave_sample(7), SG_POSITIVE_FIVE(7), PresentState, PresentState, wave_next(7), carries(7));
	SGGen:
	for i in 0 to 6 generate
	  SGX: AddSub port map (wave_sample(i), SG_POSITIVE_FIVE(i), PresentState, carries(i+1), wave_next(i), carries(i));
	end generate;	 
	
end dataflow;
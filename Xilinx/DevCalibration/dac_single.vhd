-- This entity is a first order sigma-delta DAC operating
-- on an 8-bit unsigned input and generating a single output bit.
-- It was designed not to overflow via software simulation.
--
-- Inputs
--	filter sample (8 bits, unsigned), mutable
--	calibration sample (8 bits, unsigned), mutable
--	flag_calibration (active high), registered
-- reset (active high), synchronous
--	sys_clk (20 MHz)
--	sample_tick (40 kHz), registered
--	oversample_tick (1.25 MHz), registered
--
--	oe (active high), registered
--
-- Outputs
--	out_dac (1 bit), asynchronous
--
-- Limitations
-- As designed this entity introduces a 19 bit asynchronous adder.
-- If this turns out to be the critical path it can easily be pipelined.
--
-- Operation
-- The input sample can either come from the filter or the 
-- calibration block. This is decided by the flag_calibration.
-- In either case the sample is latched on a sample_tick.
--
-- This sample is added to either an 8 bit unsigned 255 or 0
-- The value depends on whether the DAC accumulator is + or -.
-- If the DAC accumulator is > 0, the value is 255 implicitly
-- sign extended to 9 bits along with the sample. This is
-- really just the negation of the MSB of the accumulator 
-- passed into every bit of the initial sample adder.
--
-- The sample is not affected by this operation.
--
-- Both sample and quantizer !(DAC accumulator > 0) are
-- implicitly sign extended to 9 bits during this first addition.
-- The result is sign extended to 11 bits using
-- !(8th carry out) as the extender.
-- 
-- This result is accumulated in a 11 bit accumulator guaranteed
-- not to overflow. Accumulation happens on oversample_ticks.
-- 
-- The output is simply the negation of the MSB of the accumulator.
-- 
-- On sample_ticks, the accumulator is zeroed and the sample is
-- updated. This operation is gated by the system clock.
--
-- On reset all state goes to 0.
--
-- Last Revised: 13 Feb 2016 by Sushant Sundaresh. implemented.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dac_single is
	Port (	
		-- Inputs
		filter_sample : in std_logic_vector(0 to 7); 
		calibration_sample : in std_logic_vector(0 to 7);
		flag_calibration : in std_logic;
		sys_clk : in std_logic;
		sample_tick : in std_logic;
		oversample_tick : in std_logic;
		oe : in std_logic;	
		reset : in std_logic;
		-- Outputs
		out_dac : out std_logic;
		-- Outputs for test visibility
		accumulator_state : out std_logic_vector(0 to 10);
		internal_sample_state : out std_logic_vector(0 to 7)
	);
end dac_single;

architecture dataflow of dac_single is
	-- Asynchronous adder
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input (set to 1 for LSB on sub)
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	
	-- Internal Sample, Registered, 8 bit unsigned, implicit '0' 9th sign bit in adder
	signal dac_sample	: std_logic_vector(0 to 7);	 
	signal accumulator : std_logic_vector(0 to 10);
	
	-- Internal Adder Wiring, Asynchronous 
	signal sample_adder : std_logic_vector(0 to 7); 
	signal sample_carries : std_logic_vector(0 to 7);
	signal accum_adder : std_logic_vector(0 to 10);
	signal accum_carries: std_logic_vector(0 to 10);	
	
	-- Control Signals, Active High, Asynchronous
	signal quantizer : std_logic; 	 -- !accumulator(0)
	signal sign_extender : std_logic; -- !sample_carries(0)

	-- Adder Constants, 9 bit signed.
	constant DAC_ACCUM_ZERO 	  : std_logic_vector(0 to 10) := "00000000000";	
	constant DAC_SAMPL_ZERO 	  : std_logic_vector(0 to 7) := "00000000";
	
begin
	-- Test Outputs
	accumulator_state <= accumulator;
	internal_sample_state <= dac_sample;
	
	-- Output	
	out_dac <= quantizer when (oe = '1') else '0';
	
	-- Sign Extension and Quantizer Logic
	quantizer <= '0' when (accumulator(0) = '1') else '1';
	sign_extender <= '0' when (sample_carries(0) = '1') else '1';		

	-- Input and Accumulator Register Latching
	process (sys_clk, reset, dac_sample, accumulator, sample_tick, filter_sample, calibration_sample, oversample_tick, accum_adder) 
	begin	
		if rising_edge(sys_clk) then
			if ((reset = '0') and (sample_tick = '1')) then			
				if (flag_calibration = '1') then 
					dac_sample <= calibration_sample;
				else
					dac_sample <= filter_sample;
				end if;
				accumulator <= DAC_ACCUM_ZERO;			
			elsif ((reset = '0') and (sample_tick = '0') and (oversample_tick = '1')) then
				accumulator <= accum_adder;
			elsif (reset = '1') then			
				dac_sample <= DAC_SAMPL_ZERO;		
				accumulator <= DAC_ACCUM_ZERO;			
			end if;
		end if;
	end process;

	-- Sample Addition Wiring
	DACSampInitial: AddSub port map (dac_sample(7), quantizer, '1', '1', sample_adder(7), sample_carries(7));
	DACSampGen:
	for i in 0 to 6 generate
	  DACSampX: AddSub port map (dac_sample(i), quantizer, '1', sample_carries(i+1), sample_adder(i), sample_carries(i));
	end generate;	 	
	
	-- DAC Accumulator Wiring
	DACAccumInitial: AddSub port map (accumulator(10), sample_adder(7), '0', '0', accum_adder(10), accum_carries(10));
	DACAccumGen:
	for i in 0 to 6 generate
	  DACAccumX: AddSub port map (accumulator(i+3), sample_adder(i), '0', accum_carries(i+4), accum_adder(i+3), accum_carries(i+3));
	end generate;	 	
	DACAccum2: AddSub port map (accumulator(2), sign_extender, '0', accum_carries(3), accum_adder(2), accum_carries(2));		
	DACAccum1: AddSub port map (accumulator(1), sign_extender, '0', accum_carries(2), accum_adder(1), accum_carries(1));		
	DACAccum0: AddSub port map (accumulator(0), sign_extender, '0', accum_carries(1), accum_adder(0), accum_carries(0));		
	
end dataflow;
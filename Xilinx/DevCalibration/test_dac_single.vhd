-- test_dac_single.vhd
--
-- This testbench simply runs the DAC with a few test inputs
-- and verifies correct operation for simple cases.
--
-- This is also a visual test, though it really shouldn't be.
-- The meat of it is a user-specified test uint8_t, with
-- known qualitative sigma-delta output. All of these seem
-- acceptable, as well.
--
--  Revision History:
--   13 February 2016 Sushant Sundaresh created testbench
--   13 February 2016 Sushant Sundaresh passes visual screen

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    

entity test_dac_single is
end test_dac_single;

architecture test_dac_single_TbArch of test_dac_single is

	component dac_single is
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
	end component;

    -- Stimulus signals 
	 signal clock : std_logic; 
	 signal reset : std_logic;    
	 signal oe : std_logic;
	 signal sample_tick : std_logic; 
	 signal oversample_tick : std_logic;
	 signal flag_calibration : std_logic;
	 signal filter_sample : std_logic_vector(0 to 7);
	 signal calibration_sample : std_logic_vector(0 to 7);
	 
	 -- UUT Output
	 signal out_dac : std_logic;
	 signal accum : std_logic_vector(0 to 10);
	 signal sampl : std_logic_vector(0 to 7);
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;
	 
	 -- Visual Screen Constants
	 constant val_001 : std_logic_vector(0 to 7) := "00000001"; -- should be mostly low - it is
	 constant val_254 : std_logic_vector(0 to 7) := "11111110"; -- should be mostly high - it is
	 constant val_128 : std_logic_vector(0 to 7) := "10000000"; -- should be half-half - it is
	 constant val_064 : std_logic_vector(0 to 7) := "01000000"; -- should tend towards low - it does
begin
	
    -- UUT
    UUT: dac_single port map  (filter_sample, calibration_sample, flag_calibration, clock, sample_tick, oversample_tick, oe, reset, out_dac, accum, sampl);
	        
    process		
    begin  
		-- Reset.
		-- Set the filter_sample to 0.
		-- Set the calibration sample to 1.
		-- Choose the calibration sample.
		-- Disable output.				
		reset <= '1';
		filter_sample <= "00000000";
		calibration_sample <= "11111111";
		flag_calibration <= '1';
		sample_tick <= '0';
		oversample_tick <= '0';
		oe <= '0';
		wait for 95 ns;		
				
		reset <= '0';
		wait for 5 ns;
		
		-- Wait a few clocks. Internal registers
		-- should remain cleared. Output should be disabled, 0.
		assert (std_match(sampl, (0 to 7 => '0')))
			report  "DAC sample not cleared on reset."
			severity ERROR; 		
		assert (std_match(accum, (0 to 10 => '0')))
			report  "DAC accumulator not cleared on reset."
			severity ERROR; 					
		assert (std_match(out_dac, '0'))
			report  "OE failed to disable output."
			severity ERROR; 		
		
		-- Enable output, and as accum = 0, out_dac = 1
		oe <= '1';
		wait for 100 ns;
		assert (std_match(out_dac, '1'))
			report "OE failed to enable output."
			severity ERROR;
		
		-- Sample tick to get calibration sample
		sample_tick <= '1';
		wait for 95 ns;
		sample_tick <= '0';
		wait for 5 ns;
		
		-- Tick for oversampling, confirm accumulator state stays 0 (255-255+0 = 0)
		oversample_tick <= '1';
		wait for 95 ns;
		oversample_tick <= '0';
		wait for 5 ns;
		assert (std_match(sampl, "11111111") and std_match(accum,"00000000000") and std_match(out_dac,'1'))
			report "First accumulation failed."
			severity ERROR;
		
		-- Then, change to filter_sample, tick for sample, and confirm accumulator wiped
		-- and sample set appropriately.
		flag_calibration <= '0';
		sample_tick <= '1';
		wait for 95 ns;		
		sample_tick <= '0';
		wait for 5 ns;
		assert (std_match(sampl, "00000000") and std_match(accum,"00000000000") and std_match(out_dac,'1'))
			report "Second sample tick failed."
			severity ERROR;
	
		-- Confirm accumulator accumlates twice in succession correctly with a filter_sample = 0
		-- With output currently 1, this means the sample_adder should yield 
		-- 000000000-011111111 = 
		-- 000000000+100000001 = 
		-- 100000001 = -255
		-- and therefore get sign extended to 11100000001
		-- After one oversample tick, the accumulator should become 11100000001, negative,
		-- so the output should become 0.
		-- Thus the second oversample tick should see the accumulator unchanged.
		oversample_tick <= '1';
		wait for 100 ns;
		assert (std_match(sampl, "00000000") and std_match(accum,"11100000001") and std_match(out_dac,'0'))
			report "Sequential accumulator with 0 sample - first accum failed."
			severity ERROR;
		wait for 100 ns;
		assert (std_match(sampl, "00000000") and std_match(accum,"11100000001") and std_match(out_dac,'0'))
			report "Sequential accumulator with 0 sample - second accum failed."
			severity ERROR;
		
		-- Make sure if an oversample tick and a sample tick overlap, the sample tick wins.
		sample_tick <= '1';
		flag_calibration <= '1';
		calibration_sample <= val_064;  -- USER SPECIFIED
		wait for 100 ns;
		assert (std_match(sampl, calibration_sample) and std_match(accum,"00000000000") and std_match(out_dac,'1'))
			report "Sample tick not totally dominant over oversample tick."
			severity ERROR;
		
		-- Not rigorous at all, but for now, good enough.
		-- Now let's play it by eye and put in a user-variable sample (0x01, 0xFE, or 0x80) as set above,
	   -- and make sure the output visually looks like the appropriate sigma-delta DAC output, 
		-- as known from SW simulation.
		sample_tick <= '0';		
		for i in 1 to 1000 loop
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

end test_dac_single_TbArch; 



configuration TESTBENCH_FOR_dac_single of test_dac_single is
    for test_dac_single_TbArch
        for UUT : dac_single
            use entity work.dac_single(dataflow);
        end for;         
    end for;
end TESTBENCH_FOR_dac_single;

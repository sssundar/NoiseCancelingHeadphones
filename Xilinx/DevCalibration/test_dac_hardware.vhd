---------------------------------------------------------------------------
--
--  Structural model for the DAC hardware test setup
--  
--  Contains a square wave (sinusoidal) generator, sigma-delta DAC,
--  and two pulse generators dividing 20 MHz down to 1.28 MHz and 40 kHz. 
--  Requires a clock (50 MHz -> 20 MHz), reset & output enable pin configuration
--  file and an external hardware post-amplifier (LM386, see design doc).
--
--  Entities included are:
--     test_dac_hardware
--
--  Revision History:
-- 	 2/13/2016 Sushant Sundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {test_dac_hardware} architecture {structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity  test_dac_hardware  is
    port (		
		-- User Buttons, to be synchronized -- 		
		reset : in std_logic;		 					-- Switch 5, active high
		oe : in std_logic;								-- Switch 6, active high
		
		reset_led : out std_logic; 				   -- For state visibility, 
		oe_led : out std_logic; 						-- and to demonstrate programming
		
		-- Testing clocking
		hz_pulse : out std_logic;
		
		-- a DAC (output) data line.
		out_dac : out std_logic;
		out_dac1 : out std_logic;
		out_dac2 : out std_logic;
		out_dac3 : out std_logic;
		
		-- System Clock
		sys_clk_50 : in std_logic
    );
end  test_dac_hardware;

--}} End of automatically maintained section

architecture  structural  of  test_dac_hardware  is					
	
	component clock_divider is
   port ( CLKIN_IN        : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic);
	end component;

	component kBitCounter
		generic (
			k : integer := 3 						
		);
		port (	
			sys_clk : in std_logic; 			
			clear : in std_logic; 				
			run : in std_logic; 					
			count : out std_logic_vector(0 to (k-1));
			finalCarry : out std_logic 					
			);
	end component;

	component generator_sine is
		Port (		
		 	-- Outputs
			sample : out std_logic_vector(0 to 7);	-- synchronous
			
			-- Inputs
			sample_tick : in std_logic; 	-- active high, synchronous
			reset : in std_logic;  			-- active high, synchronous
			
			-- Global Clock
			sys_clk : in std_logic
		);
	end component;

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
			out_dac1 : out std_logic;
			out_dac2 : out std_logic;
			out_dac3 : out std_logic; -- testing
			
			-- Outputs for test visibility
			accumulator_state : out std_logic_vector(0 to 10);
			internal_sample_state : out std_logic_vector(0 to 7)
		);
	end component;

	-- Sample Pulses
	signal sample_tick, oversample_tick : std_logic;	

	-- Sample Wiring
	signal dac_in : std_logic_vector(0 to 7);	
	
	-- Clock Management
	signal sys_clk_20 : std_logic;
	
	-- Test LED pulsing at 1 Hz for clocking demonstration
	signal hz_pulse_latched : std_logic;
	signal hz_led : std_logic;
	
begin
	
	-- Test LEDs
	reset_led <= reset;
	oe_led <= oe;
	
	-- Clock		
	ClockManager: clock_divider
		port map ( 
			CLKIN_IN => sys_clk_50,
			CLKFX_OUT => sys_clk_20,
			CLKIN_IBUFG_OUT => open,
			CLK0_OUT => open
			 );	

	-- 1.28 MHz off 20 MHz
	SixteenCounter: kBitCounter
		generic map ( k => 4 )
		port map (	
			sys_clk => sys_clk_20,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => oversample_tick
			);

	-- 40 kHz off 20 MHz (19 bit counter)	
	-- For testing, 160 Hz and send out_dac to an LED (19 bit counter)
	-- For actual, 9 bit counter
	FiveTwelveCounter: kBitCounter
		generic map ( k => 9 )
		--generic map ( k => 19 )
		port map (	
			sys_clk => sys_clk_20,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => sample_tick
			);

	
	-- TEST CODE --
	-- 1 Hz off 20 MHz
	HzCounter: kBitCounter
		generic map ( k => 24 )
		port map (	
			sys_clk => sys_clk_20,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => hz_led
			);

	process (sys_clk_20, hz_pulse_latched, hz_led)
	begin
			if rising_edge(sys_clk_20) then
				if ((hz_led = '1') and (reset = '0')) then
					if (hz_pulse_latched = '1') then
						hz_pulse_latched <= '0';
					else 
						hz_pulse_latched <= '1';
					end if;
				elsif (reset = '1') then
					hz_pulse_latched <= '0';
				end if;				
			end if;
	end process;
	
	hz_pulse <= hz_pulse_latched;
	-- TEST CODE DONE --
	
	-- Sound waveform generator
	WaveGen: generator_sine
		port map (		 	
			sample => dac_in,						
			sample_tick => sample_tick,
			reset => reset,						
			sys_clk => sys_clk_20
			);	
	
	DAC: dac_single
		port map (				
			filter_sample => "00000000",
			calibration_sample => dac_in,
			flag_calibration => '1',
			sys_clk => sys_clk_20,
			sample_tick => sample_tick,
			oversample_tick => oversample_tick,
			oe => oe,
			reset => reset,			
			out_dac => out_dac,			
			out_dac1 => out_dac1,	
			out_dac2 => out_dac2,	
			out_dac3 => out_dac3,	
			accumulator_state => open,
			internal_sample_state => open
			);	

end  structural;


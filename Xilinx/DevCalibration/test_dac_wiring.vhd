--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {test_dac_wiring} architecture {dstaflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity  test_dac_wiring  is
    port (		
		-- User Buttons, to be synchronized -- 		
		reset : in std_logic;		 					-- Switch 5, active high
		oe : in std_logic;								-- Switch 6, active high
						
		-- a DAC (output) data line.
		out_dac : out std_logic;
		
		-- System Clock
		sys_clk : in std_logic
    );
end  test_dac_wiring;

--}} End of automatically maintained section

architecture  dataflow  of  test_dac_wiring  is					

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
			-- Outputs for test visibility
			accumulator_state : out std_logic_vector(0 to 10);
			internal_sample_state : out std_logic_vector(0 to 7)
		);
	end component;

	-- Sample Pulses
	signal sample_tick, oversample_tick : std_logic;	

	-- Sample Wiring
	signal dac_in : std_logic_vector(0 to 7);	
	
begin
	
	-- 1.28 MHz off 20 MHz
	SixteenCounter: kBitCounter
		generic map ( k => 4 )
		port map (	
			sys_clk => sys_clk,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => oversample_tick
			);

	-- 40 kHz off 20 MHz
	FiveTwelveCounter: kBitCounter
		generic map ( k => 9 )
		port map (	
			sys_clk => sys_clk,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => sample_tick
			);
	
	-- Sound waveform generator
	WaveGen: generator_sine
		port map (		 	
			sample => dac_in,						
			sample_tick => sample_tick,
			reset => reset,						
			sys_clk => sys_clk
			);	
	
	DAC: dac_single
		port map (				
			filter_sample => "00000000",
			calibration_sample => dac_in,
			flag_calibration => '1',
			sys_clk => sys_clk,
			sample_tick => sample_tick,
			oversample_tick => oversample_tick,
			oe => oe,
			reset => reset,			
			out_dac => out_dac,			
			accumulator_state => open,
			internal_sample_state => open
			);	

end  dataflow;
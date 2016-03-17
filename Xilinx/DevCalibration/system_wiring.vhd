---------------------------------------------------------------------------
--
--  Structural model for the headphones
--  Think of this as a baseline functionality test.
--   
--  Entities included are:
--     system_wiring
--
--  Revision History:
-- 	 3/16/2016 Sushant Sundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {system_wiring} architecture {structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  system_wiring  is
    port (		
		-- User Buttons, to be synchronized -- 		
		reset : in std_logic;		 					-- Switch 5, active high
		async_oe : in std_logic;								-- Switch 6, active high		
		async_ae : in std_logic; 								-- Switch 3, active high
		
		-- ADC IO
		nInt 			: in std_logic;	-- interrupt, active low, asynchronous		
												-- Pin M15
												
		databus  	: in std_logic_vector(0 to 7);  
			--   adc data bus (low 8 bits, 0 is MSB here but mapped to DB7 from ADC, the MSB).
			-- ADC DB0 -> BI B8 -> BI A8 -> PMOD JC10 -> Pin J12 -> databus(7)
			-- ADC DB1 -> BI B7 -> BI A7 -> PMOD JC9  -> Pin G16 -> databus(6)
			-- ADC DB2 -> BI B6 -> BI A6 -> PMOD JC8  -> Pin F14 -> databus(5)
			-- ADC DB3 -> BI B5 -> BI A5 -> PMOD JC7  -> Pin H15 -> databus(4)
			-- ADC DB4 -> BI B4 -> BI A4 -> PMOD JC4  -> Pin H16 -> databus(3)
			-- ADC DB5 -> BI B3 -> BI A3- > PMOD JC3  -> Pin G13 -> databus(2)
			-- ADC DB6 -> BI B2 -> BI A2 -> PMOD JC2  -> Pin J16 -> databus(1)
			-- ADC DB7 -> BI B1 -> BI A1 -> PMOD JC1  -> Pin G15 -> databus(0)
			
		nRD 			: out std_logic;	
										--active low read
										-- PMOD JB9 -> Pin T18
		nSH			: out std_logic;	
										--active low sample (active high hold)
										-- PMOD JB10 -> Pin U18
										
										-- active high sample selectors, (s1s0, 00 = 0, .., 11 = 3)
		s0 			: out std_logic;		
										-- PMOD JB8 -> Pin R16
		s1 			: out std_logic;	
										-- PMOD JB7 -> Pin P17
		
		-- DAC (output) data lines
		out_dac_l : out std_logic;
		out_dac_r : out std_logic;		
				
		-- System Clock
		sys_clk_50 : in std_logic
						-- Pin B8
    );
end  system_wiring;

--}} End of automatically maintained section

architecture  structural  of  system_wiring  is					
	
	component clock_divider is
   port ( CLKIN_IN        : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic);
	end component;

	component block_filter_pair
		 port (
			-- Inputs -- 
			-- active high control signals
			reset : in std_logic;
			sys_clk : in std_logic;
			may_update_filter : in std_logic;
			trigger_convolution : in std_logic;
			
			-- ADC output register
			left_mic_sample_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));
			left_mic_error_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));		
			right_mic_sample_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));
			right_mic_error_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));		
			-- End Inputs -- 
			
			-- Outputs --
			-- DAC input register
			left_spk_dac_input : out std_logic_vector(0 to (ADC_DATA_BITS-1));		
			right_spk_dac_input : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			-- End Outputs -- 
			
			-- Test Outputs: leave open --
			left_best_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			right_best_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			left_working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
			right_working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY	
		 );
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

	component  fsm_adc  is
		 port (
			sys_clk 		: in std_logic;	--20 MHz
			sample_tick : in std_logic;	--active high
			reset 		: in std_logic;	--active high		
			nInt 			: in std_logic;	--interrupt, active low, asynchronous
			buttons 		: in std_logic_vector(0 to 3); --	active high buttons, asynchronous
			databus  	: in std_logic_vector(0 to 7); --   adc data bus (low 8 bits, 0 is MSB here but mapped to DB7 from ADC, the MSB).

			nRD 			: out std_logic;	--active low read
			nSH			: out std_logic;	--active low sample (active high hold)
			vin0 			: out std_logic_vector(0 to 7);	-- samples, 8 bit signed and level shifted down by 128
			vin1			: out std_logic_vector(0 to 7);
			vin2			: out std_logic_vector(0 to 7);
			vin3 			: out std_logic_vector(0 to 7);
			leds 			: out std_logic_vector(0 to 7);	-- active high led array (0 to 7)
			s0 			: out std_logic;		
			s1 			: out std_logic	-- active high sample selectors, (s1s0, 00 = 0, .., 11 = 3)
		 );
	end  component;

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
		
	-- Adaptation Enable synchronization
	-- Output Enable synchronization
	signal daisyChain_ae	: std_logic_vector(2 downto 0);
	signal daisyChain_oe	: std_logic_vector(2 downto 0);
	signal oe : std_logic;
	signal ae : std_logic;
	signal may_update_filter : std_logic;
	
	-- ADC Register
	signal left_mic_sample_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal left_mic_error_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));		
	signal right_mic_sample_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));
	signal right_mic_error_adc_output : std_logic_vector(0 to (ADC_DATA_BITS-1));		

	-- Filter-to-DAC 
	signal left_spk_dac_input : std_logic_vector(0 to (ADC_DATA_BITS-1));		
	signal right_spk_dac_input : std_logic_vector(0 to (ADC_DATA_BITS-1));			

	-- Clock Management
	signal sys_clk_20 : std_logic;
		
begin
	
	-- Synchronize OE,AE Inputs.
	oe <= daisyChain_oe(2);
	ae <= daisyChain_ae(2);
	may_update_filter <= '1' when ((oe = '1') and (ae = '1')) else '0';
	
	process (sys_clk_20) 
	begin	
		if (rising_edge(sys_clk_20)) then			
			daisyChain_oe(2 downto 0) <= daisyChain_oe(1 downto 0) & async_oe; 
			daisyChain_ae(2 downto 0) <= daisyChain_ae(1 downto 0) & async_ae; 
		end if;
	end process;
	
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

	-- 40 kHz off 20 MHz	
	FiveTwelveCounter: kBitCounter
		generic map ( k => 9 )		
		port map (	
			sys_clk => sys_clk_20,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => sample_tick
			);

	myADC:  fsm_adc
		 port map (
			sys_clk => sys_clk_20,
			sample_tick => sample_tick, 
			reset => reset,
			nInt => nInt,
			buttons => "0000",
			databus => databus,
			nRD => nRD,
			nSH => nSH,
			vin0 => left_mic_sample_adc_output,
			vin1 => left_mic_error_adc_output,
			vin2 => right_mic_error_adc_output,
			vin3 => right_mic_sample_adc_output,
			leds => open,
			s0 => s0,
			s1 => s1
		 );	
		
	DACL: dac_single
		port map (				
			filter_sample => left_spk_dac_input,
			calibration_sample => "00000000",
			flag_calibration => '0',
			sys_clk => sys_clk_20,
			sample_tick => sample_tick,
			oversample_tick => oversample_tick,
			oe => oe,
			reset => reset,			
			out_dac => out_dac_l,			
			out_dac1 => open,	
			out_dac2 => open,	
			out_dac3 => open,	
			accumulator_state => open,
			internal_sample_state => open
			);	

	DACR: dac_single
		port map (				
			filter_sample => right_spk_dac_input, 
			calibration_sample => "00000000",
			flag_calibration => '0',
			sys_clk => sys_clk_20,
			sample_tick => sample_tick,
			oversample_tick => oversample_tick,
			oe => oe,
			reset => reset,			
			out_dac => out_dac_r,			
			out_dac1 => open,	
			out_dac2 => open,	
			out_dac3 => open,	
			accumulator_state => open,
			internal_sample_state => open
			);	

	myFILTER: block_filter_pair
		 port map (
			reset => reset,
			sys_clk => sys_clk_20,
			may_update_filter => may_update_filter,
			trigger_convolution => sample_tick,
			left_mic_sample_adc_output => left_mic_sample_adc_output,
			left_mic_error_adc_output => left_mic_error_adc_output,
			right_mic_sample_adc_output => right_mic_sample_adc_output,
			right_mic_error_adc_output => right_mic_error_adc_output,
			left_spk_dac_input => left_spk_dac_input,
			right_spk_dac_input => right_spk_dac_input,			
			left_best_filter_coefficients => open,
			right_best_filter_coefficients => open,
			left_working_filter_coefficients => open,
			right_working_filter_coefficients => open
		 );	


end  structural;


---------------------------------------------------------------------------
--
--  The noise-canceling headphones system (less analog components).
--  
--  Contains an ADC interface block, a pair of filter blocks, and a pair of DAC output blocks.
--  Also contains two clocks (sample trigger, DAC oversampled trigger), and
--  a synchronization/combinational logic module to parse user input via buttons and switches.
--
--  Entities included are:
--     system_wiring
--
--  Revision History:
--     09/29/2015 SSundaresh created - not complete.
--     10/2/2015 SSundaresh the necessity for a DAC calibration block was noted. Wiring might change slightly.
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
		-- User Switch and Button Inputs, to be synchronized -- 		
		reset_switch : in std_logic;
		filter_update_enable_switch : in std_logic;
		sound_output_enable_switch : in std_logic;
		led_display_left_sample_mic_raw_input : in std_logic;
		led_display_left_error_mic_raw_input : in std_logic;
		led_display_right_sample_mic_raw_input : in std_logic;
		led_display_right_error_mic_raw_input : in std_logic;
		
		-- ADC (input) control line (interrupt, needs to be synchronized)
		adc_control_int : in std_logic;
		
		-- ADC (input) data lines (do not need to be synchronized)
		adc_data_in : in std_logic_vector(0 to (ADC_DATA_BITS-1));
		
		-- ADC (output) control lines
		adc_control_out : out std_logic_vector(0 to (ADC_CONTROL_BITS-1));
		
		-- pair of DAC (output) data lines. 0 is left, 1 is right.
		dac_data_out : out std_logic_vector(0 to 1);
		
		-- System Clock
		sys_clk : in std_logic
    );
end  system_wiring;

--}} End of automatically maintained section

architecture  structural  of  system_wiring  is																		

-- Components --
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

component block_adc_interface
	port (
		reset : in std_logic;		 	
		trigger : in std_logic;
		adc_control_in : in std_logic; -- INT				
		adc_data_in : in std_logic_vector(0 to (ADC_DATA_BITS-1));				
		adc_control_out : out std_logic_vector(0 to (ADC_CONTROL_BITS-1));
		left_mic_sample_adc_output : out std_logic_vector(0 to (ADC_DATA_BITS-1));
		left_mic_error_adc_output : out std_logic_vector(0 to (ADC_DATA_BITS-1));		
		right_mic_sample_adc_output : out std_logic_vector(0 to (ADC_DATA_BITS-1));
		right_mic_error_adc_output : out std_logic_vector(0 to (ADC_DATA_BITS-1))
	);
end component;

component block_dac_output
	port (
		reset : in std_logic;
		updateSampleTrigger : in std_logic;
		oversamplingTrigger : in std_logic;	
		dataToConvert : in std_logic_vector(0 to (ADC_DATA_BITS-1))		
	);
end component;

component synchronizingDecoder
	port (
		reset_switch : in std_logic;
		filter_update_enable_switch : in std_logic;
		sound_output_enable_switch : in std_logic;
		led_display_left_sample_mic_raw_input : in std_logic;
		led_display_left_error_mic_raw_input : in std_logic;
		led_display_right_sample_mic_raw_input : in std_logic;
		led_display_right_error_mic_raw_input : in std_logic;		
		adc_control_int : in std_logic;		
		
		reset : out std_logic; 	
		adc_interrupt : out std_logic;		
		mayUpdateFilter : out std_logic;   				
		mayOutputSound : out std_logic; 					-- must toggle dac output enables		
		led_display_left_sample_mic : out std_logic; -- guaranteed exclusive
		led_display_left_error_mic : out std_logic;
		led_display_right_sample_mic : out std_logic;
		led_display_right_error_mic : out std_logic		
	);
end component;


component nCounter
	generic (
		n : integer := 8  -- counter max value
	);
	port (	
		clk : in std_logic; 
		clr : in std_logic; 
		run : in std_logic; 
		count : out integer range 0 to n;
		hitTarget : out std_logic 		
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

-- Wiring Aliases for Control Signals -- 


begin


end  structural;
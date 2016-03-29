---------------------------------------------------------------------------
--
--  A pair of filter blocks, wired up.
--  Takes as input the output register of the ADC block, containing two samples and two error signals,
--  a reset signal, a system clock, a may-update-filter signal, a trigger-filter-blocks signal.
--  Outputs two convolution products guaranteed to be in 0-2^(ADC_DATA_BITS)-1, unsigned, as input to a pair of DAC blocks.
-- 
--  
--  Entities included are:
--     block_filter_pair
--
--  Revision History:
--     09/29/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {block_filter_pair} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  block_filter_pair  is
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
		right_working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;	
		
		left_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		left_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		
		left_input_history : out HISTORY_REGISTER_ARRAY;
		right_input_history : out HISTORY_REGISTER_ARRAY;
		
		left_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		
		left_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE
    );
end  block_filter_pair;

--}} End of automatically maintained section

architecture  dataflow  of  block_filter_pair  is																		

-- Components --

component  fsm_load_next_samples 
    port (
		reset : in std_logic; 
		sys_clk : in std_logic;
		getData : in std_logic;
		getADCOutputRegisters : out std_logic; 
		triggerAdaptiveFilter : out std_logic 
    );
end component;

component fsm_input_history_shift
    port (
		reset : in std_logic; 
      shift_input_history : in std_logic; 
		sys_clk : in std_logic; 
		shift : out std_logic 
    );
end component;

component fsm_convolution
 port (
	reset : in std_logic; 
	sys_clk : in std_logic; 
	trigger_convolution : in std_logic; 
	multiply_shift_request : out std_logic; 
	multiply_negate_request : out std_logic; 
	trigger_fsm_filter_update : out std_logic; 
	accumulator_shift_request : out std_logic; 
	accumulator_clear_request : out std_logic; 
	accumulate_add_request : out std_logic; 
	write_output_register_request : out std_logic 
 );
end component;

component lfsr_maximal_xnor_64_bit
    port (
        sys_clk  : in   std_logic; 
        reset : in  std_logic; 		
		  random_64mer : out std_logic_vector(0 to 63) 
    );
end component;

component block_filter
    port (	
		-- Global and User Inputs -- 
		reset : in std_logic;
		sys_clk : in std_logic;
		may_update_filter : in std_logic;
		
		-- External FSM & Counter Control Signals -- 
		trigger_convolution : in std_logic;
		loadSample_and_clearConvBlock : in std_logic;
		load_and_trigger_ConvBlock_and_shiftInputHistory : in std_logic;
		shift_input_history : in std_logic;
		accumulator_multiply_shift_request : in std_logic;
		accumulator_multiply_negate_request : in std_logic;
		accumulator_accumulator_shift_request : in std_logic;
		accumulator_accumulator_clear_request : in std_logic;
		accumulator_accumulate_add_request : in std_logic;
		accumulator_write_output_register_request : in std_logic;
		lfsr_state : in lfsr_state_64_bit;
		
		-- ADC output register
		mic_sample_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));
		mic_error_adc_output : in std_logic_vector(0 to (ADC_DATA_BITS-1));		
		-- End Inputs -- 
		
		-- Outputs --
		-- DAC input register
		spk_dac_input : out std_logic_vector(0 to (ADC_DATA_BITS-1));
		-- End Outputs -- 
		
		-- Test Outputs: leave open -- 
		best_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
		working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY;
		observe_input_history_registers : out HISTORY_REGISTER_ARRAY;
		observe_the_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		observe_current_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		observe_myPresentState : out FSM_FILTER_UPDATE_BLOCK_STATE;
		observe_myNextState : out FSM_FILTER_UPDATE_BLOCK_STATE
    );
end component;

-- Wiring Aliases for Control Signals -- 

-- Generated by fsm_load_next_samples
signal loadSample_and_clearConvBlock : std_logic; 
signal load_and_trigger_ConvBlock_and_shiftInputHistory : std_logic;

-- Generated by fsm_input_history_shift
signal shift_input_history : std_logic;

-- Common Accumulator Control Signals
signal accumulator_multiply_shift_request : std_logic; 
signal accumulator_multiply_negate_request : std_logic;
signal accumulator_accumulator_shift_request : std_logic;
signal accumulator_accumulator_clear_request : std_logic;
signal accumulator_accumulate_add_request : std_logic; 
signal accumulator_write_output_register_request : std_logic; 

-- LFSR Holder
signal lfsr_state : lfsr_state_64_bit;

begin

-- Instantiate Common Components -- 
LFSR: lfsr_maximal_xnor_64_bit
    port map (
        sys_clk => sys_clk,
        reset => reset,
		  random_64mer => lfsr_state
    );

FSM1: fsm_load_next_samples 
    port map (
		reset => reset,
		sys_clk => sys_clk, 
		getData => trigger_convolution,
		getADCOutputRegisters => loadSample_and_clearConvBlock,
		triggerAdaptiveFilter => load_and_trigger_ConvBlock_and_shiftInputHistory
    );
FSM2: fsm_input_history_shift
    port map (
		reset => reset,
      shift_input_history => load_and_trigger_ConvBlock_and_shiftInputHistory,
		sys_clk => sys_clk,
		shift => shift_input_history
    );
FSM3: fsm_convolution
   port map (
		reset => reset, 
		sys_clk => sys_clk, 
      trigger_convolution => load_and_trigger_ConvBlock_and_shiftInputHistory, 
		multiply_shift_request => accumulator_multiply_shift_request, 
		multiply_negate_request => accumulator_multiply_negate_request,
		trigger_fsm_filter_update => open, 
		accumulator_shift_request => accumulator_accumulator_shift_request,
		accumulator_clear_request => accumulator_accumulator_clear_request,
		accumulate_add_request => accumulator_accumulate_add_request, 
		write_output_register_request => accumulator_write_output_register_request
    );	

-- Instantiate Left Filter Block --
LEFTFILTER: block_filter
    port map (			
		reset => reset,
		sys_clk => sys_clk, 
		may_update_filter => may_update_filter,
		trigger_convolution => trigger_convolution,
		loadSample_and_clearConvBlock => loadSample_and_clearConvBlock,
		load_and_trigger_ConvBlock_and_shiftInputHistory => load_and_trigger_ConvBlock_and_shiftInputHistory,
		shift_input_history => shift_input_history,
		accumulator_multiply_shift_request => accumulator_multiply_shift_request,
		accumulator_multiply_negate_request => accumulator_multiply_negate_request,
		accumulator_accumulator_shift_request => accumulator_accumulator_shift_request, 
		accumulator_accumulator_clear_request => accumulator_accumulator_clear_request,
		accumulator_accumulate_add_request => accumulator_accumulate_add_request, 
		accumulator_write_output_register_request => accumulator_write_output_register_request,
		lfsr_state => lfsr_state,
		mic_sample_adc_output => left_mic_sample_adc_output,
		mic_error_adc_output => left_mic_error_adc_output,
		spk_dac_input => left_spk_dac_input,
		best_filter_coefficients => left_best_filter_coefficients,
		working_filter_coefficients => left_working_filter_coefficients,
		observe_input_history_registers => left_input_history,
		observe_the_best_residual => left_best_residual,
		observe_current_residual => left_working_residual,
		observe_myPresentState => left_current_fsm_state,
		observe_myNextState => left_next_fsm_state
    );

-- Instantiate Right Filter Block --
RIGHTFILTER: block_filter
    port map (			
		reset => reset,
		sys_clk => sys_clk, 
		may_update_filter => may_update_filter,
		trigger_convolution => trigger_convolution,
		loadSample_and_clearConvBlock => loadSample_and_clearConvBlock,
		load_and_trigger_ConvBlock_and_shiftInputHistory => load_and_trigger_ConvBlock_and_shiftInputHistory,
		shift_input_history => shift_input_history,
		accumulator_multiply_shift_request => accumulator_multiply_shift_request,
		accumulator_multiply_negate_request => accumulator_multiply_negate_request,
		accumulator_accumulator_shift_request => accumulator_accumulator_shift_request, 
		accumulator_accumulator_clear_request => accumulator_accumulator_clear_request,
		accumulator_accumulate_add_request => accumulator_accumulate_add_request, 
		accumulator_write_output_register_request => accumulator_write_output_register_request,
		lfsr_state => lfsr_state,
		mic_sample_adc_output => right_mic_sample_adc_output,
		mic_error_adc_output => right_mic_error_adc_output,
		spk_dac_input => right_spk_dac_input,
		best_filter_coefficients => right_best_filter_coefficients,
		working_filter_coefficients => right_working_filter_coefficients,
		observe_input_history_registers => right_input_history,
		observe_the_best_residual => right_best_residual,
		observe_current_residual => right_working_residual,
		observe_myPresentState => right_current_fsm_state,
		observe_myNextState => right_next_fsm_state
    );

end  dataflow;
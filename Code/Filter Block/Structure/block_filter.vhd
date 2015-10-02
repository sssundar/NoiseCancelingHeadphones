---------------------------------------------------------------------------
--
--  A single filter block (i.e. left, right), wired up.
--  Outputs a convolution product guaranteed to be in 0-2^(ADC_DATA_BITS)-1, unsigned, as input to the DAC block.
--  
--  Entities included are:
--     block_filter
--
--  Revision History:
--     09/29/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {block_filter} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  block_filter  is
    port (
		-- active high control signals --
		
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
		working_filter_coefficients : out COEFFICIENT_REGISTER_ARRAY
    );
end  block_filter;

--}} End of automatically maintained section

architecture  dataflow  of  block_filter  is																		

-- Components --

component register_input_history
    port(	  
			reset : in std_logic; 							
			shift : in std_logic; 					
			load : in std_logic; 					
			serial_in : in std_logic; 				
			load_in : in std_logic_vector(0 to (ADC_DATA_BITS-1)); 		
			sys_clk : in std_logic; 								
			register_out : out std_logic_vector(0 to (ADC_DATA_BITS-1));
			serial_out : out std_logic					
        );                                               
end component;

component register_convolution_input
    port(	  
			reset : in std_logic; 				
			sys_clk : in std_logic; 			
			
			load_sample : in std_logic;  		
			load_data : in std_logic_vector(0 to (ADC_DATA_BITS-1)); 
			
			shift_to_accumulator : in std_logic; 	
			serial_in : in std_logic; 					
			serial_out : out std_logic;				
			
			shift_to_multiply : in std_logic; 		
			load_negation : in std_logic;	 				
			filterCoefficientIsZero : in std_logic; 	
			
			register_state : out std_logic_vector(0 to (ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1));
			sign_bit : out std_logic 						
        );                                               
end component;

component accumulator_convolution
 port(	  
		sys_clk : in std_logic;
		product : in std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1));
		accumulate : in std_logic;
		clear_accumulator : in std_logic;
		clear_output_register : in std_logic;
		write_output_register : in std_logic;			
		register_filter_output : out std_logic_vector(0 to (ADC_DATA_BITS-1));
		accumulator_state : out std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1))
	  );                                               
end component;

component register_convolution_filter_coefficient
    port(	  
			sys_clk : in std_logic;										
			load_req : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			is_load_data_zero : in std_logic;
			shift_req : in std_logic; 
			negate_req : in std_logic;
			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic;
			shift_input : out std_logic;
			negate_input : out std_logic
        );                                               
end component;

component register_filter_coefficient
    port(	  
			sys_clk : in std_logic;							
			reset : in std_logic; 							
			update_coefficient : in std_logic; 			
			load : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			unifrnd0 : in std_logic; 					
			unifrnd1 : in std_logic; 		 			
			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic					
        );                                               
end component;

component fsm_update_filter
    port (
		-- Inputs
		reset : in std_logic; 
		sys_clk : in std_logic; 
      trigger : in std_logic; 
		shouldUpdate : in std_logic; 
		working_filter : in COEFFICIENT_REGISTER_ARRAY; 
		inputError : in std_logic_vector(0 to (ADC_DATA_BITS-1));
		
		-- Outputs To Other Blocks
		reset_working_to_best_filter : out std_logic;
		update_working_filter : out std_logic; 
		best_filter : out COEFFICIENT_REGISTER_ARRAY;
		
		-- Outputs to Test Benches (will be left unconnected in final wiring)
		the_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		current_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		myPresentState : out FSM_FILTER_UPDATE_BLOCK_STATE;
		myNextState : out FSM_FILTER_UPDATE_BLOCK_STATE
    );	
end component;

-- Wiring Aliases for Control Signals -- 

-- Input History Holders
signal input_history_serial_chain : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
signal input_history_registers : HISTORY_REGISTER_ARRAY;

-- Convolution Control Signals and Holders
signal convolution_accumulator_serial_chain : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
signal convolution_shift_to_multiply : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
signal convolution_load_negation : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
signal convolution_filterCoefficientIsZero : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));
signal convolution_accumulator_input : std_logic_vector(0 to (ADC_DATA_BITS+FILTER_SHIFT_MULTIPLIER_PRECISION_BITS-1));		

-- Working Coefficients, Holders and Signals
signal working_coeffs : COEFFICIENT_REGISTER_ARRAY;
signal working_coeffs_zero_flags : std_logic_vector(0 to (FILTER_FIR_LENGTH-1));

-- Filter Update Block Holders, Signals
signal working_update : std_logic;
signal working_replace_with_best : std_logic;
signal best_coeffs : COEFFICIENT_REGISTER_ARRAY;

begin

-- Wire up test outputs --
best_filter_coefficients <= best_coeffs;
working_filter_coefficients <= working_coeffs;

-- Instantiate Components -- 
FSM4: fsm_update_filter
    port map (		
		reset => reset,
		sys_clk => sys_clk,
      trigger => trigger_convolution,
		shouldUpdate => may_update_filter,
		working_filter => working_coeffs,
		inputError => mic_error_adc_output,		
		reset_working_to_best_filter => working_replace_with_best,
		update_working_filter => working_update,
		best_filter => best_coeffs,				
		the_best_residual => open,
		current_residual => open,
		myPresentState => open,
		myNextState => open
    );	

HISTORY0: register_input_history
    port map(	  
			reset => reset,
			shift => shift_input_history,
			load => loadSample_and_clearConvBlock,
			serial_in => '0',
			load_in => mic_sample_adc_output,
			sys_clk => sys_clk,
			register_out => input_history_registers(0),
			serial_out => input_history_serial_chain(0)
        );                                               
HISTORYGEN: for k in 1 to (FILTER_FIR_LENGTH-1) generate
	HISTORYk: register_input_history
    port map(	  
			reset => reset,
			shift => shift_input_history,
			load => '0',
			serial_in => input_history_serial_chain(k-1),
			load_in => (0 to (ADC_DATA_BITS-1) => '0'), 		
			sys_clk => sys_clk,
			register_out => input_history_registers(k),
			serial_out => input_history_serial_chain(k)
        );                                               
end generate;

CONVINPUTHISTORY0: register_convolution_input
    port map (	  
			reset => loadSample_and_clearConvBlock,
			sys_clk => sys_clk,			
			load_sample => load_and_trigger_ConvBlock_and_shiftInputHistory,
			load_data => input_history_registers(0),			
			shift_to_accumulator => accumulator_accumulator_shift_request,  	
			serial_in => '0',
			serial_out => convolution_accumulator_serial_chain(0),
			shift_to_multiply => convolution_shift_to_multiply(0),
			load_negation => convolution_load_negation(0),
			filterCoefficientIsZero => convolution_filterCoefficientIsZero(0),
			register_state => open,
			sign_bit => open
        );                                               
CONVINPUTHISTORYGEN: for k in 1 to (FILTER_FIR_LENGTH-2) generate
	CONVINPUTHISTORYk: register_convolution_input
    port map (	  
			reset => loadSample_and_clearConvBlock,
			sys_clk => sys_clk,			
			load_sample => load_and_trigger_ConvBlock_and_shiftInputHistory,
			load_data => input_history_registers(k),			
			shift_to_accumulator => accumulator_accumulator_shift_request,  	
			serial_in => convolution_accumulator_serial_chain(k-1),
			serial_out => convolution_accumulator_serial_chain(k),
			shift_to_multiply => convolution_shift_to_multiply(k),
			load_negation => convolution_load_negation(k),
			filterCoefficientIsZero => convolution_filterCoefficientIsZero(k),
			register_state => open,
			sign_bit => open
        );                            
end generate;
CONVINPUTHISTORYFINAL: register_convolution_input
    port map (	  
			reset => loadSample_and_clearConvBlock,
			sys_clk => sys_clk,			
			load_sample => load_and_trigger_ConvBlock_and_shiftInputHistory,
			load_data => input_history_registers(FILTER_FIR_LENGTH-1),			
			shift_to_accumulator => accumulator_accumulator_shift_request,  	
			serial_in => convolution_accumulator_serial_chain(FILTER_FIR_LENGTH-2),
			serial_out => convolution_accumulator_serial_chain(FILTER_FIR_LENGTH-1),
			shift_to_multiply => convolution_shift_to_multiply(FILTER_FIR_LENGTH-1),
			load_negation => convolution_load_negation(FILTER_FIR_LENGTH-1),
			filterCoefficientIsZero => convolution_filterCoefficientIsZero(FILTER_FIR_LENGTH-1),
			register_state => convolution_accumulator_input,
			sign_bit => open
        );                       

ACCUMULATOR: accumulator_convolution
	port map (
		sys_clk => sys_clk,
		product => convolution_accumulator_input,
		accumulate => accumulator_accumulate_add_request, 
		clear_accumulator => accumulator_accumulator_clear_request, 
		clear_output_register => reset, 
		write_output_register => accumulator_write_output_register_request, 
		register_filter_output => spk_dac_input, 
		accumulator_state => open
	); 

CONVCOEFFGEN: for i in 0 to (FILTER_FIR_LENGTH-1) generate
	  CONVCOEFFi: register_convolution_filter_coefficient 
		port map ( 
			sys_clk => sys_clk, 			
			load_req => load_and_trigger_ConvBlock_and_shiftInputHistory,
			load_data => working_coeffs(i),
			is_load_data_zero => working_coeffs_zero_flags(i),
			shift_req => accumulator_multiply_shift_request,
			negate_req => accumulator_multiply_negate_request,
			coefficient => open,
			coefficientIsZero => convolution_filterCoefficientIsZero(i),
			shift_input => convolution_shift_to_multiply(i),
			negate_input => convolution_load_negation(i)
	  );       
end generate;	 

WORKINGCOEFFGEN: for i in 0 to (FILTER_FIR_LENGTH-1) generate
  WORKCOEFFi: register_filter_coefficient
    port map (	  
			sys_clk => sys_clk, 
			reset => reset,
			update_coefficient => working_update,
			load => working_replace_with_best,
			load_data => best_coeffs(i),
			unifrnd0 => lfsr_state(2*i+0),
			unifrnd1 => lfsr_state(2*i+1),		 			
			coefficient => working_coeffs(i),
			coefficientIsZero => working_coeffs_zero_flags(i)					
        );                                                 
end generate;	 

end  dataflow;
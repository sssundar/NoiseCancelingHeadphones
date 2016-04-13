-- magic_numbers.vhd
--
-- A collection of constants (that are mostly not magic numbers, Glen!).
-- I found these useful for Project Headphones.
--
-- For the moment I have avoided the use of ceiling and LOG2 math functions.
-- so changes made to bit lengths require consistent changes to log-bit-length variables, where appropriate.
--
--  Revision History:
--     09/23/2015 SSundaresh created

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;

package magic_numbers is
	
	---------------
	-- ADC Block --
	---------------
	
	-- Number of bits, ADC block, incoming from ADC itself. Must be a power of two.
	constant ADC_DATA_BITS : integer := 8;	
	constant LOG2_ADC_DATA_BITS : integer := 3;
	
	-- level shifter constant value added to ADC inputs to shift from 0..2^ADC_DATA_BITS-1 to -2^(ADC_DATA_BITS-1) .. 2^(ADC_DATA_BITS-1)-1
	-- not necessary, just flip MSB	

	constant ADC_CONTROL_BITS : integer := 3;
	constant ADC_REQUEST_READ : std_logic := '0'; -- active low control signal
	constant ADC_REQUEST_SAMPLE : std_logic := '0'; -- active low control signal
	constant ADC_SELECT_CHIP : std_logic := '0'; -- active low control signal
	
	constant ADC_INTERRUPT_DATA_READY : std_logic := '0'; -- active low chip response
	constant ADC_INTERRUPT_DATA_CONVERTING : std_logic := '1'; 
	
	------------------
	-- Filter Block --
	------------------
	
	-- Input history block controller, bits in shift counter
	constant FILTER_INPUT_HISTORY_SHIFT_COUNTER_BITS : integer := LOG2_ADC_DATA_BITS;	
	
	-- GetData and Trigger Filter FSM States
	subtype FSM_GDT_STATE is std_logic_vector(0 to 2);
	constant FSM_GDT_STATE_WAIT : FSM_GDT_STATE := "100";	
	constant FSM_GDT_STATE_GET_DATA : FSM_GDT_STATE := "010";
	constant FSM_GDT_STATE_SETUP_CONV : FSM_GDT_STATE := "001";	
	constant FSM_GDT_WAIT_INDEX : integer := 0;
	constant FSM_GDT_GET_INDEX : integer := 1;
	constant FSM_GDT_CONV_INDEX : integer := 2;
	
	-- Prepare For Next Sample FSM States
	subtype  FSM_INPUT_HISTORY_SHIFT_STATE is std_logic;	
	constant FSM_INPUT_HISTORY_SHIFT_STATE_WAIT : FSM_INPUT_HISTORY_SHIFT_STATE := '0';
	constant FSM_INPUT_HISTORY_SHIFT_STATE_SHIFT : FSM_INPUT_HISTORY_SHIFT_STATE := '1';
	
	-- Convolution FSM States
	subtype  FSM_CONVOLUTION_MULTIPLY_STATE is std_logic_vector(0 to 2);		
	constant FSM_CONVOLUTION_MULTIPLY_STATE_WAIT : FSM_CONVOLUTION_MULTIPLY_STATE := "000";	
	constant FSM_CONVOLUTION_MULTIPLY_STATE_SHIFT : FSM_CONVOLUTION_MULTIPLY_STATE := "001";
	constant FSM_CMS_SHIFT_HOT_INDEX : integer := 2;
	constant FSM_CONVOLUTION_MULTIPLY_STATE_NEGATE : FSM_CONVOLUTION_MULTIPLY_STATE := "010";
	constant FSM_CMS_NEGATE_HOT_INDEX : integer := 1;
	constant FSM_CONVOLUTION_MULTIPLY_STATE_TRIGGER_ACCUMULATOR_AND_FILTER_UPDATE : FSM_CONVOLUTION_MULTIPLY_STATE := "100";
	constant FSM_CMS_TRIGGER_HOT_INDEX : integer := 0;
	
	subtype  FSM_CONVOLUTION_ACCUMULATE_STATE is std_logic_vector(0 to 2);	
	constant FSM_CONVOLUTION_ACCUMULATE_STATE_WAIT : FSM_CONVOLUTION_ACCUMULATE_STATE := "000";
	constant FSM_CONVOLUTION_ACCUMULATE_STATE_ADD : FSM_CONVOLUTION_ACCUMULATE_STATE := "001";
	constant FSM_CAS_ADD_HOT_INDEX : integer := 2;
	constant FSM_CONVOLUTION_ACCUMULATE_STATE_SHIFT : FSM_CONVOLUTION_ACCUMULATE_STATE := "010";
	constant FSM_CAS_SHIFT_HOT_INDEX : integer := 1;
	constant FSM_CONVOLUTION_ACCUMULATE_STATE_OUTPUT : FSM_CONVOLUTION_ACCUMULATE_STATE := "100";
	constant FSM_CAS_OUTPUT_HOT_INDEX : integer := 0;
	
	-- Filter Update Block FSM States
	subtype  FSM_FILTER_UPDATE_BLOCK_STATE is std_logic_vector(0 to 6);
	constant FSM_FILTER_UPDATE_BLOCK_STATE_BITS : integer := 7;
	constant FSM_FUB_WAIT : 		FSM_FILTER_UPDATE_BLOCK_STATE := "1000000";
	constant FSM_FUB_ABS : 			FSM_FILTER_UPDATE_BLOCK_STATE := "0100000";
	constant FSM_FUB_ADD : 			FSM_FILTER_UPDATE_BLOCK_STATE := "0010000";
	constant FSM_FUB_CMP : 			FSM_FILTER_UPDATE_BLOCK_STATE := "0001000";
	constant FSM_FUB_UPD_BEST : 	FSM_FILTER_UPDATE_BLOCK_STATE := "0000100";
	constant FSM_FUB_WIPE : 		FSM_FILTER_UPDATE_BLOCK_STATE := "0000010";
	constant FSM_FUB_STEP : 		FSM_FILTER_UPDATE_BLOCK_STATE := "0000001";
	
	constant FSM_FUB_WAIT_INDEX : 		integer := 0;
	constant FSM_FUB_ABS_INDEX : 			integer := 1;
	constant FSM_FUB_ADD_INDEX : 			integer := 2;
	constant FSM_FUB_CMP_INDEX : 			integer := 3;
	constant FSM_FUB_UPD_BEST_INDEX : 	integer := 4;	
	constant FSM_FUB_WIPE_INDEX : 		integer := 5;
	constant FSM_FUB_STEP_INDEX : 		integer := 6;
	
	
	-- Number of bits, filter block, filter coefficients. 
	-- MSB is interpreted as a sign bit. 0 = +, 1 = -
	-- Bits MSB-1 to 0 are interpreted as 2^-1 2^-2 ... 
	-- Must be a power of two + 1.
	constant FILTER_COEFFICIENT_BITS : integer := 9;
	constant FILTER_COEFFICIENT_SHIFT_MULTIPLY_COUNTER_BITS : integer := 3; -- log2(FILTER_COEFFICIENT_BITS-1) = 3.
	
	-- Number of added bits of precision in the powers-of-two shifter-multipler filtering scheme implemented
	-- A value of 3 implies 2^-1 2^-2 2^-3 are stored in addition to integer values < 2^ADC_DATA_BITS - 1
	constant FILTER_SHIFT_MULTIPLIER_PRECISION_BITS : integer := 3;
	
	-- number of filter coefficients, number of samples stored in input history
	-- required to be a power of two 0 < FILTER_FIR_LENGTH <= 32 for simple recognition in counters.	
	constant FILTER_FIR_LENGTH : integer := 32;
	constant HALF_FILTER_FIR_LENGTH : integer := 16;
	
	constant LOG2_FIR_LENGTH : integer := 5;	
	constant FILTER_CONVOLUTION_ACCUMULATE_SAMPLE_COUNTER_BITS : integer := LOG2_FIR_LENGTH;
	constant FILTER_CONVOLUTION_ACCUMULATE_SHIFT_COUNTER_TARGET : integer := ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS - 1;
	
	-- The 32-coefficient upper limit is imposed in particular because our random number generator is a hardcoded 64-bit LFSR and we need
	-- 2 bits per coefficient (a random number between 0-3) for each coefficient update step. 
	subtype lfsr_state_64_bit is std_logic_vector(0 to 63);
	
	-- number of samples before filter is updated in random walk. 
	-- required to be a power of two for simple recognition in counters.
	constant FILTER_UPDATE_INTERVAL : integer := 512;
	constant LOG2_UPDATE_INTERVAL : integer := 9;	
	constant FILTER_UPDATE_INTERVAL_COUNTER_BITS : integer := LOG2_UPDATE_INTERVAL;	

	-- number of additional bits required in filter convolution accumulator, which adds FILTER_FIR_LENGTH numbers of bitlength ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS
	constant FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS : integer := LOG2_FIR_LENGTH;
	constant FILTER_CONVOLUTION_ACCUMULATOR_BITS : integer := FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS + ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS; 
	
	-- level shifter constant value added to filter convolution result to shift by +2^(ADC_DATA_BITS-1) prior to truncation to 0..2^ADC_DATA_BITS-1
	-- flags for overflow, < 0, or > 2^ADC_DATA_BITS - 1 post level-shift are set purely based on arithmetic operations on bits >= 2^(ADC_DATA_BITS-1) 	
	constant FILTER_LEVEL_SHIFTER : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1)) := (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0') & '1' & (1 to (ADC_DATA_BITS-1) => '0');
	
	-- number of additional bits required in filter error/residual accumulator 
	constant FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS : integer := LOG2_UPDATE_INTERVAL;
	constant FILTER_RESIDUAL_ACCUMULATOR_BITS : integer := FILTER_RESIDUAL_ACCUMULATOR_OVERFLOW_BITS + ADC_DATA_BITS; 			
	
	-- Number of integer-precision bits, filter block, convolution result register
	constant FILTER_OUTPUT_DATA_BITS : integer := ADC_DATA_BITS;
	
	-- Subtypes of array for passing around filter register arrays
	type COEFFICIENT_REGISTER_ARRAY is array (0 to (FILTER_FIR_LENGTH-1)) of std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1)); 
	
	-- Subtypes of array for passing around input history arrays
	type HISTORY_REGISTER_ARRAY is array (0 to (FILTER_FIR_LENGTH-1)) of std_logic_vector(0 to (ADC_DATA_BITS-1)); 
	
	---------------
	-- DAC Block --
	---------------
	
	
	
	---------------
	-- Debugging --
	---------------
	
	-- Number of bits to serialize per parallel output port for hardware filter test --
	constant toSerialize : integer := 499;
	
end magic_numbers;

package body magic_numbers is
 
end magic_numbers;

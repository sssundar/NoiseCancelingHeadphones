---------------------------------------------------------------------------
--
--  Structural model for the headphones
--  Think of this as a baseline functionality test.
--   
--  Entities included are:
--     system_wiring
--
--  Revision History:
-- 	 3/16/2016 Sushant Sundaresh 	created
-- 	 3/28/2016 Sushant Sundaresh 	added serializer debugging block
--     4/2/2016  Sushant Sundaresh 	added error sample to serializer
--     4/2/2016  Sushant Sundaresh 	added LEDs for reset, oe-sync, ae-sync, 
-- 											and l_residual_0, r_residual_0
--  	 4/12/2016 Sushant Sundaresh  updated serializer for more filter update samples
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
		
		led_oe : out std_logic; 		-- synchronous oe
		led_ae : out std_logic;  		-- synchronous ae
		led_reset : out std_logic; 	-- asynchronous reset
		led_left_best_residual_0 : out std_logic; -- synchronous best_residuals
		led_right_best_residual_0 : out std_logic;
		
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
		sys_clk_50 : in std_logic;
						-- Pin B8
						
		-- Serializer Debug Lines, Combinational
		trigger_on_sys_clk_20 : out std_logic; -- simply sys_clk_20 made visible
		trigger_on_sample_tick : out std_logic; -- simple the 40kHz tick made visible
		end_serializer : out std_logic; 
		serial_left_1 : out std_logic;
		serial_left_2 : out std_logic;
		serial_right_1 : out std_logic;
		serial_right_2 : out std_logic
	
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

	component  block_serializer
		 port (			
			reset : in std_logic;
			sys_clk : in std_logic;
			sample_tick : in std_logic;				
			end_serialization : out std_logic;
			ddr_serial_clock : out std_logic;
			input_register_1 : in std_logic_vector(0 to toSerialize);		
			input_register_2 : in std_logic_vector(0 to toSerialize);		
			input_register_3 : in std_logic_vector(0 to toSerialize);		
			input_register_4 : in std_logic_vector(0 to toSerialize);					
			serial_1 : out std_logic;
			serial_2 : out std_logic;
			serial_3 : out std_logic;
			serial_4 : out std_logic
		 );
	end  component;

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
		
	-- Serial Debugging
	signal serial_ir_left_1, serial_ir_left_2, serial_ir_right_1, serial_ir_right_2 : std_logic_vector(0 to toSerialize);

	signal left_best_filter_coefficients : COEFFICIENT_REGISTER_ARRAY;
	signal right_best_filter_coefficients : COEFFICIENT_REGISTER_ARRAY;
	signal left_working_filter_coefficients : COEFFICIENT_REGISTER_ARRAY;
	signal right_working_filter_coefficients : COEFFICIENT_REGISTER_ARRAY;

	signal left_best_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal right_best_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal left_working_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	signal right_working_residual : std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
	
	signal left_input_history : HISTORY_REGISTER_ARRAY;
	signal right_input_history : HISTORY_REGISTER_ARRAY;
	
	signal left_current_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	signal right_current_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	
	signal left_next_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	signal right_next_fsm_state : FSM_FILTER_UPDATE_BLOCK_STATE;
	
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
	
	-- Assign LEDs
	led_oe <= oe;
	led_ae <= ae;
	led_reset <= reset;
	led_left_best_residual_0 <= '1' when (std_match(left_best_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '0'))) else '0';
	led_right_best_residual_0 <= '1' when (std_match(right_best_residual, (0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1) => '0'))) else '0';
	
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
	
	-- Serial Debugger Wiring
	assignSerialIR: process (left_best_filter_coefficients, right_best_filter_coefficients, left_working_filter_coefficients, right_working_filter_coefficients, left_best_residual, right_best_residual, left_working_residual, right_working_residual, left_input_history, right_input_history, left_current_fsm_state, right_current_fsm_state, left_next_fsm_state, right_next_fsm_state)
	begin
	
		-- Add starting watermark
		serial_ir_left_1(0 to 3) <= "1010";
		serial_ir_left_2(0 to 3) <= "1010";
		serial_ir_right_1(0 to 3) <= "1010";
		serial_ir_right_2(0 to 3) <= "1010";
		
		-- Now index is at 4
		
		for I in 0 to (FILTER_FIR_LENGTH-1) loop
			-- Assign Working Coefficients
			serial_ir_left_1(4+I*FILTER_COEFFICIENT_BITS to (4+((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= left_working_filter_coefficients(I);
			serial_ir_right_1(4+I*FILTER_COEFFICIENT_BITS to (4+((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= right_working_filter_coefficients(I);
			
			-- Assign Input History	
			serial_ir_left_2(4+I*ADC_DATA_BITS to (4+((I+1)*ADC_DATA_BITS)-1)) <= left_input_history(I);
			serial_ir_right_2(4+I*ADC_DATA_BITS to (4+((I+1)*ADC_DATA_BITS)-1)) <= right_input_history(I);
		end loop;
		-- Now index is at 4+(FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS)	for (1)
		-- Now index is at 4+(FILTER_FIR_LENGTH*ADC_DATA_BITS) for (2)		
		
		-- Assign Best Coefficients (half-half)
		for I in 0 to (HALF_FILTER_FIR_LENGTH-1) loop
			serial_ir_left_1(4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS+I*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS+(((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= left_best_filter_coefficients(I);
			serial_ir_right_1(4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS+I*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS+(((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= right_best_filter_coefficients(I);
			
			serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS+I*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS+(((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= left_best_filter_coefficients(I+HALF_FILTER_FIR_LENGTH);
			serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS+I*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS+(((I+1)*FILTER_COEFFICIENT_BITS)-1)) <= right_best_filter_coefficients(I+HALF_FILTER_FIR_LENGTH);
		end loop;		
		-- Now index is at 4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS	for (1)
		-- Now index is at 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS for (2)
		
		-- Everything else gets assigned to the (2) serial input register (which should have about 100 bits left) 
		
		-- Assign Residuals (FILTER_RESIDUAL_ACCUMULATOR_BITS bits each)
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + FILTER_RESIDUAL_ACCUMULATOR_BITS - 1) <= left_best_residual;
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + FILTER_RESIDUAL_ACCUMULATOR_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS -1) <= left_working_residual;
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + FILTER_RESIDUAL_ACCUMULATOR_BITS - 1) <= right_best_residual;
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + FILTER_RESIDUAL_ACCUMULATOR_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS -1) <= right_working_residual;
		
		-- Now (2) is at index 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS
		
		-- Assign Filter Output (ADC_DATA_BITS each)
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS - 1) <= left_spk_dac_input;		
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS - 1) <= right_spk_dac_input;				
		
		-- Now (2) is at index 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS
		
		-- Assign Filter FSM State (FSM_FILTER_UPDATE_BLOCK_STATE_BITS bits each)
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + FSM_FILTER_UPDATE_BLOCK_STATE_BITS - 1) <= left_current_fsm_state;		
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + FSM_FILTER_UPDATE_BLOCK_STATE_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS - 1) <= left_next_fsm_state;

		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + FSM_FILTER_UPDATE_BLOCK_STATE_BITS - 1) <= right_current_fsm_state;		
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + FSM_FILTER_UPDATE_BLOCK_STATE_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS - 1) <= right_next_fsm_state;
		
		-- Now (2) is at index 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE
		
		-- Assign Error Samples (L, R) latched for the NEXT tick
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS + ADC_DATA_BITS - 1) <= left_mic_error_adc_output;
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS + ADC_DATA_BITS - 1) <= right_mic_error_adc_output;
			
		-- Now (2) is at 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE to 4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + 2*ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS
		-- At our current numbers this is 456 bits in (2) and 432 in (1), well within the 510 bits we could transmit in a sample_tick
		
		-- For now, fill in the rest with zeros
		serial_ir_left_1(4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to toSerialize) <= (4+ FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to toSerialize => '0');
		serial_ir_left_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + 2*ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to toSerialize) <= (4+ FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + 2*ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to toSerialize => '0');
		serial_ir_right_1(4+FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to toSerialize) <= (4+ FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS to toSerialize => '0');
		serial_ir_right_2(4+FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + 2*ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to toSerialize) <= (4+ FILTER_FIR_LENGTH*ADC_DATA_BITS + HALF_FILTER_FIR_LENGTH*FILTER_COEFFICIENT_BITS + 2*FILTER_RESIDUAL_ACCUMULATOR_BITS + 2*ADC_DATA_BITS + 2*FSM_FILTER_UPDATE_BLOCK_STATE_BITS to toSerialize => '0');		

	end process assignSerialIR;
	
	trigger_on_sample_tick <= sample_tick;	
	DebugSerializer: block_serializer
		 port map (			
			reset => reset, 
			sys_clk => sys_clk_20,
			sample_tick => sample_tick,
			end_serialization => end_serializer,
			ddr_serial_clock => trigger_on_sys_clk_20,
			input_register_1 => serial_ir_left_1, 
			input_register_2 => serial_ir_left_2, 
			input_register_3 => serial_ir_right_1, 
			input_register_4 => serial_ir_right_2, 
			serial_1 => serial_left_1,
			serial_2 => serial_left_2,
			serial_3 => serial_right_1,
			serial_4 => serial_right_2
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
			left_best_filter_coefficients => left_best_filter_coefficients,
			right_best_filter_coefficients => right_best_filter_coefficients,
			left_working_filter_coefficients => left_working_filter_coefficients,
			right_working_filter_coefficients => right_working_filter_coefficients,			
			left_best_residual => left_best_residual,
			right_best_residual => right_best_residual,
			left_working_residual => left_working_residual,
			right_working_residual => right_working_residual,			
			left_input_history => left_input_history,
			right_input_history => right_input_history,		
			left_current_fsm_state => left_current_fsm_state,
			right_current_fsm_state => right_current_fsm_state,			
			left_next_fsm_state => left_next_fsm_state,
			right_next_fsm_state => right_next_fsm_state
		 );	


end  structural;


---------------------------------------------------------------------------
--
--  Structural model for the headphones, simplified to test the interface
--  to the block_filter_pair. 
--
--  Current Goal: attempt to replicate the "best residual 0" bug found
--  in the serial debug traces.
--   
--  Entities included are:
--     test_block_filter_in_system
--
--  Revision History:
-- 	 4/1/2016 Sushant Sundaresh created
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {test_block_filter_in_system} architecture {structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  test_block_filter_in_system  is
    port (		
		-- User Buttons, to be synchronized -- 		
		reset : in std_logic;		 					-- Switch 5, active high
		async_oe : in std_logic;								-- Switch 6, active high		
		async_ae : in std_logic; 								-- Switch 3, active high
						
		-- System Clock
		sys_clk_20 : in std_logic;
		
		-- Sample Tick
		observe_ticks : out std_logic;
		
		-- Test Outputs
		left_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_best_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		left_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));
		right_working_residual : out std_logic_vector(0 to (FILTER_RESIDUAL_ACCUMULATOR_BITS-1));

		left_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_current_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		
		left_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE;
		right_next_fsm_state : out FSM_FILTER_UPDATE_BLOCK_STATE
		
    );
end  test_block_filter_in_system;

--}} End of automatically maintained section

architecture  structural  of  test_block_filter_in_system  is					

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

	-- Sample Pulses
	signal sample_tick : std_logic;	

	-- Sample Wiring	
		
	-- Adaptation Enable synchronization
	-- Output Enable synchronization
	signal daisyChain_ae	: std_logic_vector(2 downto 0);
	signal daisyChain_oe	: std_logic_vector(2 downto 0);
	signal oe : std_logic;
	signal ae : std_logic;
	signal may_update_filter : std_logic;
				
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
	
	-- 40 kHz off 20 MHz	
	observe_ticks <= sample_tick;
	FiveTwelveCounter: kBitCounter
		generic map ( k => 9 )		
		port map (	
			sys_clk => sys_clk_20,
			clear => reset,
			run => '1',
			count => open,
			finalCarry => sample_tick
			);

	myFILTER: block_filter_pair
		 port map (
			reset => reset,
			sys_clk => sys_clk_20,
			may_update_filter => may_update_filter,
			trigger_convolution => sample_tick,
			left_mic_sample_adc_output => "00000000",
			left_mic_error_adc_output => "00000001",
			right_mic_sample_adc_output => "00000000",
			right_mic_error_adc_output => "00000001",
			left_spk_dac_input => open,
			right_spk_dac_input => open,
			left_best_filter_coefficients => open,
			right_best_filter_coefficients => open,
			left_working_filter_coefficients => open,
			right_working_filter_coefficients => open,
			left_best_residual => left_best_residual,
			right_best_residual => right_best_residual,
			left_working_residual => left_working_residual,
			right_working_residual => right_working_residual,			
			left_input_history => open,
			right_input_history => open,
			left_current_fsm_state => left_current_fsm_state,
			right_current_fsm_state => right_current_fsm_state,			
			left_next_fsm_state => left_next_fsm_state,
			right_next_fsm_state => right_next_fsm_state
		 );	


end  structural;


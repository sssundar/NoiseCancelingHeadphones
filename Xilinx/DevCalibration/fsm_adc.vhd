---------------------------------------------------------------------------
--
--  ADC Controller
--
--  This is an FSM that waits for a signal to sample new input and error signals,
--  and communicates with the ADC10464 peripheral. The design conservatively
--  meets the timing requirements for Mode 1 operation of the peripheral assuming
--  direct connection from the FPGA to the ADC for control, a resistive divider for
--  bringing the 5 V ~INT signal to 3.3V, and a 4ns max delay bidirectional logic 
--  converter for the data bus.
--
--  It requires 100kHz operation of the ADC10484 in bursts of 4 samples.
--  This entity also contains helper structures for sample holding, shifting, 
--  and LED display (calibration).
--
--  Inputs:
-- 	sys_clk 			20 MHz
-- 	sample_tick 	active high
-- 	reset 			active high
--		nint 				interrupt, active low, asynchronous
--  	button0..3 		active high buttons, asynchronous
--  	databus 			adc data lines, low 8 lsb.		
-- 
--  Outputs:
-- 	nRD 				active low read
-- 	nSH 				active low sample (active high hold)
-- 	vin0 				samples, 8 bit signed and level shifted down by 128
-- 	vin1
-- 	vin2
-- 	vin3 	
-- 	leds 				active high led array (0 to 7)
-- 	s0, s1 			active high sample selectors, (s1s0, 00 = 0, .., 11 = 3)
-- 	
--  Entities included are:
--     fsm_adc
--
--
--  Revision History:
--     02/16/2016 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fsm_adc} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity  fsm_adc  is

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
	 
end  fsm_adc;

--}} End of automatically maintained section

architecture  dataflow  of  fsm_adc  is	
	
	component kBitCounter
		generic (
			k : integer := 3 -- number of bits in counter
		);
		port (	
			sys_clk : in std_logic; 				-- clock input
			clear : in std_logic; 					-- synchronous clear
			run : in std_logic; 						-- increment enable 
			count : out std_logic_vector(0 to (k-1));  -- the counter state
			finalCarry :  out  std_logic       --  carry out
			);
	end component;
	
	subtype FSM_ADC_STATE is std_logic_vector(0 to 4);
	-- States are NOT one-hot, their bits are registered control signals.
	-- bit 0 and 1 are nRD and nSH respectively.
	constant ADC_RESET 					: FSM_ADC_STATE := "11000";	
	constant ADC_CNTR_INC 				: FSM_ADC_STATE := "11001";	
	constant ADC_CNTR_STABILIZE_WAIT : FSM_ADC_STATE := "11010";	
	constant ADC_SAMPLE 					: FSM_ADC_STATE := "10011";	
	constant ADC_SAMPLE_WAIT 			: FSM_ADC_STATE := "11100";	
	constant ADC_READ 					: FSM_ADC_STATE := "01101";	
	constant ADC_SHIFT 					: FSM_ADC_STATE := "01110";	
	
	-- states
	signal PresentState, NextState : FSM_ADC_STATE; 																				

	-- control signals, active high, & registers
	signal led_register : std_logic_vector(0 to 7); 
	signal vin0_register : std_logic_vector(0 to 7); 
	signal vin1_register : std_logic_vector(0 to 7); 
	signal vin2_register : std_logic_vector(0 to 7); 
	signal vin3_register : std_logic_vector(0 to 7); 
	signal led_write_enable : std_logic;
	signal shift_samples : std_logic;
	signal inv_msb : std_logic;
	
	-- sample counter related
	signal clear_sample_counter : std_logic;
	signal inc_sample_counter : std_logic;	
	signal sample_count : std_logic_vector(0 to 1);	-- 0 must be LSB for ADC10464
	signal is_sample_count_at_max : std_logic;  

	-- wait counter related (all wait cycles are 8 clocks)
	signal clear_wait_counter : std_logic;
	signal inc_wait_counter : std_logic;	
	signal is_wait_count_at_max : std_logic;  
		
	-- synchronizer for buttons + nINT
	signal daisyChain0	: std_logic_vector(2 downto 0);
	signal syncButton0 : std_logic;
	
	signal daisyChain1	: std_logic_vector(2 downto 0);
	signal syncButton1 : std_logic;
	
	signal daisyChain2	: std_logic_vector(2 downto 0);
	signal syncButton2 : std_logic;
	
	signal daisyChain3	: std_logic_vector(2 downto 0);
	signal syncButton3 : std_logic;

	signal daisyChain4	: std_logic_vector(2 downto 0);
	signal syncNInt : std_logic;

begin
	-- Control Signals
	led_write_enable <= '1' when ((shift_samples = '1') and ( ( (syncButton0 = '1') and std_match(sample_count, "00") ) or ( (syncButton1 = '1') and std_match(sample_count, "01") ) or ( (syncButton2 = '1') and std_match(sample_count, "10") ) or ( (syncButton3 = '1') and std_match(sample_count, "11") ) ) ) else '0';
	shift_samples <= '1' when std_match(PresentState, ADC_SHIFT) else '0';
	inv_msb <= '0' when std_match(databus(0),'1') else '1';
	
	-- Assign Outputs
	s0 <= sample_count(1);
	s1 <= sample_count(0);
	leds <= led_register;
	vin0 <= vin0_register;
	vin1 <= vin1_register;
	vin2 <= vin2_register;
	vin3 <= vin3_register;
	nRD <= PresentState(0);
	nSH <= PresentState(1);
	
	-- Synchronize Inputs. Do not press at same time for consistent LED viewing.
	syncButton0 <= daisyChain0(2);
	syncButton1 <= daisyChain1(2);
	syncButton2 <= daisyChain2(2);
	syncButton3 <= daisyChain3(2);
	syncNInt <= daisyChain4(2); 
		
	process (sys_clk) 
	begin	
		if (rising_edge(sys_clk)) then			
			daisyChain0(2 downto 0) <= daisyChain0(1 downto 0) & buttons(0); 
			daisyChain1(2 downto 0) <= daisyChain1(1 downto 0) & buttons(1); 
			daisyChain2(2 downto 0) <= daisyChain2(1 downto 0) & buttons(2); 
			daisyChain3(2 downto 0) <= daisyChain3(1 downto 0) & buttons(3); 
			daisyChain4(2 downto 0) <= daisyChain4(1 downto 0) & nInt; 
		end if;
	end process;



	-- Sample Counter
	sampleCounter: kBitCounter
		generic map ( k => 2 )
		port map (	
			sys_clk => sys_clk,
			clear => clear_sample_counter,
			run => inc_sample_counter,
			count => sample_count,
			finalCarry => is_sample_count_at_max
			);

	-- Wait Counter
	waitCounter: kBitCounter
		generic map ( k => 4 )
		port map (	
			sys_clk => sys_clk,
			clear => clear_wait_counter,
			run => inc_wait_counter,
			count => open,
			finalCarry => is_wait_count_at_max
			);	
	
	
	-- Sample Register, LED Register Update Process
	register_update: process (sys_clk, reset, led_write_enable, shift_samples, inv_msb, led_register, vin0_register, vin1_register, vin2_register, vin3_register, databus)
	begin
		if rising_edge(sys_clk) then
			if ( (shift_samples = '1') and (reset = '0') )then
				vin0_register <= vin1_register;
				vin1_register <= vin2_register;
				vin2_register <= vin3_register;
				vin3_register(0 to 7) <= inv_msb & databus(1 to 7);
			end if;
			
			if ( (led_write_enable = '1') and (reset = '0') )then
				led_register <= databus;
			end if;			
			
			if (reset = '1') then
				led_register  <= "00000000";
				vin0_register <= "00000000";
				vin1_register <= "00000000";
				vin2_register <= "00000000";
				vin3_register <= "00000000";
			end if;
		end if;
	end process register_update;
	
	-- ADC FSM	
	fsm_stateupdate: process (sys_clk)
	begin		
		if rising_edge(sys_clk) then		
			PresentState <= NextState;											
		end if;
	end process fsm_stateupdate;

	-- combinational NextState calculation and control signal generation	
	clear_sample_counter <= '1' when std_match(PresentState, ADC_RESET) else '0';
	inc_sample_counter <= '1' when std_match(PresentState, ADC_CNTR_INC) else '0';	
	clear_wait_counter <= '1' when ( std_match(PresentState, ADC_RESET) or std_match(PresentState, ADC_SAMPLE_WAIT) or std_match(PresentState, ADC_CNTR_INC) ) else '0';
	inc_wait_counter <= '1' when ( std_match(PresentState, ADC_CNTR_STABILIZE_WAIT) or std_match(PresentState, ADC_SAMPLE) or std_match(PresentState, ADC_READ)) else '0';			
	
	fsm_nextstatecalc: process (PresentState, is_sample_count_at_max, is_wait_count_at_max, syncNInt, reset, sample_tick)
	begin		
		NextState <= ADC_RESET; -- by default.	 
		
		if ( std_match(PresentState,ADC_RESET) and (sample_tick = '1') and (reset = '0') ) then
			NextState <= ADC_CNTR_STABILIZE_WAIT; 
		end if;
		
		if ( std_match(PresentState,ADC_CNTR_STABILIZE_WAIT) and (reset = '0') ) then
			if (is_wait_count_at_max = '1') then
				NextState <= ADC_SAMPLE; 
			else
				NextState <= ADC_CNTR_STABILIZE_WAIT;
			end if;		
		end if;
		
		if ( std_match(PresentState, ADC_SAMPLE) and (reset = '0') ) then
			if (is_wait_count_at_max = '1') then
				NextState <= ADC_SAMPLE_WAIT; 
			else
				NextState <= ADC_SAMPLE;
			end if;					
		end if;
		
		if ( std_match(PresentState, ADC_SAMPLE_WAIT) and (reset = '0') ) then
			if (syncNInt = '0') then
				NextState <= ADC_READ;
			else 
				NextState <= ADC_SAMPLE_WAIT;
			end if;
		end if;
		
		if ( std_match(PresentState, ADC_READ) and (reset = '0') ) then
			if (is_wait_count_at_max = '1') then
				NextState <= ADC_SHIFT; 
			else
				NextState <= ADC_READ;
			end if;					
		end if;

		if ( std_match(PresentState, ADC_SHIFT) and (reset = '0') ) then 
			NextState <= ADC_CNTR_INC;
		end if;
		
		if ( std_match(PresentState, ADC_CNTR_INC) and (reset = '0') ) then
				if (is_sample_count_at_max = '0') then
					NextState <= ADC_CNTR_STABILIZE_WAIT;
				end if;
				-- else default
		end if;
		
	end process fsm_nextstatecalc;

end  dataflow;
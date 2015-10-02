-- This entity is not complete. 
-- It is my test code for pin mapping to the FPGA to test my ADC I/O controller.
-- Last Revised: 30 Sep 2015 by Sushant Sundaresh. Started implementing FSM.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_counter is
	Port (
		-- For Testing, Visibility 
		led : out std_logic_vector(0 to 7);
		
		-- Inputs from ADC Chip
		cInterrupt : in std_logic;
		DB : in std_logic_vector(0 to 7); 
		
		-- Outputs to ADC Chip 
		cSample : out std_logic;
		cRead : out std_logic;
		cSelect0 : out std_logic;
		cSelect1 : out std_logic;		
		
		-- User Input Buttons 
		button0 : in std_logic;
		button1 : in std_logic;
		button2 : in std_logic;
		button3 : in std_logic;
		reset : in std_logic; 
		
		sys_clk : in std_logic
	);
end led_counter;

architecture dataflow of led_counter is
	component kBitCounter
		generic (
			k : integer := 3 							-- number of bits in counter
		);
		port (	
			sys_clk : in std_logic; 				-- clock input
			clear : in std_logic; 					-- synchronous clear, active high
			run : in std_logic; 						-- increment enable, active high
			count : out std_logic_vector(0 to (k-1));  -- the counter state
			finalCarry : out std_logic 					-- combinational carry out of the counter
			);
	end component;

	-- Buttons
	signal daisyChain0	: std_logic_vector(0 to 2);
	signal syncButton0 : std_logic;
	
	signal daisyChain1	: std_logic_vector(0 to 2);
	signal syncButton1 : std_logic;
	
	signal daisyChain2	: std_logic_vector(0 to 2);
	signal syncButton2 : std_logic;
	
	signal daisyChain3	: std_logic_vector(0 to 2);
	signal syncButton3 : std_logic;
	
	-- ADC Inputs, for synchronization
	signal daisyChain4	: std_logic_vector(0 to 2);
	signal syncCInterrupt : std_logic;
	
	-- Constants	
	subtype FSM_ADC_STATE is std_logic_vector(0 to 7);
	constant FSM_ADC_STATE_REST : FSM_ADC_STATE := "10000000";	
	constant FSM_ADC_STATE_BUF1 : FSM_ADC_STATE := "01000000";	
	constant FSM_ADC_STATE_SAMP : FSM_ADC_STATE := "00100000";	
	constant FSM_ADC_STATE_BUF2 : FSM_ADC_STATE := "00010000";	
	constant FSM_ADC_STATE_READ : FSM_ADC_STATE := "00001000";	
	constant FSM_ADC_STATE_BUF3 : FSM_ADC_STATE := "00000100";	
	constant FSM_ADC_STATE_COPY : FSM_ADC_STATE := "00000010";	
	constant FSM_ADC_STATE_INCR : FSM_ADC_STATE := "00000001";		
	constant FSM_ADC_INDEX_REST : integer := 0;	
	constant FSM_ADC_INDEX_BUF1 : integer := 1;	
	constant FSM_ADC_INDEX_SAMP : integer := 2;	
	constant FSM_ADC_INDEX_BUF2 : integer := 3;	
	constant FSM_ADC_INDEX_READ : integer := 4;	
	constant FSM_ADC_INDEX_BUF3 : integer := 5;	
	constant FSM_ADC_INDEX_COPY : integer := 6;	
	constant FSM_ADC_INDEX_INCR : integer := 7;	
	
	-- State
	signal PresentState, NextState : FSM_ADC_STATE;
	signal inputCounter : std_logic_vector(0 to 1);
	
	-- Test Register for display on LEDs
	signal test_register : std_logic_vector(0 to 7);
	signal should_write_test_register : std_logic;
	
begin
	-- Control Signals
	should_write_test_register <= '1' if ( (PresentState(FSM_ADC_INDEX_COPY) = '1') and ( ((syncButton0 = '1') and ()) or () or () or () ) )
	
	-- Synchronize Inputs. Do not press at same time for consistent LED viewing.
	syncButton0 <= daisyChain0(2);
	syncButton1 <= daisyChain1(2);
	syncButton2 <= daisyChain2(2);
	syncButton3 <= daisyChain3(2);
	syncCInterrupt <= daisyChain4(2); 
		
	process (sys_clk) 
	begin	
		if (rising_edge(sys_clk)) then			
			daisyChain0 <= button0 & daisyChain0(0 to 1);
			daisyChain1 <= button1 & daisyChain1(0 to 1);
			daisyChain2 <= button2 & daisyChain2(0 to 1);
			daisyChain3 <= button3 & daisyChain3(0 to 1);
			daisyChain4 <= cInterrupt & daisyChain4(0 to 1);
		end if;
	end process;
	
	led <= test_register;	

end dataflow;


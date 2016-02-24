---------------------------------------------------------------------------
--
--  Structural model for the ADC hardware test setup
--  
--  Entities included are:
--     test_adc_hardware
--
--  Revision History:
-- 	 2/23/2016 Sushant Sundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {test_adc_hardware} architecture {structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity  test_adc_hardware  is
    port (		
		-- User Buttons, to be synchronized -- 		
		reset : in std_logic;		 					 -- Switch 5, active high, Pin L13		
		buttons 		: in std_logic_vector(0 to 3); -- active high buttons, asynchronous
																 -- 0 = B18, 1 = D18, 2 = E18, 3 = H13		
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

		-- ADC Sample Visibility
		leds 			: out std_logic_vector(0 to 7);	
						-- active high led array (0 to 7)
						-- Pins MSB - J14, J15, K15, K14, E16, P16, E4, P4 - LSB
		
		-- System Clock
		sys_clk_50 : in std_logic
						-- Pin B8
    );
end  test_adc_hardware;

--}} End of automatically maintained section

architecture  structural  of  test_adc_hardware  is					
	
	component clock_divider is
   port ( CLKIN_IN        : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic);
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

	-- Sample Pulses
	signal sample_tick : std_logic;	
	
	-- Clock Management
	signal sys_clk_20 : std_logic;
		
begin
	
	-- Clock		
	ClockManager: clock_divider
		port map ( 
			CLKIN_IN => sys_clk_50,
			CLKFX_OUT => sys_clk_20,
			CLKIN_IBUFG_OUT => open,
			CLK0_OUT => open
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

	UUT:  fsm_adc
		 port map (
			sys_clk => sys_clk_20,
			sample_tick => sample_tick, 
			reset => reset,
			nInt => nInt,
			buttons => buttons,
			databus => databus,
			nRD => nRD,
			nSH => nSH,
			vin0 => open,
			vin1 => open,
			vin2 => open,
			vin3 => open,
			leds => leds,
			s0 => s0,
			s1 => s1
		 );	
	
end  structural;


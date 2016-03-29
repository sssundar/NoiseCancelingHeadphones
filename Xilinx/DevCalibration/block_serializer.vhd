---------------------------------------------------------------------------
--
--  A debugging block. Serializes up to 500 bits per filter block. 
--  The input register is sampled on sample_ticks. 
--  Useful if the shift line is connected to a PMOD. 
--  With speeds of 20MHz for the system clock,
--  we see we'll need a Saleae Logic Pro 8 (100MHz digital sampling)
--  and at most a 40kHz or so sample tick to be able to shift out
--  the entire register in time.
--  
--  Entities included are:
--     block_serializer
--
--  Revision History:
--     03/28/2016 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {block_serializer} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity  block_serializer  is
    port (
		-- Inputs -- 
		-- active high control signals
		reset : in std_logic;
		sys_clk : in std_logic;		
		sample_tick : in std_logic;				
		end_serialization : out std_logic;
		ddr_serial_clock : out std_logic;
		
		input_register_1 : in std_logic_vector(0 to toSerialize);		
		input_register_2 : in std_logic_vector(0 to toSerialize);		
		input_register_3 : in std_logic_vector(0 to toSerialize);		
		input_register_4 : in std_logic_vector(0 to toSerialize);		
		
		-- Outputs --
		serial_1 : out std_logic;
		serial_2 : out std_logic;
		serial_3 : out std_logic;
		serial_4 : out std_logic
    );
end  block_serializer;

--}} End of automatically maintained section

architecture  dataflow  of  block_serializer  is																		
	
	component nCounter 
		generic (
			n : integer := toSerialize 
		);
		port (	
			clk : in std_logic; 
			clr : in std_logic; 
			run : in std_logic; 
			count : out integer range 0 to n; 
			hitTarget : out std_logic 	
			);
	end component;
	
	signal latched_shift_reg_1 : std_logic_vector(0 to toSerialize);
	signal latched_shift_reg_2 : std_logic_vector(0 to toSerialize);
	signal latched_shift_reg_3 : std_logic_vector(0 to toSerialize);
	signal latched_shift_reg_4 : std_logic_vector(0 to toSerialize);
	
	-- Double Data Rate (both edges) serial clock, synchronous
	signal ddr : std_logic;
	
begin
	
	ddr_serial_clock <= ddr;	
	process (sys_clk, sample_tick)
	begin
		if (rising_edge(sys_clk)) then
			if (sample_tick = '0') then				
				ddr <= not ddr;
			else
				ddr <= '0';
			end if;
		end if;
	end process;
	
	shiftCounter: nCounter	
		generic map ( n => toSerialize )
		port map (	
			clk => sys_clk,
			clr => sample_tick,
			run => '1',
			count => open,
			hitTarget => end_serialization
			);
	
	serial_1 <= latched_shift_reg_1(0);
	serial_2 <= latched_shift_reg_2(0);
	serial_3 <= latched_shift_reg_3(0);
	serial_4 <= latched_shift_reg_4(0);
	
	process (sys_clk)
	begin
		if (rising_edge(sys_clk)) then
			if (sample_tick = '1') then
				latched_shift_reg_1 <= input_register_1;
				latched_shift_reg_2 <= input_register_2;
				latched_shift_reg_3 <= input_register_3;
				latched_shift_reg_4 <= input_register_4;
			else 
				latched_shift_reg_1(0 to toSerialize) <= latched_shift_reg_1(1 to toSerialize) & '0';
				latched_shift_reg_2(0 to toSerialize) <= latched_shift_reg_2(1 to toSerialize) & '0';
				latched_shift_reg_3(0 to toSerialize) <= latched_shift_reg_3(1 to toSerialize) & '0';
				latched_shift_reg_4(0 to toSerialize) <= latched_shift_reg_4(1 to toSerialize) & '0';
			end if;
		end if;
	end process;
	
end  dataflow;
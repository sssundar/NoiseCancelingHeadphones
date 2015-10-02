----------------------------------------------------------------------------
--
--  This entity represents the filter convolution accumulator block. 
--
--  The accumulator adds FILTER_FIR_LENGTH signed values of ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS bits. 
--  It is guaranteed not to overflow or underflow.
--  It makes a local copy of itself truncated to integer-precision, level-shifts this by +2^(ADC_DATA_BITS-1) (guaranteed not to overflow so long as filter coefficients
--  stay less than or equal to +/- 0.5, and then truncates this to 0,2^(ADC_DATA_BITS)-1 when asked to write itself to the filter block output register as a DAC input.
--
--  Inputs
--  Product 				a filter coefficient-input history multiplication product from the current convolution. signed, ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS bits. 
--  Accumulate 			active high - retain fractional precision bits - sign extend product
--  Clear Accumulator 	active high
--  Clear Output Reg		active high
--  Write Output Reg 	active high
--  sys_clk 			 	system clock
--
--  Outputs
--  Register Filter Output 	can be copied directly by DAC block. Guaranteed in 0, 2^(ADC_DATA_BITS)-1, unsigned.
--	 Accumulator State 			log2(FILTER_FIR_LENGTH) + ADC_DATA_BITS + FILTER_SHIFT_MULTIPLIER_PRECISION_BITS bits, signed.

--  Entities included are:
--  accumulator_convolution
--
--  Revision History:
--  09/27/2015 SSundaresh created
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {accumulator_convolution} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;	  
use IEEE.NUMERIC_STD.all;
use WORK.MAGIC_NUMBERS.all; 

entity accumulator_convolution is
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
end accumulator_convolution;

--}} End of automatically maintained section

architecture  dataflow  of  accumulator_convolution  is                                                                 
	signal this_accumulator : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1));
	signal this_accumulator_integer_precision : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1));
	signal this_output_register : std_logic_vector(0 to (ADC_DATA_BITS-1));
	
	signal sign_extended_product : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1));
	signal accumulator_carrys, accumulator_sum : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1));
	signal ls_carrys, ls_sum : std_logic_vector(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1));	
	
	signal shouldLevelShiftedAccumulatorBeTruncatedBelow : std_logic; -- level shifted value negative
	signal shouldLevelShiftedAccumulatorBeOutputDirectly : std_logic; -- level shifted value in 0, 2^(ADC_DATA_BITS)-1
	signal shouldLevelShiftedAccumulatorBeTruncatedAbove : std_logic; -- level shifted value > 2^(ADC_DATA_BITS)-1
	
	component AddSub
		port (
			A, B    :  in  std_logic;       --  to add, subtract
			AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
			Cin     :  in  std_logic;       --  carry in input
			SumDiff :  out  std_logic;      --  sum or difference output
			Cout    :  out  std_logic       --  carry out output
    );
	end component;
	
begin             
	accumulator_state <= this_accumulator;
	register_filter_output <= this_output_register;
	sign_extended_product <= (0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => product(0)) & product;
	this_accumulator_integer_precision <= this_accumulator(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1));	
	
	--	Accumulator Combinational Adder Chain
	AdderFinal: AddSub port map (this_accumulator(FILTER_CONVOLUTION_ACCUMULATOR_BITS-1), sign_extended_product(FILTER_CONVOLUTION_ACCUMULATOR_BITS-1), '0', '0', accumulator_sum(FILTER_CONVOLUTION_ACCUMULATOR_BITS-1), accumulator_carrys(FILTER_CONVOLUTION_ACCUMULATOR_BITS-1));
	AdderGen:
	for i in 0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-2) generate
	  AdderX: AddSub port map (this_accumulator(i), sign_extended_product(i), '0', accumulator_carrys(i+1), accumulator_sum(i), accumulator_carrys(i));
	end generate;	 
	
	--	Level Shifter Combinational Adder Chain
	LSFinal: AddSub port map (this_accumulator_integer_precision(FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1), FILTER_LEVEL_SHIFTER(FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1), '0', '0', ls_sum(FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1), ls_carrys(FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1));
	LSGen:
	for i in 0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-2) generate
	  LSX: AddSub port map (this_accumulator_integer_precision(i), FILTER_LEVEL_SHIFTER(i), '0', ls_carrys(i+1), ls_sum(i), ls_carrys(i));
	end generate;	 
	
	-- if level shifted result is negative
	shouldLevelShiftedAccumulatorBeTruncatedBelow <= '1' when (ls_sum(0) = '1') else '0'; 
	-- if level shifted result fits in ADC_DATA_BITS, unsigned
	shouldLevelShiftedAccumulatorBeOutputDirectly <= '1' when ( std_match(ls_sum(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1)),(0 to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS-1) => '0')) ) else '0'; 
	-- if level shifted result is greater than ADC_DATA_BITS can hold
	shouldLevelShiftedAccumulatorBeTruncatedAbove <= '1' when ( (shouldLevelShiftedAccumulatorBeOutputDirectly = '0') and (shouldLevelShiftedAccumulatorBeTruncatedBelow = '0') ) else '0'; 

	
	accum_conv_updater: process (sys_clk)
	begin       				  		
	  if (rising_edge(sys_clk)) then
			if (clear_accumulator = '1') then
				this_accumulator <= (0 to (FILTER_CONVOLUTION_ACCUMULATOR_BITS-1) => '0');
			end if;
			
			if (clear_output_register = '1') then
				this_output_register <= (0 to (ADC_DATA_BITS-1) => '0');
			end if;
			
			if (accumulate = '1') then
				this_accumulator <= accumulator_sum;
			end if;	
			
			if (write_output_register = '1') then
				if (shouldLevelShiftedAccumulatorBeTruncatedBelow = '1') then
					this_output_register <= (0 to (ADC_DATA_BITS-1) => '0');
				end if;
				
				if (shouldLevelShiftedAccumulatorBeOutputDirectly = '1') then
					this_output_register <= ls_sum(FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS to (FILTER_CONVOLUTION_ACCUMULATOR_OVERFLOW_BITS+ADC_DATA_BITS-1));
				end if;
				
				if (shouldLevelShiftedAccumulatorBeTruncatedAbove = '1') then
					this_output_register <= (0 to (ADC_DATA_BITS-1) => '1');
				end if;
			end if;
			
			-- else 
				-- persist			
	  end if;                                
	end process accum_conv_updater;		 
end  dataflow;
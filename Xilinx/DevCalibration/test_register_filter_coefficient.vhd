-- test_register_filter_coefficient.vhd         			       
--
-- This testbench unit tests a filter coefficient register for resets and would-overflow, is-zero, and normal updates.
-- It assumes FILTER_COEFFICIENT_BITS = 9.
--
--  Revision History:
--     26 Sep 2015 Sushant Sundaresh created testbench.
--     27 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_register_filter_coefficient is
end test_register_filter_coefficient;

architecture test_register_filter_coefficient_TbArch of test_register_filter_coefficient is

	component register_filter_coefficient is
    port(	  
			sys_clk : in std_logic;							
			reset : in std_logic; 							

			update_coefficient : in std_logic; 			
			load : in std_logic; 							
			load_data : in std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			
			unifrnd0 : in std_logic; 					-- if 0, do nothing on update. if 1, attempt to shift if no overflow would occur.
			unifrnd1 : in std_logic; 		 			-- if 0, shift positive numbers left and negative numbers right. if 1, shift positive numbers right and negative numbers left.

			coefficient : out std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
			coefficientIsZero : out std_logic					
        );                                               
	end component;



    -- Stimulus signals - signals mapped to the input and inout ports of tested entity   	
	 signal clock : std_logic; 
	 signal reset : std_logic;
    signal load : std_logic;
	 signal load_data : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
	 signal update_coefficient : std_logic;
	 signal unifrnd0 : std_logic;
	 signal unifrnd1 : std_logic;
	 
	 signal coefficient : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
	 signal coefficientIsZero : std_logic;
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    REG: register_filter_coefficient
	 port map (	  
			sys_clk => clock,
			reset => reset,
			update_coefficient => update_coefficient,
			load => load,
			load_data => load_data,
			unifrnd0 => unifrnd0,
			unifrnd1 => unifrnd1,
			coefficient => coefficient,
			coefficientIsZero => coefficientIsZero
        );        
	 
    process
    begin  

	-- Reset
	load <= '0';	 
	update_coefficient <= '0';
	unifrnd0 <= '0';	 
	unifrnd1 <= '0';
	reset <= '1';
	wait for 95 ns;					
	reset <= '0';
	wait for 5 ns;
		
	-- Check if state cleared by reset. Check that sign bit is positive.	Check if iszero set.
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register not cleared on reset"
		severity  ERROR; 		
	assert (std_match(coefficientIsZero,'1'))
		report  "Filter coefficient register flags not set on reset"
		severity  ERROR; 		
		
	-- walk LEFT to +2^-8
	unifrnd0 <= '1';
	unifrnd1 <= '0';
	update_coefficient <= '1';
		
	wait for 100 ns;			
			
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1'))
		report  "Filter coefficient register not updated to +2^-8"
		severity  ERROR; 		
	assert (std_match(coefficientIsZero,'0'))
		report  "Filter coefficient register flags not set on update"
		severity  ERROR; 		
			
	-- keep walking LEFT
	wait for 100 ns;			
			
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-3) => '0') & "10"))
		report  "Filter coefficient register not updated to +2^-7"
		severity  ERROR; 		

	-- Start walking RIGHT
	unifrnd1 <= '1';
	wait for 100 ns;			
			
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1'))
		report  "Filter coefficient register not updated to +2^-8"
		severity  ERROR; 		

	-- keep walking right
	wait for 100 ns;
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register not updated to +0"
		severity  ERROR; 		
	wait for 100 ns;
	assert (std_match(coefficient, '1' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1'))
		report  "Filter coefficient register not updated to -2^-8"
		severity  ERROR; 		
	wait for 700 ns;
	assert (std_match(coefficient, '1' & '1' & (2 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register not updated to -2^-1"
		severity  ERROR; 		
	-- try and overflow negative by walking right again
	wait for 200 ns;
	assert (std_match(coefficient, '1' & '1' & (2 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register did not overflow negatively"
		severity  ERROR; 		
	-- try and walk left 
	unifrnd1 <= '0';
	wait for 100 ns;
	assert (std_match(coefficient, '1' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register at -2^-2"
		severity  ERROR; 		
	-- try and reset with precendence over update
	reset <= '1';
	wait for 100 ns;
	reset <= '0';
	assert (std_match(coefficient, '0' & (1 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register reset did not have precedence over update"
		severity  ERROR; 		
	-- try to overflow positive
	wait for 800 ns;
	assert (std_match(coefficient, '0' & '1' & (2 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register did not reach max positive value"
		severity  ERROR; 			
	wait for 200 ns;
	assert (std_match(coefficient, '0' & '1' & (2 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register did not detect positive overflow attempt"
		severity  ERROR; 			
	-- try and walk right after positive overflow attempt
	unifrnd1 <= '1';
	wait for 100 ns;
	assert (std_match(coefficient, '0' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register did not update properly after positive overflow attempt"
		severity  ERROR; 			
	-- try and update while unifrnd says stay the same
	unifrnd1 <= '0';
	unifrnd0 <= '0';
	wait for 100 ns;
	assert (std_match(coefficient, '0' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register updated when it shouldn't have, attempt 1"
		severity  ERROR; 			
	unifrnd1 <= '1';
	unifrnd0 <= '0';
	wait for 100 ns;
	assert (std_match(coefficient, '0' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register updated when it shouldn't have, attempt 2"
		severity  ERROR; 			
	-- reset then shift right to -2^-8 to test if shifting left gives -0 and an iszero flag.
	reset <= '1';	
	wait for 100 ns;
	reset <= '0';
	unifrnd0 <= '1';
	unifrnd1 <= '1';
	wait for 100 ns;
	unifrnd1 <= '0';
	wait for 100 ns;
	assert (std_match(coefficient, '1' & (1 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register not set proplery when initially negative then shifted to 0"
		severity  ERROR; 		
	assert (std_match(coefficientIsZero,'1'))
		report  "Filter coefficient register flags not set on reset when initially negative"
		severity  ERROR; 		
	-- shift right to -2^-8 from -0
	unifrnd1 <= '1';
	wait for 100 ns;
	assert (std_match(coefficient, '1' & (1 to (FILTER_COEFFICIENT_BITS-2) => '0') & '1'))
		report  "Filter coefficient register not updated properly from -0"
		severity  ERROR; 		
	assert (std_match(coefficientIsZero,'0'))
		report  "Filter coefficient register flags not set properly from -0"
		severity  ERROR; 		
	-- test load
	update_coefficient <= '0';
	load <= '1';
	load_data <= "01" & (2 to (FILTER_COEFFICIENT_BITS-1) => '0');
	wait for 100 ns;
	assert (std_match(coefficient, "01" & (2 to (FILTER_COEFFICIENT_BITS-1) => '0')))
		report  "Filter coefficient register not loaded properly"
		severity  ERROR; 		
	load <= '0';
	
	END_SIM <= TRUE;
	wait;
		
	end process; -- end of stimulus process

    
	CLOCK_clk : process

	begin

	  -- this process generates a 100 ns period, 50% duty cycle clock

	  -- only generate clock while still have stimulus vectors

	  if END_SIM = FALSE then
			clock <= '0';
			wait for 50 ns;
	  else
			wait;
	  end if;

	  if END_SIM = FALSE then
			clock <= '1';
			wait for 50 ns;
	  else
			wait;
	  end if;

	end process;    -- end of clock process


end test_register_filter_coefficient_TbArch; 



configuration TESTBENCH_FOR_test_register_filter_coefficient of test_register_filter_coefficient is
    for test_register_filter_coefficient_TbArch        
        for REG : register_filter_coefficient
            use entity work.register_filter_coefficient(dataflow);
        end for; 			
    end for;
end TESTBENCH_FOR_test_register_filter_coefficient;

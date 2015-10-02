-- test_register_convolution_filter_coefficient.vhd         			       
--
-- This testbench unit tests a convolution filter coefficient register for load and proper modification of shift, negate control lines.
--
--  Revision History:
--     27 Sep 2015 Sushant Sundaresh created testbench.
--     27 Sep 2015 Sushant Sundaresh all tests passed. represents a unit test going forward.

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;    
use WORK.MAGIC_NUMBERS.all;

entity test_register_convolution_filter_coefficient is
end test_register_convolution_filter_coefficient;

architecture test_register_convolution_filter_coefficient_TbArch of test_register_convolution_filter_coefficient is

	component register_convolution_filter_coefficient is
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


    -- Stimulus signals - signals mapped to the input and inout ports of tested entity   	
	 signal clock : std_logic; 	 
    signal load_req : std_logic;
	 signal load_data : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
	 signal is_load_data_zero : std_logic;
	 signal shift_req, negate_req : std_logic;
	 
	 signal coefficient : std_logic_vector(0 to (FILTER_COEFFICIENT_BITS-1));
	 signal coefficientIsZero : std_logic;
	 
	 signal shift_input, negate_input : std_logic;
	 
    -- Signal used to stop clock signal generators
    signal END_SIM : BOOLEAN := FALSE;


begin
	
    REG: register_convolution_filter_coefficient
	 port map (	  
			sys_clk => clock,			
			load_req => load_req, 
			load_data => load_data,
			is_load_data_zero => is_load_data_zero,			
			shift_req => shift_req,
			negate_req => negate_req,
			coefficient => coefficient,
			coefficientIsZero => coefficientIsZero,
			shift_input => shift_input,
			negate_input => negate_input
        );        
	 
		  
    process
    begin  

	-- Clear filter coefficient
	load_data <= (0 to (FILTER_COEFFICIENT_BITS-1) => '0');
	is_load_data_zero <= '1';
	load_req <= '1';
	shift_req <= '0';
	negate_req <= '0';	
	wait for 100 ns;	
	load_req <= '0';
		
	-- Check if state cleared
	assert ( std_match(coefficient, (0 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'1') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not cleared properly"
		severity ERROR; 		
		
   -- Try a few shifts in this state; nothing should happen as we are 0.
	shift_req <= '1';
	wait for 100 ns;
	assert ( std_match(coefficient, (0 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'1') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not recognizing zero state when asked to shift"
		severity ERROR; 		
	wait for 200 ns;
	assert ( std_match(coefficient, (0 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'1') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not recognizing zero state when asked to shift"
		severity ERROR; 		
	shift_req <= '0';	
	
	-- Load in +2^-2 and try shift, shift, shift, shift, negate. Expect ctrl lines passed, passed, not passed, not passed, not passed.	
	load_data <= '0' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0');
	is_load_data_zero <= '0';
	load_req <= '1';
	wait for 100 ns;
	load_req <= '0';
	assert ( std_match(coefficient, '0' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not loading positive non-zero state properly 1"
		severity ERROR; 		
	shift_req <= '1';
	wait for 100 ns;
	assert ( std_match(coefficient, '0' & "10" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'1') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting positive non-zero state properly 2"
		severity ERROR; 		
	wait for 100 ns;
	assert ( std_match(coefficient, '0' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting positive non-zero state properly 3"
		severity ERROR; 		
	wait for 100 ns;
	assert ( std_match(coefficient, '0' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting positive non-zero state properly 4"
		severity ERROR; 		
	shift_req <= '0';
	negate_req <= '1';
	wait for 100 ns;
	assert ( std_match(coefficient, '0' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not negating positive non-zero state properly 5"
		severity ERROR; 		
	negate_req <= '0';
	
	-- Load in -2^-2 and try the same. Expect pass, pass, fail, fail, pass.
	load_data <= '1' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0');
	is_load_data_zero <= '0';
	load_req <= '1';
	wait for 100 ns;
	load_req <= '0';
	assert ( std_match(coefficient, '1' & "01" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not loading negative non-zero state properly 1"
		severity ERROR; 		
	shift_req <= '1';
	wait for 100 ns;
	assert ( std_match(coefficient, '1' & "10" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'1') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting negative non-zero state properly 2"
		severity ERROR; 		
	wait for 100 ns;
	assert ( std_match(coefficient, '1' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting negative non-zero state properly 3"
		severity ERROR; 		
	wait for 100 ns;
	assert ( std_match(coefficient, '1' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'0') )
		report  "Filter coefficient not shifting negative non-zero state properly 4"
		severity ERROR; 		
	shift_req <= '0';
	negate_req <= '1';
	wait for 100 ns;
	assert ( std_match(coefficient, '1' & "00" & (3 to (FILTER_COEFFICIENT_BITS-1) => '0')) and std_match(coefficientIsZero,'0') and std_match(shift_input,'0') and std_match(negate_input,'1') )
		report  "Filter coefficient not negating negative non-zero state properly 5"
		severity ERROR; 		
	negate_req <= '0';
	
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


end test_register_convolution_filter_coefficient_TbArch; 



configuration TESTBENCH_FOR_test_register_convolution_filter_coefficient of test_register_convolution_filter_coefficient is
    for test_register_convolution_filter_coefficient_TbArch        
        for REG : register_convolution_filter_coefficient
            use entity work.register_convolution_filter_coefficient(dataflow);
        end for; 			
    end for;
end TESTBENCH_FOR_test_register_convolution_filter_coefficient;

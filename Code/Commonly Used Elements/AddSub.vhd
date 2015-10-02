----------------------------------------------------------------------------
--
--  AddSub in VHDL
--
--  This is an implementation of a full adder/subtractor in VHDL.
--  Subtractions are done via two's complement and only carries are
--  used, notationally.
--
--  Entities included are:
--     AddSub - full adder/subtractor
--
--  Revision History:
--     16 Apr 98  Glen George       Initial revision.
--     10 May 99  Glen George       Fixed generic size on Adder (off by 1).
--      7 Nov 99  Glen George       Updated formatting.
--      4 Nov 05  Glen George       Updated commenting.
--      6 Jan 15  SSundaresh        stripped to single full adder
--     18 Jan 15  SSundaresh        expanded to add/sub
--
----------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {AddSub} architecture {dataflow}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

--
--  AddSub entity declaration (used in n-bit adder/subtractor)
--

entity  AddSub  is

    port (
		A, B    :  in  std_logic;       --  to add, subtract
		AddOrSubtract : in std_logic;   --  defined so 1 if subtracting, 0 if adding
        Cin     :  in  std_logic;       --  carry in input
        SumDiff :  out  std_logic;      --  sum or difference output
        Cout    :  out  std_logic       --  carry out output
    );

end  AddSub;

--}} End of automatically maintained section

--
--  AddSub dataflow architecture
--

architecture  dataflow  of  AddSub  is
	signal bEffective : std_logic;
begin
    bEffective <= B xor AddOrSubtract;
    SumDiff <= A xor bEffective xor Cin;
    Cout <= (A and bEffective) or (A and Cin) or (bEffective and Cin);
end  dataflow;

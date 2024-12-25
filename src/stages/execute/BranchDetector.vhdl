LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY BranchDetector IS
    PORT (
        NF         : IN STD_LOGIC;
        JN         : IN STD_LOGIC;
        CF         : IN STD_LOGIC;
        JC         : IN STD_LOGIC;
        ZF         : IN STD_LOGIC;
        JZ         : IN STD_LOGIC;
        branch_out : OUT STD_LOGIC
    );
END BranchDetector;

ARCHITECTURE Behavioral OF BranchDetector IS
    COMPONENT And2
        PORT (
            A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            Y : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Or3
        PORT (
            A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            C : IN STD_LOGIC;
            Y : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL and_negative, and_carry, and_zero : STD_LOGIC;
    SIGNAL or_output                         : STD_LOGIC;
BEGIN

    and2_inst1 : and2 PORT MAP(a => NF, b => JN, y => and_negative);
    and2_inst2 : and2 PORT MAP(a => CF, b => JC, y => and_carry);
    and2_inst3 : and2 PORT MAP(a => ZF, b => JZ, y => and_zero);
    or3_inst   : or3 PORT MAP(a => and_negative, b => and_carry, c => and_zero, y => or_output);

    branch_out <= or_output;
END Behavioral;
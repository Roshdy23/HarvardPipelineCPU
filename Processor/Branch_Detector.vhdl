library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Branch_Detector is
    Port (
        NF: in std_logic;
        JN: in std_logic;
        CF: in std_logic;
        JC: in std_logic;
        ZF: in std_logic;
        JZ: in std_logic;
        branch_out: out std_logic 
    );
end Branch_Detector;

architecture Behavioral of Branch_Detector is
    component And2
        Port (
            A : in std_logic;
            B : in std_logic;
            Y : out std_logic
        );
    end component;

    component Or3
        Port (
            A : in std_logic;
            B : in std_logic;
            C : in std_logic;
            Y : out std_logic
        );
    end component;
    signal and_negative, and_carry, and_zero: std_logic;
    signal or_output: std_logic;
begin
     
        and2_inst1:  and2 port map (a => NF, b => JN, y => and_negative);
        and2_inst2: and2 port map (a => CF, b => JC, y => and_carry);
        and2_inst3:  and2 port map (a => ZF, b => JZ, y => and_zero);
        or3_inst:  or3 port map (a => and_negative, b => and_carry, c => and_zero, y => or_output);

        branch_out <= or_output;
end Behavioral;
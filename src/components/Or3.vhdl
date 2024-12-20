library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Or3 is
    Port (
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        C : in STD_LOGIC;
        Y : out STD_LOGIC
    );
end Or3;

architecture Behavioral of Or3 is
begin
    Y <= A or B or C;
end Behavioral;
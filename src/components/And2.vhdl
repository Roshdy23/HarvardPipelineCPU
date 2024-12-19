library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity And2 is
    Port (
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        Y : out STD_LOGIC
    );
end And2;

architecture Behavioral of And2 is
begin
    Y <= A and B;
end Behavioral;
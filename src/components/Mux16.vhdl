library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux16 is
    Port (
        A   : in  STD_LOGIC_VECTOR(15 downto 0);
        B   : in  STD_LOGIC_VECTOR(15 downto 0);
        Sel : in  STD_LOGIC;
        Y   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Mux16;

architecture Behavioral of Mux16 is
begin
    Y <= A when Sel = '0' else B;
end Behavioral;
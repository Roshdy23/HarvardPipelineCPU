library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux3 is
    Port (
        flags   : in  STD_LOGIC_VECTOR(2 downto 0);
        INT_flags   : in  STD_LOGIC_VECTOR(2 downto 0);
        Sel : in  STD_LOGIC;
        Y   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Mux3;

architecture Behavioral of Mux3 is
begin
    Y <= flags when Sel = '0' else INT_flags;
end Behavioral;
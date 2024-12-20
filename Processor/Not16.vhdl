library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Not16 is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);        
        Y : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Not16;

architecture Behavioral of Not16 is
begin
    Y <= not (A);
    
end Behavioral;
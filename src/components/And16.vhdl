library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity And16 is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);   
        B : in STD_LOGIC_VECTOR(15 downto 0);      
        Y : out STD_LOGIC_VECTOR(15 downto 0)
    );
end And16;

architecture Behavioral of And16 is
begin
    Y <= A and B;
    
end Behavioral;
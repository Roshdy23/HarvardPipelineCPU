library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Inc16 is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);        
        Y : out STD_LOGIC_VECTOR(15 downto 0);
        CF: out STD_LOGIC
    );
end Inc16;

architecture Behavioral of Inc16 is
    signal res:unsigned(16 downto 0);
begin
  
        res <= '0' & unsigned(A) + 1;
        Y <= std_logic_vector(res(15 downto 0));
        CF <= res(16);
    
end Behavioral;
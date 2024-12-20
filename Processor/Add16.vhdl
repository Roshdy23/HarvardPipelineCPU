library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Add16 is
    Port (
        A          : in  STD_LOGIC_VECTOR(15 downto 0);
        B          : in  STD_LOGIC_VECTOR(15 downto 0);
        Y        : out STD_LOGIC_VECTOR(15 downto 0);
        CF : out STD_LOGIC
    );
end Add16;

architecture Behavioral of Add16 is
    signal temp_sum : unsigned(16 downto 0);
begin
    temp_sum <='0' & unsigned(A) + unsigned(B);
    Y <= std_logic_vector(temp_sum(15 downto 0));
    CF <= temp_sum(16);
end Behavioral;
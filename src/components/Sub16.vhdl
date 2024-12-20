library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sub16 is
    Port (
        A : in  STD_LOGIC_VECTOR(15 downto 0);
        B : in  STD_LOGIC_VECTOR(15 downto 0);
        Result : out STD_LOGIC_VECTOR(15 downto 0);
        NF : out std_logic
    );
end Sub16;

architecture Behavioral of Sub16 is
    signal temp_result : signed(16 downto 0);
begin
    temp_result <= '0' & signed(A) - signed(B);
    Result <= std_logic_vector(temp_result(15 downto 0));
    NF <= temp_result(16);
end Behavioral;
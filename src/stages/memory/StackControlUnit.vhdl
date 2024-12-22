library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StackControlUnit is
    Port (
        rst : in STD_LOGIC;                                 -- Reset
        push : in STD_LOGIC;                                -- Push
        pop : in STD_LOGIC;                                 -- Pop
        sp: out STD_LOGIC_VECTOR(15 downto 0);              -- Stack Pointer
        empty_exception: out STD_LOGIC;                     -- Empty Exception
    );
end StackControlUnit;

architecture Behavioral of StackControlUnit is
begin
    process(rst, push, pop)
    begin
        if rst = '1' then
            sp <= std_logic_vector(to_unsigned(4095, 16));
            empty_exception <= '0';
        elsif push = '1' then
            sp <= std_logic_vector(unsigned(sp) + 1);
            empty_exception <= '0';
        elsif pop = '1' then
            if sp = (others => '0') then
                empty_exception <= '1';
            else
                sp <= std_logic_vector(unsigned(sp) - 1);
                empty_exception <= '0';
            end if;
        end if;
    end process;
end Behavioral;

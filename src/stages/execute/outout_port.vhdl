library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity outout_port is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        input1 : in  STD_LOGIC_vector(15 downto 0);
        output1 : out STD_LOGIC_vector (15 downto 0)
    );
end outout_port;

architecture Behavioral of outout_port is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            output1 <= (others =>'0');
        elsif rising_edge(clk) then
            output1 <= input1;
        end if;
    end process;
end Behavioral;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY OutPort IS
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        en      : IN STD_LOGIC;
        input1  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        output1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END OutPort;

ARCHITECTURE Behavioral OF OutPort IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            output1 <= (OTHERS => '0');
        ELSIF rising_edge(clk) and en = '1' THEN
            output1 <= input1;
        END IF;
    END PROCESS;
END Behavioral;
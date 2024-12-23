LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ExceptionController IS
    PORT (
        rst    : IN STD_LOGIC;
        empty  : IN STD_LOGIC;
        memory : IN STD_LOGIC;
        pc     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        excep  : OUT STD_LOGIC;
        epc    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ExceptionController;
ARCHITECTURE Behavioral OF ExceptionController IS
BEGIN
    PROCESS (rst, empty, memory, pc)
    BEGIN
        IF rst = '0' THEN
            excep <= '0';
            epc   <= (OTHERS => '0');
        ELSIF empty = '1' THEN
            excep <= '1';
            epc   <= pc;
        ELSIF memory = '1' THEN
            excep <= '1';
            epc   <= pc;
        ELSE
            excep <= '0';
            epc   <= (OTHERS => '0');
        END IF;
    END PROCESS;
END Behavioral;
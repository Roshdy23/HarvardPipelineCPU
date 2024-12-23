LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ARCHITECTURE DataMemory OF Ram IS
    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4096 words of 16 bits
    SIGNAL memory             : memory_array := (OTHERS => (OTHERS => '0'));
    SIGNAL accessible_address : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            data_out <= (OTHERS => '0');
            memory   <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF we = '1' THEN
                memory(to_integer(unsigned(accessible_address))) <= data_in;
            ELSIF re = '1' THEN
                data_out <= memory(to_integer(unsigned(accessible_address)));
            END IF;
        END IF;
    END PROCESS;
    accessible_address <= address(11 DOWNTO 0);
END DataMemory;
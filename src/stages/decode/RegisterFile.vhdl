LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterFile IS
    PORT (
        clk        : IN STD_LOGIC;                      -- Clock
        rst        : IN STD_LOGIC;                      -- Reset
        we         : IN STD_LOGIC;                      -- Write enable
        read_reg1  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);   -- Read register 1
        read_reg2  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);   -- Read register 2
        write_reg  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);   -- Write register
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Write data
        read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Read data 1
        read_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- Read data 2
    );
END RegisterFile;

ARCHITECTURE Behavioral OF RegisterFile IS
    TYPE reg_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registers : reg_array := (OTHERS => (OTHERS => '0'));
BEGIN

    PROCESS (rst, clk, read_reg1, read_reg2, registers, we)
    BEGIN
        IF rst = '0' THEN -- Reset: Set all registers to 0
            read_data1 <= (OTHERS => '0');
            read_data2 <= (OTHERS => '0');
        ELSIF falling_edge(clk) THEN -- Write operation: In the first half of the clock cycle
            IF we = '1' THEN
                registers(to_integer(unsigned(write_reg))) <= write_data;
            END IF;
        ELSIF rising_edge(clk) THEN -- Read operation: In the second half of the clock cycle
            read_data1 <= registers(to_integer(unsigned(read_reg1)));
            read_data2 <= registers(to_integer(unsigned(read_reg2)));
        END IF;
    END PROCESS;
END Behavioral;
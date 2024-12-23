LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY StackControlUnit IS
    PORT (
        rst             : IN STD_LOGIC;                      -- Reset
        push            : IN STD_LOGIC;                      -- Push
        pop             : IN STD_LOGIC;                      -- Pop
        sp              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Stack Pointer
        empty_exception : OUT STD_LOGIC;                     -- Empty Exception
    );
END StackControlUnit;

ARCHITECTURE Behavioral OF StackControlUnit IS
    SIGNAL sp_reg  : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(4095, 16));
    SIGNAL next_sp : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    PROCESS (rst, push, pop)
    BEGIN
        IF rst = '0' THEN
            sp_reg          <= STD_LOGIC_VECTOR(to_unsigned(4095, 16));
            empty_exception <= '0';
        ELSIF push = '1' THEN
            next_sp         <= STD_LOGIC_VECTOR(unsigned(sp_reg) - 1);
            empty_exception <= '0';
        ELSIF pop = '1' THEN
            IF sp_reg = STD_LOGIC_VECTOR(to_unsigned(4095, 16)) THEN
                empty_exception <= '1';
                next_sp         <= sp_reg;
            ELSE
                next_sp         <= STD_LOGIC_VECTOR(unsigned(sp_reg) + 1);
                empty_exception <= '0';
            END IF;
        ELSE
            next_sp <= sp_reg;
        END IF;
    END PROCESS;

    sp <= next_sp;
END Behavioral;
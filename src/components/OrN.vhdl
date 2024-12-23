LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY OrN IS
    GENERIC (
        W : INTEGER := 3
    );
    PORT (
        inputs : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y      : OUT STD_LOGIC
    );
END OrN;

ARCHITECTURE Behavioral OF OrN IS
BEGIN
    PROCESS (inputs)
        VARIABLE temp : STD_LOGIC := '0';
    BEGIN
        temp := '0';
        FOR i IN inputs'RANGE LOOP
            temp := temp OR inputs(i);
        END LOOP;
        y <= temp;
    END PROCESS;
END Behavioral;
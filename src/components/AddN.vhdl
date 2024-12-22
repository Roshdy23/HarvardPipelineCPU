LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY AddN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a   : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        b   : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y   : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        cf  : OUT STD_LOGIC
    );
END AddN;

ARCHITECTURE Behavioral OF AddN IS
BEGIN
    PROCESS (a, b)
    VARIABLE temp : unsigned(W DOWNTO 0);
    BEGIN
        temp := '0' & unsigned(a) + unsigned(b);
        y <= STD_LOGIC_VECTOR(temp(W - 1 DOWNTO 0));
        cf <= temp(W);
    END PROCESS;
END Behavioral;
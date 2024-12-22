LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY IncN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a   : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y   : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        cf  : OUT STD_LOGIC
    );
END IncN;

ARCHITECTURE Behavioral OF IncN IS
BEGIN
    PROCESS (a)
    VARIABLE temp : unsigned(W DOWNTO 0);
    BEGIN
        temp := '0' & unsigned(a) + 1;
        y <= STD_LOGIC_VECTOR(temp(W - 1 DOWNTO 0));
        cf <= temp(W);
    END PROCESS;
END Behavioral;
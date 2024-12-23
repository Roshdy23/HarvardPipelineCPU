LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SubN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a  : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        b  : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y  : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        nf : OUT STD_LOGIC
    );
END SubN;

ARCHITECTURE Behavioral OF SubN IS
BEGIN
    PROCESS (a, b)
        VARIABLE temp : SIGNED(W DOWNTO 0);
    BEGIN
        temp := SIGNED('0' & a) - SIGNED('0' & b);
        y  <= STD_LOGIC_VECTOR(temp(W - 1 DOWNTO 0));
        nf <= temp(W);
    END PROCESS;
END Behavioral;
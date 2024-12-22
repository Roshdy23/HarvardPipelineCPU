LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY AndN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
    );
END AndN;

ARCHITECTURE Behavioral OF AndN IS
BEGIN
    y <= a AND b;
END Behavioral;
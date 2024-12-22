LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY NotN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
    );
END NotN;

ARCHITECTURE Behavioral OF NotN IS
BEGIN
    y <= NOT a;
END Behavioral;
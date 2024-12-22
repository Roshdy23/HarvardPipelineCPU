LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MuxN IS
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        sel : IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
    );
END MuxN;

ARCHITECTURE Behavioral OF MuxN IS
BEGIN
    y <= a WHEN sel = '0' ELSE
        b;
END Behavioral;
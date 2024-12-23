LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Mux2 IS
    PORT (
        a   : IN STD_LOGIC;
        b   : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y   : OUT STD_LOGIC
    );
END Mux2;

ARCHITECTURE Behavioral OF Mux2 IS
BEGIN
    y <= a WHEN sel = '0' ELSE
        b;
END Behavioral;
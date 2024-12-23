LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY And2 IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END And2;

ARCHITECTURE Behavioral OF And2 IS
BEGIN
    y <= a AND b;
END Behavioral;
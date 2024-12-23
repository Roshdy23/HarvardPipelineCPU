LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY OrN IS
    GENERIC (
        W : INTEGER := 3
    );
    PORT (
        inputs : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0); -- Give it input as (a & b & c)
        y      : OUT STD_LOGIC
    );
END OrN;

ARCHITECTURE Behavioral OF OrN IS
BEGIN
    y <= OR reduce(inputs); -- Reduce function performs OR on all bits of the vector
END Behavioral;
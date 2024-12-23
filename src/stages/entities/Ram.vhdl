LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Ram IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        ADDR_WIDTH : INTEGER := 16 
    );
    PORT (
        clk      : IN STD_LOGIC;
        rst      : IN STD_LOGIC;
        we       : IN STD_LOGIC;
        re       : IN STD_LOGIC;
        address  : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        data_in  : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END Ram;
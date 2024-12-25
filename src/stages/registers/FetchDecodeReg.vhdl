LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY FetchDecodeReg IS
    PORT (
        clk                  : IN STD_LOGIC;
        rst                  : IN STD_LOGIC;
        flush                : IN STD_LOGIC;
        NOP                  : IN STD_LOGIC;
        in_data_instruction  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        in_data_next_pc      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_next_pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END FetchDecodeReg;
ARCHITECTURE Behavioral OF FetchDecodeReg IS
    -- REGISTER --
    SIGNAL Instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            Instruction <= (OTHERS => '0');
            next_pc <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF (flush = '1') THEN
                Instruction <= (OTHERS => '0');
                next_pc <= (OTHERS => '0');
            ELSIF (NOP = '0') THEN
                Instruction <= in_data_instruction;
                next_pc <= in_data_next_pc;
            END IF;
        END IF;
    END PROCESS;

    out_data_instruction <= Instruction;
    out_data_next_pc <= next_pc;
END Behavioral;
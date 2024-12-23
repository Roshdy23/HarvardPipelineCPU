LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY StackControlUnit IS
    PORT (
        clk             : IN STD_LOGIC;
        rst             : IN STD_LOGIC;
        push            : IN STD_LOGIC;
        pop             : IN STD_LOGIC;
        sp_out          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        empty_exception : OUT STD_LOGIC
    );
END StackControlUnit;

ARCHITECTURE Behavioral OF StackControlUnit IS
    SIGNAL prev_sp : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(4094, 16));
    SIGNAL sp_reg  : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(4095, 16));
BEGIN
    PROCESS (clk, rst)
        VARIABLE current_sp : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(4095, 16));
    BEGIN
        IF rst = '0' THEN
            prev_sp <= STD_LOGIC_VECTOR(to_unsigned(4094, 16));
            current_sp := STD_LOGIC_VECTOR(to_unsigned(4095, 16));
            empty_exception <= '0';
        ELSIF rising_edge(clk) THEN
            IF push = '1' THEN
                current_sp := STD_LOGIC_VECTOR(unsigned(current_sp) - 1);
            ELSIF pop = '1' THEN
                IF current_sp = STD_LOGIC_VECTOR(to_unsigned(4095, 16)) THEN
                    empty_exception <= '1';
                ELSE
                    current_sp := STD_LOGIC_VECTOR(unsigned(current_sp) + 1);
                END IF;
            END IF;
            prev_sp <= STD_LOGIC_VECTOR(unsigned(current_sp) - 1);
            sp_reg  <= current_sp;
        END IF;
    END PROCESS;

    imux2 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => sp_reg,
            b   => prev_sp,
            sel => push,
            y   => sp_out
        );
END Behavioral;
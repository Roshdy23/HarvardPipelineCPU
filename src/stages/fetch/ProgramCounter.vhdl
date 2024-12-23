LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ProgramCounter IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16
    );
    PORT (
        clk                        : IN STD_LOGIC;
        rst                        : IN STD_LOGIC; -- reset
        hazard                     : IN STD_LOGIC;
        prev_op                    : IN STD_LOGIC;
        jmp                        : IN STD_LOGIC;
        call                       : IN STD_LOGIC;
        branch_detector            : IN STD_LOGIC;
        reset_signal               : IN STD_LOGIC;
        hazard_signal              : IN STD_LOGIC;
        alu_data_out               : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        read_data1                 : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        instruction_memory_data_in : IN STD_LOGIC;
        hazard_data_in             : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        program_counter            : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ProgramCounter;

ARCHITECTURE Behavioral OF ProgramCounter IS
    SIGNAL pc : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL prev_pc : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN

    ---------------------------------------------------------------------------------------------    
    PROCESS (clk, rst)

        VARIABLE v_is_hlt : STD_LOGIC;
        VARIABLE v_is_jump : STD_LOGIC;
        VARIABLE v_next_pc : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE v_hlt_check_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE v_reset_signal_check_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE v_jump_check_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE v_final_pc : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    BEGIN
        IF rst = '0' THEN
            pc <= "0000000000001001";
            prev_pc <= (OTHERS => '0');
        ELSIF hazard_signal = '1' THEN
            pc <= hazard_data_in;
        ELSIF rising_edge(clk) THEN
            prev_pc <= pc;

            -- Compute intermediate values
            v_is_hlt := instruction_memory_data_in AND NOT prev_op;
            v_is_jump := jmp OR call OR branch_detector;
            v_next_pc := STD_LOGIC_VECTOR(unsigned(pc) + 1);

            -- Mux operations
            IF v_is_hlt = '0' THEN
                v_hlt_check_out := v_next_pc;
            ELSE
                v_hlt_check_out := prev_pc;
            END IF;

            IF reset_signal = '1' THEN
                v_reset_signal_check_out := v_hlt_check_out;
            ELSE
                v_reset_signal_check_out := "0000000000001001";
            END IF;

            IF branch_detector = '1' THEN
                v_jump_check_out := alu_data_out;
            ELSE
                v_jump_check_out := read_data1;
            END IF;

            IF v_is_jump = '0' THEN
                v_final_pc := v_reset_signal_check_out;
            ELSE
                v_final_pc := v_jump_check_out;
            END IF;

            pc <= v_final_pc;
        END IF;
    END PROCESS;

    program_counter <= pc;

END Behavioral;
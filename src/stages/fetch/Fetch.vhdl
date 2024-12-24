LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16
    );
    PORT (
        clk             : IN STD_LOGIC;
        rst             : IN STD_LOGIC; -- reset
        hazard          : IN STD_LOGIC;
        prev_op         : IN STD_LOGIC;
        jmp             : IN STD_LOGIC;
        call            : IN STD_LOGIC;
        branch_detector : IN STD_LOGIC;
        reset_signal    : IN STD_LOGIC;
        hazard_signal   : IN STD_LOGIC;
        alu_data_out    : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        read_data1      : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        hazard_data_in  : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        instruction     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        next_pc         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Fetch;

ARCHITECTURE Behavioral OF Fetch IS
    SIGNAL pc : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pre_fetched_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hlt_bit : STD_LOGIC;
    SIGNAL data_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reset_value : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN

    PROCESS (pc, rst, clk)
    BEGIN
        IF pc = (pc'RANGE => '0') THEN
            reset_value <= pre_fetched_instruction;
        END IF;
    END PROCESS;

    instruction_memory : ENTITY work.Ram(InstructionMemory)
        GENERIC MAP(
            DATA_WIDTH => 16,
            ADDR_WIDTH => 12
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            we       => '0',
            re       => '1',
            address  => address,
            data_in  => data_in,
            data_out => pre_fetched_instruction
        );

    hlt_bit <= pre_fetched_instruction(0);

    instruction <= pre_fetched_instruction;

    program_counter : ENTITY work.ProgramCounter(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => 16
        )
        PORT MAP(
            clk                        => clk,
            rst                        => rst,
            hazard                     => hazard,
            prev_op                    => prev_op,
            jmp                        => jmp,
            call                       => call,
            branch_detector            => branch_detector,
            reset_value                => reset_value,
            reset_signal               => reset_signal,
            hazard_signal              => hazard_signal,
            alu_data_out               => alu_data_out,
            read_data1                 => read_data1,
            instruction_memory_data_in => hlt_bit,
            hazard_data_in             => hazard_data_in,
            program_counter            => pc
        );

    address <= pc(11 DOWNTO 0);

    next_pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);

END Behavioral;
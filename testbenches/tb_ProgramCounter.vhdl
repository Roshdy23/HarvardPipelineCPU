LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_ProgramCounter IS
END tb_ProgramCounter;

ARCHITECTURE behavior OF tb_ProgramCounter IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ProgramCounter
    GENERIC (
        DATA_WIDTH : INTEGER := 16
    );
    PORT(
        clk                        : IN  std_logic;
        rst                        : IN  std_logic;
        hazard                     : IN  std_logic;
        prev_op                    : IN  std_logic;
        jmp                        : IN  std_logic;
        call                       : IN  std_logic;
        branch_detector            : IN  std_logic;
        reset_signal               : IN  std_logic;
        hazard_signal              : IN  std_logic;
        alu_data_out               : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        read_data1                 : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        instruction_memory_data_in : IN  std_logic;
        hazard_data_in             : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        program_counter            : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Inputs
    signal clk                        : std_logic := '0';
    signal rst                        : std_logic := '0';
    signal hazard                     : std_logic := '0';
    signal prev_op                    : std_logic := '0';
    signal jmp                        : std_logic := '0';
    signal call                       : std_logic := '0';
    signal branch_detector            : std_logic := '0';
    signal reset_signal               : std_logic := '0';
    signal hazard_signal              : std_logic := '0';
    signal alu_data_out               : std_logic_vector(15 downto 0) := (others => '0');
    signal read_data1                 : std_logic_vector(15 downto 0) := (others => '0');
    signal instruction_memory_data_in : std_logic := '0';
    signal hazard_data_in             : std_logic_vector(15 downto 0) := (others => '0');

    -- Outputs
    signal program_counter            : std_logic_vector(15 downto 0);

    -- Testbench variables
    signal test_passed : integer := 0;

    -- Clock period definition
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ProgramCounter PORT MAP (
        clk => clk,
        rst => rst,
        hazard => hazard,
        prev_op => prev_op,
        jmp => jmp,
        call => call,
        branch_detector => branch_detector,
        reset_signal => reset_signal,
        hazard_signal => hazard_signal,
        alu_data_out => alu_data_out,
        read_data1 => read_data1,
        instruction_memory_data_in => instruction_memory_data_in,
        hazard_data_in => hazard_data_in,
        program_counter => program_counter
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin        
        -- hold reset state for 100 ns.
        wait for 20 ns;  
        rst <= '0';
        reset_signal <= '1';
        wait for clk_period;
        rst <= '1';
        
        -- Test case 1: Normal operation
        assert not program_counter = x"0000" report "Test case 1 success" severity error;
        test_passed <= test_passed + 1;

        -- Test case 2: Reset signal
        reset_signal <= '1';
        wait for clk_period;
        assert not program_counter = x"0009" report "Test case 2 success" severity error;
        test_passed <= test_passed + 1;
        reset_signal <= '0';

        -- Test case 3: Hazard signal
        hazard_signal <= '1';
        hazard_data_in <= x"00FF";
        assert not program_counter = x"00FF" report "Test case 3 success" severity error;
        test_passed <= test_passed + 1;
        hazard_signal <= '0';

        -- Test case 4: Jump signal
        jmp <= '1';
        alu_data_out <= x"0010";
        wait for clk_period;
        assert not program_counter = x"0010" report "Test case 4 success" severity error;
        test_passed <= test_passed + 1;
        jmp <= '0';

        -- Test case 5: Call signal
        call <= '1';
        read_data1 <= x"0020";
        wait for clk_period;
        assert not program_counter = x"0020" report "Test case 5 success" severity error;
        test_passed <= test_passed + 1;
        call <= '0';

        -- Test case 6: Branch detector
        branch_detector <= '1';
        alu_data_out <= x"0030";
        wait for clk_period;
        assert not program_counter = x"0030" report "Test case 6 success" severity error;
        test_passed <= test_passed + 1;
        branch_detector <= '0';

        -- Test case 7: Instruction memory data in
        instruction_memory_data_in <= '1';
        prev_op <= '0';
        wait for clk_period;
        assert not program_counter = x"0031" report "Test case 7 success" severity error;
        test_passed <= test_passed + 1;

        -- Test case 8: Hazard and reset signal together
        hazard_signal <= '1';
        reset_signal <= '1';
        hazard_data_in <= x"0040";
        wait for clk_period;
        assert not program_counter = x"0040" report "Test case 8 success" severity error;
        test_passed <= test_passed + 1;
        hazard_signal <= '0';
        reset_signal <= '0';

        -- End of test
        wait;
    end process;

END;
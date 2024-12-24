LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_Fetch IS
END tb_Fetch;

ARCHITECTURE behavior OF tb_Fetch IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Fetch
        GENERIC (
            DATA_WIDTH : INTEGER := 16
        );
        PORT (
            clk             : IN STD_LOGIC;
            rst             : IN STD_LOGIC;
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
    END COMPONENT;

    -- Inputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL hazard : STD_LOGIC := '0';
    SIGNAL prev_op : STD_LOGIC := '0';
    SIGNAL jmp : STD_LOGIC := '0';
    SIGNAL call : STD_LOGIC := '0';
    SIGNAL branch_detector : STD_LOGIC := '0';
    SIGNAL reset_signal : STD_LOGIC := '0';
    SIGNAL hazard_signal : STD_LOGIC := '0';
    SIGNAL alu_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hazard_data_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Outputs
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : Fetch
    GENERIC MAP(
        DATA_WIDTH => 16
    )
    PORT MAP(
        clk             => clk,
        rst             => rst,
        hazard          => hazard,
        prev_op         => prev_op,
        jmp             => jmp,
        call            => call,
        branch_detector => branch_detector,
        reset_signal    => reset_signal,
        hazard_signal   => hazard_signal,
        alu_data_out    => alu_data_out,
        read_data1      => read_data1,
        hazard_data_in  => hazard_data_in,
        instruction     => instruction,
        next_pc         => next_pc
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.
        rst <= '0';
        WAIT FOR 100 ns;
        rst <= '1';

        reset_signal <= '0';
        WAIT FOR 100 ns;
        reset_signal <= '1';

        -- Add stimulus here
        WAIT FOR 100 ns;

        -- Test case 1: Normal operation
        hazard <= '0';
        prev_op <= '0';
        jmp <= '0';
        call <= '0';
        branch_detector <= '0';
        reset_signal <= '1';
        hazard_signal <= '0';
        alu_data_out <= x"0001";
        read_data1 <= x"0002";
        hazard_data_in <= x"0003";
        WAIT FOR 100 ns;

        -- Test case 2: Hazard detected
        hazard <= '1';
        WAIT FOR 100 ns;

        -- Test case 3: Jump operation
        hazard <= '0';
        jmp <= '1';
        WAIT FOR 100 ns;

        -- Test case 4: Call operation
        jmp <= '0';
        call <= '1';
        WAIT FOR 100 ns;

        -- Test case 5: Branch detected
        call <= '0';
        branch_detector <= '1';
        WAIT FOR 100 ns;

        -- Test case 6: Reset signal
        branch_detector <= '0';
        reset_signal <= '0';
        WAIT FOR 100 ns;

        -- Test case 7: Hazard signal
        reset_signal <= '1';
        hazard_signal <= '1';
        WAIT FOR 100 ns;

        -- Test case 8: Normal operation again
        hazard_signal <= '0';
        WAIT FOR 100 ns;

        -- Stop simulation
        WAIT;
    END PROCESS;

END;
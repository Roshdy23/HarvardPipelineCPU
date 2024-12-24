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
    PORT(
        clk             : IN  std_logic;
        rst             : IN  std_logic;
        hazard          : IN  std_logic;
        prev_op         : IN  std_logic;
        jmp             : IN  std_logic;
        call            : IN  std_logic;
        branch_detector : IN  std_logic;
        reset_signal    : IN  std_logic;
        hazard_signal   : IN  std_logic;
        alu_data_out    : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        read_data1      : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        hazard_data_in  : IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        instruction     : OUT std_logic_vector(15 DOWNTO 0);
        next_pc         : OUT std_logic_vector(15 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Inputs
    signal clk             : std_logic := '0';
    signal rst             : std_logic := '0';
    signal hazard          : std_logic := '0';
    signal prev_op         : std_logic := '0';
    signal jmp             : std_logic := '0';
    signal call            : std_logic := '0';
    signal branch_detector : std_logic := '0';
    signal reset_signal    : std_logic := '0';
    signal hazard_signal   : std_logic := '0';
    signal alu_data_out    : std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal read_data1      : std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal hazard_data_in  : std_logic_vector(15 DOWNTO 0) := (others => '0');

    -- Outputs
    signal instruction     : std_logic_vector(15 DOWNTO 0);
    signal next_pc         : std_logic_vector(15 DOWNTO 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Fetch
    GENERIC MAP (
        DATA_WIDTH => 16
    )
    PORT MAP (
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
        rst <= '0';
        wait for 100 ns;	
        rst <= '1';

        -- Add stimulus here
        wait for 100 ns;
        
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
        wait for 100 ns;

        -- Test case 2: Hazard detected
        hazard <= '1';
        wait for 100 ns;

        -- Test case 3: Jump operation
        hazard <= '0';
        jmp <= '1';
        wait for 100 ns;

        -- Test case 4: Call operation
        jmp <= '0';
        call <= '1';
        wait for 100 ns;

        -- Test case 5: Branch detected
        call <= '0';
        branch_detector <= '1';
        wait for 100 ns;

        -- Test case 6: Reset signal
        branch_detector <= '0';
        reset_signal <= '0';
        wait for 100 ns;

        -- Test case 7: Hazard signal
        reset_signal <= '1';
        hazard_signal <= '1';
        wait for 100 ns;

        -- Test case 8: Normal operation again
        hazard_signal <= '0';
        wait for 100 ns;

        -- Stop simulation
        wait;
    end process;

END;
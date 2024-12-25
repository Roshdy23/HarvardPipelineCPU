LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_FetchDecodeReg IS
END tb_FetchDecodeReg;

ARCHITECTURE behavior OF tb_FetchDecodeReg IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT FetchDecodeReg
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
    END COMPONENT;

    -- Inputs
    SIGNAL clk                 : STD_LOGIC                     := '0';
    SIGNAL rst                 : STD_LOGIC                     := '0';
    SIGNAL flush               : STD_LOGIC                     := '0';
    SIGNAL NOP                 : STD_LOGIC                     := '0';
    SIGNAL in_data_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in_data_next_pc     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Outputs
    SIGNAL out_data_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_next_pc     : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : FetchDecodeReg PORT MAP(
        clk                  => clk,
        rst                  => rst,
        flush                => flush,
        NOP                  => NOP,
        in_data_instruction  => in_data_instruction,
        in_data_next_pc      => in_data_next_pc,
        out_data_instruction => out_data_instruction,
        out_data_next_pc     => out_data_next_pc
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
        rst <= '1';
        WAIT FOR 100 ns;
        rst <= '0';

        WAIT FOR clk_period * 2;

        -- Test case 1: Normal operation
        in_data_instruction <= x"1234";
        in_data_next_pc     <= x"5678";
        NOP                 <= '0';
        WAIT FOR clk_period * 2;
        ASSERT (out_data_instruction = x"1234" AND out_data_next_pc = x"5678")
        REPORT "Test case 1 failed" SEVERITY error;

        -- Test case 2: Flush
        flush <= '1';
        WAIT FOR clk_period * 2;
        flush <= '0';
        ASSERT (out_data_instruction = x"0000" AND out_data_next_pc = x"0000")
        REPORT "Test case 2 failed" SEVERITY error;

        -- Test case 3: NOP
        in_data_instruction <= x"ABCD";
        in_data_next_pc     <= x"EF01";
        NOP                 <= '1';
        WAIT FOR clk_period * 2;
        ASSERT (out_data_instruction = x"0000" AND out_data_next_pc = x"0000")
        REPORT "Test case 3 failed" SEVERITY error;
        WAIT FOR clk_period;
        -- Test case 4: Normal operation again
        NOP <= '0';
        WAIT FOR clk_period * 2;
        ASSERT (out_data_instruction = x"ABCD" AND out_data_next_pc = x"EF01")
        REPORT "Test case 4 failed" SEVERITY error;

        -- Stop simulation
        WAIT;
    END PROCESS;

END;
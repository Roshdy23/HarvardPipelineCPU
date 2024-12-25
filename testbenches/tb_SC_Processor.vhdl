LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_SC_Processor IS
END ENTITY tb_SC_Processor;

ARCHITECTURE behavior OF tb_SC_Processor IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SC_Processor
    PORT(
        clk          : IN  std_logic;
        rst          : IN  std_logic;
        reset_signal : IN  std_logic;
        wb_data      : OUT std_logic_vector(15 downto 0)
    );
    END COMPONENT;

    -- Signals for the UUT
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal reset_signal : std_logic := '1';
    signal wb_data      : std_logic_vector(15 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: SC_Processor PORT MAP (
        clk => clk,
        rst => rst,
        reset_signal => reset_signal,
        wb_data => wb_data
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
        -- hold reset state for 20 ns.
        rst <= '0';
        wait for 20 ns;
        rst <= '1';
        reset_signal <= '0';
        wait for 20 ns;
        reset_signal <= '1';
        -- Add stimulus here
        wait for 100 ns;
        
        -- End simulation
        wait;
    end process;

END ARCHITECTURE behavior;
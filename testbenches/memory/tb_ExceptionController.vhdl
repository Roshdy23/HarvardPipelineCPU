LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_ExceptionController IS
END tb_ExceptionController;

ARCHITECTURE Behavioral OF tb_ExceptionController IS
    SIGNAL rst    : STD_LOGIC                     := '0';
    SIGNAL empty  : STD_LOGIC                     := '0';
    SIGNAL memory : STD_LOGIC                     := '0';
    SIGNAL pc     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL excep  : STD_LOGIC;
    SIGNAL epc    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT zero_vector : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    CONSTANT clk_period  : TIME                          := 10 ns;

BEGIN
    uut : ENTITY work.ExceptionController
        PORT MAP(
            rst    => rst,
            empty  => empty,
            memory => memory,
            pc     => pc,
            excep  => excep,
            epc    => epc
        );

    stim_proc : PROCESS
    BEGIN
        -- Test case 1: Reset condition
        rst <= '0';
        WAIT FOR clk_period;
        rst <= '1';
        WAIT FOR clk_period;

        -- Expect excep = '0' and epc = "0000000000000000"
        ASSERT (excep = '0' AND epc = zero_vector) REPORT "Test case 1 failed" SEVERITY ERROR;

        -- Test case 2: Empty exception condition
        pc <= (OTHERS => '1');
        empty  <= '1';
        memory <= '0';
        WAIT FOR clk_period;
        -- Expect excep = '1' and epc = pc
        ASSERT (excep = '1' AND epc = pc) REPORT "Test case 2 failed" SEVERITY ERROR;

        -- Test case 3: Memory exception condition
        empty  <= '0';
        memory <= '1';
        WAIT FOR clk_period;
        -- Expect excep = '1' and epc = pc
        ASSERT (excep = '1' AND epc = pc) REPORT "Test case 3 failed" SEVERITY ERROR;

        -- Test case 4: No exception condition
        empty  <= '0';
        memory <= '0';
        WAIT FOR clk_period;
        -- Expect excep = '0' and epc = "0000000000000000"
        ASSERT (excep = '0' AND epc = zero_vector) REPORT "Test case 4 failed" SEVERITY ERROR;

        
        -- End simulation
        WAIT;
    END PROCESS;
END Behavioral;
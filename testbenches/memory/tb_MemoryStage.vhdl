LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_MemoryStage IS
END tb_MemoryStage;

ARCHITECTURE Behavioral OF tb_MemoryStage IS
    SIGNAL clk        : STD_LOGIC                     := '0';
    SIGNAL rst        : STD_LOGIC                     := '0';
    SIGNAL push       : STD_LOGIC                     := '0';
    SIGNAL pop        : STD_LOGIC                     := '0';
    SIGNAL int        : STD_LOGIC                     := '0';
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL result     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc         : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_plus1   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL we         : STD_LOGIC                     := '0';
    SIGNAL re         : STD_LOGIC                     := '0';
    SIGNAL stack_op   : STD_LOGIC                     := '0';
    SIGNAL epc        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL excep      : STD_LOGIC;
    SIGNAL data_out   : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT zero_vector : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    CONSTANT clk_period  : TIME                          := 10 ns;

BEGIN
    uut : ENTITY work.MemoryStage
        PORT MAP(
            clk        => clk,
            rst        => rst,
            push       => push,
            pop        => pop,
            int        => int,
            read_data1 => read_data1,
            result     => result,
            pc         => pc,
            pc_plus1   => pc_plus1,
            we         => we,
            re         => re,
            stack_op   => stack_op,
            epc        => epc,
            excep      => excep,
            data_out   => data_out
        );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        -- Test case 1: Reset condition, expect no exception and zeroed outputs
        rst <= '0';
        WAIT FOR clk_period;
        rst <= '1';
        WAIT FOR clk_period;
        ASSERT (excep = '0') REPORT "Test case 1 failed (reset)" SEVERITY ERROR;
        ASSERT (data_out = zero_vector) REPORT "Test case 1 failed (reset data_out)" SEVERITY ERROR;

        -- Test case 2: Push operation, test stack behavior
        push       <= '1';
        stack_op   <= '1';
        we         <= '1';
        read_data1 <= x"1234";
        WAIT FOR clk_period;

        push     <= '0';
        result   <= x"0FFE";
        stack_op <= '0';
        we       <= '0';
        re       <= '1';
        WAIT FOR clk_period;
        ASSERT (data_out = x"1234") REPORT "Test case 2 failed (push operation)" SEVERITY ERROR;
       
        -- Test case again: Push operation, test stack behavior
        push       <= '1';
        stack_op   <= '1';
        we         <= '1';
        read_data1 <= x"1235";
        WAIT FOR clk_period;

        push     <= '0';
        stack_op <= '0';
        result   <= x"0FFD";
        we       <= '0';
        re       <= '1';
        WAIT FOR clk_period;
        ASSERT (data_out = x"1235") REPORT "Test case again failed (push operation)" SEVERITY ERROR;
        
        -- Test case 3: Pop operation, test stack behavior
        pop      <= '1';
        stack_op <= '1';
        we       <= '0';
        re       <= '1';
        WAIT FOR clk_period;
        pop      <= '0';
        stack_op <= '0';
        ASSERT (data_out = x"1235") REPORT "Test case 3 failed (pop operation)" SEVERITY ERROR;

        -- Test case again: Pop operation, test stack behavior
        pop      <= '1';
        stack_op <= '1';
        we       <= '0';
        re       <= '1';
        WAIT FOR clk_period;
        pop      <= '0';
        stack_op <= '0';
        ASSERT (data_out = x"1234") REPORT "Test case again failed (pop operation)" SEVERITY ERROR;


        -- Test case 4: Interrupt condition, expect `data_in` to be taken from `pc_plus1`
        int      <= '1';
        pc_plus1 <= x"5678";
        we       <= '1';
        re       <= '0';
        result   <= x"0000";
        WAIT FOR clk_period;
        int <= '0';
        re  <= '1';
        we  <= '0';
        WAIT FOR clk_period;
        ASSERT (data_out = x"5678") REPORT "Test case 4 failed (interrupt behavior)" SEVERITY ERROR;

        -- Test case 5: No memory exception, expect no exception signal
        we <= '0';
        re <= '0';
        WAIT FOR clk_period;
        ASSERT (excep = '0') REPORT "Test case 5 failed (no exception)" SEVERITY ERROR;

        -- End simulation
        WAIT;
    END PROCESS;
END Behavioral;
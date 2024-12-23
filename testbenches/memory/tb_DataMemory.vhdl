LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_DataMemory IS
END tb_DataMemory;

ARCHITECTURE Behavioral OF tb_DataMemory IS
    SIGNAL clk      : STD_LOGIC                     := '0';
    SIGNAL rst      : STD_LOGIC                     := '0';
    SIGNAL we       : STD_LOGIC                     := '0';
    SIGNAL re       : STD_LOGIC                     := '0';
    SIGNAL address  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period  : TIME                          := 10 ns;
    CONSTANT zero_vector : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
    uut : ENTITY work.Ram(DataMemory)
        GENERIC MAP(
            DATA_WIDTH => 16,
            ADDR_WIDTH => 16
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            we       => we,
            re       => re,
            address  => address,
            data_in  => data_in,
            data_out => data_out
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
        -- Test case 1: Reset condition, expect data_out to be zero
        rst <= '0';
        WAIT FOR clk_period;
        rst <= '1';
        WAIT FOR clk_period;
        ASSERT (data_out = zero_vector) REPORT "Test case 1 failed (reset)" SEVERITY ERROR;

        -- Test case 2: Write to memory, expect data_out to be zero (no read)
        we      <= '1';
        re      <= '0';
        address <= x"0000";
        data_in <= x"1234";
        WAIT FOR clk_period;
        we <= '0';
        WAIT FOR clk_period;
        ASSERT (data_out = zero_vector) REPORT "Test case 2 failed (write but no read)" SEVERITY ERROR;

        -- Test case 3: Read from address x"0000" after write, expect data_out to be x"1234"
        re      <= '1';
        address <= x"0000";
        WAIT FOR clk_period;
        ASSERT (data_out = x"1234") REPORT "Test case 3 failed (read after write)" SEVERITY ERROR;

        -- Test case 4: Write to address x"0FFF", expect data_out to be SAME (no read)
        we      <= '1';
        re      <= '0';
        address <= x"0FFF";
        data_in <= x"5678";
        WAIT FOR clk_period;
        we <= '0';
        WAIT FOR clk_period;
        ASSERT (data_out =  x"1234") REPORT "Test case 4 failed (write but no read)" SEVERITY ERROR;

        -- Test case 5: Read from address x"0FFF" after write, expect data_out to be x"5678"
        re      <= '1';
        address <= x"0FFF";
        WAIT FOR clk_period;
        ASSERT (data_out = x"5678") REPORT "Test case 5 failed (read after write to 4095)" SEVERITY ERROR;

        -- Test case 6: Write to address x"0001", expect data_out to be SAME (no read)
        we      <= '1';
        re      <= '0';
        address <= x"0001";
        data_in <= x"9ABC";
        WAIT FOR clk_period;
        we <= '0';
        WAIT FOR clk_period;
        ASSERT (data_out = x"5678") REPORT "Test case 6 failed (write but no read)" SEVERITY ERROR;

        -- Test case 7: Read from address x"0000" after write, expect data_out to be x"1234"
        re      <= '1';
        address <= x"0000";
        WAIT FOR clk_period;
        ASSERT (data_out = x"1234") REPORT "Test case 7 failed (read after write to address 0)" SEVERITY ERROR;

        WAIT;
    END PROCESS;
END Behavioral;
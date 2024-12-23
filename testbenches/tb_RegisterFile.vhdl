LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_RegisterFile IS
END tb_RegisterFile;

ARCHITECTURE Behavioral OF tb_RegisterFile IS

    SIGNAL clk        : STD_LOGIC                     := '0';             -- Clock signal
    SIGNAL rst        : STD_LOGIC                     := '0';             -- Reset signal
    SIGNAL we         : STD_LOGIC                     := '0';             -- Write enable
    SIGNAL read_reg1  : STD_LOGIC_VECTOR(2 DOWNTO 0)  := "000";           -- Read register 1
    SIGNAL read_reg2  : STD_LOGIC_VECTOR(2 DOWNTO 0)  := "000";           -- Read register 2
    SIGNAL write_reg  : STD_LOGIC_VECTOR(2 DOWNTO 0)  := "000";           -- Write register
    SIGNAL write_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0'); -- Write data
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);                    -- Read data 1
    SIGNAL read_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);                    -- Read data 2

    COMPONENT RegisterFile
        PORT (
            clk        : IN STD_LOGIC;
            rst        : IN STD_LOGIC;
            we         : IN STD_LOGIC;
            read_reg1  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_reg2  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_reg  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT clk_period : TIME := 10 ns;

    FUNCTION to_string(slv : STD_LOGIC_VECTOR) RETURN STRING IS
        VARIABLE result        : STRING(1 TO slv'LENGTH);
    BEGIN
        FOR i IN slv'RANGE LOOP
            IF slv(i) = '1' THEN
                result(i - slv'LOW + 1) := '1';
            ELSE
                result(i - slv'LOW + 1) := '0';
            END IF;
        END LOOP;
        RETURN result;
    END FUNCTION;

    FUNCTION check_and_report(actual : STD_LOGIC_VECTOR; expected : STD_LOGIC_VECTOR; message : STRING) RETURN INTEGER IS
    BEGIN
        IF actual = expected THEN
            RETURN 1;
        ELSE
            REPORT message & " Actual: " & to_string(actual) & " Expected: " & to_string(expected) SEVERITY ERROR;
            RETURN 0;
        END IF;
    END FUNCTION;
BEGIN

    uut : RegisterFile
    PORT MAP(
        clk        => clk,
        rst        => rst,
        we         => we,
        read_reg1  => read_reg1,
        read_reg2  => read_reg2,
        write_reg  => write_reg,
        write_data => write_data,
        read_data1 => read_data1,
        read_data2 => read_data2
    );

    -- Clock generation
    closk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Test procedure
    test_process : PROCESS
        VARIABLE passed_tests : INTEGER := 0;
    BEGIN
        -- Reset the system
        rst <= '0';
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 10 ns;

        -- Test 1: Write to register 1 and read back
        write_reg  <= "001";   -- Select register 1
        write_data <= X"1234"; -- Data to write
        we         <= '1';     -- Enable write
        WAIT FOR 5 ns;         -- Wait for rising edge
        we <= '0';             -- Disable write

        read_reg1 <= "001"; -- Read register 1
        WAIT FOR 5 ns;      -- Wait for falling edge
        passed_tests := passed_tests + check_and_report(read_data1, X"1234", "Test 1 failed: Read data does not match write data");

        -- Test 2: Write to register 2 and read back
        write_reg  <= "010";   -- Select register 2
        write_data <= X"8765"; -- Data to write
        we         <= '1';     -- Enable write
        WAIT FOR 5 ns;         -- Wait for rising edge
        we <= '0';             -- Disable write

        read_reg2 <= "010"; -- Read register 2
        WAIT FOR 5 ns;      -- Wait for falling edge
        passed_tests := passed_tests + check_and_report(read_data2, X"8765", "Test 2 failed: Read data does not match write data");

        -- Test 3: Write to register 1 without write enable
        write_reg  <= "001";   -- Select register 1
        write_data <= X"8765"; -- Data to write
        we         <= '0';     -- Disable write
        WAIT FOR 5 ns;         -- Wait for rising edge

        read_reg1 <= "001"; -- Read register 1
        WAIT FOR 5 ns;      -- Wait for falling edge
        IF read_data1 /= X"8765" THEN
            passed_tests := passed_tests + 1;
        ELSE
            REPORT "Test 3 failed: Read data does not match previous write data. " & " Actual: " & to_string(read_data1) & " Expected: " & to_string(X"8765") SEVERITY ERROR;
        END IF;

        -- Test 4: Write in first half does not affect read in second half
        write_reg  <= "010";   -- Select register 2
        write_data <= X"ABCD"; -- Data to write
        we         <= '1';     -- Enable write
        read_reg1  <= "010";   -- Read register 2
        WAIT FOR 5 ns;         -- Wait for rising edge
        IF read_data1 /= X"ABCD" THEN
            passed_tests := passed_tests + 1;
        ELSE
            REPORT "Test 4 failed: Read data was affected by write operation in the first half. " & " Actual: " & to_string(read_data1) & " Expected: " & to_string(X"8765") SEVERITY ERROR;
        END IF;

        -- Test 5: Write in second half does not take effect till next cycle
        write_reg  <= "000";   -- Select register 0
        write_data <= X"1234"; -- Data to write
        we         <= '1';     -- Enable write
        WAIT FOR 5 ns;         -- Wait for rising edge
        IF read_data1 /= X"1234" THEN
            passed_tests := passed_tests + 1;
        ELSE
            REPORT "Test 5 failed: Write operation took effect in the second half. " & " Actual: " & to_string(read_data1) & " Expected: " & to_string(X"0000") SEVERITY ERROR;
        END IF;

        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 5" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
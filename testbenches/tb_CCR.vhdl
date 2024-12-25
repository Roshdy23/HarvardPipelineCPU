LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_CCR IS
END tb_CCR;

ARCHITECTURE Behavioral OF tb_CCR IS

    SIGNAL clk         : STD_LOGIC;
    SIGNAL rst         : STD_LOGIC;
    SIGNAL flags_in    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL flags_reset : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL flags_out   : STD_LOGIC_VECTOR(2 DOWNTO 0);

    COMPONENT CCR
        PORT (
            clk         : IN STD_LOGIC;
            rst         : IN STD_LOGIC;
            flags_in    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            flags_reset : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            flags_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
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

    uut : CCR
    PORT MAP(
        clk         => clk,
        rst         => rst,
        flags_in    => flags_in,
        flags_reset => flags_reset,
        flags_out   => flags_out
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
        rst     <= '0';
        flags_in <= "000";
        flags_reset <= "000";
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 10 ns;

        -- Test 1: Set the CF flag
        flags_in(2) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "100", "Test 1 failed");

        -- Test 2: Set the NF flag
        flags_in(1) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "110", "Test 2 failed");

        -- Test 3: Set the ZF flag
        flags_in(0) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "111", "Test 3 failed");

        -- Test 4: Reset the CF flag
        flags_reset(2) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "011", "Test 4 failed");
    
        -- Test 5: Reset the NF flag
        flags_reset(1) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "001", "Test 5 failed");

        -- Test 6: Reset the ZF flag
        flags_reset(0) <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "000", "Test 6 failed");

        -- Test 7: Set all flags
        flags_in <= "111";
        flags_reset <= "000";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "111", "Test 7 failed");

        -- Test 8: Reset all flags
        flags_reset <= "111";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(flags_out, "000", "Test 8 failed");

        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 8" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
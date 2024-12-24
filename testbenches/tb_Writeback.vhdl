LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_Writeback IS
END tb_Writeback;

ARCHITECTURE Behavioral OF tb_Writeback IS

    CONSTANT MEM_DATA_FAKER : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"1234";
    CONSTANT IN_DATA_FAKER  : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"ABCD";

    SIGNAL mem_to_reg : STD_LOGIC                     := '0';
    SIGNAL index      : STD_LOGIC                     := '0';
    SIGNAL int        : STD_LOGIC                     := '0';
    SIGNAL mem_data   : STD_LOGIC_VECTOR(15 DOWNTO 0) := MEM_DATA_FAKER;
    SIGNAL in_data    : STD_LOGIC_VECTOR(15 DOWNTO 0) := IN_DATA_FAKER;
    SIGNAL wb_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    COMPONENT Writeback
        PORT (
            mem_to_reg : IN STD_LOGIC;
            index      : IN STD_LOGIC;
            int        : IN STD_LOGIC;
            mem_data   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            wb_data    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

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

    uut : Writeback
    PORT MAP(
        mem_to_reg => mem_to_reg,
        index      => index,
        int        => int,
        mem_data   => mem_data,
        in_data    => in_data,
        wb_data    => wb_data
    );

    -- Test procedure
    test_process : PROCESS
        VARIABLE passed_tests : INTEGER := 0;
    BEGIN
        WAIT FOR 10 ns;

        -- Test 1: Writeback from memory to register
        mem_to_reg <= '1';
        index      <= '0';
        int        <= '0';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, MEM_DATA_FAKER, "Test 1 failed: Writeback data does not match memory data");
        
        -- Test 2: Writeback from normal register to register
        mem_to_reg <= '0';
        index      <= '0';
        int        <= '0';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, IN_DATA_FAKER, "Test 2 failed: Writeback data does not match input data");
        
        -- Test 3: Writeback from memory to register with index
        mem_to_reg <= '1';
        index      <= '1';
        int        <= '0';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, MEM_DATA_FAKER, "Test 3 failed: Writeback data does not match memory data");
        
        -- Test 4: Writeback from normal register to register with index
        mem_to_reg <= '0';
        index      <= '1';
        int        <= '0';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, IN_DATA_FAKER, "Test 4 failed: Writeback data does not match input data");
        
        -- Test 5: Interrupt writeback with index of 1
        mem_to_reg <= '0';
        index      <= '1';
        int        <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, X"0008", "Test 5 failed: Writeback data does not match interrupt data");
        
        -- Test 6: Interrupt writeback with index of 0
        mem_to_reg <= '0';
        index      <= '0';
        int        <= '1';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(wb_data, X"0006", "Test 6 failed: Writeback data does not match interrupt data");

        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 6" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
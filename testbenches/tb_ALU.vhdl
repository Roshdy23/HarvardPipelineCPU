LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_ALU IS
END tb_ALU;

ARCHITECTURE behavior OF tb_ALU IS

    -- Component Declaration for the ALU
    COMPONENT ALU
        PORT (
            a                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            b                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            op                  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            flags_en            : IN STD_LOGIC;
            cf_in, nf_in, zf_in : IN STD_LOGIC;
            result              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cf, nf, zf          : OUT STD_LOGIC
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

    CONSTANT ALU_AND : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT ALU_NOT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT ALU_ADD : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT ALU_INC : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ALU_SUB : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT ALU_NOP : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

    -- Inputs
    SIGNAL a                   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL b                   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL op                  : STD_LOGIC_VECTOR(2 DOWNTO 0)  := ALU_NOP;
    SIGNAL flags_en            : STD_LOGIC                     := '1';
    SIGNAL cf_in, nf_in, zf_in : STD_LOGIC                     := '0';

    -- Outputs
    SIGNAL result     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cf, nf, zf : STD_LOGIC;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : ALU PORT MAP(
        a        => a,
        b        => b,
        op       => op,
        flags_en => flags_en,
        cf_in    => cf_in,
        nf_in    => nf_in,
        zf_in    => zf_in,
        result   => result,
        cf       => cf,
        nf       => nf,
        zf       => zf
    );

    test_process : PROCESS
        VARIABLE passed_tests : INTEGER := 0;
    BEGIN
        -- Initialize inputs
        flags_en <= '1';
        cf_in    <= '0';
        nf_in    <= '0';
        zf_in    <= '0';

        -- Test 1 : AND operation with 1 and 1
        a        <= x"0001";
        b        <= x"0001";
        op       <= ALU_AND;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf), 
            ((a and b) & '0' & '0' & '0'),
            "Test 1 failed: AND operation with 1 and 1"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 2 : NOT operation with 1
        a        <= x"0001";
        op       <= ALU_NOT;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf), 
            ((not a) & '0' & '1' & '0'),
            "Test 2 failed: NOT operation with 1"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 3 : ADD operation with 1 and 1
        a        <= x"0001";
        b        <= x"0001";
        op       <= ALU_ADD;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf), 
            ((a + b) & '0' & '0' & '0'),
            "Test 3 failed: ADD operation with 1 and 1"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 4 : INC operation with 1
        a        <= x"0001";
        op       <= ALU_INC;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf), 
            ((a + 1) & '0' & '0' & '0'),
            "Test 4 failed: INC operation with 1"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 5 : SUB operation with 1 and 1
        a        <= x"0001";
        b        <= x"0001";
        op       <= ALU_SUB;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf), 
            ((a - b) & '0' & '0' & '1'),
            "Test 5 failed: SUB operation with 1 and 1"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 6 : NOP operation
        a        <= x"0001";
        b        <= x"0001";
        op       <= ALU_NOP;
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf),
            (a & cf_in & nf_in & zf_in),
            "Test 6 failed: NOP operation"
        );
        cf_in    <= cf;
        nf_in    <= nf;
        zf_in    <= zf;

        -- Test 7 : Flag enable disabled
        a        <= x"1111";
        b        <= x"0001";
        op      <= ALU_ADD;
        flags_en <= '0';
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (result & cf & nf & zf),
            ((a + b) & cf_in & nf_in & zf_in),
            "Test 7 failed: Flag enable disabled"
        );
        
        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 7" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END behavior;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_Decode IS
END tb_Decode;

ARCHITECTURE Behavioral OF tb_Decode IS

    SIGNAL clk        : STD_LOGIC;
    SIGNAL rst        : STD_LOGIC;
    SIGNAL we         : STD_LOGIC;
    SIGNAL instruction: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL in_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL write_reg  : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL write_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL immediate  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL in_data_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rdest_out  : STD_LOGIC_VECTOR(2 DOWNTO 0);

    COMPONENT Decode
        PORT (
            clk         : IN STD_LOGIC;
            rst         : IN STD_LOGIC;
            we          : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            write_reg   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- From Mem/WB register
            write_data  : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- From WriteBack
            next_pc     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data1  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data2  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            immediate   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            next_pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            rdest_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
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

    uut : Decode
    PORT MAP(
        clk        => clk,
        rst        => rst,
        we         => we,
        instruction => instruction,
        in_data     => in_data,
        write_reg   => write_reg,
        write_data  => write_data,
        next_pc     => next_pc,
        read_data1  => read_data1,
        read_data2  => read_data2,
        immediate   => immediate,
        in_data_out => in_data_out,
        next_pc_out => next_pc_out,
        rdest_out   => rdest_out
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
        in_data <= X"0000";
        next_pc <= X"0000";
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 10 ns;

        -- Test 1: Write to register 0 and read back
        write_reg  <= "000";   -- Select register 0
        write_data <= X"ABCD"; -- Data to write
        we         <= '1';     -- Enable write
        instruction <= "0000000000000000"; -- Read register 0
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(read_data1, X"ABCD", "Test 1 failed: Read data does not match write data");

        -- Test 2: Write to register 1 and read back
        write_reg  <= "001";   -- Select register 1
        write_data <= X"1234"; -- Data to write
        we         <= '1';     -- Enable write
        instruction <= "0000000100000000"; -- Read register 1
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(read_data1, X"1234", "Test 2 failed: Read data does not match write data");

        -- Test 3: Read from register 1 and register 0
        we         <= '0';     -- Disable write
        instruction <= "0000000100000000"; -- Read register 1
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (read_data1 & read_data2),
            X"1234ABCD",
            "Test 3 failed: Read data does not match write data");
        
        -- Test 4: Check immediate value
        instruction <= "1101000100000000"; -- Read register 1
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(immediate, instruction, "Test 4 failed: Immediate value does not match instruction");
        
        -- Test 5 : Check in_data_out
        in_data <= X"1234";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(in_data_out, X"1234", "Test 5 failed: In Port data does not match");
        
        -- Test 6 : Check next_pc_out
        next_pc <= X"1234";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(next_pc_out, X"1234", "Test 6 failed: Next PC does not match");

        -- Test 7 : Check rdest_out of R-type and I-type instructions
        instruction <= "0000010101111000";      -- Should be 110 [4:2]
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(rdest_out, "110", "Test 7 failed: Rdest does not match bit [4:2] of instruction for R-type and I-type instructions");

        -- Test 8 : Check rdest_out of J-type and other instructions
        instruction <= "1100010101111000";      -- Should be 011 [7:5]
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(rdest_out, "011", "Test 8 failed: Rdest does not match bit [7:5] of instruction for J-type and other instructions");
        
        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 8" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
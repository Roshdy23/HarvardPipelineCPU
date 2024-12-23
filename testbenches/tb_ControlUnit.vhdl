LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_ControlUnit IS
END tb_ControlUnit;

ARCHITECTURE Behavioral OF tb_ControlUnit IS
    COMPONENT ControlUnit
        PORT (
            clk            : IN STD_LOGIC;
            rst            : IN STD_LOGIC;
            opcode         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            func_code      : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            index_in       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            jz             : OUT STD_LOGIC;
            jn             : OUT STD_LOGIC;
            jc             : OUT STD_LOGIC;
            jmp            : OUT STD_LOGIC;
            call           : OUT STD_LOGIC;
            ret            : OUT STD_LOGIC;
            int            : OUT STD_LOGIC;
            nop            : OUT STD_LOGIC;
            branch_predict : OUT STD_LOGIC;
            alu_control    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            prev_op        : OUT STD_LOGIC;
            out_en         : OUT STD_LOGIC;
            in_en          : OUT STD_LOGIC;
            mem_re         : OUT STD_LOGIC;
            mem_we         : OUT STD_LOGIC;
            mem_to_reg     : OUT STD_LOGIC;
            reg_we         : OUT STD_LOGIC;
            rti            : OUT STD_LOGIC;
            alu_src1       : OUT STD_LOGIC;
            alu_src2       : OUT STD_LOGIC;
            ie_mem_wb      : OUT STD_LOGIC;
            mem_wb_wb      : OUT STD_LOGIC;
            index_out      : OUT STD_LOGIC;
            stack_op       : OUT STD_LOGIC;
            push           : OUT STD_LOGIC;
            pop            : OUT STD_LOGIC;
            keep_flags     : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk                  : STD_LOGIC := '0';
    SIGNAL rst                  : STD_LOGIC;
    SIGNAL opcode               : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL func_code            : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL index_in             : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL jz, jn, jc, jmp      : STD_LOGIC;
    SIGNAL call, ret, int, nop  : STD_LOGIC;
    SIGNAL branch_predict       : STD_LOGIC;
    SIGNAL alu_control          : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL prev_op              : STD_LOGIC;
    SIGNAL out_en, in_en        : STD_LOGIC;
    SIGNAL mem_re               : STD_LOGIC;
    SIGNAL mem_we               : STD_LOGIC;
    SIGNAL mem_to_reg           : STD_LOGIC;
    SIGNAL reg_we               : STD_LOGIC;
    SIGNAL rti                  : STD_LOGIC;
    SIGNAL alu_src1, alu_src2   : STD_LOGIC;
    SIGNAL ie_mem_wb, mem_wb_wb : STD_LOGIC;
    SIGNAL index_out            : STD_LOGIC;
    SIGNAL stack_op, push, pop  : STD_LOGIC;
    SIGNAL keep_flags           : STD_LOGIC;

    CONSTANT clk_period     : TIME                         := 10 ns;
    CONSTANT ALU_AND        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT ALU_NOT        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT ALU_ADD        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT ALU_INC        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ALU_SUB        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT ALU_NOP        : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
    CONSTANT READ_DATA_1    : STD_LOGIC                    := '1';
    CONSTANT READ_DATA_2    : STD_LOGIC                    := '0';
    CONSTANT READ_IMMEDIATE : STD_LOGIC                    := '1';

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
    -- Clock generation
    closk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Instantiate the Unit Under Test (UUT)
    uut : ControlUnit
    PORT MAP(
        clk            => clk,
        rst            => rst,
        opcode         => opcode,
        func_code      => func_code,
        index_in       => index_in,
        jz             => jz,
        jn             => jn,
        jc             => jc,
        jmp            => jmp,
        call           => call,
        ret            => ret,
        int            => int,
        nop            => nop,
        branch_predict => branch_predict,
        alu_control    => alu_control,
        prev_op        => prev_op,
        out_en         => out_en,
        in_en          => in_en,
        mem_re         => mem_re,
        mem_we         => mem_we,
        mem_to_reg     => mem_to_reg,
        reg_we         => reg_we,
        rti            => rti,
        alu_src1       => alu_src1,
        alu_src2       => alu_src2,
        ie_mem_wb      => ie_mem_wb,
        mem_wb_wb      => mem_wb_wb,
        index_out      => index_out,
        stack_op       => stack_op,
        push           => push,
        pop            => pop,
        keep_flags     => keep_flags
    );

    -- Test process
    test_process : PROCESS
        VARIABLE passed_tests : INTEGER := 0;
    BEGIN
        -- Reset the system
        rst       <= '0';
        opcode    <= (OTHERS => '0');
        func_code <= (OTHERS => '0');
        index_in  <= (OTHERS => '0');
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 10 ns;

        -- Test R-Type instruction
        -- Test 1: NOT operation
        opcode    <= "00";
        func_code <= "000"; -- NOT
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & reg_we),
            (ALU_NOT & READ_DATA_1 & '1'),
            "Test 1 failed: NOT operation");

        -- Test 2: INC operation
        opcode    <= "00";
        func_code <= "001"; -- INC
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & reg_we),
            (ALU_INC & READ_DATA_1 & '1'),
            "Test 2 failed: INC operation");

        -- Test 3: MOV operation
        opcode    <= "00";
        func_code <= "010"; -- MOV
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & reg_we),
            (ALU_NOP & READ_DATA_1 & '1'),
            "Test 3 failed: MOV operation");

        -- Test 4: ADD operation
        opcode    <= "00";
        func_code <= "011"; -- ADD
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we),
            (ALU_ADD & READ_DATA_1 & READ_DATA_2 & '1'),
            "Test 4 failed: ADD operation");

        -- Test 5: SUB operation
        opcode    <= "00";
        func_code <= "100"; -- SUB
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we),
            (ALU_SUB & READ_DATA_1 & READ_DATA_2 & '1'),
            "Test 5 failed: SUB operation");

        -- Test 6: AND operation
        opcode    <= "00";
        func_code <= "101"; -- AND
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we),
            (ALU_AND & READ_DATA_1 & READ_DATA_2 & '1'),
            "Test 6 failed: AND operation");

        -- Test I-Type instruction
        -- Test 7: IADD operation
        opcode    <= "01";
        func_code <= "000"; -- IADD
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we & prev_op & nop & keep_flags),
            (ALU_ADD & READ_DATA_1 & READ_IMMEDIATE & '1' & '1' & '1' & '0'),
            "Test 7 failed: IADD operation");

        -- Test 8: Previous operation
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we & prev_op & nop),
            (ALU_ADD & READ_DATA_1 & READ_IMMEDIATE & '1' & '0' & '0'),
            "Test 8 failed: Previous operation");

        -- Test 9: LDM operation
        opcode    <= "01";
        func_code <= "001"; -- LDM
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src2 & reg_we & mem_re & mem_to_reg & prev_op & nop & keep_flags),
            (ALU_NOP & READ_IMMEDIATE & '1' & '1' & '1' & '1' & '1' & '0'),
            "Test 9 failed: LDM operation");
        WAIT FOR 10 ns; -- Wait for the previous operation to complete

        -- Test 10: LDD operation
        opcode    <= "01";
        func_code <= "010"; -- LDD
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we & mem_re & mem_to_reg & prev_op & nop & keep_flags),
            (ALU_ADD & READ_DATA_1 & READ_IMMEDIATE & '1' & '1' & '1' & '1' & '1' & '1'),
            "Test 10 failed: LDD operation");
        WAIT FOR 10 ns; -- Wait for the previous operation to complete

        -- Test 11: STD operation
        opcode    <= "01";
        func_code <= "011"; -- STD
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (alu_control & alu_src1 & alu_src2 & reg_we & mem_we & prev_op & nop & keep_flags),
            (ALU_ADD & READ_DATA_2 & READ_IMMEDIATE & '0' & '1' & '1' & '1' & '1'),
            "Test 11 failed: STD operation");
        WAIT FOR 10 ns; -- Wait for the previous operation to complete

        -- Test J-Type instruction: JMP operation
        -- Test 12: JZ operation
        opcode    <= "10";
        func_code <= "000"; -- JZ
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn),
            ('0' & '0' & '1' & '0' & '0'),
            "Test 12 failed: JZ operation");

        -- Test 13: JN operation
        opcode    <= "10";
        func_code <= "001"; -- JN
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn),
            ('0' & '0' & '0' & '0' & '1'),
            "Test 13 failed: JN operation");

        -- Test 14: JC operation
        opcode    <= "10";
        func_code <= "010"; -- JC
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn),
            ('0' & '0' & '0' & '1' & '0'),
            "Test 14 failed: JC operation");

        -- Test 15: JMP operation
        opcode    <= "10";
        func_code <= "011"; -- JMP
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn),
            ('0' & '1' & '0' & '0' & '0'),
            "Test 15 failed: JMP operation");

        -- Test 16: CALL operation
        opcode    <= "10";
        func_code <= "100"; -- CALL
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn & call & stack_op & push & pop),
            ('0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0'),
            "Test 16 failed: CALL operation");

        -- Test 17: RET operation
        opcode    <= "10";
        func_code <= "101"; -- RET
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn & ret & stack_op & push & pop),
            ('0' & '0' & '0' & '0' & '0' & '1' & '1' & '0' & '1'),
            "Test 17 failed: RET operation");

        -- Test 18: RTI operation
        opcode    <= "10";
        func_code <= "110"; -- RTI
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn & rti & stack_op & push & pop),
            ('0' & '0' & '0' & '0' & '0' & '1' & '1' & '0' & '1'),
            "Test 18 failed: RTI operation");

        -- Test 19: INT operation
        opcode    <= "10";
        func_code <= "111"; -- INT
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (branch_predict & jmp & jz & jc & jn & int & stack_op & push & pop),
            ('0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0'),
            "Test 19 failed: INT operation");

        -- Test Other instruction
        -- Test 20: NOP operation
        opcode    <= "11";
        func_code <= "000";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (nop & '0'),
            ('1' & '0'),
            "Test 20 failed: NOP operation");

        -- Test 21: HLT operation
        opcode    <= "11";
        func_code <= "001";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            ('1' & keep_flags),
            ('1' & '0'),
            "Test 21 failed: HLT operation");

        -- Test 22: SETC operation
        opcode    <= "11";
        func_code <= "010";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (keep_flags & '0'),
            ('0' & '0'),
            "Test 22 failed: SETC operation");

        -- Test 23: OUT operation
        opcode    <= "11";
        func_code <= "011";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (out_en & '0'),
            ('1' & '0'),
            "Test 23 failed: OUT operation");

        -- Test 24: IN operation
        opcode    <= "11";
        func_code <= "100";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (in_en & '0'),
            ('1' & '0'),
            "Test 24 failed: IN operation");

        -- Test 25: PUSH operation
        opcode    <= "11";
        func_code <= "101";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (stack_op & push & mem_we & stack_op),
            ('1' & '1' & '1' & '1'),
            "Test 25 failed: PUSH operation");

        -- Test 26: POP operation
        opcode    <= "11";
        func_code <= "110";
        WAIT FOR 10 ns;
        passed_tests := passed_tests + check_and_report(
            (stack_op & pop & mem_re & stack_op & mem_to_reg),
            ('1' & '1' & '1' & '1' & '1'),
            "Test 26 failed: POP operation");

        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 26" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
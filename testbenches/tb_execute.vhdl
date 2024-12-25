LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_Execute IS
END tb_Execute;

ARCHITECTURE Behavioral OF tb_Execute IS

    SIGNAL clk                                   : STD_LOGIC;
    SIGNAL rst                                   : STD_LOGIC;
    SIGNAL read_data1, read_data2                : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL res_forward, wb_forward               : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL immediate, input_port                 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_op                                : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL jn, jz, jc, rti, int                  : STD_LOGIC;
    SIGNAL flags_en, alu_src1, alu_src2          : STD_LOGIC;
    SIGNAL foward_unit_sel_1, foward_unit_sel_2  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL input_port_enable, output_port_enable : STD_LOGIC;
    SIGNAL branch_detect                         : STD_LOGIC;
    SIGNAL final_res, alu_res                    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL output_port                           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    CONSTANT ALU_AND                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT ALU_NOT                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT ALU_ADD                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT ALU_INC                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ALU_SUB                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT ALU_NOP                             : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
    CONSTANT READ_DATA_1                         : STD_LOGIC                    := '1';
    CONSTANT READ_DATA_2_SRC1                    : STD_LOGIC                    := '0';
    CONSTANT READ_DATA_2_SRC2                    : STD_LOGIC                    := '1';
    CONSTANT READ_IMMEDIATE                      : STD_LOGIC                    := '0';

    COMPONENT Execute IS
        PORT (
            clk                : IN STD_LOGIC;
            rst                : IN STD_LOGIC;
            read_data1         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data2         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            res_forward        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            wb_forward         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            immediate          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            input_port         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            alu_op             : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            jn, jz, jc         : IN STD_LOGIC;
            rti                : IN STD_LOGIC;
            int                : IN STD_LOGIC;
            flags_en           : IN STD_LOGIC;
            alu_src1           : IN STD_LOGIC;
            foward_unit_sel_1  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            alu_src2           : IN STD_LOGIC;
            foward_unit_sel_2  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            input_port_enable  : IN STD_LOGIC;
            output_port_enable : IN STD_LOGIC;
            branch_detect      : OUT STD_LOGIC;
            final_res, alu_res : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            output_port        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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

    uut : Execute PORT MAP(
        clk                => clk,
        rst                => rst,
        read_data1         => read_data1,
        read_data2         => read_data2,
        res_forward        => res_forward,
        wb_forward         => wb_forward,
        immediate          => immediate,
        input_port         => input_port,
        alu_op             => alu_op,
        jn                 => jn,
        jz                 => jz,
        jc                 => jc,
        rti                => rti,
        int                => int,
        flags_en           => flags_en,
        alu_src1           => alu_src1,
        foward_unit_sel_1  => foward_unit_sel_1,
        alu_src2           => alu_src2,
        foward_unit_sel_2  => foward_unit_sel_2,
        input_port_enable  => input_port_enable,
        output_port_enable => output_port_enable,
        branch_detect      => branch_detect,
        final_res          => final_res,
        alu_res            => alu_res,
        output_port        => output_port
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
        rst                <= '0';
        input_port_enable  <= '0';
        output_port_enable <= '0';
        foward_unit_sel_1  <= "00";
        foward_unit_sel_2  <= "00";
        res_forward        <= (OTHERS => '0');
        wb_forward         <= (OTHERS => '0');
        immediate          <= (OTHERS => '0');
        read_data1         <= (OTHERS => '0');
        read_data2         <= (OTHERS => '0');
        alu_src1           <= '0';
        alu_src2           <= '0';
        input_port         <= (OTHERS => '0');
        alu_op             <= ALU_NOP;
        jn                 <= '0';
        jz                 <= '0';
        jc                 <= '0';
        rti                <= '0';
        int                <= '0';
        flags_en           <= '0';
        WAIT FOR clk_period;
        rst      <= '1';
        flags_en <= '1';
        WAIT FOR clk_period;

        -- Test 1 : Test the ALU operation ADD for Rsrc1 = 0x0001 and Rsrc2 = 0x0002
        read_data1 <= x"0001";
        read_data2 <= x"0002";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_ADD;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"0003", "Test 1 failed: ADD for Rsrc1 = 0x0001 and Rsrc2 = 0x0002");

        -- Test 2 : Test the ALU operation SUB for Rsrc1 = 0x0002 and Rsrc2 = 0x0001
        read_data1 <= x"0002";
        read_data2 <= x"0001";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_SUB;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"0001", "Test 2 failed: SUB for Rsrc1 = 0x0002 and Rsrc2 = 0x0001");

        -- Test 3 : Test the ALU operation ADD for Rsrc1 = 0x0001 and Immediate = 0x0002
        read_data1 <= x"0001";
        read_data2 <= x"0000";
        immediate  <= x"0002";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_IMMEDIATE;
        alu_op     <= ALU_ADD;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"0003", "Test 3 failed: ADD for Rsrc1 = 0x0001 and Immediate = 0x0002");

        -- Test 4 : Test the ALU operation NOP for Rsrc1 = 0x0001 and Rsrc2 = 0x0002
        read_data1 <= x"0001";
        read_data2 <= x"0002";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_NOP;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"0001", "Test 4 failed: NOP for Rsrc1 = 0x0001 and Rsrc2 = 0x0002");

        -- Test 5 : Test the ALU operation AND for Rsrc2 = 0x0011 and Immediate = 0x0101
        read_data1 <= x"0000";
        read_data2 <= x"0011";
        immediate  <= x"0101";
        alu_src1   <= READ_DATA_2_SRC1;
        alu_src2   <= READ_IMMEDIATE;
        alu_op     <= ALU_AND;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"0001", "Test 5 failed: AND for Rsrc2 = 0x0011 and Immediate = 0x0001");

        -- Test 6 : Test the ALU operation NOT for Rsrc2 = 0x0011
        read_data1 <= x"0000";
        read_data2 <= x"0011";
        alu_src1   <= READ_DATA_2_SRC1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_NOT;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, NOT read_data2, "Test 6 failed: NOT for Rsrc2 = 0x0011");

        -- Test 7 : Test the Output port enable
        output_port_enable <= '1';
        read_data1         <= x"3456";
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(output_port, x"3456", "Test 7 failed: Output port enable");

        -- Test 8 : Test the Output port disable
        output_port_enable <= '0';
        read_data1         <= x"1234";
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(output_port, x"3456", "Test 8 failed: Output port disable");

        -- Test 9 : Test the Input port enable
        input_port_enable <= '1';
        input_port        <= x"ABCD";
        read_data2        <= x"1234";
        immediate         <= x"5678";
        alu_src1          <= READ_DATA_2_SRC1;
        alu_src2          <= READ_IMMEDIATE;
        alu_op            <= ALU_AND;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"ABCD", "Test 9 failed: Input port enable");

        -- Test 10 : Test the Input port disable
        input_port_enable <= '0';
        input_port        <= x"ABCD";
        read_data2        <= x"1234";
        immediate         <= x"5678";
        alu_src1          <= READ_DATA_2_SRC1;
        alu_src2          <= READ_IMMEDIATE;
        alu_op            <= ALU_ADD;
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report(final_res, x"68AC", "Test 10 failed: Input port disable");

        -- Test 11 : Test the Branch detect on JZ
        -- Reset CF, ZF, NF
        flags_en   <= '1';
        read_data1 <= x"1000";
        read_data2 <= x"0000";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_ADD;
        WAIT FOR clk_period;
        -- Set ZF
        read_data1 <= x"0000";
        jz         <= '1';
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "10", "Test 11 failed: Branch detect on JZ");
        read_data1 <= x"0001";
        
        -- Test 12 : Test the ZF was reset after branch detect
        WAIT FOR clk_period;
        flags_en   <= '0';
        jz        <= '0';
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "00", "Test 12 failed: ZF was not reset after branch detect");

        -- Test 13 : Test the Branch detect on JN
        -- Reset CF, ZF, NF
        flags_en   <= '1';
        read_data1 <= x"1000";
        read_data2 <= x"0000";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_ADD;
        WAIT FOR clk_period;
        -- Set NF
        read_data1 <= x"8000";
        jn         <= '1';
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "10", "Test 13 failed: Branch detect on JN");
        read_data1 <= x"0001";
        
        -- Test 14 : Test the NF was reset after branch detect
        WAIT FOR clk_period;
        flags_en   <= '0';
        jn         <= '0';
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "00", "Test 14 failed: NF was not reset after branch detect");
        
        -- Test 15 : Test the Branch detect on JC
        -- Reset CF, ZF, NF
        flags_en   <= '1';
        read_data1 <= x"1000";
        read_data2 <= x"0000";
        alu_src1   <= READ_DATA_1;
        alu_src2   <= READ_DATA_2_SRC2;
        alu_op     <= ALU_ADD;
        WAIT FOR clk_period;
        -- Set CF
        read_data1 <= x"FFFF";
        read_data2 <= x"0001";
        jc         <= '1';
        WAIT FOR clk_period;
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "10", "Test 15 failed: Branch detect on JC");
        read_data1 <= x"0001";
        
        -- Test 16 : Test the CF was reset after branch detect
        WAIT FOR clk_period;
        flags_en   <= '0';
        jc        <= '0';
        passed_tests := passed_tests + check_and_report((branch_detect & '0'), "00", "Test 16 failed: CF was not reset after branch detect");

        -- Test completed
        -- Print the number of passed tests
        REPORT "Passed tests: " & INTEGER'image(passed_tests) & " out of 16" SEVERITY NOTE;

        -- Stop the simulation
        std.env.stop;
        WAIT;
    END PROCESS;

END Behavioral;
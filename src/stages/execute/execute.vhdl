LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Execute IS
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
END Execute;

ARCHITECTURE Behavioral OF Execute IS
    SIGNAL branch_signal                                    : STD_LOGIC;
    SIGNAL alu_input1, alu_input2, alu_result, final_result : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL out_port                                         : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL flags_CCR, flags_CCR_pre                         : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL flags_int_CCR, flags_int_CCR_pre                 : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL flags_alu, flags_CCR_reset, temp                 : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (OTHERS => '0');

BEGIN

    U1 : ENTITY work.ALUInputSelector(Behavioral)
        PORT MAP(
            forword_unit_sel => foward_unit_sel_1,
            ctrl_unit_sel    => alu_src1,
            result           => res_forward,
            write_back       => wb_forward,
            input1           => read_data2,
            input2           => read_data1,
            outp             => alu_input1
        );

    U2 : ENTITY work.ALUInputSelector(Behavioral)
        PORT MAP(
            forword_unit_sel => foward_unit_sel_2,
            ctrl_unit_sel    => alu_src2,
            result           => res_forward,
            write_back       => wb_forward,
            input1           => immediate,
            input2           => read_data2,
            outp             => alu_input2
        );

    alu_instance : ENTITY work.ALU(Behavioral)
        PORT MAP(
            a        => alu_input1,
            b        => alu_input2,
            op       => alu_op,
            flags_en => flags_en,
            cf_in    => flags_CCR_pre(2),
            nf_in    => flags_CCR_pre(1),
            zf_in    => flags_CCR_pre(0),
            result   => alu_result,
            cf       => flags_alu(2),
            nf       => flags_alu(1),
            zf       => flags_alu(0)
        );

    ccr_inst : ENTITY work.CCR(Behavioral)
        PORT MAP(
            clk         => clk,
            rst         => rst,
            flags_in    => flags_CCR,
            flags_reset => flags_CCR_reset,
            flags_out   => flags_CCR_pre
        );

    U3 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 3
        )
        PORT MAP(
            a   => flags_alu,
            b   => flags_int_CCR_pre,
            sel => rti,
            y   => flags_CCR
        );

    branch_detector_inst : ENTITY work.BranchDetector(Behavioral)
        PORT MAP(
            nf          => flags_alu(1),
            jn          => jn,
            cf          => flags_alu(2),
            jc          => jc,
            zf          => flags_alu(0),
            jz          => jz,
            branch_out  => branch_signal,
            flags_reset => flags_CCR_reset
        );

    int_ccr_inst : ENTITY work.CCR(Behavioral)
        PORT MAP(
            clk         => clk,
            rst         => rst,
            flags_in    => flags_int_CCR,
            flags_reset => "000",
            flags_out   => flags_int_CCR_pre
        );

    U4 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 3
        )
        PORT MAP(
            a   => flags_CCR_pre,
            b   => flags_int_CCR_pre,
            sel => int,
            y   => flags_int_CCR
        );

    U5 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => alu_result,
            b   => input_port,
            sel => input_port_enable,
            y   => final_result
        );

    U6 : ENTITY work.OutPort(Behavioral)
        PORT MAP(
            clk     => clk,
            rst     => rst,
            en      => output_port_enable,
            input1  => read_data1,
            output1 => out_port
        );

    alu_res       <= alu_result;
    output_port   <= out_port;
    branch_detect <= branch_signal;
    final_res     <= final_result;
END Behavioral;
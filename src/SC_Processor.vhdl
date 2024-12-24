LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

--------------------------------------------------------------------
ENTITY SC_Processor IS
    PORT (
        clk          : IN STD_LOGIC;
        rst          : IN STD_LOGIC;
        reset_signal : IN STD_LOGIC;
        wb_data      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY SC_Processor;

--------------------------------------------------------------------
ARCHITECTURE SC_Processor OF SC_Processor IS
    -- Fetch signals
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL in_data     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL current_pc  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc     : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Control Unit signals
    SIGNAL jz, jn, jc, jmp, call, ret, int, nop, rti, branch_predict    : STD_LOGIC                    := '0';
    SIGNAL alu_control                                                  : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL prev_op, out_en, in_en, mem_re, mem_we, mem_to_reg, reg_we   : STD_LOGIC                    := '0';
    SIGNAL alu_src1, alu_src2, index_out, stack_op, push, pop, flags_en : STD_LOGIC                    := '0';

    -- Decode signals
    SIGNAL read_data1          : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data2          : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL immediate           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL in_data_from_decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc_from_decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rdest_out           : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Execute signals
    SIGNAL ZF_CCR, CF_CCR, NF_CCR             : STD_LOGIC                     := '0';
    SIGNAL ZF_Pre_CCR, CF_Pre_CCR, NF_Pre_CCR : STD_LOGIC                     := '0';
    SIGNAL branch_detect                      : STD_LOGIC                     := '0';
    SIGNAL alu_res                            : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL execute_res                        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rsrc1_out_from_execute             : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rdst_out_from_execute              : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL next_pc_from_execute               : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Hazard detection signals
    SIGNAL hazard         : STD_LOGIC                     := '0';
    SIGNAL hazard_data_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Forwarding signals
    SIGNAL res_forward   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wb_forward    : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL forward_sel_1 : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL forward_sel_2 : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL write_reg     : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (OTHERS => '0');

    -- Memory signals
    SIGNAL mem_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- WriteBack signals
    SIGNAL write_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Exception signals
    SIGNAL epc       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL exception : STD_LOGIC;

BEGIN

    --------------------------------------------------------------------
    ------------------------ Fetch stage -------------------------------

    fetch_stage : ENTITY work.Fetch(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => 16
        )
        PORT MAP(
            clk             => clk,
            rst             => rst,
            hazard          => branch_detect,
            prev_op         => prev_op,
            jmp             => jmp,
            call            => call,
            branch_detector => branch_detect,
            reset_signal    => reset_signal,
            hazard_signal   => hazard,
            alu_data_out    => alu_res,
            read_data1      => read_data1,
            hazard_data_in  => hazard_data_in,
            instruction     => instruction,
            pc_out          => current_pc,
            next_pc         => next_pc
        );

    --------------------------------------------------------------------
    ------------------------ Decode stage ------------------------------

    decode_stage : ENTITY work.Decode(Behavioral)
        PORT MAP(
            clk         => clk,
            rst         => rst,
            we          => reg_we,
            instruction => instruction,
            in_data     => in_data,
            write_reg   => write_reg,
            write_data  => write_data,
            next_pc     => next_pc,
            read_data1  => read_data1,
            read_data2  => read_data2,
            immediate   => immediate,
            in_data_out => in_data_from_decode,
            next_pc_out => next_pc_from_decode,
            rdest_out   => rdest_out
        );

    --------------------------------------------------------------------
    ------------------------ Control Unit ------------------------------

    control_unit : ENTITY work.ControlUnit(Behavioral)
        PORT MAP(
            clk            => clk,
            rst            => rst,
            opcode         => instruction(15 DOWNTO 14),
            func_code      => instruction(13 DOWNTO 11),
            index_in       => instruction(7 DOWNTO 6),
            jz             => jz,
            jn             => jn,
            jc             => jc,
            jmp            => jmp,
            call           => call,
            ret            => ret,
            int            => int,
            nop            => nop,
            rti            => rti,
            branch_predict => branch_predict,
            alu_control    => alu_control,
            prev_op        => prev_op,
            out_en         => out_en,
            in_en          => in_en,
            mem_re         => mem_re,
            mem_we         => mem_we,
            mem_to_reg     => mem_to_reg,
            reg_we         => reg_we,
            alu_src1       => alu_src1,
            alu_src2       => alu_src2,
            index_out      => index_out,
            stack_op       => stack_op,
            push           => push,
            pop            => pop,
            flags_en       => flags_en
        );

    --------------------------------------------------------------------
    ------------------------ Execute stage -----------------------------

    execute_stage : ENTITY work.Execute(Behavioral)
        PORT MAP(
            clk                => clk,
            rst                => rst,
            read_data1         => read_data1,
            read_data2         => read_data2,
            rdst_in            => rdest_out,
            pc_in              => next_pc_from_decode,
            res_forward        => res_forward,
            wb_forward         => wb_forward,
            immediate          => immediate,
            input_port         => in_data_from_decode,
            alu_sel            => alu_control,
            RTI                => RTI,
            JZ                 => JZ,
            JN                 => JN,
            JC                 => JC,
            flags_en           => flags_en,
            control_unit_sel_1 => alu_src1,
            foward_unit_sel_1  => forward_sel_1,
            control_unit_sel_2 => alu_src2,
            foward_unit_sel_2  => forward_sel_2,
            input_port_enable  => in_en,
            output_port_enable => out_en,
            branch_detect      => branch_detect,
            final_res          => execute_res,
            rsrc1_out          => rsrc1_out_from_execute,
            rdst_out           => rdst_out_from_execute,
            pc_out             => next_pc_from_execute
        );

    --------------------------------------------------------------------
    ------------------------ Memory stage ------------------------------

    memory_stage : ENTITY work.MemoryStage(Behavioral)
        PORT MAP(
            clk        => clk,
            rst        => rst,
            push       => push,
            pop        => pop,
            int        => int,
            read_data1 => read_data1,
            result     => execute_res,
            pc         => current_pc,
            pc_plus1   => next_pc_from_decode,
            stack_op   => stack_op,
            we         => mem_we,
            re         => mem_re,
            epc        => epc,
            excep      => exception,
            data_out   => mem_data
        );

    --------------------------------------------------------------------
    ------------------------ WriteBack stage ---------------------------

    writeback_stage : ENTITY work.Writeback(Behavioral)
        PORT MAP(
            mem_to_reg => mem_to_reg,
            index      => index_out,
            int        => int,
            mem_data   => mem_data,
            in_data    => rsrc1_out_from_execute,
            wb_data    => write_data
        );
    
    wb_data <= write_data;
END SC_Processor;
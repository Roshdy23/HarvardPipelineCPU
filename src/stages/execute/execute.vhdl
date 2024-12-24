library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity execute is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        alu_op      : in  STD_LOGIC_VECTOR(3 downto 0);
        read_data1    : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data2    : in  STD_LOGIC_VECTOR(15 downto 0);
        rdst_in, pc_in        : in std_logic_vector(15 downto 0);
        res_forward           : in std_logic_vector(15 downto 0);
        wb_forward           : in std_logic_vector(15 downto 0);
        immediate   : in  STD_LOGIC_VECTOR(15 downto 0);
        input_port : in  STD_LOGIC_VECTOR(15 downto 0);
        alu_sel     : in  STD_LOGIC_VECTOR(2 downto 0);
        ZF_CCR, CF_CCR, NF_CCR  : in  STD_LOGIC;
        RTI :in std_logic;
        JZ, JN, JC : in std_logic;
        flags_enable : in std_logic;

        ZF_pre_CCR, CF_pre_CCR, NF_pre_CCR  : in  STD_LOGIC;
        control_unit_sel_1 : in  STD_LOGIC;
        foward_unit_sel_1 : in  STD_LOGIC_VECTOR(1 downto 0);
        control_unit_sel_2 : in  STD_LOGIC;
        foward_unit_sel_2 : in  STD_LOGIC_VECTOR(1 downto 0);
        input_port_enable : in std_logic;
        output_port_enable : in std_logic;
        branch_detect : out std_logic;
        final_res, rsrc1_out, rdst_out, pc_out :out std_logic_vector(15 downto 0)
    );
end execute;

architecture Behavioral of execute is

    component Special_Mux is
        Port (
            forword_unit_sel: in STD_LOGIC_VECTOR(0 to 1);
            ctrl_unit_sel : in STD_LOGIC;
            result : in STD_LOGIC_VECTOR(15 downto 0);
            write_back : in STD_LOGIC_VECTOR(15 downto 0);
            input1 : in STD_LOGIC_VECTOR(15 downto 0);
            input2 : in STD_LOGIC_VECTOR(15 downto 0);
            outp : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component ALU is
        Port (
            A                   : in  STD_LOGIC_VECTOR(15 downto 0);
            B                   : in  STD_LOGIC_VECTOR(15 downto 0);
            Sel                 : in  STD_LOGIC_VECTOR(2 downto 0);
            CF_in, NF_in, ZF_in : in  STD_LOGIC;
            Result              : out STD_LOGIC_VECTOR(15 downto 0);
            CF, NF, ZF          : out STD_LOGIC
        );
    end component;

    component MuxN is
        generic (
            W : INTEGER := 16
        );
        port (
            a   : in STD_LOGIC_VECTOR(W - 1 downto 0);
            b   : in STD_LOGIC_VECTOR(W - 1 downto 0);
            sel : in STD_LOGIC;
            y   : out STD_LOGIC_VECTOR(W - 1 downto 0)
        );
    end component;

    component CCR is
        port (
            rst, clk                  : in  std_logic;
            Cin, Nin, Zin             : in  std_logic;
            Reset_CF, Reset_ZF, Reset_NF : in  std_logic;
            Flags_out                 : out std_logic_vector(2 downto 0);
            Enable                    : in  std_logic
        );
    end component;

    component Preserved_CCR is
        port (
            rst          : in  std_logic;
            clk          : in  std_logic;
            Flags_in     : in  std_logic_vector(2 downto 0);
            Flags_Restor : out std_logic_vector(2 downto 0)
        );
    end component;

    component Branch_Detector is
        Port (
            NF: in std_logic;
            JN: in std_logic;
            CF: in std_logic;
            JC: in std_logic;
            ZF: in std_logic;
            JZ: in std_logic;
            branch_out: out std_logic 
        );
    end component;

    component outout_port is
        Port (
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            input1 : in  STD_LOGIC_vector (15 downto 0);
            output1 : out STD_LOGIC_vector (15 downto 0)
        );
    end component;

    signal branch_signal : std_logic;

    signal mux_out1, mux_out2, ALU_res, temp_final_res, output_port1 : STD_LOGIC_VECTOR(15 downto 0);
    signal CF_ALU, ZF_ALU, NF_ALU : STD_LOGIC;
    signal flags_CCR, flags_CCR_out, flags_pre_ccr_in, flags_pre_ccr_out, temp_flags_comb1, temp_flags_comb2 : std_logic_vector ( 2 downto 0);
    
    begin

        U1: Special_Mux
            Port map (
                forword_unit_sel => foward_unit_sel_1,
                ctrl_unit_sel => control_unit_sel_1,
                result => res_forward,
                write_back => wb_forward,
                input1 => read_data1 ,
                input2 => read_data2,
                outp => mux_out1
            );

        U2: Special_Mux
            Port map (
                forword_unit_sel => foward_unit_sel_2,
                ctrl_unit_sel => control_unit_sel_2,
                result => res_forward,
                write_back => wb_forward,
                input1 => read_data2,
                input2 => immediate,
                outp => mux_out2
            );

        U3: ALU
            Port map (
                A => mux_out1,
                B => mux_out2,
                Sel => ALU_sel,
                CF_in =>  CF_CCR,
                NF_in => NF_CCR,
                ZF_in =>  ZF_CCR,
                Result => ALU_res,
                CF => CF_ALU,
                NF => NF_ALU,
                ZF => ZF_ALU
            );


        temp_flags_comb1 <= ZF_ALU & CF_ALU & NF_ALU;
        temp_flags_comb2 <= ZF_pre_CCR & CF_pre_CCR & NF_pre_CCR;

        U4: MuxN
            generic map (
                W => 3
            )
            port map (
                a => temp_flags_comb1,
                b => temp_flags_comb2,
                sel => RTI,
                y => flags_CCR
            );
        
        U5: CCR
            port map (
            rst => reset,
            clk => clk,
            Cin => flags_CCR(1),
            Nin => flags_CCR(0),
            Zin => flags_CCR(2),
            Reset_CF => JC,
            Reset_ZF => JZ,
            Reset_NF => JN,
            Flags_out => flags_CCR_out,
            Enable => flags_enable
            );

        U6: MuxN
            generic map (
                W => 3
            )
            port map (
                a => flags_CCR_out,
                b => temp_flags_comb2,
                sel => RTI,
                y => flags_pre_ccr_in
            );

        U7: Preserved_CCR
            port map (
            rst => reset,
            clk => clk,
            Flags_in => flags_pre_ccr_in,
            Flags_Restor => flags_pre_ccr_out
            );

        
        U8: Branch_Detector
        Port map (
            NF => NF_ALU,
            JN => JN,
            CF => CF_ALU,
            JC => JC,
            ZF => ZF_ALU,
            JZ => JZ,
            branch_out => branch_signal
        );

       

        U10:   MuxN
            generic map (
                W => 16
            )
            port map (
                a => ALU_res,
                b => input_port,
                sel => input_port_enable,
                y => temp_final_res
            );

        U11:   outout_port 
            Port map (
                clk => clk,
                rst => reset,
                input1 => temp_final_res,
                output1 => output_port1
            );


        branch_detect <= branch_signal;
        final_res <= temp_final_res;
        rsrc1_out <= read_data1;
        rdst_out <= rdst_in;
        pc_out <= pc_in;

        

        


    end Behavioral;

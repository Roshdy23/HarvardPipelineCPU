library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity execute is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        read_data1    : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data2    : in  STD_LOGIC_VECTOR(15 downto 0);
        rdst_in        : in std_logic_vector(2 downto 0);
        pc_in        : in std_logic_vector(15 downto 0);
        res_forward           : in std_logic_vector(15 downto 0);
        wb_forward           : in std_logic_vector(15 downto 0);
        immediate   : in  STD_LOGIC_VECTOR(15 downto 0);
        input_port : in  STD_LOGIC_VECTOR(15 downto 0);
        alu_sel     : in  STD_LOGIC_VECTOR(2 downto 0);
        JN, JZ, JC : in std_logic;
      
        RTI :in std_logic;
        flags_enable : in std_logic;

        control_unit_sel_1 : in  STD_LOGIC;
        foward_unit_sel_1 : in  STD_LOGIC_VECTOR(1 downto 0);
        control_unit_sel_2 : in  STD_LOGIC;
        foward_unit_sel_2 : in  STD_LOGIC_VECTOR(1 downto 0);
        input_port_enable : in std_logic;
        output_port_enable : in std_logic;
        branch_detect : out std_logic;
        rdst_out : out std_logic_vector(2 downto 0);
        final_res, rsrc1_out, pc_out :out std_logic_vector(15 downto 0)
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

    -- 0 -> z , 1 -> N, 2 -> C

    signal flags_CCR, flags_CCR_pre, temp_flags_comb1, temp_flags_comb2 : std_logic_vector ( 2 downto 0);
    
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
                CF_in =>  flags_CCR(2),
                NF_in => flags_CCR(1),
                ZF_in =>  flags_CCR(0),
                Result => ALU_res,
                CF => flags_CCR(2),
                NF => flags_CCR(1),
                ZF => flags_CCR(0)
            );


        U4: MuxN
            generic map (
                W => 3
            )
            port map (
                a => flags_CCR,
                b => flags_CCR_pre,
                sel => RTI,
                y => flags_CCR
                );

       
                U8: Branch_Detector
                Port map (
                    NF => flags_CCR(1),
                    JN => JN,
                    CF => flags_CCR(2),
                    JC => JC,
                    ZF => flags_CCR(0),
                    JZ => JZ,
                    branch_out => branch_signal
                );


                flags_CCR(2) <= '0' when JC = '1' else flags_CCR(2);
                flags_CCR(1) <= '0' when JN = '1' else flags_CCR(1);
                flags_CCR(0) <= '0' when JZ = '1' else flags_CCR(0);

             

        U6: MuxN
            generic map (
                W => 3
            )
            port map (
                a => flags_CCR,
                b => flags_CCR_pre,
                sel => RTI,
                y => flags_CCR_pre
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

            flags_CCR <= (others => '0') when reset = '1' else flags_CCR;
            flags_CCR_pre <= (others => '0') when reset = '1' else flags_CCR_pre;


        branch_detect <= branch_signal;
        final_res <= temp_final_res;
        rsrc1_out <= read_data1;
        rdst_out <= rdst_in;
        pc_out <= pc_in;

        

        


    end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControlUnit is
    Port (
        rst             : in  std_logic;                        -- Reset
        opcode          : in  std_logic_vector(1 downto 0);     -- Opcode
        func_code       : in  std_logic_vector(2 downto 0);     -- Function
        index_in        : in  std_logic_vector(2 downto 0);     -- Index
        jz              : out std_logic;
        jn              : out std_logic;
        jc              : out std_logic;
        jmp             : out std_logic;
        call            : out std_logic;
        ret             : out std_logic;
        int             : out std_logic;
        nop             : out std_logic;
        branch_predict  : out std_logic;
        alu_control     : out std_logic_vector(2 downto 0);
        prev_op         : out std_logic;
        out_en          : out std_logic;
        in_en           : out std_logic;
        mem_read        : out std_logic;
        mem_write       : out std_logic;
        mem_to_reg      : out std_logic;
        write_en        : out std_logic;
        rti             : out std_logic;
        alu_src1        : out std_logic;
        alu_src2        : out std_logic;
        ie_mem_wb       : out std_logic;
        mem_wb_wb       : out std_logic;
        index_out       : out std_logic;
        stack_op        : out std_logic;
        push            : out std_logic;
        pop             : out std_logic;
        keep_flags      : out std_logic
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    constant ALU_AND : std_logic_vector(2 downto 0) := "000";
    constant ALU_NOT : std_logic_vector(2 downto 0) := "001";
    constant ALU_ADD : std_logic_vector(2 downto 0) := "010";
    constant ALU_INC : std_logic_vector(2 downto 0) := "011";
    constant ALU_SUB : std_logic_vector(2 downto 0) := "100";
    constant ALU_NOP : std_logic_vector(2 downto 0) := "101";
    constant READ_DATA_1 : std_logic := '1';
    constant READ_DATA_2 : std_logic := '0';
    constant READ_IMMEDIATE : std_logic := '1';
begin
    process(rst)
    begin
        if rst = '0' then
            jz              <= '0';
            jn              <= '0';
            jc              <= '0';
            jmp             <= '0';
            call            <= '0';
            ret             <= '0';
            int             <= '0';
            nop             <= '0';
            branch_predict  <= '0';
            alu_control     <= ALU_NOP;
            prev_op         <= '0';
            out_en          <= '0';
            in_en           <= '0';
            mem_read        <= '0';
            mem_write       <= '0';
            mem_to_reg      <= '0';
            write_en        <= '0';
            rti             <= '0';
            alu_src1        <= '0';
            alu_src2        <= '0';
            ie_mem_wb       <= '0';
            mem_wb_wb       <= '0';
            index_out       <= '0';
            stack_op        <= '0';
            push            <= '0';
            pop             <= '0';
            keep_flags      <= '0';
        end if;
    end process;
    begin

    process(opcode, func_code, index_in)
    begin
        if rst = '0' then return; end if;
        -- Default values
        jz              <= '0';
        jn              <= '0';
        jc              <= '0';
        jmp             <= '0';
        call            <= '0';
        ret             <= '0';
        int             <= '0';
        nop             <= '0';
        branch_predict  <= '0';
        alu_control     <= ALU_NOP;
        prev_op         <= '0';
        out_en          <= '0';
        in_en           <= '0';
        mem_read        <= '0';
        mem_write       <= '0';
        mem_to_reg      <= '0';
        write_en        <= '0';
        rti             <= '0';
        alu_src1        <= '0';
        alu_src2        <= '0';
        ie_mem_wb       <= '0';
        mem_wb_wb       <= '0';
        index_out       <= '0';
        stack_op        <= '0';
        keep_flags      <= '0';

        -- Previous Op Code  indicates that the current instruction is a 16-bit Immediate
        if prev_op = '1' then
            prev_op <= '0';
            nop <= '0';
        else
            -- Control signals
            case opcode is
                -- R-Type Instructions
                when "00" =>
                    case func_code is
                        when "000" =>                 -- NOT Rdst, Rsrc1
                            alu_control <= ALU_NOT;
                        when "001" =>                 -- INC Rdst, Rsrc1
                            alu_control <= ALU_INC;
                        when "010" =>                 -- Mov Rdst, Rsrc1
                            alu_control <= ALU_NOP;
                        when "011" =>                 -- ADD Rdst, Rsrc1, Rsrc2
                            alu_control <= ALU_ADD;
                            alu_src2    <= READ_DATA_2;       -- Read Data 2
                        when "100" =>                 -- SUB Rdst, Rsrc1, Rsrc2
                            alu_control <= ALU_SUB;
                            alu_src2    <= READ_DATA_2;       -- Read Data 2
                        when "101" =>                 -- AND Rdst, Rsrc1, Rsrc2
                            alu_control <= ALU_AND;
                            alu_src2    <= READ_DATA_2;       -- Read Data 2
                        when others =>
                            nop <= '1';
                    end case;
                    alu_src1 <= READ_DATA_1;
                    write_en <= '1';

                -- I-Type Instructions
                when "01" =>
                    case func_code is
                        when "000" =>                 -- IADD Rdst, Rsrc1, Imm
                            alu_control <= ALU_ADD;
                            alu_src1    <= READ_DATA_1;       -- Read Data 1
                            alu_src2    <= READ_IMMEDIATE;    -- Read Data 2
                            write_en    <= '1';
                        when "001" =>                 -- LDM Rdst, Imm
                            alu_control <= ALU_NOP;
                            alu_src2    <= READ_IMMEDIATE;    -- Read Data 2
                            mem_read    <= '1';
                            mem_to_reg  <= '1';
                            write_en    <= '1';
                        when "010" =>                 -- LDD Rdst, offset(Rsrc1)
                            alu_control <= ALU_ADD;
                            alu_src1    <= READ_DATA_1;       -- Read Data 1
                            alu_src2    <= READ_IMMEDIATE;    -- Read Data 2
                            mem_read    <= '1';
                            mem_to_reg  <= '1';
                            write_en    <= '1';
                            keep_flags  <= '1';
                        when "011" =>                 -- STD Rsrc1, offset(Rsrc2)
                            alu_control <= ALU_ADD;
                            alu_src1    <= READ_DATA_2;       -- Read Data 1
                            alu_src2    <= READ_IMMEDIATE;    -- Read Data 2
                            mem_write   <= '1';
                            keep_flags  <= '1';
                        when others =>
                            nop <= '1';
                    end case;
                    prev_op <= '1';
                    nop <= '1';                       -- Stall in the ID stage
                
                -- J-Type Instructions
                when "10" =>
                    case func_code is
                        when "000" =>                 -- JZ Rsrc1
                            alu_src1 <= READ_DATA_1;
                            jz <= '1';
                        when "001" =>                 -- JN Rsrc1
                            alu_src1 <= READ_DATA_1;
                            jn <= '1';
                        when "010" =>                 -- JC Rsrc1
                            alu_src1 <= READ_DATA_1;
                            jc <= '1';
                        when "011" =>                 -- JMP Rsrc1
                            alu_src1 <= READ_DATA_1;
                            jmp <= '1';
                        when "100" =>                 -- CALL Rsrc1
                            alu_src1 <= READ_DATA_1;
                            call <= '1';
                            stack_op <= '1';
                            push <= '1';
                        when "101" =>                 -- RET
                            ret <= '1';
                            stack_op <= '1';
                            pop <= '1';
                        when "110" =>                 -- RTI
                            rti <= '1';
                            stack_op <= '1';
                            pop <= '1';
                        when "111" =>                 -- INT index
                            index_out <= index_in(1);
                            int <= '1';
                            stack_op <= '1';
                            push <= '1';
                        when others =>
                            nop <= '1';
                    end case;
                    branch_predict <= '0';            -- Predict not taken
                
                -- Other Instructions
                when "11" =>
                    case func_code is
                        when "000" =>                 -- NOP
                            nop <= '1';
                        when "001" =>                 -- HTL
                            -- No need to do anything [Handled in the IF stage]
                        when "010" =>                 -- SETC
                            jc <= '1';
                        when "010" =>                 -- OUT Rsrc1
                            out_en <= '1';
                        when "011" =>                 -- IN Rdst
                            in_en <= '1';
                        when "100" =>                 -- PUSH Rsrc1
                            alu_src1 <= READ_DATA_1;
                            push <= '1';
                            mem_write <= '1';
                            stack_op <= '1';
                        when "101" =>                 -- POP Rdst
                            pop <= '1';
                            mem_read <= '1';
                            mem_to_reg <= '1';
                            stack_op <= '1';
                        when others =>
                            nop <= '1';
                    end case;
            end case;
        end if;
    end process;
end Behavioral;

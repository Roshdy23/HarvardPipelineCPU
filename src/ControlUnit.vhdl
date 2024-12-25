LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ControlUnit IS
    PORT (
        clk            : IN STD_LOGIC;                    -- Clock
        rst            : IN STD_LOGIC;                    -- Reset
        opcode         : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Opcode
        func_code      : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Function
        index_in       : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Index
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
        prev_op        : BUFFER STD_LOGIC;
        out_en         : OUT STD_LOGIC;
        in_en          : OUT STD_LOGIC;
        mem_re         : OUT STD_LOGIC;
        mem_we         : OUT STD_LOGIC;
        mem_to_reg     : OUT STD_LOGIC;
        reg_we         : OUT STD_LOGIC;
        rti            : OUT STD_LOGIC;
        alu_src1       : OUT STD_LOGIC;
        alu_src2       : OUT STD_LOGIC;
        index_out      : OUT STD_LOGIC;
        stack_op       : OUT STD_LOGIC;
        push           : OUT STD_LOGIC;
        pop            : OUT STD_LOGIC;
        flags_en       : OUT STD_LOGIC
    );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS
    CONSTANT ALU_AND          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT ALU_NOT          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT ALU_ADD          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT ALU_INC          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ALU_SUB          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT ALU_NOP          : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
    CONSTANT READ_DATA_1      : STD_LOGIC                    := '1';
    CONSTANT READ_DATA_2_SRC1 : STD_LOGIC                    := '0';
    CONSTANT READ_DATA_2_SRC2 : STD_LOGIC                    := '1';
    CONSTANT READ_IMMEDIATE   : STD_LOGIC                    := '0';
BEGIN
    PROCESS (rst, clk, opcode, func_code, index_in)
    BEGIN
        IF rst = '0' THEN
            jz             <= '0';
            jn             <= '0';
            jc             <= '0';
            jmp            <= '0';
            call           <= '0';
            ret            <= '0';
            int            <= '0';
            nop            <= '0';
            branch_predict <= '0';
            alu_control    <= ALU_NOP;
            prev_op        <= '0';
            out_en         <= '0';
            in_en          <= '0';
            mem_re         <= '0';
            mem_we         <= '0';
            mem_to_reg     <= '0';
            reg_we         <= '0';
            rti            <= '0';
            alu_src1       <= '0';
            alu_src2       <= '0';
            index_out      <= '0';
            stack_op       <= '0';
            push           <= '0';
            pop            <= '0';
            flags_en       <= '1';
        ELSIF rising_edge(clk) THEN
            -- Previous Op Code  indicates that the current instruction is a 16-bit Immediate
            IF prev_op = '1' THEN
                prev_op <= '0';
                nop     <= '0';
            ELSE
                -- Default values
                jz             <= '0';
                jn             <= '0';
                jc             <= '0';
                jmp            <= '0';
                call           <= '0';
                ret            <= '0';
                int            <= '0';
                nop            <= '0';
                branch_predict <= '0';
                alu_control    <= ALU_NOP;
                prev_op        <= '0';
                out_en         <= '0';
                in_en          <= '0';
                mem_re         <= '0';
                mem_we         <= '0';
                mem_to_reg     <= '0';
                reg_we         <= '0';
                rti            <= '0';
                alu_src1       <= '0';
                alu_src2       <= '0';
                index_out      <= '0';
                stack_op       <= '0';
                push           <= '0';
                pop            <= '0';
                flags_en       <= '1';

                -- Control signals
                CASE opcode IS
                        -- R-Type Instructions
                    WHEN "00" =>
                        CASE func_code IS
                            WHEN "000" => -- NOT Rdst, Rsrc1
                                alu_control <= ALU_NOT;
                            WHEN "001" => -- INC Rdst, Rsrc1
                                alu_control <= ALU_INC;
                            WHEN "010" => -- Mov Rdst, Rsrc1
                                alu_control <= ALU_NOP;
                            WHEN "011" => -- ADD Rdst, Rsrc1, Rsrc2
                                alu_control <= ALU_ADD;
                                alu_src2    <= READ_DATA_2_SRC2; -- Read Data 2
                            WHEN "100" =>                    -- SUB Rdst, Rsrc1, Rsrc2
                                alu_control <= ALU_SUB;
                                alu_src2    <= READ_DATA_2_SRC2; -- Read Data 2
                            WHEN "101" =>                    -- AND Rdst, Rsrc1, Rsrc2
                                alu_control <= ALU_AND;
                                alu_src2    <= READ_DATA_2_SRC2; -- Read Data 2
                            WHEN OTHERS =>
                                nop <= '1';
                        END CASE;
                        alu_src1 <= READ_DATA_1;
                        reg_we   <= '1';

                        -- I-Type Instructions
                    WHEN "01" =>
                        CASE func_code IS
                            WHEN "000" => -- IADD Rdst, Rsrc1, Imm
                                alu_control <= ALU_ADD;
                                alu_src1    <= READ_DATA_1;    -- Read Data 1
                                alu_src2    <= READ_IMMEDIATE; -- Read Data 2
                                reg_we      <= '1';
                            WHEN "001" => -- LDM Rdst, Imm
                                alu_control <= ALU_NOP;
                                alu_src2    <= READ_IMMEDIATE; -- Read Data 2
                                mem_re      <= '1';
                                mem_to_reg  <= '1';
                                reg_we      <= '1';
                            WHEN "010" => -- LDD Rdst, offset(Rsrc1)
                                alu_control <= ALU_ADD;
                                alu_src1    <= READ_DATA_1;    -- Read Data 1
                                alu_src2    <= READ_IMMEDIATE; -- Read Data 2
                                mem_re      <= '1';
                                mem_to_reg  <= '1';
                                reg_we      <= '1';
                                flags_en    <= '0';
                            WHEN "011" => -- STD Rsrc1, offset(Rsrc2)
                                alu_control <= ALU_ADD;
                                alu_src1    <= READ_DATA_2_SRC1; -- Read Data 1
                                alu_src2    <= READ_IMMEDIATE;   -- Read Data 2
                                mem_we      <= '1';
                                flags_en    <= '0';
                            WHEN OTHERS =>
                                nop <= '1';
                        END CASE;
                        prev_op <= '1';
                        nop     <= '1'; -- Stall in the ID stage

                        -- J-Type Instructions
                    WHEN "10" =>
                        CASE func_code IS
                            WHEN "000" => -- JZ Rsrc1
                                alu_src1 <= READ_DATA_1;
                                jz       <= '1';
                            WHEN "001" => -- JN Rsrc1
                                alu_src1 <= READ_DATA_1;
                                jn       <= '1';
                            WHEN "010" => -- JC Rsrc1
                                alu_src1 <= READ_DATA_1;
                                jc       <= '1';
                            WHEN "011" => -- JMP Rsrc1
                                alu_src1 <= READ_DATA_1;
                                jmp      <= '1';
                            WHEN "100" => -- CALL Rsrc1
                                alu_src1 <= READ_DATA_1;
                                call     <= '1';
                                stack_op <= '1';
                                push     <= '1';
                            WHEN "101" => -- RET
                                ret      <= '1';
                                stack_op <= '1';
                                pop      <= '1';
                            WHEN "110" => -- RTI
                                rti      <= '1';
                                stack_op <= '1';
                                pop      <= '1';
                            WHEN "111" => -- INT index
                                index_out <= index_in(1);
                                int       <= '1';
                                stack_op  <= '1';
                                push      <= '1';
                            WHEN OTHERS =>
                                nop <= '1';
                        END CASE;
                        branch_predict <= '0'; -- Predict not taken

                        -- Other Instructions
                    WHEN "11" =>
                        CASE func_code IS
                            WHEN "000" => -- NOP
                                nop <= '1';
                            WHEN "001" => -- HTL
                                -- No need to do anything [Handled in the IF stage]
                            WHEN "010" => -- SETC
                                -- TODO: Set the carry flag
                            WHEN "011" => -- OUT Rsrc1
                                out_en <= '1';
                            WHEN "100" => -- IN Rdst
                                in_en <= '1';
                            WHEN "101" => -- PUSH Rsrc1
                                alu_src1 <= READ_DATA_1;
                                push     <= '1';
                                mem_we   <= '1';
                                stack_op <= '1';
                            WHEN "110" => -- POP Rdst
                                pop        <= '1';
                                mem_re     <= '1';
                                mem_to_reg <= '1';
                                stack_op   <= '1';
                            WHEN OTHERS =>
                                nop <= '1';
                        END CASE;
                    WHEN OTHERS =>
                        nop <= '1';
                END CASE;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
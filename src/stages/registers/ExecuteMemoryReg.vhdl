LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExecuteMemoryReg IS
    PORT (
        clk   : IN STD_LOGIC;
        rst   : IN STD_LOGIC;
        flush : IN STD_LOGIC;
        NOP   : IN STD_LOGIC;
        -----------------------others--------------------
        in_data_index       : IN STD_LOGIC;
        out_data_index      : OUT STD_LOGIC;
        in_data_nop         : IN STD_LOGIC;
        out_data_nop        : OUT STD_LOGIC;
        in_data_alu_op      : IN STD_LOGIC;
        out_data_alu_op     : OUT STD_LOGIC;
        in_data_mem_write   : IN STD_LOGIC;
        out_data_mem_write  : OUT STD_LOGIC;
        in_data_mem_read    : IN STD_LOGIC;
        out_data_mem_read   : OUT STD_LOGIC;
        in_data_mem_to_reg  : IN STD_LOGIC;
        out_data_mem_to_reg : OUT STD_LOGIC;
        --------------------- Stack ---------------------   
        in_data_push  : IN STD_LOGIC;
        out_data_push : OUT STD_LOGIC;
        in_data_pop   : IN STD_LOGIC;
        out_data_pop  : OUT STD_LOGIC;
        --------------------- Flags ---------------------
        in_data_jmp   : IN STD_LOGIC;
        out_data_jmp  : OUT STD_LOGIC;
        in_data_jn    : IN STD_LOGIC;
        out_data_jn   : OUT STD_LOGIC;
        in_data_jz    : IN STD_LOGIC;
        out_data_jz   : OUT STD_LOGIC;
        in_data_jc    : IN STD_LOGIC;
        out_data_jc   : OUT STD_LOGIC;
        in_data_call  : IN STD_LOGIC;
        out_data_call : OUT STD_LOGIC;
        in_data_ret   : IN STD_LOGIC;
        out_data_ret  : OUT STD_LOGIC;
        in_data_int   : IN STD_LOGIC;
        out_data_int  : OUT STD_LOGIC;
        in_data_rti   : IN STD_LOGIC;
        out_data_rti  : OUT STD_LOGIC;
        -------------------- read data 1 -----------------
        in_data_read_data1  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -------------------- id/ie Rdst -----------------
        in_data_id_ie_rdst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_id_ie_rdst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -------------------- execute output -----------------
        in_data_execute_final_res  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_execute_final_res : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -------------------- next pc -----------------
        in_data_next_pc  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_next_pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ExecuteMemoryReg;

ARCHITECTURE Behavioral OF ExecuteMemoryReg IS
    -- REGISTER --
    SIGNAL read_data1        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL id_ie_rdst        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL execute_final_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL next_pc           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL index             : STD_LOGIC;
    SIGNAL nop_sig               : STD_LOGIC;
    SIGNAL alu_op            : STD_LOGIC;
    SIGNAL mem_write         : STD_LOGIC;
    SIGNAL mem_read          : STD_LOGIC;
    SIGNAL mem_to_reg        : STD_LOGIC;
    SIGNAL push              : STD_LOGIC;
    SIGNAL pop               : STD_LOGIC;
    SIGNAL jmp               : STD_LOGIC;
    SIGNAL jn                : STD_LOGIC;
    SIGNAL jz                : STD_LOGIC;
    SIGNAL jc                : STD_LOGIC;
    SIGNAL call              : STD_LOGIC;
    SIGNAL ret               : STD_LOGIC;
    SIGNAL int               : STD_LOGIC;
    SIGNAL rti               : STD_LOGIC;

BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            read_data1        <= (OTHERS => '0');
            id_ie_rdst        <= (OTHERS => '0');
            execute_final_res <= (OTHERS => '0');
            next_pc           <= (OTHERS => '0');
            index             <= '0';
            nop_sig               <= '0';
            alu_op            <= '0';
            mem_write         <= '0';
            mem_read          <= '0';
            mem_to_reg        <= '0';
            push              <= '0';
            pop               <= '0';
            jmp               <= '0';
            jn                <= '0';
            jz                <= '0';
            jc                <= '0';
            call              <= '0';
            ret               <= '0';
            int               <= '0';
            rti               <= '0';
        ELSIF rising_edge(clk) THEN
            IF (flush = '1') THEN
                read_data1        <= (OTHERS => '0');
                id_ie_rdst        <= (OTHERS => '0');
                execute_final_res <= (OTHERS => '0');
                next_pc           <= (OTHERS => '0');
                index             <= '0';
                nop_sig               <= '0';
                alu_op            <= '0';
                mem_write         <= '0';
                mem_read          <= '0';
                mem_to_reg        <= '0';
                push              <= '0';
                pop               <= '0';
                jmp               <= '0';
                jn                <= '0';
                jz                <= '0';
                jc                <= '0';
                call              <= '0';
                ret               <= '0';
                int               <= '0';
                rti               <= '0';
            ELSIF (NOP = '0') THEN
                read_data1        <= in_data_read_data1;
                id_ie_rdst        <= in_data_id_ie_rdst;
                execute_final_res <= in_data_execute_final_res;
                next_pc           <= in_data_next_pc;
                index             <= in_data_index;
                nop_sig               <= in_data_nop;
                alu_op            <= in_data_alu_op;
                mem_write         <= in_data_mem_write;
                mem_read          <= in_data_mem_read;
                mem_to_reg        <= in_data_mem_to_reg;
                push              <= in_data_push;
                pop               <= in_data_pop;
                jmp               <= in_data_jmp;
                jn                <= in_data_jn;
                jz                <= in_data_jz;
                jc                <= in_data_jc;
                call              <= in_data_call;
                ret               <= in_data_ret;
                int               <= in_data_int;
                rti               <= in_data_rti;
            END IF;
        END IF;
    END PROCESS;

    out_data_read_data1        <= read_data1;
    out_data_id_ie_rdst        <= id_ie_rdst;
    out_data_execute_final_res <= execute_final_res;
    out_data_next_pc           <= next_pc;
    out_data_index             <= index;
    out_data_nop               <= nop_sig;
    out_data_alu_op            <= alu_op;
    out_data_mem_write         <= mem_write;
    out_data_mem_read          <= mem_read;
    out_data_mem_to_reg        <= mem_to_reg;
    out_data_push              <= push;
    out_data_pop               <= pop;
    out_data_jmp               <= jmp;
    out_data_jn                <= jn;
    out_data_jz                <= jz;
    out_data_jc                <= jc;
    out_data_call              <= call;
    out_data_ret               <= ret;
    out_data_int               <= int;
    out_data_rti               <= rti;
END Behavioral;
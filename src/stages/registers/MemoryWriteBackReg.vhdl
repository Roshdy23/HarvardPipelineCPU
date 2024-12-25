LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MemoryWriteBackReg IS
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
        -------------------- id/ie Rdst -----------------
        in_data_ie_mem_rdst  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_ie_mem_rdst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -------------------- execute output -----------------
        in_data_ie_mem_execute_final_res  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_ie_mem_execute_final_res : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -------------------- memory read  -----------------
        in_data_memory_read  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data_memory_read : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END MemoryWriteBackReg;

ARCHITECTURE Behavioral OF MemoryWriteBackReg IS
    -- REGISTER SIGNALS --
    SIGNAL reg_data_index                    : STD_LOGIC;
    SIGNAL reg_data_nop                      : STD_LOGIC;
    SIGNAL reg_data_alu_op                   : STD_LOGIC;
    SIGNAL reg_data_mem_write                : STD_LOGIC;
    SIGNAL reg_data_mem_read                 : STD_LOGIC;
    SIGNAL reg_data_mem_to_reg               : STD_LOGIC;
    SIGNAL reg_data_push                     : STD_LOGIC;
    SIGNAL reg_data_pop                      : STD_LOGIC;
    SIGNAL reg_data_jmp                      : STD_LOGIC;
    SIGNAL reg_data_jn                       : STD_LOGIC;
    SIGNAL reg_data_jz                       : STD_LOGIC;
    SIGNAL reg_data_jc                       : STD_LOGIC;
    SIGNAL reg_data_call                     : STD_LOGIC;
    SIGNAL reg_data_ret                      : STD_LOGIC;
    SIGNAL reg_data_int                      : STD_LOGIC;
    SIGNAL reg_data_rti                      : STD_LOGIC;
    SIGNAL reg_data_ie_mem_rdst              : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL reg_data_ie_mem_execute_final_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL reg_data_memory_read              : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            reg_data_index                    <= '0';
            reg_data_nop                      <= '0';
            reg_data_alu_op                   <= '0';
            reg_data_mem_write                <= '0';
            reg_data_mem_read                 <= '0';
            reg_data_mem_to_reg               <= '0';
            reg_data_push                     <= '0';
            reg_data_pop                      <= '0';
            reg_data_jmp                      <= '0';
            reg_data_jn                       <= '0';
            reg_data_jz                       <= '0';
            reg_data_jc                       <= '0';
            reg_data_call                     <= '0';
            reg_data_ret                      <= '0';
            reg_data_int                      <= '0';
            reg_data_rti                      <= '0';
            reg_data_ie_mem_rdst              <= (OTHERS => '0');
            reg_data_ie_mem_execute_final_res <= (OTHERS => '0');
            reg_data_memory_read              <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF (flush = '1') THEN
                reg_data_index                    <= '0';
                reg_data_nop                      <= '0';
                reg_data_alu_op                   <= '0';
                reg_data_mem_write                <= '0';
                reg_data_mem_read                 <= '0';
                reg_data_mem_to_reg               <= '0';
                reg_data_push                     <= '0';
                reg_data_pop                      <= '0';
                reg_data_jmp                      <= '0';
                reg_data_jn                       <= '0';
                reg_data_jz                       <= '0';
                reg_data_jc                       <= '0';
                reg_data_call                     <= '0';
                reg_data_ret                      <= '0';
                reg_data_int                      <= '0';
                reg_data_rti                      <= '0';
                reg_data_ie_mem_rdst              <= (OTHERS => '0');
                reg_data_ie_mem_execute_final_res <= (OTHERS => '0');
                reg_data_memory_read              <= (OTHERS => '0');
            ELSIF (NOP = '0') THEN
                reg_data_index                    <= in_data_index;
                reg_data_nop                      <= in_data_nop;
                reg_data_alu_op                   <= in_data_alu_op;
                reg_data_mem_write                <= in_data_mem_write;
                reg_data_mem_read                 <= in_data_mem_read;
                reg_data_mem_to_reg               <= in_data_mem_to_reg;
                reg_data_push                     <= in_data_push;
                reg_data_pop                      <= in_data_pop;
                reg_data_jmp                      <= in_data_jmp;
                reg_data_jn                       <= in_data_jn;
                reg_data_jz                       <= in_data_jz;
                reg_data_jc                       <= in_data_jc;
                reg_data_call                     <= in_data_call;
                reg_data_ret                      <= in_data_ret;
                reg_data_int                      <= in_data_int;
                reg_data_rti                      <= in_data_rti;
                reg_data_ie_mem_rdst              <= in_data_ie_mem_rdst;
                reg_data_ie_mem_execute_final_res <= in_data_ie_mem_execute_final_res;
                reg_data_memory_read              <= in_data_memory_read;
            END IF;
        END IF;
    END PROCESS;

    out_data_index                    <= reg_data_index;
    out_data_nop                      <= reg_data_nop;
    out_data_alu_op                   <= reg_data_alu_op;
    out_data_mem_write                <= reg_data_mem_write;
    out_data_mem_read                 <= reg_data_mem_read;
    out_data_mem_to_reg               <= reg_data_mem_to_reg;
    out_data_push                     <= reg_data_push;
    out_data_pop                      <= reg_data_pop;
    out_data_jmp                      <= reg_data_jmp;
    out_data_jn                       <= reg_data_jn;
    out_data_jz                       <= reg_data_jz;
    out_data_jc                       <= reg_data_jc;
    out_data_call                     <= reg_data_call;
    out_data_ret                      <= reg_data_ret;
    out_data_int                      <= reg_data_int;
    out_data_rti                      <= reg_data_rti;
    out_data_ie_mem_rdst              <= reg_data_ie_mem_rdst;
    out_data_ie_mem_execute_final_res <= reg_data_ie_mem_execute_final_res;
    out_data_memory_read              <= reg_data_memory_read;

END Behavioral;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_ExecuteMemoryReg IS
END tb_ExecuteMemoryReg;

ARCHITECTURE behavior OF tb_ExecuteMemoryReg IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ExecuteMemoryReg
        PORT (
            clk                        : IN STD_LOGIC;
            rst                        : IN STD_LOGIC;
            flush                      : IN STD_LOGIC;
            NOP                        : IN STD_LOGIC;
            in_data_index              : IN STD_LOGIC;
            out_data_index             : OUT STD_LOGIC;
            in_data_nop                : IN STD_LOGIC;
            out_data_nop               : OUT STD_LOGIC;
            in_data_alu_op             : IN STD_LOGIC;
            out_data_alu_op            : OUT STD_LOGIC;
            in_data_mem_write          : IN STD_LOGIC;
            out_data_mem_write         : OUT STD_LOGIC;
            in_data_mem_read           : IN STD_LOGIC;
            out_data_mem_read          : OUT STD_LOGIC;
            in_data_mem_to_reg         : IN STD_LOGIC;
            out_data_mem_to_reg        : OUT STD_LOGIC;
            in_data_push               : IN STD_LOGIC;
            out_data_push              : OUT STD_LOGIC;
            in_data_pop                : IN STD_LOGIC;
            out_data_pop               : OUT STD_LOGIC;
            in_data_jmp                : IN STD_LOGIC;
            out_data_jmp               : OUT STD_LOGIC;
            in_data_jn                 : IN STD_LOGIC;
            out_data_jn                : OUT STD_LOGIC;
            in_data_jz                 : IN STD_LOGIC;
            out_data_jz                : OUT STD_LOGIC;
            in_data_jc                 : IN STD_LOGIC;
            out_data_jc                : OUT STD_LOGIC;
            in_data_call               : IN STD_LOGIC;
            out_data_call              : OUT STD_LOGIC;
            in_data_ret                : IN STD_LOGIC;
            out_data_ret               : OUT STD_LOGIC;
            in_data_int                : IN STD_LOGIC;
            out_data_int               : OUT STD_LOGIC;
            in_data_rti                : IN STD_LOGIC;
            out_data_rti               : OUT STD_LOGIC;
            in_data_read_data1         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_read_data1        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_id_ie_rdst         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_id_ie_rdst        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_execute_final_res  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_execute_final_res : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_next_pc            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_next_pc           : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    --Inputs
    SIGNAL clk                       : STD_LOGIC                     := '0';
    SIGNAL rst                       : STD_LOGIC                     := '0';
    SIGNAL flush                     : STD_LOGIC                     := '0';
    SIGNAL NOP                       : STD_LOGIC                     := '0';
    SIGNAL in_data_index             : STD_LOGIC                     := '0';
    SIGNAL in_data_nop               : STD_LOGIC                     := '0';
    SIGNAL in_data_alu_op            : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_write         : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_read          : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_to_reg        : STD_LOGIC                     := '0';
    SIGNAL in_data_push              : STD_LOGIC                     := '0';
    SIGNAL in_data_pop               : STD_LOGIC                     := '0';
    SIGNAL in_data_jmp               : STD_LOGIC                     := '0';
    SIGNAL in_data_jn                : STD_LOGIC                     := '0';
    SIGNAL in_data_jz                : STD_LOGIC                     := '0';
    SIGNAL in_data_jc                : STD_LOGIC                     := '0';
    SIGNAL in_data_call              : STD_LOGIC                     := '0';
    SIGNAL in_data_ret               : STD_LOGIC                     := '0';
    SIGNAL in_data_int               : STD_LOGIC                     := '0';
    SIGNAL in_data_rti               : STD_LOGIC                     := '0';
    SIGNAL in_data_read_data1        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in_data_id_ie_rdst        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in_data_execute_final_res : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in_data_next_pc           : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    --Outputs
    SIGNAL out_data_index             : STD_LOGIC;
    SIGNAL out_data_nop               : STD_LOGIC;
    SIGNAL out_data_alu_op            : STD_LOGIC;
    SIGNAL out_data_mem_write         : STD_LOGIC;
    SIGNAL out_data_mem_read          : STD_LOGIC;
    SIGNAL out_data_mem_to_reg        : STD_LOGIC;
    SIGNAL out_data_push              : STD_LOGIC;
    SIGNAL out_data_pop               : STD_LOGIC;
    SIGNAL out_data_jmp               : STD_LOGIC;
    SIGNAL out_data_jn                : STD_LOGIC;
    SIGNAL out_data_jz                : STD_LOGIC;
    SIGNAL out_data_jc                : STD_LOGIC;
    SIGNAL out_data_call              : STD_LOGIC;
    SIGNAL out_data_ret               : STD_LOGIC;
    SIGNAL out_data_int               : STD_LOGIC;
    SIGNAL out_data_rti               : STD_LOGIC;
    SIGNAL out_data_read_data1        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_id_ie_rdst        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_execute_final_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_next_pc           : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : ExecuteMemoryReg PORT MAP(
        clk                        => clk,
        rst                        => rst,
        flush                      => flush,
        NOP                        => NOP,
        in_data_index              => in_data_index,
        out_data_index             => out_data_index,
        in_data_nop                => in_data_nop,
        out_data_nop               => out_data_nop,
        in_data_alu_op             => in_data_alu_op,
        out_data_alu_op            => out_data_alu_op,
        in_data_mem_write          => in_data_mem_write,
        out_data_mem_write         => out_data_mem_write,
        in_data_mem_read           => in_data_mem_read,
        out_data_mem_read          => out_data_mem_read,
        in_data_mem_to_reg         => in_data_mem_to_reg,
        out_data_mem_to_reg        => out_data_mem_to_reg,
        in_data_push               => in_data_push,
        out_data_push              => out_data_push,
        in_data_pop                => in_data_pop,
        out_data_pop               => out_data_pop,
        in_data_jmp                => in_data_jmp,
        out_data_jmp               => out_data_jmp,
        in_data_jn                 => in_data_jn,
        out_data_jn                => out_data_jn,
        in_data_jz                 => in_data_jz,
        out_data_jz                => out_data_jz,
        in_data_jc                 => in_data_jc,
        out_data_jc                => out_data_jc,
        in_data_call               => in_data_call,
        out_data_call              => out_data_call,
        in_data_ret                => in_data_ret,
        out_data_ret               => out_data_ret,
        in_data_int                => in_data_int,
        out_data_int               => out_data_int,
        in_data_rti                => in_data_rti,
        out_data_rti               => out_data_rti,
        in_data_read_data1         => in_data_read_data1,
        out_data_read_data1        => out_data_read_data1,
        in_data_id_ie_rdst         => in_data_id_ie_rdst,
        out_data_id_ie_rdst        => out_data_id_ie_rdst,
        in_data_execute_final_res  => in_data_execute_final_res,
        out_data_execute_final_res => out_data_execute_final_res,
        in_data_next_pc            => in_data_next_pc,
        out_data_next_pc           => out_data_next_pc
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.
        rst <= '1';
        WAIT FOR 100 ns;
        rst <= '0';

        -- insert stimulus here 
        WAIT FOR clk_period * 10;

        -- Test case 1: Normal operation
        in_data_read_data1        <= x"AAAA";
        in_data_id_ie_rdst        <= x"BBBB";
        in_data_execute_final_res <= x"CCCC";
        in_data_next_pc           <= x"DDDD";
        in_data_index             <= '1';
        in_data_nop               <= '0';
        in_data_alu_op            <= '1';
        in_data_mem_write         <= '1';
        in_data_mem_read          <= '0';
        in_data_mem_to_reg        <= '1';
        in_data_push              <= '1';
        in_data_pop               <= '0';
        in_data_jmp               <= '1';
        in_data_jn                <= '0';
        in_data_jz                <= '1';
        in_data_jc                <= '0';
        in_data_call              <= '1';
        in_data_ret               <= '0';
        in_data_int               <= '1';
        in_data_rti               <= '0';

        WAIT FOR clk_period * 10;

        ASSERT (out_data_read_data1 = x"AAAA") REPORT "Test case 1 failed for out_data_read_data1" SEVERITY error;
        ASSERT (out_data_id_ie_rdst = x"BBBB") REPORT "Test case 1 failed for out_data_id_ie_rdst" SEVERITY error;
        ASSERT (out_data_execute_final_res = x"CCCC") REPORT "Test case 1 failed for out_data_execute_final_res" SEVERITY error;
        ASSERT (out_data_next_pc = x"DDDD") REPORT "Test case 1 failed for out_data_next_pc" SEVERITY error;
        ASSERT (out_data_index = '1') REPORT "Test case 1 failed for out_data_index" SEVERITY error;
        ASSERT (out_data_nop = '0') REPORT "Test case 1 failed for out_data_nop" SEVERITY error;
        ASSERT (out_data_alu_op = '1') REPORT "Test case 1 failed for out_data_alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '1') REPORT "Test case 1 failed for out_data_mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '0') REPORT "Test case 1 failed for out_data_mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '1') REPORT "Test case 1 failed for out_data_mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '1') REPORT "Test case 1 failed for out_data_push" SEVERITY error;
        ASSERT (out_data_pop = '0') REPORT "Test case 1 failed for out_data_pop" SEVERITY error;
        ASSERT (out_data_jmp = '1') REPORT "Test case 1 failed for out_data_jmp" SEVERITY error;
        ASSERT (out_data_jn = '0') REPORT "Test case 1 failed for out_data_jn" SEVERITY error;
        ASSERT (out_data_jz = '1') REPORT "Test case 1 failed for out_data_jz" SEVERITY error;
        ASSERT (out_data_jc = '0') REPORT "Test case 1 failed for out_data_jc" SEVERITY error;
        ASSERT (out_data_call = '1') REPORT "Test case 1 failed for out_data_call" SEVERITY error;
        ASSERT (out_data_ret = '0') REPORT "Test case 1 failed for out_data_ret" SEVERITY error;
        ASSERT (out_data_int = '1') REPORT "Test case 1 failed for out_data_int" SEVERITY error;
        ASSERT (out_data_rti = '0') REPORT "Test case 1 failed for out_data_rti" SEVERITY error;

        -- Test case for NOP
        NOP <= '1';
        WAIT FOR 20 ns;
        ASSERT (out_data_read_data1 = x"AAAA") REPORT "Test case 1 failed for out_data_read_data1" SEVERITY error;
        ASSERT (out_data_id_ie_rdst = x"BBBB") REPORT "Test case 1 failed for out_data_id_ie_rdst" SEVERITY error;
        ASSERT (out_data_execute_final_res = x"CCCC") REPORT "Test case 1 failed for out_data_execute_final_res" SEVERITY error;
        ASSERT (out_data_next_pc = x"DDDD") REPORT "Test case 1 failed for out_data_next_pc" SEVERITY error;
        ASSERT (out_data_index = '1') REPORT "Test case 1 failed for out_data_index" SEVERITY error;
        ASSERT (out_data_nop = '0') REPORT "Test case 1 failed for out_data_nop" SEVERITY error;
        ASSERT (out_data_alu_op = '1') REPORT "Test case 1 failed for out_data_alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '1') REPORT "Test case 1 failed for out_data_mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '0') REPORT "Test case 1 failed for out_data_mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '1') REPORT "Test case 1 failed for out_data_mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '1') REPORT "Test case 1 failed for out_data_push" SEVERITY error;
        ASSERT (out_data_pop = '0') REPORT "Test case 1 failed for out_data_pop" SEVERITY error;
        ASSERT (out_data_jmp = '1') REPORT "Test case 1 failed for out_data_jmp" SEVERITY error;
        ASSERT (out_data_jn = '0') REPORT "Test case 1 failed for out_data_jn" SEVERITY error;
        ASSERT (out_data_jz = '1') REPORT "Test case 1 failed for out_data_jz" SEVERITY error;
        ASSERT (out_data_jc = '0') REPORT "Test case 1 failed for out_data_jc" SEVERITY error;
        ASSERT (out_data_call = '1') REPORT "Test case 1 failed for out_data_call" SEVERITY error;
        ASSERT (out_data_ret = '0') REPORT "Test case 1 failed for out_data_ret" SEVERITY error;
        ASSERT (out_data_int = '1') REPORT "Test case 1 failed for out_data_int" SEVERITY error;
        ASSERT (out_data_rti = '0') REPORT "Test case 1 failed for out_data_rti" SEVERITY error;

        -- Test case for flush
        flush <= '1';
        WAIT FOR 20 ns;
        ASSERT (out_data_read_data1 = x"0000") REPORT "Test case 1 failed for out_data_read_data1" SEVERITY error;
        ASSERT (out_data_id_ie_rdst = x"0000") REPORT "Test case 1 failed for out_data_id_ie_rdst" SEVERITY error;
        ASSERT (out_data_execute_final_res = x"0000") REPORT "Test case 1 failed for out_data_execute_final_res" SEVERITY error;
        ASSERT (out_data_next_pc = x"0000") REPORT "Test case 1 failed for out_data_next_pc" SEVERITY error;
        ASSERT (out_data_index = '0') REPORT "Test case 1 failed for out_data_index" SEVERITY error;
        ASSERT (out_data_nop = '0') REPORT "Test case 1 failed for out_data_nop" SEVERITY error;
        ASSERT (out_data_alu_op = '0') REPORT "Test case 1 failed for out_data_alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '0') REPORT "Test case 1 failed for out_data_mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '0') REPORT "Test case 1 failed for out_data_mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '0') REPORT "Test case 1 failed for out_data_mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '0') REPORT "Test case 1 failed for out_data_push" SEVERITY error;
        ASSERT (out_data_pop = '0') REPORT "Test case 1 failed for out_data_pop" SEVERITY error;
        ASSERT (out_data_jmp = '0') REPORT "Test case 1 failed for out_data_jmp" SEVERITY error;
        ASSERT (out_data_jn = '0') REPORT "Test case 1 failed for out_data_jn" SEVERITY error;
        ASSERT (out_data_jz = '0') REPORT "Test case 1 failed for out_data_jz" SEVERITY error;
        ASSERT (out_data_jc = '0') REPORT "Test case 1 failed for out_data_jc" SEVERITY error;
        ASSERT (out_data_call = '0') REPORT "Test case 1 failed for out_data_call" SEVERITY error;
        ASSERT (out_data_ret = '0') REPORT "Test case 1 failed for out_data_ret" SEVERITY error;
        ASSERT (out_data_int = '0') REPORT "Test case 1 failed for out_data_int" SEVERITY error;
        ASSERT (out_data_rti = '0') REPORT "Test case 1 failed for out_data_rti" SEVERITY error;

        WAIT;
    END PROCESS;

END;
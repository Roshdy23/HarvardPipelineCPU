LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_DecodeExecuteReg IS
END tb_DecodeExecuteReg;

ARCHITECTURE behavior OF tb_DecodeExecuteReg IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT DecodeExecuteReg
        PORT (
            clk                    : IN STD_LOGIC;
            rst                    : IN STD_LOGIC;
            flush                  : IN STD_LOGIC;
            NOP                    : IN STD_LOGIC;
            in_data_index          : IN STD_LOGIC;
            out_data_index         : OUT STD_LOGIC;
            in_data_nop            : IN STD_LOGIC;
            out_data_nop           : OUT STD_LOGIC;
            in_data_alu_op         : IN STD_LOGIC;
            out_data_alu_op        : OUT STD_LOGIC;
            in_data_mem_write      : IN STD_LOGIC;
            out_data_mem_write     : OUT STD_LOGIC;
            in_data_mem_read       : IN STD_LOGIC;
            out_data_mem_read      : OUT STD_LOGIC;
            in_data_mem_to_reg     : IN STD_LOGIC;
            out_data_mem_to_reg    : OUT STD_LOGIC;
            in_data_push           : IN STD_LOGIC;
            out_data_push          : OUT STD_LOGIC;
            in_data_pop            : IN STD_LOGIC;
            out_data_pop           : OUT STD_LOGIC;
            in_data_jmp            : IN STD_LOGIC;
            out_data_jmp           : OUT STD_LOGIC;
            in_data_jn             : IN STD_LOGIC;
            out_data_jn            : OUT STD_LOGIC;
            in_data_jz             : IN STD_LOGIC;
            out_data_jz            : OUT STD_LOGIC;
            in_data_jc             : IN STD_LOGIC;
            out_data_jc            : OUT STD_LOGIC;
            in_data_call           : IN STD_LOGIC;
            out_data_call          : OUT STD_LOGIC;
            in_data_ret            : IN STD_LOGIC;
            out_data_ret           : OUT STD_LOGIC;
            in_data_int            : IN STD_LOGIC;
            out_data_int           : OUT STD_LOGIC;
            in_data_rti            : IN STD_LOGIC;
            out_data_rti           : OUT STD_LOGIC;
            in_data_read_data1     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_read_data1    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_read_data2     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_read_data2    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_immediate      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_immediate     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_function_code  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_function_code : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_if_id_rsrc1    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_if_id_rsrc1   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_if_id_rsrc2    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_if_id_rsrc2   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_if_id_rdst     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_if_id_rdst    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_in_port        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_in_port       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            in_data_next_pc        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data_next_pc       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    --Inputs
    SIGNAL clk                   : STD_LOGIC                     := '0';
    SIGNAL rst                   : STD_LOGIC                     := '0';
    SIGNAL flush                 : STD_LOGIC                     := '0';
    SIGNAL NOP                   : STD_LOGIC                     := '0';
    SIGNAL in_data_index         : STD_LOGIC                     := '0';
    SIGNAL in_data_nop           : STD_LOGIC                     := '0';
    SIGNAL in_data_alu_op        : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_write     : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_read      : STD_LOGIC                     := '0';
    SIGNAL in_data_mem_to_reg    : STD_LOGIC                     := '0';
    SIGNAL in_data_push          : STD_LOGIC                     := '0';
    SIGNAL in_data_pop           : STD_LOGIC                     := '0';
    SIGNAL in_data_jmp           : STD_LOGIC                     := '0';
    SIGNAL in_data_jn            : STD_LOGIC                     := '0';
    SIGNAL in_data_jz            : STD_LOGIC                     := '0';
    SIGNAL in_data_jc            : STD_LOGIC                     := '0';
    SIGNAL in_data_call          : STD_LOGIC                     := '0';
    SIGNAL in_data_ret           : STD_LOGIC                     := '0';
    SIGNAL in_data_int           : STD_LOGIC                     := '0';
    SIGNAL in_data_rti           : STD_LOGIC                     := '0';
    SIGNAL in_data_read_data1    : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_read_data2    : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_immediate     : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_function_code : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_if_id_rsrc1   : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_if_id_rsrc2   : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_if_id_rdst    : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_in_port       : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL in_data_next_pc       : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

    --Outputs
    SIGNAL out_data_index         : STD_LOGIC;
    SIGNAL out_data_nop           : STD_LOGIC;
    SIGNAL out_data_alu_op        : STD_LOGIC;
    SIGNAL out_data_mem_write     : STD_LOGIC;
    SIGNAL out_data_mem_read      : STD_LOGIC;
    SIGNAL out_data_mem_to_reg    : STD_LOGIC;
    SIGNAL out_data_push          : STD_LOGIC;
    SIGNAL out_data_pop           : STD_LOGIC;
    SIGNAL out_data_jmp           : STD_LOGIC;
    SIGNAL out_data_jn            : STD_LOGIC;
    SIGNAL out_data_jz            : STD_LOGIC;
    SIGNAL out_data_jc            : STD_LOGIC;
    SIGNAL out_data_call          : STD_LOGIC;
    SIGNAL out_data_ret           : STD_LOGIC;
    SIGNAL out_data_int           : STD_LOGIC;
    SIGNAL out_data_rti           : STD_LOGIC;
    SIGNAL out_data_read_data1    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_read_data2    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_immediate     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_function_code : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_if_id_rsrc1   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_if_id_rsrc2   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_if_id_rdst    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_in_port       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_data_next_pc       : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : DecodeExecuteReg PORT MAP(
        clk                    => clk,
        rst                    => rst,
        flush                  => flush,
        NOP                    => NOP,
        in_data_index          => in_data_index,
        out_data_index         => out_data_index,
        in_data_nop            => in_data_nop,
        out_data_nop           => out_data_nop,
        in_data_alu_op         => in_data_alu_op,
        out_data_alu_op        => out_data_alu_op,
        in_data_mem_write      => in_data_mem_write,
        out_data_mem_write     => out_data_mem_write,
        in_data_mem_read       => in_data_mem_read,
        out_data_mem_read      => out_data_mem_read,
        in_data_mem_to_reg     => in_data_mem_to_reg,
        out_data_mem_to_reg    => out_data_mem_to_reg,
        in_data_push           => in_data_push,
        out_data_push          => out_data_push,
        in_data_pop            => in_data_pop,
        out_data_pop           => out_data_pop,
        in_data_jmp            => in_data_jmp,
        out_data_jmp           => out_data_jmp,
        in_data_jn             => in_data_jn,
        out_data_jn            => out_data_jn,
        in_data_jz             => in_data_jz,
        out_data_jz            => out_data_jz,
        in_data_jc             => in_data_jc,
        out_data_jc            => out_data_jc,
        in_data_call           => in_data_call,
        out_data_call          => out_data_call,
        in_data_ret            => in_data_ret,
        out_data_ret           => out_data_ret,
        in_data_int            => in_data_int,
        out_data_int           => out_data_int,
        in_data_rti            => in_data_rti,
        out_data_rti           => out_data_rti,
        in_data_read_data1     => in_data_read_data1,
        out_data_read_data1    => out_data_read_data1,
        in_data_read_data2     => in_data_read_data2,
        out_data_read_data2    => out_data_read_data2,
        in_data_immediate      => in_data_immediate,
        out_data_immediate     => out_data_immediate,
        in_data_function_code  => in_data_function_code,
        out_data_function_code => out_data_function_code,
        in_data_if_id_rsrc1    => in_data_if_id_rsrc1,
        out_data_if_id_rsrc1   => out_data_if_id_rsrc1,
        in_data_if_id_rsrc2    => in_data_if_id_rsrc2,
        out_data_if_id_rsrc2   => out_data_if_id_rsrc2,
        in_data_if_id_rdst     => in_data_if_id_rdst,
        out_data_if_id_rdst    => out_data_if_id_rdst,
        in_data_in_port        => in_data_in_port,
        out_data_in_port       => out_data_in_port,
        in_data_next_pc        => in_data_next_pc,
        out_data_next_pc       => out_data_next_pc
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
        in_data_read_data1    <= x"AAAA";
        in_data_read_data2    <= x"BBBB";
        in_data_immediate     <= x"CCCC";
        in_data_function_code <= x"DDDD";
        in_data_if_id_rsrc1   <= x"EEEE";
        in_data_if_id_rsrc2   <= x"FFFF";
        in_data_if_id_rdst    <= x"1111";
        in_data_in_port       <= x"2222";
        in_data_next_pc       <= x"3333";
        in_data_index         <= '1';
        in_data_nop           <= '0';
        in_data_alu_op        <= '1';
        in_data_mem_write     <= '0';
        in_data_mem_read      <= '1';
        in_data_mem_to_reg    <= '0';
        in_data_push          <= '1';
        in_data_pop           <= '0';
        in_data_jmp           <= '1';
        in_data_jn            <= '0';
        in_data_jz            <= '1';
        in_data_jc            <= '0';
        in_data_call          <= '1';
        in_data_ret           <= '0';
        in_data_int           <= '1';
        in_data_rti           <= '0';

        WAIT FOR 20 ns;

        ASSERT (out_data_read_data1 = x"AAAA") REPORT "Test failed for read_data1" SEVERITY error;
        ASSERT (out_data_read_data2 = x"BBBB") REPORT "Test failed for read_data2" SEVERITY error;
        ASSERT (out_data_immediate = x"CCCC") REPORT "Test failed for immediate" SEVERITY error;
        ASSERT (out_data_function_code = x"DDDD") REPORT "Test failed for function_code" SEVERITY error;
        ASSERT (out_data_if_id_rsrc1 = x"EEEE") REPORT "Test failed for if_id_rsrc1" SEVERITY error;
        ASSERT (out_data_if_id_rsrc2 = x"FFFF") REPORT "Test failed for if_id_rsrc2" SEVERITY error;
        ASSERT (out_data_if_id_rdst = x"1111") REPORT "Test failed for if_id_rdst" SEVERITY error;
        ASSERT (out_data_in_port = x"2222") REPORT "Test failed for in_port" SEVERITY error;
        ASSERT (out_data_next_pc = x"3333") REPORT "Test failed for next_pc" SEVERITY error;
        ASSERT (out_data_index = '1') REPORT "Test failed for index" SEVERITY error;
        ASSERT (out_data_nop = '0') REPORT "Test failed for nop" SEVERITY error;
        ASSERT (out_data_alu_op = '1') REPORT "Test failed for alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '0') REPORT "Test failed for mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '1') REPORT "Test failed for mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '0') REPORT "Test failed for mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '1') REPORT "Test failed for push" SEVERITY error;
        ASSERT (out_data_pop = '0') REPORT "Test failed for pop" SEVERITY error;
        ASSERT (out_data_jmp = '1') REPORT "Test failed for jmp" SEVERITY error;
        ASSERT (out_data_jn = '0') REPORT "Test failed for jn" SEVERITY error;
        ASSERT (out_data_jz = '1') REPORT "Test failed for jz" SEVERITY error;
        ASSERT (out_data_jc = '0') REPORT "Test failed for jc" SEVERITY error;
        ASSERT (out_data_call = '1') REPORT "Test failed for call" SEVERITY error;
        ASSERT (out_data_ret = '0') REPORT "Test failed for ret" SEVERITY error;
        ASSERT (out_data_int = '1') REPORT "Test failed for int" SEVERITY error;
        ASSERT (out_data_rti = '0') REPORT "Test failed for rti" SEVERITY error;

        
        -- Additional test case 1
        in_data_read_data1    <= x"1234";
        in_data_read_data2    <= x"5678";
        in_data_immediate     <= x"9ABC";
        in_data_function_code <= x"DEF0";
        in_data_if_id_rsrc1   <= x"1357";
        in_data_if_id_rsrc2   <= x"2468";
        in_data_if_id_rdst    <= x"369C";
        in_data_in_port       <= x"48AE";
        in_data_next_pc       <= x"5BDF";
        in_data_index         <= '0';
        in_data_nop           <= '1';
        in_data_alu_op        <= '0';
        in_data_mem_write     <= '1';
        in_data_mem_read      <= '0';
        in_data_mem_to_reg    <= '1';
        in_data_push          <= '0';
        in_data_pop           <= '1';
        in_data_jmp           <= '0';
        in_data_jn            <= '1';
        in_data_jz            <= '0';
        in_data_jc            <= '1';
        in_data_call          <= '0';
        in_data_ret           <= '1';
        in_data_int           <= '0';
        in_data_rti           <= '1';

        WAIT FOR 20 ns;

        ASSERT (out_data_read_data1 = x"1234") REPORT "Test failed for read_data1" SEVERITY error;
        ASSERT (out_data_read_data2 = x"5678") REPORT "Test failed for read_data2" SEVERITY error;
        ASSERT (out_data_immediate = x"9ABC") REPORT "Test failed for immediate" SEVERITY error;
        ASSERT (out_data_function_code = x"DEF0") REPORT "Test failed for function_code" SEVERITY error;
        ASSERT (out_data_if_id_rsrc1 = x"1357") REPORT "Test failed for if_id_rsrc1" SEVERITY error;
        ASSERT (out_data_if_id_rsrc2 = x"2468") REPORT "Test failed for if_id_rsrc2" SEVERITY error;
        ASSERT (out_data_if_id_rdst = x"369C") REPORT "Test failed for if_id_rdst" SEVERITY error;
        ASSERT (out_data_in_port = x"48AE") REPORT "Test failed for in_port" SEVERITY error;
        ASSERT (out_data_next_pc = x"5BDF") REPORT "Test failed for next_pc" SEVERITY error;
        ASSERT (out_data_index = '0') REPORT "Test failed for index" SEVERITY error;
        ASSERT (out_data_nop = '1') REPORT "Test failed for nop" SEVERITY error;
        ASSERT (out_data_alu_op = '0') REPORT "Test failed for alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '1') REPORT "Test failed for mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '0') REPORT "Test failed for mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '1') REPORT "Test failed for mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '0') REPORT "Test failed for push" SEVERITY error;
        ASSERT (out_data_pop = '1') REPORT "Test failed for pop" SEVERITY error;
        ASSERT (out_data_jmp = '0') REPORT "Test failed for jmp" SEVERITY error;
        ASSERT (out_data_jn = '1') REPORT "Test failed for jn" SEVERITY error;
        ASSERT (out_data_jz = '0') REPORT "Test failed for jz" SEVERITY error;
        ASSERT (out_data_jc = '1') REPORT "Test failed for jc" SEVERITY error;
        ASSERT (out_data_call = '0') REPORT "Test failed for call" SEVERITY error;
        ASSERT (out_data_ret = '1') REPORT "Test failed for ret" SEVERITY error;
        ASSERT (out_data_int = '0') REPORT "Test failed for int" SEVERITY error;
        ASSERT (out_data_rti = '1') REPORT "Test failed for rti" SEVERITY error;
        
        -- Additional test case 2
        in_data_read_data1    <= x"FFFF";
        in_data_read_data2    <= x"EEEE";
        in_data_immediate     <= x"DDDD";
        in_data_function_code <= x"CCCC";
        in_data_if_id_rsrc1   <= x"BBBB";
        in_data_if_id_rsrc2   <= x"AAAA";
        in_data_if_id_rdst    <= x"9999";
        in_data_in_port       <= x"8888";
        in_data_next_pc       <= x"7777";
        in_data_index         <= '1';
        in_data_nop           <= '1';
        in_data_alu_op        <= '1';
        in_data_mem_write     <= '1';
        in_data_mem_read      <= '1';
        in_data_mem_to_reg    <= '1';
        in_data_push          <= '1';
        in_data_pop           <= '1';
        in_data_jmp           <= '1';
        in_data_jn            <= '1';
        in_data_jz            <= '1';
        in_data_jc            <= '1';
        in_data_call          <= '1';
        in_data_ret           <= '1';
        in_data_int           <= '1';
        in_data_rti           <= '1';

        WAIT FOR 20 ns;

        ASSERT (out_data_read_data1 = x"FFFF") REPORT "Test failed for read_data1" SEVERITY error;
        ASSERT (out_data_read_data2 = x"EEEE") REPORT "Test failed for read_data2" SEVERITY error;
        ASSERT (out_data_immediate = x"DDDD") REPORT "Test failed for immediate" SEVERITY error;
        ASSERT (out_data_function_code = x"CCCC") REPORT "Test failed for function_code" SEVERITY error;
        ASSERT (out_data_if_id_rsrc1 = x"BBBB") REPORT "Test failed for if_id_rsrc1" SEVERITY error;
        ASSERT (out_data_if_id_rsrc2 = x"AAAA") REPORT "Test failed for if_id_rsrc2" SEVERITY error;
        ASSERT (out_data_if_id_rdst = x"9999") REPORT "Test failed for if_id_rdst" SEVERITY error;
        ASSERT (out_data_in_port = x"8888") REPORT "Test failed for in_port" SEVERITY error;
        ASSERT (out_data_next_pc = x"7777") REPORT "Test failed for next_pc" SEVERITY error;
        ASSERT (out_data_index = '1') REPORT "Test failed for index" SEVERITY error;
        ASSERT (out_data_nop = '1') REPORT "Test failed for nop" SEVERITY error;
        ASSERT (out_data_alu_op = '1') REPORT "Test failed for alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '1') REPORT "Test failed for mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '1') REPORT "Test failed for mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '1') REPORT "Test failed for mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '1') REPORT "Test failed for push" SEVERITY error;
        ASSERT (out_data_pop = '1') REPORT "Test failed for pop" SEVERITY error;
        ASSERT (out_data_jmp = '1') REPORT "Test failed for jmp" SEVERITY error;
        ASSERT (out_data_jn = '1') REPORT "Test failed for jn" SEVERITY error;
        ASSERT (out_data_jz = '1') REPORT "Test failed for jz" SEVERITY error;
        ASSERT (out_data_jc = '1') REPORT "Test failed for jc" SEVERITY error;
        ASSERT (out_data_call = '1') REPORT "Test failed for call" SEVERITY error;
        ASSERT (out_data_ret = '1') REPORT "Test failed for ret" SEVERITY error;
        ASSERT (out_data_int = '1') REPORT "Test failed for int" SEVERITY error;
        ASSERT (out_data_rti = '1') REPORT "Test failed for rti" SEVERITY error;
        
        -- Test case for NOP
        NOP <= '1';
        WAIT FOR 20 ns;
        ASSERT (out_data_read_data1 = x"FFFF") REPORT "Test failed for NOP read_data1" SEVERITY error;
        ASSERT (out_data_read_data2 = x"EEEE") REPORT "Test failed for NOP read_data2" SEVERITY error;
        ASSERT (out_data_immediate = x"DDDD") REPORT "Test failed for NOP immediate" SEVERITY error;
        ASSERT (out_data_function_code = x"CCCC") REPORT "Test failed for NOP function_code" SEVERITY error;
        ASSERT (out_data_if_id_rsrc1 = x"BBBB") REPORT "Test failed for NOP if_id_rsrc1" SEVERITY error;
        ASSERT (out_data_if_id_rsrc2 = x"AAAA") REPORT "Test failed for NOP if_id_rsrc2" SEVERITY error;
        ASSERT (out_data_if_id_rdst = x"9999") REPORT "Test failed for NOP if_id_rdst" SEVERITY error;
        ASSERT (out_data_in_port = x"8888") REPORT "Test failed for NOP in_port" SEVERITY error;
        ASSERT (out_data_next_pc = x"7777") REPORT "Test failed for NOP next_pc" SEVERITY error;
        ASSERT (out_data_index = '1') REPORT "Test failed for NOP index" SEVERITY error;
        ASSERT (out_data_nop = '1') REPORT "Test failed for NOP nop" SEVERITY error;
        ASSERT (out_data_alu_op = '1') REPORT "Test failed for NOP alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '1') REPORT "Test failed for NOP mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '1') REPORT "Test failed for NOP mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '1') REPORT "Test failed for NOP mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '1') REPORT "Test failed for NOP push" SEVERITY error;
        ASSERT (out_data_pop = '1') REPORT "Test failed for NOP pop" SEVERITY error;
        ASSERT (out_data_jmp = '1') REPORT "Test failed for NOP jmp" SEVERITY error;
        ASSERT (out_data_jn = '1') REPORT "Test failed for NOP jn" SEVERITY error;
        ASSERT (out_data_jz = '1') REPORT "Test failed for NOP jz" SEVERITY error;
        ASSERT (out_data_jc = '1') REPORT "Test failed for NOP jc" SEVERITY error;
        ASSERT (out_data_call = '1') REPORT "Test failed for NOP call" SEVERITY error;
        ASSERT (out_data_ret = '1') REPORT "Test failed for NOP ret" SEVERITY error;
        ASSERT (out_data_int = '1') REPORT "Test failed for NOP int" SEVERITY error;
        ASSERT (out_data_rti = '1') REPORT "Test failed for NOP rti" SEVERITY error;

        -- Test case for flush
        flush <= '1';
        WAIT FOR 20 ns;
        ASSERT (out_data_read_data1 = x"0000") REPORT "Test failed for flush read_data1" SEVERITY error;
        ASSERT (out_data_read_data2 = x"0000") REPORT "Test failed for flush read_data2" SEVERITY error;
        ASSERT (out_data_immediate = x"0000") REPORT "Test failed for flush immediate" SEVERITY error;
        ASSERT (out_data_function_code = x"0000") REPORT "Test failed for flush function_code" SEVERITY error;
        ASSERT (out_data_if_id_rsrc1 = x"0000") REPORT "Test failed for flush if_id_rsrc1" SEVERITY error;
        ASSERT (out_data_if_id_rsrc2 = x"0000") REPORT "Test failed for flush if_id_rsrc2" SEVERITY error;
        ASSERT (out_data_if_id_rdst = x"0000") REPORT "Test failed for flush if_id_rdst" SEVERITY error;
        ASSERT (out_data_in_port = x"0000") REPORT "Test failed for flush in_port" SEVERITY error;
        ASSERT (out_data_next_pc = x"0000") REPORT "Test failed for flush next_pc" SEVERITY error;
        ASSERT (out_data_index = '0') REPORT "Test failed for flush index" SEVERITY error;
        ASSERT (out_data_nop = '0') REPORT "Test failed for flush nop" SEVERITY error;
        ASSERT (out_data_alu_op = '0') REPORT "Test failed for flush alu_op" SEVERITY error;
        ASSERT (out_data_mem_write = '0') REPORT "Test failed for flush mem_write" SEVERITY error;
        ASSERT (out_data_mem_read = '0') REPORT "Test failed for flush mem_read" SEVERITY error;
        ASSERT (out_data_mem_to_reg = '0') REPORT "Test failed for flush mem_to_reg" SEVERITY error;
        ASSERT (out_data_push = '0') REPORT "Test failed for flush push" SEVERITY error;
        ASSERT (out_data_pop = '0') REPORT "Test failed for flush pop" SEVERITY error;
        ASSERT (out_data_jmp = '0') REPORT "Test failed for flush jmp" SEVERITY error;
        ASSERT (out_data_jn = '0') REPORT "Test failed for flush jn" SEVERITY error;
        ASSERT (out_data_jz = '0') REPORT "Test failed for flush jz" SEVERITY error;
        ASSERT (out_data_jc = '0') REPORT "Test failed for flush jc" SEVERITY error;
        ASSERT (out_data_call = '0') REPORT "Test failed for flush call" SEVERITY error;
        ASSERT (out_data_ret = '0') REPORT "Test failed for flush ret" SEVERITY error;
        ASSERT (out_data_int = '0') REPORT "Test failed for flush int" SEVERITY error;
        ASSERT (out_data_rti = '0') REPORT "Test failed for flush rti" SEVERITY error;

        WAIT;
    END PROCESS;
END;
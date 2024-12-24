LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MemoryStage IS
    PORT (
        clk        : IN STD_LOGIC;
        rst        : IN STD_LOGIC;
        push       : IN STD_LOGIC;
        pop        : IN STD_LOGIC;
        int        : IN STD_LOGIC;
        read_data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        result     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc_plus1   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        we         : IN STD_LOGIC;
        re         : IN STD_LOGIC;
        stack_op   : IN STD_LOGIC;
        epc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        excep      : OUT STD_LOGIC;
        data_out   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END MemoryStage;

ARCHITECTURE Behavioral OF MemoryStage IS
    SIGNAL empty_exception  : STD_LOGIC;
    SIGNAL memory_exception : STD_LOGIC;
    SIGNAL sp_out           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_in          : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL address          : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL unused           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL nf               : STD_LOGIC;
    SIGNAL read_or_write    : STD_LOGIC;
    SIGNAL we_and_re        : STD_LOGIC_VECTOR(1 DOWNTO 0);
    CONSTANT x0FFF          : STD_LOGIC_VECTOR(15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(4095, 16));
BEGIN
    PROCESS (we, re)
    BEGIN
        we_and_re <= we & re;
    END PROCESS;

    istack : ENTITY work.StackControlUnit(Behavioral)
        PORT MAP(
            clk             => clk,
            rst             => rst,
            push            => push,
            pop             => pop,
            sp_out          => sp_out,
            empty_exception => empty_exception
        );
    imux1 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => read_data1,
            b   => pc_plus1,
            sel => int,
            y   => data_in
        );
    imux2 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => result,
            b   => sp_out,
            sel => stack_op,
            y   => address
        );
    imem : ENTITY work.Ram(DataMemory)
        GENERIC MAP(
            DATA_WIDTH => 16,
            ADDR_WIDTH => 16
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            we       => we,
            re       => re,
            address  => address,
            data_in  => data_in,
            data_out => data_out
        );
    isub : ENTITY work.SubN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a  => x0FFF,
            b  => address,
            y  => unused,
            nf => nf
        );
    ior : ENTITY work.OrN(Behavioral)
        GENERIC MAP(
            W => 2
        )
        PORT MAP(
            inputs => we_and_re,
            y      => read_or_write
        );
    iand : ENTITY work.And2(Behavioral)
        PORT MAP(
            a => nf,
            b => read_or_write,
            y => memory_exception
        );
    iexception : ENTITY work.ExceptionController(Behavioral)
        PORT MAP(
            rst    => rst,
            empty  => empty_exception,
            memory => memory_exception,
            pc     => pc,
            excep  => excep,
            epc    => epc
        );
END Behavioral;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--------------------------------------------------------------------
ENTITY Decode IS
    PORT (
        clk         : IN STD_LOGIC;
        rst         : IN STD_LOGIC;
        we          : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        in_data     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        write_reg   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- From Mem/WB register
        write_data  : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- From WriteBack
        next_pc     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data1  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data2  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        immediate   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        in_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        next_pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        rdest_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END Decode;

--------------------------------------------------------------------
ARCHITECTURE Behavioral OF Decode IS

    COMPONENT RegisterFile IS
        PORT (
            clk        : IN STD_LOGIC;
            rst        : IN STD_LOGIC;
            we         : IN STD_LOGIC;
            read_reg1  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_reg2  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_reg  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MuxN IS
        GENERIC (
            W : INTEGER := 3
        );
        PORT (
            a   : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
            b   : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            y   : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL selected_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    register_file : RegisterFile
    PORT MAP(
        clk        => clk,
        we         => we,
        rst        => rst,
        read_reg1  => instruction(10 DOWNTO 8),
        read_reg2  => instruction(7 DOWNTO 5),
        write_reg  => write_reg,
        write_data => write_data,
        read_data1 => read_data1,
        read_data2 => read_data2
    );

    U1 : MuxN
    PORT MAP(
        a   => instruction(4 DOWNTO 2),
        b   => instruction(7 DOWNTO 5),
        sel => instruction(15),
        y   => selected_rdest
    );

    rdest_out <= selected_rdest;
    in_data_out <= in_data;
    next_pc_out <= next_pc;
    immediate   <= instruction;
END Behavioral;
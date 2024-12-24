LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Writeback IS
    PORT (
        mem_to_reg : IN STD_LOGIC;
        index      : IN STD_LOGIC;
        int        : IN STD_LOGIC;
        mem_data   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        in_data    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        wb_data    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Writeback;

ARCHITECTURE Behavioral OF Writeback IS
    SIGNAL wb_result   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL added_index : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    U1 : Entity work.MuxN(Behavioral)
    PORT MAP(
        a   => in_data,
        b   => mem_data,
        sel => mem_to_reg,
        y   => wb_result
    );

    U2 : Entity work.MuxN(Behavioral)
    PORT MAP(
        a   => x"0006",
        b   => x"0008",
        sel => index,
        y   => added_index
    );

    U3 : Entity work.MuxN(Behavioral)
    PORT MAP(
        a   => wb_result,
        b   => added_index,
        sel => int,
        y   => wb_data
    );

END Behavioral;
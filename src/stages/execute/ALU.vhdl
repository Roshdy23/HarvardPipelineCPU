LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        a                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        b                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op                  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        flags_en            : IN STD_LOGIC;
        cf_in, nf_in, zf_in : IN STD_LOGIC;
        result              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        cf, nf, zf          : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    CONSTANT ALU_AND : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT ALU_NOT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT ALU_ADD : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT ALU_INC : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ALU_SUB : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT ALU_NOP : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

    SIGNAL result_and, result_not, result_add, result_inc, result_sub      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL carry_add, carry_inc, carry_sub                                 : STD_LOGIC;
    SIGNAL mux_output1, mux_output2, mux_output3, mux_output4, res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL zero_flag                                                       : STD_LOGIC;
BEGIN

    uut_and16 : ENTITY work.AndN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a => A,
            b => B,
            y => result_and
        );

    -- Instantiate Not16
    uut_Not16 : ENTITY work.NotN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a => A,
            y => result_not
        );

    -- Instantiate add16
    uut_add16 : ENTITY work.AddN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a  => A,
            b  => B,
            y  => result_add,
            cf => carry_add
        );

    -- Instantiate inc16
    uut_inc16 : ENTITY work.IncN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a  => A,
            y  => result_inc,
            cf => carry_inc
        );

    uut_sub16 : ENTITY work.SubN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a => A,
            b => B,
            y => result_sub,
            cf => carry_sub
        );

    -- Choose between "xx0" or "xx1"
    U1 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => result_and,
            b   => result_not,
            sel => op(0),
            y   => mux_output1
        );

    U2 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => result_add,
            b   => result_inc,
            sel => op(0),
            y   => mux_output2
        );

    U3 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => result_sub,
            b   => a,
            sel => op(0),
            y   => mux_output3
        );

    -- Choose between "x0x" or "x1x"
    U4 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => mux_output1,
            b   => mux_output2,
            sel => op(1),
            y   => mux_output4
        );

    -- Choose between "0xx" or "1xx"
    U5 : ENTITY work.MuxN(Behavioral)
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a   => mux_output4,
            b   => mux_output3,
            sel => op(2),
            y   => res
        );

    cf <= carry_add WHEN (op = ALU_ADD AND flags_en = '1') ELSE
        carry_inc WHEN (op = ALU_INC AND flags_en = '1') ELSE
        carry_sub WHEN (op = ALU_SUB AND flags_en = '1') ELSE
        cf_in;

    -- Negative flag gets the value of the most significant bit of the result
    -- It is updated om all operations.
    nf <= res(15) WHEN flags_en = '1' AND op /= ALU_NOP ELSE
        nf_in;

    zero_flag <= '1' WHEN (res = std_logic_vector(TO_UNSIGNED(0, res'LENGTH))) ELSE
        '0';
    zf <= zero_flag WHEN flags_en = '1' AND op /= ALU_NOP ELSE
        zf_in;

    result <= res;

END Behavioral;
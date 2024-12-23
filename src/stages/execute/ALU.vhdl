LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        A                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        B                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        flag                : IN STD_LOGIC;
        jump                : IN STD_LOGIC;
        Sel                 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CF_in, NF_in, ZF_in : IN STD_LOGIC;
        Result              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        CF, NF, ZF          : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL res, result_and, result_not, result_add, result_inc, result_sub : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL carry_add, carry_inc, neg_sub                                   : STD_LOGIC;
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
            a  => A,
            b  => B,
            y  => result_sub,
            nf => neg_sub
        );

    -- WHY AREN'T YOU USING MUX HERE?
    res <= result_and WHEN Sel = "000" ELSE
        result_not WHEN Sel = "001" ELSE
        result_add WHEN Sel = "010" ELSE
        result_inc WHEN Sel = "011" ELSE
        result_sub WHEN Sel = "100" ELSE
        A WHEN Sel = "101" ELSE
        (OTHERS => '0');

    CF <= '0' WHEN jump = '1' ELSE
        carry_add WHEN (Sel = "010" AND flag = '0') ELSE
        carry_inc WHEN (Sel = "011" AND flag = '0') ELSE
        CF_in;

    NF <= '0' WHEN jump = '1' ELSE
        neg_sub WHEN (Sel = "100" AND flag = '0') ELSE
        NF_in;

    ZF <= '0' WHEN jump = '1' ELSE
        '1' WHEN (res = "0000000000000000" AND flag = '0') ELSE
        ZF_in;

    Result <= res;

END Behavioral;
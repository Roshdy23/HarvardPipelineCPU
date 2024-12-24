LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        A                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        B                   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Sel                 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CF_in, NF_in, ZF_in : IN STD_LOGIC;
        Result              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        CF, NF, ZF          : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
COMPONENT AndN
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        b : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT NotN
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT AddN
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a  : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        b  : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        y  : OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        cf : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT IncN
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a  : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        y  : OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        cf : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT SubN
    GENERIC (
        W : INTEGER := 16
    );
    PORT (
        a  : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        b  : IN  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        y  : OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0);
        nf : OUT STD_LOGIC
    );
END COMPONENT;
    SIGNAL res, result_and, result_not, result_add, result_inc, result_sub : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL carry_add, carry_inc, neg_sub                                   : STD_LOGIC;
BEGIN

    uut_and16 :  AndN
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a => A,
            b => B,
            y => result_and
        );

    -- Instantiate Not16
    uut_Not16 : NotN
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a => A,
            y => result_not
        );

    -- Instantiate add16
    uut_add16 :  AddN
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
    uut_inc16 :  IncN
        GENERIC MAP(
            W => 16
        )
        PORT MAP(
            a  => A,
            y  => result_inc,
            cf => carry_inc
        );

    uut_sub16 : SubN
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

    CF <= 
        carry_add WHEN (Sel = "010") ELSE
        carry_inc WHEN (Sel = "011") ELSE
        CF_in;

    NF <= 
        neg_sub WHEN (Sel = "100") ELSE
        NF_in;

    ZF <=
        '1' WHEN (res = "0000000000000000" ) ELSE
        ZF_in;

    Result <= res;

END Behavioral;
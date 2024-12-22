library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
        A       : in  STD_LOGIC_VECTOR(15 downto 0);
        B       : in  STD_LOGIC_VECTOR(15 downto 0);
        flag    : in  std_logic;
        jump    : in  std_logic;
        Sel     : in  STD_LOGIC_VECTOR(2 downto 0);
        CF_in, NF_in, ZF_in : in std_logic;
        Result  : out STD_LOGIC_VECTOR(15 downto 0);
        CF, NF, ZF : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
    -- Component declarations

    component Sub16 
    port (
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        Result : out std_logic_vector(15 downto 0);
        NF : out std_logic
    );
    end component;
   
    component and16
        port(
            A, B : in  std_logic_vector(15 downto 0);
            Y : out std_logic_vector(15 downto 0)
        );
    end component;

    component Not16
        port(
            A : in  std_logic_vector(15 downto 0);
            Y : out std_logic_vector(15 downto 0)
        );
    end component;

    component add16
        port(
            A, B : in  std_logic_vector(15 downto 0);
            Y : out std_logic_vector(15 downto 0);
            CF : out std_logic
        );
    end component;

    component inc16
        port(
            A : in  std_logic_vector(15 downto 0);
            Y : out std_logic_vector(15 downto 0);
            CF : out std_logic
        );
    end component;

    
    signal res, result_and, result_not, result_add, result_inc, result_sub : std_logic_vector(15 downto 0);
    signal carry_add, carry_inc, neg_sub : std_logic;
begin

    uut_and16: and16
    port map(
        A => A,
        B => B,
        Y => result_and
    );

-- Instantiate Not16
uut_Not16: Not16
    port map(
        A => A,
        Y => result_not
    );

-- Instantiate add16
uut_add16: add16
    port map(
        A => A,
        B => B,
        Y => result_add,
        CF => carry_add
    );

-- Instantiate inc16
uut_inc16: inc16
    port map(
        A => A,
        Y => result_inc,
        CF => carry_inc
    );

uut_sub16: Sub16
    port map(
        A => A,
        B => B,
        Result => result_sub,
        NF => neg_sub
    );


    res <= result_and when Sel = "000" else
              result_not when Sel = "001" else
              result_add when Sel = "010" else
              result_inc when Sel = "011" else
              result_sub when Sel = "100" else
              A           when Sel = "101" else 
              (others => '0');

    CF <= '0' when jump = '1' else
        carry_add when (Sel = "010" and flag = '0') else
        carry_inc when (Sel = "011" and flag = '0') else
        CF_in;

    NF <= '0' when jump = '1' else
        neg_sub when (Sel = "100" and flag = '0') else
        NF_in;

    ZF <= '0' when jump = '1' else
        '1' when (res = "0000000000000000" and flag = '0') else
        ZF_in;

    Result <= res;
    
end Behavioral;
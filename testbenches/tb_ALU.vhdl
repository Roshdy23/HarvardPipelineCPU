library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end tb_ALU;

architecture behavior of tb_ALU is

    -- Component Declaration for the ALU
    component ALU
        port(
            A       : in  STD_LOGIC_VECTOR(15 downto 0);
        B       : in  STD_LOGIC_VECTOR(15 downto 0);
        Sel     : in  STD_LOGIC_VECTOR(2 downto 0);
        CF_in, NF_in, ZF_in : in std_logic;
        Result  : out STD_LOGIC_VECTOR(15 downto 0);
        CF, NF, ZF : out std_logic
    );
    end component;

    -- Inputs
    signal A1       : std_logic_vector(15 downto 0) := (others => '0');
    signal B1      : std_logic_vector(15 downto 0) := (others => '0');
    signal Op      : std_logic_vector(2 downto 0) := (others => '0');

    -- Outputs
    signal Result1  : std_logic_vector(15 downto 0);
    signal Zero    : std_logic;
    signal Carry   : std_logic;
    signal Negative: std_logic;

    signal Zero_out    : std_logic;
    signal Carry_out   : std_logic;
    signal Negative_out: std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ALU port map (
        A => A1,
        B => B1,
        Sel => Op,
        CF_in => Carry,
        NF_in => Negative,
        ZF_in => Zero,
        Result => Result1,
        CF => Carry_out,
        NF =>  Negative_out,
        ZF => Zero_out
    );

     process
    begin
       
        A1 <= x"0001";
        B1 <= x"0001";
        Op <= "000"; 
        Zero <= '0';
        Carry <= '0';
        Negative <= '0';
        wait for 10 ns;
        assert (Result1 = x"0002") report "Test 1 failed" severity error;

        A1 <= x"0003";
        B1 <= x"0001";
        Op <= "001"; 
        Zero <= '0';
        Carry <= '0';
        Negative <= '0';
        wait for 10 ns;
        assert (Result1 = x"0002") report "Test 2 failed" severity error;

        A1 <= x"000F";
        B1 <= x"00F0";
        Op <= "010";
        Zero <= '0';
        Carry <= '0';
        Negative <= '0';
        wait for 10 ns;
        assert (Result1 = x"00FF") report "Test 3 failed" severity error;

        A1 <= x"000F";
        B1 <= x"00F0";
        Op <= "011"; 
        Zero <= '0';
        Carry <= '0';
        Negative <= '0';
        wait for 10 ns;
        assert (Result1 = x"0000") report "Test 4 failed" severity error;

        A1 <= x"000F";
        B1 <= x"00F0";
        Op <= "100"; 
        Zero <= '0';
        Carry <= '0';
        Negative <= '0';
        wait for 10 ns;
        assert (Result1 = x"000F") report "Test 5 failed" severity error;



        wait;
    end process;

end behavior;
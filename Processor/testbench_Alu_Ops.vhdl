-- filepath: /home/youssef-roshdy/Public/CMP/ARCH-PROJ/HarvardPipelineCPU/Processor/testbench_Alu_Ops.vhdl
-- Testbench for and16, Not16, add16, and inc16
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_Alu_Ops is
end testbench_Alu_Ops;

architecture Behavioral of testbench_Alu_Ops is

    -- Component declarations
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

    -- Signals for testing
    signal a1, b1 : std_logic_vector(15 downto 0);
    signal result_and, result_not, result_add, result_inc : std_logic_vector(15 downto 0);
    signal carry_add, carry_inc : std_logic;

begin
    -- Instantiate and16
    uut_and16: and16
        port map(
            A => a1,
            B => b1,
            Y => result_and
        );

    -- Instantiate Not16
    uut_Not16: Not16
        port map(
            A => a1,
            Y => result_not
        );

    -- Instantiate add16
    uut_add16: add16
        port map(
            A => a1,
            B => b1,
            Y => result_add,
            CF => carry_add
        );

    -- Instantiate inc16
    uut_inc16: inc16
        port map(
            A => a1,
            Y => result_inc,
            CF => carry_inc
        );

    -- Test process
    process
    begin
        -- Test vectors
        a1 <= x"1234";
        b1 <= x"5678";
        wait for 10 ns;

        -- Output results
        assert result_and = (a1 and b1)
            report "AND16 test failed" severity error;
        assert result_not = not a1
            report "Not16 test failed" severity error;
        assert (unsigned(result_add) = unsigned(a1) + unsigned(b1)) and (carry_add = '0')
            report "ADD16 test failed" severity error;
        assert (unsigned(result_inc) = unsigned(a1) + 1) and (carry_inc = '0')
            report "INC16 test failed" severity error;

        wait;
    end process;

end Behavioral;
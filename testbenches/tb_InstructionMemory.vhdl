library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_ram is
end tb_ram;

architecture behavior of tb_ram is

    -- Component Declaration for the Unit Under Test (UUT)
    component Ram
        generic (
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 12
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            we       : in  std_logic;
            re       : in  std_logic;
            address  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            data_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;

    -- Test bench signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal we       : std_logic := '0';
    signal re       : std_logic := '0';
    signal address  : std_logic_vector(11 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(15 downto 0) := (others => '0');
    signal data_out : std_logic_vector(15 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Ram
        generic map (
            DATA_WIDTH => 16,
            ADDR_WIDTH => 12
        )
        port map (
            clk      => clk,
            rst      => rst,
            we       => we,
            re       => re,
            address  => address,
            data_in  => data_in,
            data_out => data_out
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Test procedure
    test_process: process
        variable passed_tests : integer := 0;
    begin
        -- hold reset state for 20 ns.
        rst <= '0';
        wait for 20 ns;
        rst <= '1';

        -- Write data 0x1234 to address 0x000
        we <= '1';
        re <= '0';
        address <= x"000";
        data_in <= x"1234";
        wait for clk_period;

        -- Read data from address 0x000
        we <= '0';
        re <= '1';
        address <= x"000";
        wait for clk_period;
        assert data_out = x"1234" report "Test 1 failed: data_out /= x1234" severity failure;
        if data_out = x"1234" then
            passed_tests := passed_tests + 1;
            report "Test 1 passed: data_out = x1234" severity note;
        end if;

        -- Write data 0x5678 to address 0x004
        we <= '1';
        re <= '0';
        address <= x"004";
        data_in <= x"5678";
        wait for clk_period;

        -- Read data from address 0x004
        we <= '0';
        re <= '1';
        address <= x"004";
        wait for clk_period;
        assert data_out = x"5678" report "Test 2 failed: data_out /= x5678" severity failure;
        if data_out = x"5678" then
            passed_tests := passed_tests + 1;
            report "Test 2 passed: data_out = x5678" severity note;
        end if;

        -- Reset at the end
        rst <= '0';
        wait for 20 ns;
        rst <= '1';

        -- Display number of passed tests
        if passed_tests = 2 then
            report "2/2 All tests passed" severity note;
        else
            report integer'image(passed_tests) & " tests passed" severity error;
        end if;

        -- Finish simulation
        wait;
    end process;

end behavior;
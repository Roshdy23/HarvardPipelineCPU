library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_register_file is
end tb_register_file;

architecture Behavioral of tb_register_file is

    signal clk         : std_logic := '0';                                  -- Clock signal
    signal we          : std_logic := '0';                                  -- Write enable
    signal read_reg1   : std_logic_vector(2 downto 0) := "000";             -- Read register 1
    signal read_reg2   : std_logic_vector(2 downto 0) := "000";             -- Read register 2
    signal write_reg   : std_logic_vector(2 downto 0) := "000";             -- Write register
    signal write_data  : std_logic_vector(31 downto 0) := (others => '0');  -- Write data
    signal read_data1  : std_logic_vector(31 downto 0);                     -- Read data 1
    signal read_data2  : std_logic_vector(31 downto 0);                     -- Read data 2

    component register_file
        Port (
            clk         : in  std_logic;
            we          : in  std_logic;
            read_reg1   : in  std_logic_vector(2 downto 0);
            read_reg2   : in  std_logic_vector(2 downto 0);
            write_reg   : in  std_logic_vector(2 downto 0);
            write_data  : in  std_logic_vector(31 downto 0);
            read_data1  : out std_logic_vector(31 downto 0);
            read_data2  : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    uut: register_file
        Port map (
            clk         => clk,
            we          => we,
            read_reg1   => read_reg1,
            read_reg2   => read_reg2,
            write_reg   => write_reg,
            write_data  => write_data,
            read_data1  => read_data1,
            read_data2  => read_data2
        );

    -- Clock: 20ns clock period
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Test procedure
    test_process : process
    begin
        wait for 20 ns;              -- Wait for clock to stabilize
        -- Test 1: Write to register 1 and read back
        write_reg <= "001";          -- Select register 1
        write_data <= X"12345678";   -- Data to write
        we <= '1';                   -- Enable write
        wait for 10 ns;              -- Wait for rising edge
        we <= '0';                   -- Disable write

        read_reg1 <= "001";          -- Read register 1
        wait for 10 ns;              -- Wait for falling edge
        assert read_data1 = X"12345678" report "Test 1 failed: Read data does not match write data" severity error;

        -- Test 2: Write to register 2 and read back
        write_reg <= "010";          -- Select register 2
        write_data <= X"87654321";   -- Data to write
        we <= '1';                   -- Enable write
        wait for 10 ns;              -- Wait for rising edge
        we <= '0';                   -- Disable write

        read_reg2 <= "010";          -- Read register 2
        wait for 10 ns;              -- Wait for falling edge
        assert read_data2 = X"87654321" report "Test 2 failed: Read data does not match write data" severity error;

        -- Test 3: Write to register 1 without write enable
        write_reg <= "001";          -- Select register 1
        write_data <= X"87654321";   -- Data to write
        we <= '0';                   -- Disable write
        wait for 10 ns;              -- Wait for rising edge

        read_reg1 <= "001";          -- Read register 1
        wait for 10 ns;              -- Wait for falling edge
        assert read_data1 /= X"87654321" report "Test 3 failed: Data should not have been written" severity error;

        wait;
    end process;

end Behavioral;

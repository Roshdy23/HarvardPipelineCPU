library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        clk         : in STD_LOGIC;                             -- Clock
        rst         : in STD_LOGIC;                             -- Reset
        we          : in STD_LOGIC;                             -- Write enable
        read_reg1   : in STD_LOGIC_VECTOR(2 downto 0);          -- Read register 1
        read_reg2   : in STD_LOGIC_VECTOR(2 downto 0);          -- Read register 2
        write_reg   : in STD_LOGIC_VECTOR(2 downto 0);          -- Write register
        write_data  : in STD_LOGIC_VECTOR(15 downto 0);         -- Write data
        read_data1  : out STD_LOGIC_VECTOR(15 downto 0);        -- Read data 1
        read_data2  : out STD_LOGIC_VECTOR(15 downto 0)         -- Read data 2
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin

    -- Reset
    process(rst)
    begin
        if rst = '0' then
            registers <= (others => (others => '0'));
        end if;
    end process;

    -- Read data
    process(read_reg1, read_reg2, registers)
    begin
        read_data1 <= registers(to_integer(unsigned(read_reg1)));
        read_data2 <= registers(to_integer(unsigned(read_reg2)));
    end process;

    -- Write operation: In the first half of the clock cycle
    process(clk)
    begin
        if rst = '1' and rising_edge(clk) then
            if we = '1' then
                registers(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;

    -- Read operation: In the second half of the clock cycle
    process(clk)
    begin
        if rst = '1' and falling_edge(clk) then
            read_data1 <= registers(to_integer(unsigned(read_reg1)));
            read_data2 <= registers(to_integer(unsigned(read_reg2)));
        end if;
    end process;

end Behavioral;
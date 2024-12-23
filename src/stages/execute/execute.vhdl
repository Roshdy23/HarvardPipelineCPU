library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity execute is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        alu_op      : in  STD_LOGIC_VECTOR(3 downto 0);
        read_data1    : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data2    : in  STD_LOGIC_VECTOR(15 downto 0);
        immediate   : in  STD_LOGIC_VECTOR(15 downto 0);
        input_port : in  STD_LOGIC_VECTOR(15 downto 0);
        pc_in         : in  STD_LOGIC_VECTOR(15 downto 0); 
        alu_sel     : in  STD_LOGIC_VECTOR(2 downto 0);
        control_unit_sel_1 : in  STD_LOGIC;
        foward_unit_sel_1 : in  STD_LOGIC_VECTOR(1 downto 0);
        control_unit_sel_2 : in  STD_LOGIC;
        foward_unit_sel_2 : in  STD_LOGIC_VECTOR(1 downto 0);
        pc_out       : out STD_LOGIC_VECTOR(15 downto 0);
    );
end execute;

architecture Behavioral of execute is


end Behavioral;
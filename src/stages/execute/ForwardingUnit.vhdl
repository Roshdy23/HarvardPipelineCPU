LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ForwardingUnit IS
    PORT (
        src1      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        src2      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        mem_wb_rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sel_a     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        sel_b     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ex_mem_wb_en : IN STD_LOGIC;
        mem_wb_wb_en : IN STD_LOGIC
    );
END ForwardingUnit;

ARCHITECTURE Behavioral OF ForwardingUnit IS
BEGIN
    -- Logic for sel_a
    sel_a <= "10" WHEN src1 = ex_mem_rdst AND ex_mem_wb_en = '1' 
            ELSE "11" WHEN src1 = mem_wb_rdst AND mem_wb_wb_en = '1' 
            ELSE "00";

    -- Logic for sel_b
    sel_b <= "10" WHEN src2 = ex_mem_rdst AND ex_mem_wb_en = '1' 
            ELSE "11" WHEN src2 = mem_wb_rdst AND mem_wb_wb_en = '1' 
            ELSE "00";
END Behavioral;

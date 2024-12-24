library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HDU is
    Port (
        EPC : in STD_LOGIC_VECTOR(15 downto 0);
        Exception : in STD_LOGIC;
        id_ie_rsrc1 : in STD_LOGIC_VECTOR(15 downto 0);
        id_ie_rsrc2 : in STD_LOGIC_VECTOR(15 downto 0);
        if_id_rsrc1 : in STD_LOGIC_VECTOR(15 downto 0);
        branch_detector : in STD_LOGIC;
        ie_mem_rdst : in STD_LOGIC_VECTOR(15 downto 0);
        ie_mem_wb : in STD_LOGIC;
        mem_wb_int : in STD_LOGIC;
        mem_wb_call : in STD_LOGIC;
        mem_wb_rti : in STD_LOGIC;
        mem_wb_ret : in STD_LOGIC;
        if_id_pc : in STD_LOGIC_VECTOR(15 downto 0);
        NOP : in STD_LOGIC;
        branch_prediction : in STD_LOGIC;
        
        NOP_if_id : out STD_LOGIC;
        NOP_id_ie : out STD_LOGIC;
        NOP_IE_MEM : out STD_LOGIC;
        NOP_MEM_WB : out STD_LOGIC;
        flush_if_id : out STD_LOGIC;
        flush_id_ie : out STD_LOGIC;
        pc_enable : out STD_LOGIC
    );
end HDU;
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
        branch_detector : in STD_LOGIC;
        ie_mem_rdst : in STD_LOGIC_VECTOR(15 downto 0);
        ie_mem_wb : in STD_LOGIC;
        CU_int : in STD_LOGIC;
        CU_call : in STD_LOGIC;
        CU_rti : in STD_LOGIC;
        CU_ret : in STD_LOGIC;
        if_id_pc : in STD_LOGIC_VECTOR(15 downto 0);
        NOP : in STD_LOGIC;
        mem_wb_rsrc1 :  in STD_LOGIC_VECTOR(15 downto 0);
        take_pc      : in std_logic;  -- make it equal one in case of not call or not interrupt
        if_id_rsrc1   : in STD_LOGIC_VECTOR(15 downto 0);
        
        NOP_if_id : out STD_LOGIC;
        NOP_id_ie : out STD_LOGIC;
        flush_IE_MEM : out STD_LOGIC;
        flush_MEM_WB : out STD_LOGIC;
        flush_if_id : out STD_LOGIC;
        flush_id_ie : out STD_LOGIC;
        pc_enable : out STD_LOGIC;
        pc : out STD_LOGIC_VECTOR(15 downto 0);
    );
end HDU;

architecture Behavioral of HDU is
    signal store_pc : in STD_LOGIC_VECTOR(15 downto 0);
begin

flush_IE_MEM <= '1' when Exception = '1' else '0';
flush_MEM_WB <= '1' when Exception = '1' else '0';
flush_if_id <= '1' when (Exception = '1') or (branch_detector = '1')  
or ((CU_int = '1') or (CU_call = '1')) or ((CU_rti = '1') or (CU_ret = '1'))    else '0';

flush_id_ie <= '1' when (Exception = '1') or (branch_detector = '1')  else '0';

pc <= EPC when Exception = '1' else 
    if_id_pc when ((id_ie_rsrc1 = ie_mem_rdst) and (ie_mem_wb = '1')) or 
            ((id_ie_rsrc2 = ie_mem_rdst) and (ie_mem_wb = '1')) 
    else id_ie_rsrc1 when (branch_detector = '1')
    else if_id_rsrc1 when ((CU_int = '1') or (CU_call = '1')) 
    else store_pc when or ((CU_rti = '1') or (CU_ret = '1') )   
    else (others => '0');

pc_enable <= '1' when Exception = '1' else 
 '1' when ((id_ie_rsrc1 = ie_mem_rdst) and (ie_mem_wb = '1')) or 
    ((id_ie_rsrc2 = ie_mem_rdst) and (ie_mem_wb = '1')) or ((CU_int = '1') or (CU_call = '1')) 
    (branch_detector = '1')  or ((CU_rti = '1') or (CU_ret = '1'))    else 
    '0' ;

NOP_if_id <= '1' when  (((id_ie_rsrc1 = ie_mem_rdst) and (ie_mem_wb = '1')) or 
((id_ie_rsrc2 = ie_mem_rdst) and (ie_mem_wb = '1')) or (NOP = '1')) else
    '0';


NOP_id_ie <= '1' when  (((id_ie_rsrc1 = ie_mem_rdst) and (ie_mem_wb = '1')) or 
((id_ie_rsrc2 = ie_mem_rdst) and (ie_mem_wb = '1'))) else '0';

store_pc <= if_id_pc when take_pc = '1' else '0';



else ('0');



end Behavioral;
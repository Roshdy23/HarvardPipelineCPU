Library IEEE;
Use ieee.std_logic_1164.all;


Entity Preserved_CCR is
    port(rst,clk                      :in  std_logic;
         Flags_in                     :in  std_logic_vector (2 downto 0);
         Flags_Restor                 :out std_logic_vector (2 downto 0)
         );
End Entity Preserved_CCR;

Architecture arch_Preserved_CCR Of Preserved_CCR Is
    signal temp_Flags_Restor : std_logic_vector (2 downto 0);
    BEGIN
       process(clk,rst)
       begin
            if rst='1' then
               Flags_Restor <= (others=>'0');
            elsif rising_edge (clk) then 
                 flags_Restor <= Flags_in;
            end if;  
        end process;
End arch_Preserved_CCR;      
         

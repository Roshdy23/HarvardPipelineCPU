library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
  Entity Mux2 is
    port(A,B :in std_logic_vector(2 downto 0);
         S   :in std_logic;
         Z   :out std_logic_vector(2 downto 0)
         );
  End Mux2;
 
Architecture Arch_Mux2 of Mux2 is 
   begin
       Z <=   A when s='0'
         else B;
 End Arch_Mux2;




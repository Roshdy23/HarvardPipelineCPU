Library IEEE;
Use ieee.std_logic_1164.all;

ENTITY FU IS
	PORT (Rsrc1, Rsrc2: IN std_logic_vector(15 DOWNTO 0);
		    ExMemRdst: IN std_logic_vector(15 DOWNTO 0);
		    MemWbRdst : IN std_logic_vector(15 DOWNTO 0);
		    sela : OUT std_logic_vector( 0 TO 1);
		    selb: OUT std_logic_vector(0 TO 1);
		    ExMemWbEn, MemWbWbEn: IN std_logic;
	       );
END FU;

ARCHITECTURE archFU OF FU IS
	BEGIN
        sela <= "10" WHEN Rsrc1=ExMemRdst AND ExMemWbEn='1' 
		ELSE  "11" WHEN Rsrc1=MemWbRdst AND MemWbWbEn='1' 
		ELSE "00";
		
        selb <= "10" WHEN Rsrc2=ExMemRdst AND ExMemWbEn='1' 
		ELSE  "11" WHEN Rsrc2=MemWbRdst AND MemWbWbEn='1' 
		ELSE "00";
END archFU;


--
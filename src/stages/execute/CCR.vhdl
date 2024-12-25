LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
ENTITY CCR IS
   PORT (
      clk         : IN STD_LOGIC;
      rst         : IN STD_LOGIC;
      flags_in    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      flags_reset : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      flags_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
   );
END ENTITY CCR;

ARCHITECTURE Behavioral OF CCR IS
BEGIN
   PROCESS (clk, rst)
   BEGIN
      IF rst = '0' THEN
         flags_out <= (OTHERS => '0');
      ELSIF rising_edge(clk) THEN
         flags_out <= flags_in AND NOT flags_reset;
      END IF;
   END PROCESS;
END Behavioral;
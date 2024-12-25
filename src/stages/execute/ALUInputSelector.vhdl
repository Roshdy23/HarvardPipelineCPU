library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUInputSelector is
    Port (
        forword_unit_sel: in STD_LOGIC_VECTOR(0 to 1);
        ctrl_unit_sel : in STD_LOGIC;
        result : in STD_LOGIC_VECTOR(15 downto 0);
        write_back : in STD_LOGIC_VECTOR(15 downto 0);
        input1 : in STD_LOGIC_VECTOR(15 downto 0);
        input2 : in STD_LOGIC_VECTOR(15 downto 0);
        outp : out STD_LOGIC_VECTOR(15 downto 0)
    );
end ALUInputSelector;

ARCHITECTURE Behavioral OF ALUInputSelector IS
BEGIN
    PROCESS(forword_unit_sel, ctrl_unit_sel, result, write_back, input1, input2)
    BEGIN
        CASE forword_unit_sel IS
            WHEN "00" => -- No forwarding
                if ctrl_unit_sel = '0' then
                    outp <= input1;
                else
                    outp <= input2;
                end if;

            WHEN "01" => -- Forward RS1
                outp <= input1;

            WHEN "10" => -- Forward ALU Result
                outp <= result;

            WHEN "11" => -- Write-back
                outp <= write_back;

            WHEN OTHERS =>
                outp <= (OTHERS => '0'); -- Default to zero in undefined cases
        END CASE;
    END PROCESS;
END Behavioral;
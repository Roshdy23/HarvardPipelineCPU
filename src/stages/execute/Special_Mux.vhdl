library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Special_Mux is
    Port (
        forword_unit_sel: in STD_LOGIC_VECTOR(0 to 1);
        ctrl_unit_sel : in STD_LOGIC;
        result : in STD_LOGIC_VECTOR(0 to 15);
        write_back : in STD_LOGIC_VECTOR(0 to 15);
        input1 : in STD_LOGIC_VECTOR(0 to 15);
        input2 : in STD_LOGIC_VECTOR(0 to 15);
        outp : out STD_LOGIC_VECTOR(0 to 15)
    );
end Special_Mux;

architecture Behavioral of Special_Mux is
begin
    process(forword_unit_sel, ctrl_unit_sel, result, write_back, input1, input2)
    begin
        if forword_unit_sel(0) = '0' then
            if ctrl_unit_sel = '1' then
                outp <= result;
            else
                outp <= write_back;
            end if;
        else 
            if forword_unit_sel(1) = '0' then
                outp <= input1;
            else
                outp <= input2;
            end if;
        end if;

    end process;
end Behavioral;
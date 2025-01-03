LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ARCHITECTURE InstructionMemory OF Ram IS
    -- 4K * 16 bits memory
    -- Define the RAM type
    TYPE ram_type IS ARRAY (0 TO (2 ** ADDR_WIDTH) - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    -- Impure function to initialize RAM from the generated file from the assembler
    IMPURE FUNCTION init_ram_bin RETURN ram_type IS
        FILE text_file : TEXT OPEN READ_MODE IS "instructions.txt";
        VARIABLE line : LINE;
        VARIABLE ram_content : ram_type := (OTHERS => (OTHERS => '0'));
        VARIABLE bv : bit_vector(ram_content(0)'RANGE);
        VARIABLE i : INTEGER := 0;
    BEGIN
        WHILE NOT ENDFILE(text_file) LOOP
            READLINE(text_file, line);
            READ(line, bv);
            ram_content(i) := to_stdlogicvector(bv);
            i := i + 1;
        END LOOP;
        RETURN ram_content;
    END init_ram_bin;

    -- RAM initialization
    SIGNAL ram : ram_type := init_ram_bin;

BEGIN

    PROCESS (clk, rst, address)
    BEGIN
        IF rst = '0' THEN
            data_out <= (OTHERS => '0');
            ram <= init_ram_bin;
        ELSE
            IF we = '1' AND rising_edge(clk) THEN
                ram(to_integer(unsigned(address))) <= data_in;
            END IF;
            IF re = '1' THEN
                data_out <= ram(to_integer(unsigned(address)));
            END IF;
        END IF;
    END PROCESS;

END InstructionMemory;
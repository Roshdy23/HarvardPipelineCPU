import os

R_TYPE = {'NOT': 2, 'INC': 2, 'MOV': 2, 'ADD': 3, 'SUB': 3, 'AND': 3}
I_TYPE = {'IADD': 3, 'LDM': 2, 'LDD': 2, 'STD': 2}
J_TYPE = {'JZ': 1, 'JN': 1, 'JC': 1, 'JMP': 1, 'CALL': 1, 'RET': 0, 'RTI': 0, 'INT': 1}
O_TYPE = {'NOP': 0, 'HLT': 0, 'SETC': 0, 'OUT': 1, 'IN': 1, 'PUSH': 1, 'POP': 1}
NOP = '1100000000000000'


def get_opcode(instruction_name):
    if instruction_name == '.ORG':
        return 'ORG', '00', 0
    if instruction_name in R_TYPE:
        return '00', format(list(R_TYPE.keys()).index(instruction_name), '03b'), R_TYPE[instruction_name]
    if instruction_name in I_TYPE:
        return '01', format(list(I_TYPE.keys()).index(instruction_name), '03b'), I_TYPE[instruction_name]
    if instruction_name in J_TYPE:
        return '10', format(list(J_TYPE.keys()).index(instruction_name), '03b'), J_TYPE[instruction_name]
    if instruction_name in O_TYPE:
        return '11', format(list(O_TYPE.keys()).index(instruction_name), '03b'), O_TYPE[instruction_name]
    raise ValueError(f'Invalid instruction: {instruction_name}')


def read_instructions_from_text_file(input_file_name):
    with open(input_file_name, 'r') as file:
        program_instructions = file.readlines()
    return program_instructions


def write_to_line(file_path, target_line, insert_string, fill_string=NOP):
    # Ensure the target line is within the desired range
    if not (0 <= target_line <= 4095):
        raise ValueError("target_line must be between 0 and 4095 inclusive.")

    # Read the existing content of the file if it exists
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()
    else:
        lines = []

    # Ensure the list has at least 4096 lines
    while len(lines) <= 4095:
        lines.append(fill_string + '\n')

    # Insert the specified string at the target line
    lines[target_line] = insert_string + '\n'

    # Write the modified content back to the file
    with open(file_path, 'w') as file:
        file.writelines(lines)


def check_operand(operand):
    if operand.isdigit():
        return True

    if operand[0] == '#' and operand[1:].isdigit():
        return True

    if len(operand) != 2 or operand[0] != 'R' or not operand[1].isdigit():
        return False

    return True


def get_operand(operand):
    if '(' in operand and ')' in operand:
        operand = operand.replace('(', ' ').replace(')', '')
        operand = operand.split()
        if not check_operand(operand[1][1]):
            raise ValueError(f'Invalid register: {operand[1][1]}')
        return format(int(operand[1][1]), '03b'), format(int(operand[0]), '16b')

    operand = operand.replace(',', '')

    if not check_operand(operand):
        raise ValueError(f'Invalid operand: {operand}')

    if operand.isdigit():
        return '000', format(int(operand), '16b')

    if operand[0] == '#' and operand[1:].isdigit():
        return '000', format(int(operand[1:]), '16b')

    return format(int(operand[1]), '03b'), None


def write_instructions_to_bin_file(program_instructions, output_file_name):
    current_address = 0
    for instruction in program_instructions:
        instruction = instruction.strip()  # Remove leading and trailing whitespaces
        instruction = instruction.upper()  # Convert instruction to uppercase
        instruction = instruction.split(';')[0]  # Remove comments
        if instruction == '':
            continue
        instruction = instruction.replace(',', ' ')  # Replace commas with spaces
        instruction = instruction.split()  # Split instruction into token
        opcode, funct, number_of_operands = get_opcode(instruction[0])
        if opcode == 'ORG':
            print(opcode)
            current_address = int(instruction[1], 16)
            continue

        print(instruction)
        Rdst = '000'
        Rsrc1 = '000'
        Rsrc2 = '000'
        index = '00'
        imm = None
        instruction_bit_ditail = '0' * 16
        if number_of_operands == 0:
            instruction_bit_ditail = (opcode + funct).ljust(16, '0')
        elif number_of_operands == 1:
            last_operand = ''
            if opcode == '10' and funct == '111':
                if check_operand(instruction[1]):
                    index = last_operand = format(int(instruction[1][1:]), '02b')
                else:
                    ValueError(f'Invalid operand: {instruction[1]}')
            elif opcode == '11' and (funct == '100' or funct == '110'):
                last_operand, _ = get_operand(instruction[1])
            else:
                Rsrc1, _ = get_operand(instruction[1])

            instruction_bit_ditail = (opcode + funct + Rsrc1 + last_operand).ljust(16, '0')
        elif number_of_operands == 2:
            Rdst, _ = get_operand(instruction[1])
            Rsrc1, imm = get_operand(instruction[2])
            instruction_bit_ditail = (opcode + funct + Rsrc1 + Rsrc2 + Rdst).ljust(16, '0')
        elif number_of_operands == 3:
            Rdst, _ = get_operand(instruction[1])
            Rsrc1, _ = get_operand(instruction[2])
            Rsrc2, imm = get_operand(instruction[3])
            instruction_bit_ditail = (opcode + funct + Rsrc1 + Rsrc2 + Rdst).ljust(16, '0')

        print(
            f'opcode: {opcode}, '
            f'funct: {funct}, '
            f'Rdst: {Rdst}, '
            f'Rsrc1: {Rsrc1}, '
            f'Rsrc2: {Rsrc2}, '
            f'index: {index}, '
            f'imm: {imm}')

        write_to_line(output_file_name, current_address, instruction_bit_ditail)
        current_address += 1
        if imm is not None:
            write_to_line(output_file_name, current_address, instruction_bit_ditail)
            current_address += 1


if __name__ == "__main__":
    input_file = 'program.txt'
    output_file = 'instructions.txt'
    instructions = read_instructions_from_text_file(input_file)
    write_instructions_to_bin_file(instructions, output_file)

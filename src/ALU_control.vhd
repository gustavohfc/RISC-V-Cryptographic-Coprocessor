library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity ALU_control is
	generic(
		WSIZE : natural
	);
	port(
		instruction  : in  std_logic_vector((WSIZE - 1) downto 0);
		ALU_function : out FUNCTION_TYPE
	);
end entity ALU_control;

architecture ALU_control_arch of ALU_control is
	constant FSIZE : natural := 4;

	alias opcode : std_logic_vector(6 downto 0) is instruction(6 downto 0);
	alias funct3 : std_logic_vector(2 downto 0) is instruction(14 downto 12);
	alias funct7 : std_logic_vector(6 downto 0) is instruction(31 downto 25);
begin

	control : process(instruction) is
	begin
		case opcode is
			when OPCODE_OP_IMM =>
				case funct3 is
					when FUNCT3_ADDI  => ALU_function <= ALU_ADD;
					when FUNCT3_SLTI  => ALU_function <= ALU_SLT;
					when FUNCT3_SLTIU => ALU_function <= ALU_SLTU;
					when FUNCT3_XORI  => ALU_function <= ALU_XOR;
					when FUNCT3_ORI   => ALU_function <= ALU_OR;
					when FUNCT3_ANDI  => ALU_function <= ALU_AND;
					when FUNCT3_SLLI  => ALU_function <= ALU_SLL;
					when FUNCT3_SRLI =>
						case funct7 is
							when FUNCT7_SRLI => ALU_function <= ALU_SRL;
							when FUNCT7_SRAI => ALU_function <= ALU_SRA;
						end case;
					when others => ALU_function <= ALU_ADD;
				end case;

			when OPCODE_OP =>
				case funct3 is
					when FUNCT3_ADD =>
						case funct7 is
							when FUNCT7_ADD => ALU_function <= ALU_ADD;
							when FUNCT7_SUB => ALU_function <= ALU_SUB;
						end case;
					when FUNCT3_SLL  => ALU_function <= ALU_SLL;
					when FUNCT3_SLT  => ALU_function <= ALU_SLT;
					when FUNCT3_SLTU => ALU_function <= ALU_SLTU;
					when FUNCT3_XOR  => ALU_function <= ALU_XOR;
					when FUNCT3_SRL =>
						case funct7 is
							when FUNCT7_SRL => ALU_function <= ALU_SRL;
							when FUNCT7_SRA => ALU_function <= ALU_SRA;
						end case;
					when FUNCT3_OR   => ALU_function <= ALU_OR;
					when FUNCT3_AND  => ALU_function <= ALU_AND;

					when others => ALU_function <= ALU_ADD;
				end case;
		end case;

	end process control;

end architecture ALU_control_arch;

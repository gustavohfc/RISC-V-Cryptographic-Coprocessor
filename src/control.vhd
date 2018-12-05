library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity control is
	generic(WSIZE : natural);

	port(
		instruction      : in  std_logic_vector(WSIZE - 1 downto 0);
		instruction_type : out instruction_type;
		ALU_select       : out std_logic
	);
end entity control;

architecture control_arch of control is
	alias opcode : std_logic_vector(6 downto 0) is instruction(6 downto 0);

begin

	process(instruction) is
	begin
		case opcode is
			when OPCODE_LOAD =>
				instruction_type <= I_type;
				ALU_select <= ULA_SELECT_IMM;

			when OPCODE_OP_IMM =>
				instruction_type <= I_type;
				ALU_select <= ULA_SELECT_IMM;

			when OPCODE_STORE =>
				instruction_type <= S_type;
				ALU_select <= ULA_SELECT_IMM;

			when OPCODE_OP =>
				instruction_type <= R_type;
				ALU_select <= ULA_SELECT_RS2;

			when OPCODE_LUI =>
				instruction_type <= U_type;
				ALU_select <= ULA_SELECT_IMM;

			when OPCODE_BRANCH =>
				instruction_type <= B_type;
				ALU_select <= ULA_SELECT_IMM;

			when OPCODE_JALR =>
				instruction_type <= I_type;
				ALU_select <= ULA_SELECT_IMM;
				
			when OPCODE_JAL =>
				instruction_type <= J_type;
				ALU_select <= ULA_SELECT_IMM;
		end case;
	end process;

end architecture control_arch;

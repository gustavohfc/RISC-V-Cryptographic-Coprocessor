library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity jump_control is
	generic(WSIZE : natural);
	port(
		r1, r2         : in  std_logic_vector(WSIZE - 1 downto 0);
		funct3         : in  std_logic_vector(2 downto 0);
		opcode         : in  std_logic_vector(6 downto 0);
		next_pc_select : out std_logic_vector(1 downto 0)
	);
end entity jump_control;

architecture jump_control_arch of jump_control is
begin

	process(opcode, funct3, r1, r2) is
	begin
		case opcode is
			when OPCODE_BRANCH =>
				if 	(funct3 = FUNCT3_BEQ and signed(r1) = signed(r2)) or
						(funct3 = FUNCT3_BNE and signed(r1) /= signed(r2)) or
						(funct3 = FUNCT3_BLT and signed(r1) < signed(r2)) or
						(funct3 = FUNCT3_BGE and signed(r1) > signed(r2)) or
						(funct3 = FUNCT3_BLTU and unsigned(r1) < unsigned(r2)) or
						(funct3 = FUNCT3_BGEU and unsigned(r1) > unsigned(r2)) then
					next_pc_select <= PC_SELECT_BR;
				else
					next_pc_select <= PC_SELECT_PLUS4;
				end if;

			when OPCODE_JALR =>
				next_pc_select <= PC_SELECT_JALR;

			when OPCODE_JAL =>
				next_pc_select <= PC_SELECT_JAL;

			when others =>
				next_pc_select <= PC_SELECT_PLUS4;
		end case;

	end process;

end architecture jump_control_arch;

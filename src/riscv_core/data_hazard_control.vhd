library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.riscv_core_constants.all;

entity data_hazard_control is
	port(
		clk              : in  std_logic;
		instruction      : in  std_logic_vector(WORD_SIZE - 1 downto 0);
		instruction_type : in  instruction_types;
		stall            : out std_logic
	);
end entity data_hazard_control;

architecture data_hazard_control_arch of data_hazard_control is
	constant ZERO                     : std_logic_vector(4 downto 0) := (others => '0');
	signal rq1, rq2, rq3              : std_logic_vector(4 downto 0) := (others => '0');
	signal stall_aux                  : std_logic;
	signal rs1_hazard, rs2_hazard     : std_logic;
	signal is_coprocessor_instruction : std_logic;
	signal rs1, rs2, rd               : std_logic_vector(4 downto 0);

begin
	stall <= stall_aux;

	is_coprocessor_instruction <= '1' when instruction(6 downto 0) = CRYPTOGRAPHIC_COPROCESSOR_OPCODE else '0';

	rs1 <= instruction(19 downto 15) when not is_coprocessor_instruction
		else instruction(19 downto 15) when instruction(31 downto 29) = FUNCT3_LW or instruction(31 downto 29) = FUNCT3_LAST or instruction(31 downto 29) = FUNCT3_DIGEST
	;

	rs2 <= instruction(24 downto 20) when not is_coprocessor_instruction
		else instruction(24 downto 20) when instruction(31 downto 29) = FUNCT3_LW
	;

	rd <= instruction(11 downto 7) when not is_coprocessor_instruction
		else instruction(24 downto 20) when instruction(31 downto 29) = FUNCT3_COMPLETED or instruction(31 downto 29) = FUNCT3_DIGEST
	;

	rs1_hazard <= '1' when (instruction_type = R_type or instruction_type = S_type or instruction_type = B_type or instruction_type = I_type) and (rs1 = rq1 or rs1 = rq2) and (rs1 /= ZERO) else '0';
	rs2_hazard <= '1' when (instruction_type = R_type or instruction_type = S_type or instruction_type = B_type) and (rs2 = rq1 or rs2 = rq2) and (rs2 /= ZERO) else '0';

	stall_aux <= '1' when rs2_hazard or rs1_hazard else '0';

	process(clk) is
	begin
		if rising_edge(clk) then
			if instruction_type = S_type or instruction_type = B_type or stall_aux = '1' then
				rq3 <= rq2;
				rq2 <= rq1;
				rq1 <= (others => '0');
			else
				rq3 <= rq2;
				rq2 <= rq1;
				rq1 <= rd;
			end if;
		end if;
	end process;

end architecture data_hazard_control_arch;

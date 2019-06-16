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
	constant ZERO                   : std_logic_vector(4 downto 0) := (others => '0');
	signal rq1, rq2, rq3            : std_logic_vector(4 downto 0) := (others => '0');
	signal coprocessor_funct3       : std_logic_vector(2 downto 0) := (others => '0');
	signal rs1_hazard, rs2_hazard   : std_logic;
	signal rs1, rs2, rd             : std_logic_vector(4 downto 0);
	signal has_rs1, has_rs2, has_rd : std_logic;

begin

	coprocessor_funct3 <= instruction(31 downto 29);

	has_rs1 <= '1' when instruction_type = R_type or instruction_type = S_type or instruction_type = B_type or instruction_type = I_type or (instruction_type = Coprocessor and coprocessor_funct3 = FUNCT3_LW) else '0';
	has_rs2 <= '1' when instruction_type = R_type or instruction_type = S_type or instruction_type = B_type or (instruction_type = Coprocessor and (coprocessor_funct3 = FUNCT3_LW or coprocessor_funct3 = FUNCT3_LAST or coprocessor_funct3 = FUNCT3_DIGEST)) else '0';
	has_rd  <= '1' when instruction_type = R_type or instruction_type = I_type or instruction_type = U_type or instruction_type = J_type or (instruction_type = Coprocessor and (coprocessor_funct3 = FUNCT3_BUSY or coprocessor_funct3 = FUNCT3_DIGEST)) else '0';

	rs1 <= instruction(19 downto 15) when has_rs1 else (others => '0');

	rs2 <= instruction(24 downto 20) when has_rs2 else (others => '0');

	rd <= instruction(11 downto 7) when stall /= '1' else (others => '0');

	rs1_hazard <= '1' when (rs1 = rq1 or rs1 = rq2) and (rs1 /= ZERO) else '0';
	rs2_hazard <= '1' when (rs2 = rq1 or rs2 = rq2) and (rs2 /= ZERO) else '0';

	stall <= '1' when rs2_hazard or rs1_hazard else '0';

	process(clk) is
	begin
		if rising_edge(clk) then
			rq3 <= rq2;
			rq2 <= rq1;
			rq1 <= rd;
		end if;
	end process;

end architecture data_hazard_control_arch;

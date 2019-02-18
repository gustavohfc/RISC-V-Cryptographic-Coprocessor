LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE STD.textio.all;
USE ieee.std_logic_textio.all;

use work.constants.all;

ENTITY integration_tb IS
	generic(
		runner_cfg : string;
		WSIZE      : natural;
		test_name  : string
	);
END integration_tb;

ARCHITECTURE integration_tb_arch OF integration_tb IS
	constant clk_period    : time                                     := 20 ps;
	signal clk             : std_logic                                := '1';
	signal stop            : std_logic                                := '0';
	signal instruction     : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');
	signal registers_array : ARRAY_32X32;

BEGIN
	riscv : entity work.RISCV
		generic map(
			WSIZE            => WSIZE,
			memory_init_file => test_name & ".mif"
		)

		port map(
			clk             => clk,
			instruction     => instruction,
			registers_array => registers_array
		);

	clk <= not clk after clk_period / 2 when stop = '0' else '0';

	main : PROCESS
		alias PC is <<signal riscv.PC_IF_ID : std_logic_vector(WORD_SIZE - 1 downto 0)>>;
	BEGIN
		test_runner_setup(runner, runner_cfg);

		wait until PC >= std_logic_vector(to_unsigned(24, WORD_SIZE));

		test_runner_cleanup(runner);
		wait;
	END PROCESS;

	watch_chnages : PROCESS(clk)
		file register_changes : text open write_mode is test_name & "_register_changes.txt";
		variable row          : line;

		alias register_write_enable is <<signal riscv.stage_ID_inst.registers.write_enable : std_logic>>;
		alias register_rd is <<signal riscv.stage_ID_inst.registers.rd : std_logic_vector(4 downto 0)>>;
		alias register_write_data is <<signal riscv.stage_ID_inst.registers.write_data : std_logic_vector(WSIZE - 1 downto 0)>>;
	BEGIN
		-- Watch changes to the registers
		if falling_edge(clk) and register_write_enable = '1' then
			write(row, to_string(register_rd), right);
			write(row, " " & to_string(register_write_data));
			writeline(register_changes, row);
		end if;
	END PROCESS;

END integration_tb_arch;

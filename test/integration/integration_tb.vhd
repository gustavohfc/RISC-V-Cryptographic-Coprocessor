LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE STD.textio.all;
USE ieee.std_logic_textio.all;

use work.constants.all;
use work.riscv_core_constants.all;

ENTITY integration_tb IS
	generic(
		runner_cfg : string;
		WSIZE      : natural;
		test_name  : string;
		PC_max     : natural
	);
END integration_tb;

ARCHITECTURE integration_tb_arch OF integration_tb IS
	constant clk_period : time      := 20 ps;
	signal clk          : std_logic := '1';
	signal stop         : std_logic := '0';

BEGIN
	riscv : entity work.riscv_core
		generic map(
			WSIZE                  => WSIZE,
			instructions_init_file => test_name & "_instructions.hex",
			data_init_file         => test_name & "_data.hex"
		)

		port map(
			clk => clk
		);

	clk <= not clk after clk_period / 2 when stop = '0' else '0';

	main : PROCESS
		alias PC is <<signal riscv.PC_IF_ID : std_logic_vector(WORD_SIZE - 1 downto 0)>>;
	BEGIN
		test_runner_setup(runner, runner_cfg);

		wait until PC >= std_logic_vector(to_unsigned(PC_max, WORD_SIZE));

		test_runner_cleanup(runner);
		wait;
	END PROCESS;

	watch_chnages : PROCESS(clk)
		file register_changes : text open write_mode is test_name & "_register_changes.txt";
		file memory_changes   : text open write_mode is test_name & "_memory_changes.txt";
		variable row          : line;

		alias register_write_enable is <<signal riscv.stage_ID_inst.registers.write_enable : std_logic>>;
		alias register_rd is <<signal riscv.stage_ID_inst.registers.rd : std_logic_vector(4 downto 0)>>;
		alias register_write_data is <<signal riscv.stage_ID_inst.registers.write_data : std_logic_vector(WSIZE - 1 downto 0)>>;

		alias memory_write_enable is <<signal riscv.stage_MEM_inst.wren_memory_in : std_logic>>;
		alias memory_address is <<signal riscv.stage_MEM_inst.address : std_logic_vector(WSIZE - 1 downto 0)>>;
		alias memory_wdata is <<signal riscv.stage_MEM_inst.wdata_in : std_logic_vector(WSIZE - 1 downto 0)>>;
	BEGIN
		-- Watch changes to the registers
		if falling_edge(clk) and register_write_enable = '1' and unsigned(register_rd) /= 0 then
			write(row, to_string(register_rd), right);
			write(row, " " & to_string(register_write_data));
			writeline(register_changes, row);
		end if;

		-- Watch changes to the memory
		if falling_edge(clk) and memory_write_enable = '1' then
			report (to_string(memory_address));
			write(row, to_string(memory_address), right);
			write(row, " " & to_string(memory_wdata));
			writeline(memory_changes, row);
		end if;
	END PROCESS;

END integration_tb_arch;

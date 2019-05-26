LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

use work.constants.all;
use work.riscv_core_constants.all;

ENTITY unit_register_file_tb IS
	generic(
		runner_cfg : string
	);
END unit_register_file_tb;

ARCHITECTURE unit_register_file_tb_arch OF unit_register_file_tb IS
	signal clk             : std_logic                                := '0';
	signal write_enable    : std_logic                                := '0';
	signal rs1             : std_logic_vector(4 downto 0)             := (others => '0');
	signal rs2             : std_logic_vector(4 downto 0)             := (others => '0');
	signal rd              : std_logic_vector(4 downto 0)             := (others => '0');
	signal write_data      : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');
	signal r1              : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');
	signal r2              : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');
	signal registers_array : ARRAY_32X32;

BEGIN
	register_file : entity work.register_file
		generic map(
			WSIZE => WORD_SIZE
		)
		port map(
			clk             => clk,
			write_enable    => write_enable,
			rs1             => rs1,
			rs2             => rs2,
			rd              => rd,
			write_data      => write_data,
			r1              => r1,
			r2              => r2,
			registers_array => registers_array
		);

	clk <= not clk after 10 ps;

	main : PROCESS
		alias registers is <<signal register_file.registers : ARRAY_32X32>>;
	BEGIN
		test_runner_setup(runner, runner_cfg);

		-- Try to write on register 0
		wait until rising_edge(clk);
		write_enable <= '1';
		write_data   <= (others => '1');
		rd           <= "00000";
		wait until falling_edge(clk);

		-- Check if the value on the register 0 is still zero
		rs1 <= "00000";
		wait until rising_edge(clk);
		check(r1 = std_logic_vector(to_signed(0, WORD_SIZE)), "The value of the register 0 was changed");

		-- Write on the registers 1 and 2
		write_enable <= '1';
		write_data   <= std_logic_vector(to_signed(-1, WORD_SIZE));
		rd           <= "00001";
		wait until falling_edge(clk);

		write_enable <= '1';
		write_data   <= std_logic_vector(to_signed(255, WORD_SIZE));
		rd           <= "00010";
		wait until falling_edge(clk);

		-- Check the values on the registers 1 and 2
		rs1 <= "00001";
		rs2 <= "00010";
		wait until rising_edge(clk);
		check(r1 = std_logic_vector(to_signed(-1, WORD_SIZE)), "Fail to write on register 1");
		check(r2 = std_logic_vector(to_signed(255, WORD_SIZE)), "Fail to write on register 2");

		test_runner_cleanup(runner);
		wait;
	END PROCESS;

END unit_register_file_tb_arch;

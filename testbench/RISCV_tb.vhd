LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RISCV_tb IS
END RISCV_tb;

ARCHITECTURE RISCV_tb_arch OF RISCV_tb IS
	constant clk_period : time      := 20 ps;
	signal clk          : std_logic := '1';
	signal clk_unset    : std_logic := '0';

	COMPONENT RISCV
		PORT(
			clk         : IN  STD_LOGIC
		);
	END COMPONENT;

BEGIN
	i1 : RISCV
		PORT MAP(
			clk         => clk
		);

	clk <= not clk after clk_period / 2 when clk_unset = '0' else '0';
	always : PROCESS
	BEGIN
		clk_unset <= '1' after 1000 ps;
		wait;
	END PROCESS always;
END RISCV_tb_arch;

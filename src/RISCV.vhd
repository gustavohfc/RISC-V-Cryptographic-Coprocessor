library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISCV is
	generic(WSIZE : natural := 32);

	port(
		clk         : in  std_logic;
		instruction : out std_logic_vector((WSIZE - 1) downto 0)
	);
end RISCV;

architecture RISCV_arch of RISCV is
begin

	stage_IF : entity work.stage_IF
		generic map(WSIZE => WSIZE)
		port map(
			clk         => clk,
			instruction => instruction
		);

end RISCV_arch;

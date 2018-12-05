library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity RISCV is
	generic(WSIZE : natural := WORD_SIZE);

	port(
		clk : in std_logic
	);
end RISCV;

architecture RISCV_arch of RISCV is
	signal instruction : std_logic_vector((WSIZE - 1) downto 0);

begin

	stage_IF : entity work.stage_IF
		generic map(WSIZE => WSIZE)
		port map(
			clk         => clk,
			instruction => instruction
		);

	stage_ID : entity work.stage_ID
		generic map(
			WSIZE => WSIZE
		)
		port map(
			write_enable_in => '0', --TODO
			write_data      => (others => '0'), --TODO
			clk             => clk,
			instruction_in  => instruction,
			instruction_out => instruction
		);

end RISCV_arch;

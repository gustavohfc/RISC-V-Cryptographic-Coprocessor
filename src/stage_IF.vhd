library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage_IF is
	generic(WSIZE : natural);

	port(
		clk         : in  std_logic;
		instruction : out std_logic_vector((WSIZE - 1) downto 0)
	);
end stage_IF;

architecture stage_IF_arch of stage_IF is
	signal current_pc, next_pc, pc_plus_4 : std_logic_vector((WSIZE - 1) downto 0);

begin
	PC : entity work.PC
		generic map(WSIZE => WSIZE)
		port map(
			clk        => clk,
			next_pc    => next_pc,
			current_pc => current_pc
		);

	adder : entity work.adder
		generic map(WSIZE => WSIZE)
		port map(
			a      => current_pc,
			b      => std_logic_vector(to_unsigned(4, WSIZE)),
			result => pc_plus_4
		);

	mux4 : entity work.mux4
		generic map(WSIZE => WSIZE)
		port map(
			S  => "00",
			I0 => pc_plus_4,
			I1 => (others => '0'),      --TODO
			I2 => (others => '0'),      --TODO
			I3 => (others => '0'),      --TODO
			O  => next_pc
		);

	instruction_memory : entity work.instruction_memory
		port map(
			address => current_pc(9 downto 2),
			clock   => clk,
			q       => instruction
		);

end stage_IF_arch;

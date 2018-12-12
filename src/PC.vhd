library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	generic(WSIZE : natural);

	port(
		clk, stall : in  std_logic;
		next_pc    : in  std_logic_vector(WSIZE - 1 downto 0);
		current_pc : out std_logic_vector(WSIZE - 1 downto 0)
	);
end PC;

architecture PC_arch of PC is
	signal aux : std_logic_vector(WSIZE - 1 downto 0) := std_logic_vector(to_unsigned(0, WSIZE));

begin
	current_pc <= aux;
	process(clk)
	begin
		if (rising_edge(clk)) then
			if stall /= '1' then
				aux <= next_pc;
			end if;
		end if;
	end process;
end PC_arch;


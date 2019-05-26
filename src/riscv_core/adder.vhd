library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic(WSIZE : natural := 32);

	port(
		a      : in  std_logic_vector((WSIZE - 1) downto 0);
		b      : in  std_logic_vector((WSIZE - 1) downto 0);
		result : out std_logic_vector((WSIZE - 1) downto 0)
	);

end entity;

architecture adder_arch of adder is
begin
	process(a, b) is
	begin
		result <= std_logic_vector(signed(a) + signed(b));
	end process;
end adder_arch;

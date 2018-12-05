library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage_ID is
	generic(WSIZE : natural);
	
	port(
		clk         : in std_logic;
		instruction : in std_logic_vector((WSIZE - 1) downto 0)
	);
end entity stage_ID;

architecture stage_ID_arch of stage_ID is
begin

end architecture stage_ID_arch;

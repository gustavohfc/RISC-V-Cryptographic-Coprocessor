library IEEE;
use IEEE.std_logic_1164.all;

entity mux2 is
	generic(WSIZE : natural);
	
	port(
		S              : in  std_logic;
		I0, I1 : in  std_logic_vector(WSIZE - 1 downto 0);
		O              : out std_logic_vector(WSIZE - 1 downto 0)
	);
end mux2;

architecture mux2_arch of mux2 is
begin

	with S select O <=
		I1 when '1',
		I0 when others;

end mux2_arch;

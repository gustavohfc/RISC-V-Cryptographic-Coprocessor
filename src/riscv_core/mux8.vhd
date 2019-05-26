library ieee;
use ieee.std_logic_1164.all;

entity mux8 is
	generic(WSIZE : natural);
	
	port(
		S              : in  std_logic_vector(2 downto 0);
		I0, I1, I2, I3, I4, I5, I6, I7 : in  std_logic_vector(WSIZE - 1 downto 0);
		O              : out std_logic_vector(WSIZE - 1 downto 0)
	);
end entity mux8;

architecture mux8_arch of mux8 is
begin
	
	with S select O <=
		I7 when "111",
		I6 when "110",
		I5 when "101",
		I4 when "100",
		I3 when "011",
		I2 when "010",
		I1 when "001",
		I0 when others;

end architecture mux8_arch;

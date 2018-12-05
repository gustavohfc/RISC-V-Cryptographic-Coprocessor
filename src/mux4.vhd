library IEEE;
use IEEE.std_logic_1164.all;

entity mux4 is
	generic(WSIZE : natural := 32);
	
	port(
		S              : in  std_logic_vector(1 downto 0);
		I0, I1, I2, I3 : in  std_logic_vector(WSIZE - 1 downto 0);
		O              : out std_logic_vector(WSIZE - 1 downto 0)
	);
end mux4;

architecture mux4_arch of mux4 is
begin

	with S select O <=
		I3 when "11",
		I2 when "10",
		I1 when "01",
		I0 when others;

end mux4_arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity byteena_decoder is
	generic(WSIZE : natural);

	port(
		funct3      : in  std_logic_vector(2 downto 0);
		address      : in  std_logic_vector(7 downto 0);
		byteena        : out std_logic_vector(((WSIZE/8) - 1) downto 0)
	);
end entity byteena_decoder;

architecture byteena_decoder_arch of byteena_decoder is
	
begin
	process(funct3, address) is
	begin
		case funct3 is
		when FUNCT3_SW =>
			byteena <= "1111";
		when FUNCT3_SH =>	-- TODO
			byteena <= "1111";
--			with address select byteena <=
--				"1100" when (unsigned(address) mod 2) >= 1,
--				"0011" when others;
		when FUNCT3_SB =>
			byteena <= "1111";
		when others =>
			byteena <= "1111";
	end process;
	
end architecture byteena_decoder_arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_core_constants.all;

entity byteena_decoder is
	generic(WSIZE : natural);

	port(
		funct3  : in  std_logic_vector(2 downto 0);
		address : in  std_logic_vector((WSIZE - 1) downto 0);
		byteena : out std_logic_vector(((WSIZE / 8) - 1) downto 0)
	);
end entity byteena_decoder;

architecture byteena_decoder_arch of byteena_decoder is

begin
	process(funct3, address) is
	begin
		case funct3 is
			when FUNCT3_SW =>
				byteena <= (others => '1');
			when FUNCT3_SH => 
--				byteena <= "0011";
				if (unsigned(address) mod 2) /= 0 then
					byteena <= "1100";
				else
					byteena <= "0011";
				end if;
			when FUNCT3_SB =>
--				byteena <= "0001";
				if (unsigned(address) mod 4) = 3 then
					byteena <= "1000";
				elsif (unsigned(address) mod 4) = 2 then
					byteena <= "0100";
				elsif (unsigned(address) mod 4) = 1 then
					byteena <= "0010";
				else
					byteena <= "0001";
				end if;
			when others =>
				byteena <= (others => '1');
		end case;
	end process;

end architecture byteena_decoder_arch;

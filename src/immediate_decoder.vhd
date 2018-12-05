library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity immediate_decoder is
	generic(WSIZE : natural);

	port(
		instruction      : in  std_logic_vector(WSIZE - 1 downto 0);
		instruction_type : in  instruction_type;
		immediate        : out std_logic_vector(WSIZE - 1 downto 0)
	);
end entity immediate_decoder;

architecture immediate_decoder_arch of immediate_decoder is

begin

	process(instruction_type, instruction) is
	begin
		case instruction_type is
			when R_type =>
				immediate <= (others => '-');

			when I_type =>
				immediate <=  (31 downto 11 => instruction(31)) & instruction(30 downto 20);

			when S_type =>
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 25) & instruction(11 downto 8) & instruction(7);

			when B_type =>
				immediate <= (31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
				
			when U_type =>
				immediate <= instruction(31 downto 12) & (11 downto 0 => '0');
				
			when J_type =>
				immediate <= (31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 25) & instruction(24 downto 21) & '0';
		end case;
	end process;

end architecture immediate_decoder_arch;

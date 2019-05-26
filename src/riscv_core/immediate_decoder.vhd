library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity immediate_decoder is
	generic(WSIZE : natural);

	port(
		instruction      : in  std_logic_vector(WSIZE - 1 downto 7);
		instruction_type : in  instruction_types;
		immediate        : out std_logic_vector(WSIZE - 1 downto 0)
	);
end entity immediate_decoder;

architecture immediate_decoder_arch of immediate_decoder is
--	signal I, S, B, U, J : std_logic;
begin

--	I <= '1' when instruction_type = I_type else '0';
--	S <= '1' when instruction_type = S_type else '0';
--	B <= '1' when instruction_type = B_type else '0';
--	U <= '1' when instruction_type = U_type else '0';
--	J <= '1' when instruction_type = J_type else '0';
--
--	immediate(0) <= (I and instruction(20)) or (S and instruction(7));
--
--	immediate(4 downto 1) <= ((0 to 3 => I or J) and instruction(24 downto 21)) or ((0 to 3 => S or B) and instruction(11 downto 8));
--
--	immediate(10 downto 5) <= (0 to 5 => not U) and instruction(30 downto 25);
--
--	immediate(11) <= ((I or S) and instruction(31)) or (B and instruction(7)) or (J and instruction(20));
--
--	immediate(19 downto 12) <= ((0 to 7 => U or J) and instruction(19 downto 12)) or ((0 to 7 => I or S or B) and (0 to 7 => instruction(31)));
--
--	immediate(30 downto 20) <= ((0 to 10 => U) and instruction(30 downto 20)) or ((0 to 10 => not U) and (0 to 10 => instruction(31)));
--
--	immediate(31) <= instruction(31);
	
	with instruction_type select immediate <=
		(31 downto 11 => instruction(31)) & instruction(30 downto 20) when I_type,
		(31 downto 11 => instruction(31)) & instruction(30 downto 25) & instruction(11 downto 8) & instruction(7) when S_type,
		(31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when B_type,
		instruction(31 downto 12) & (11 downto 0 => '0') when U_type,
		(31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 25) & instruction(24 downto 21) & '0' when J_type,
		(others => '-') when others;

end architecture immediate_decoder_arch;

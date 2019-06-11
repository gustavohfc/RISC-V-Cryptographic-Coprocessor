library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity stage_WB is
	generic(WSIZE : natural);

	port(
		clk               : in  std_logic;
		instruction_in    : in  std_logic_vector((WSIZE - 1) downto 0);
		data_in           : in  std_logic_vector((WSIZE - 1) downto 0);
		r2                : in  std_logic_vector((WSIZE - 1) downto 0);
		wren_register_in  : in  std_logic;
		wren_register_out : out std_logic;
		WB_address        : out std_logic_vector(4 downto 0);
		WB_data_out       : out std_logic_vector((WSIZE - 1) downto 0)
	);
end entity stage_WB;

architecture RTL of stage_WB is
	signal cryptographic_coprocessor_output : unsigned(31 downto 0);
begin

	WB_address        <= instruction_in(11 downto 7);
	wren_register_out <= wren_register_in;

	WB_data_out <= std_logic_vector(cryptographic_coprocessor_output) when instruction_in(6 downto 0) = CRYPTOGRAPHIC_COPROCESSOR_OPCODE else data_in;

	coprocessor : entity work.cryptographic_coprocessor
		port map(
			clk         => clk,
			instruction => instruction_in,
			data_in     => unsigned(data_in),
			r2          => unsigned(r2),
			output      => cryptographic_coprocessor_output
		);

end architecture RTL;

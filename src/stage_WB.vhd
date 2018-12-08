library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage_WB is
	generic(WSIZE : natural);

	port(
		clk               : in  std_logic;
		instruction_in    : in  std_logic_vector((WSIZE - 1) downto 0);
		data_in           : in  std_logic_vector((WSIZE - 1) downto 0);
		wren_register_in  : in  std_logic;
		wren_register_out : out std_logic;
		WB_address        : out std_logic_vector(4 downto 0);
		WB_data_out       : out std_logic_vector((WSIZE - 1) downto 0)
	);
end entity stage_WB;

architecture RTL of stage_WB is

begin

	process(clk) is
	begin
		if rising_edge(clk) then
			WB_address        <= instruction_in(11 downto 7);
			WB_data_out       <= data_in;
			wren_register_out <= wren_register_in;
		end if;
	end process;

end architecture RTL;

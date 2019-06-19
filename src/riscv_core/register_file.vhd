library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_core_constants.all;

entity register_file is
	generic(WSIZE : natural);

	port(
		clk, write_enable : in  std_logic;
		rs1, rs2, rd      : in  std_logic_vector(4 downto 0);
		write_data        : in  std_logic_vector(WSIZE - 1 downto 0);
		r1, r2            : out std_logic_vector(WSIZE - 1 downto 0);
		registers         : out ARRAY_32X32 := ((others => (others => '0')))
	);
end entity register_file;

architecture register_file_arch of register_file is
begin
	r1 <= registers(to_integer(unsigned(rs1)));
	r2 <= registers(to_integer(unsigned(rs2)));

	process(clk) is
		variable i : natural;

	begin
		if (falling_edge(clk)) then
			if (write_enable = '1') then
				i := to_integer(unsigned(rd));
				if (i /= 0) then
					registers(i) <= write_data;
				end if;
			end if;
		end if;

	end process;

end architecture register_file_arch;

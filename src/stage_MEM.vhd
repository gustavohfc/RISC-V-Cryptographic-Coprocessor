library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity stage_MEM is
	generic(WSIZE : natural);

	port(
		clk                              : in  std_logic;
		instruction_in                   : in  std_logic_vector((WSIZE - 1) downto 0);
		instruction_out                  : out std_logic_vector((WSIZE - 1) downto 0);
		wdata_in                         : in  std_logic_vector((WSIZE - 1) downto 0);
		ALU_Z_in                         : in  std_logic_vector((WSIZE - 1) downto 0);
		data_out                         : out std_logic_vector((WSIZE - 1) downto 0);
		wren_memory_in, wren_register_in : in  std_logic;
		WB_select_in                     : in  std_logic;
		wren_register_out                : out std_logic
	);
end entity stage_MEM;

architecture stage_MEM_arch of stage_MEM is

	signal data, rdata        : std_logic_vector((WSIZE - 1) downto 0);
	signal mux8_out : std_logic_vector((WSIZE - 1) downto 0);
	signal mux4_out : std_logic_vector(((WSIZE/8)-1) downto 0);

	alias funct3 : std_logic_vector(2 downto 0) is instruction_in(14 downto 12);
begin

	data_memory_inst : entity work.data_memory
		port map(
			address => ALU_Z_in(7 downto 0),
			byteena => mux4_out,
			clock   => clk,
			data    => wdata_in,
			wren    => wren_memory_in,
			q       => rdata
		);

	mux4_inst : entity work.mux4
		generic map(
			WSIZE => (WSIZE/8)
		)
		port map(
			S  => funct3(1 downto 0),
			I0 => "0001",
			I1 => "0011",
			I2 => "1111",
			I3 => (others => '1'),
			O  => mux4_out
		);

	mux8_inst : entity work.mux8
		generic map(
			WSIZE => WSIZE
		)
		port map(
			S  => funct3,
			I0 => ((WSIZE - 1) downto (WSIZE / 4) => '0') & rdata(((WSIZE / 4) - 1) downto 0),
			I1 => ((WSIZE - 1) downto (WSIZE / 2) => '0') & rdata(((WSIZE / 2) - 1) downto 0),
			I2 => rdata,
			I3 => (others => '0'),
			I4 => ((WSIZE - 1) downto (WSIZE / 4) => '0') & rdata((WSIZE - 1) downto (WSIZE - (WSIZE / 4))),
			I5 => ((WSIZE - 1) downto (WSIZE / 2) => '0') & rdata((WSIZE - 1) downto (WSIZE - (WSIZE / 2))),
			I6 => (others => '0'),
			I7 => (others => '0'),
			O  => mux8_out
		);

	mux2_inst : entity work.mux2
		generic map(
			WSIZE => WSIZE
		)
		port map(
			S  => WB_select_in,
			I0 => ALU_Z_in,
			I1 => mux8_out,
			O  => data
		);

	process(clk) is
	begin
		if rising_edge(clk) then
			instruction_out   <= instruction_in;
			wren_register_out <= wren_register_in;
			data_out          <= data;
		end if;
	end process;

end architecture stage_MEM_arch;

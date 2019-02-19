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

	signal data, rdata : std_logic_vector((WSIZE - 1) downto 0);
	signal mux8_out    : std_logic_vector((WSIZE - 1) downto 0);
	signal byteena     : std_logic_vector(((WSIZE / 8) - 1) downto 0);

	signal rdata_byte_signed   : std_logic_vector((WSIZE - 1) downto 0);
	signal rdata_half_signed   : std_logic_vector((WSIZE - 1) downto 0);
	signal rdata_byte_unsigned : std_logic_vector((WSIZE - 1) downto 0);
	signal rdata_half_unsigend : std_logic_vector((WSIZE - 1) downto 0);
	
	signal write_address : std_logic_vector((WSIZE - 1) downto 0);

	alias funct3  : std_logic_vector(2 downto 0) is instruction_in(14 downto 12);
	alias write_address_div4 : std_logic_vector(7 downto 0) is write_address(9 downto 2);

	signal not_clk : std_logic;

begin

	write_address <= std_logic_vector(unsigned(ALU_Z_in) + DATA_MEMORY_ADDRESS_OFFSET);
	rdata_byte_signed   <= ((WSIZE - 1) downto (WSIZE / 4) => rdata((WSIZE / 4) - 1)) & rdata(((WSIZE / 4) - 1) downto 0);
	rdata_half_signed   <= ((WSIZE - 1) downto (WSIZE / 2) => rdata((WSIZE / 4) - 1)) & rdata(((WSIZE / 2) - 1) downto 0);
	rdata_byte_unsigned <= ((WSIZE - 1) downto (WSIZE / 4) => '0') & rdata(((WSIZE / 4) - 1) downto 0);
	rdata_half_unsigend <= ((WSIZE - 1) downto (WSIZE / 2) => '0') & rdata(((WSIZE / 2) - 1) downto 0);

	not_clk <= not clk;

	data_memory_inst : entity work.data_memory
		port map(
			address => write_address_div4,
			byteena => byteena,
			clock   => not_clk, -- Update the memory input on the falling edge
			data    => wdata_in,
			wren    => wren_memory_in,
			q       => rdata
		);

	byteena_decoder_inst : entity work.byteena_decoder
		generic map(
			WSIZE => WSIZE
		)
		port map(
			funct3  => funct3,
			address => write_address,
			byteena => byteena
		);

	mux8_inst : entity work.mux8
		generic map(
			WSIZE => WSIZE
		)
		port map(
			S  => funct3,
			I0 => rdata_byte_signed,
			I1 => rdata_half_signed,
			I2 => rdata,
			I3 => (others => '0'),
			I4 => rdata_byte_unsigned,
			I5 => rdata_half_unsigend,
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

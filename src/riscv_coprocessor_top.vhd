library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity riscv_coprocessor_top is
	generic(
		WSIZE                  : natural := WORD_SIZE;
		instructions_init_file : string  := DEFAULT_INSTRUCTIONS_INIT_FILE;
		data_init_file         : string  := DEFAULT_DATA_INIT_FILE
	);

	port(
		clk              : in  std_logic;
		-- Direct memory access
		memory_word_addr : in  std_logic_vector(7 downto 0);
		memory_data_in   : in  std_logic_vector(31 downto 0);
		memory_wren      : in  std_logic;
		memory_output    : out std_logic_vector(31 downto 0)
	);
end entity riscv_coprocessor_top;

architecture riscv_coprocessor_top_arch of riscv_coprocessor_top is
	signal coprocessor_instruction : std_logic_vector(31 downto 0);
	signal coprocessor_data        : std_logic_vector(31 downto 0);
	signal coprocessor_r2          : std_logic_vector(31 downto 0);
	signal coprocessor_output      : std_logic_vector(31 downto 0);

	signal coprocessor_data_unsigned   : unsigned(31 downto 0);
	signal coprocessor_r2_unsigned     : unsigned(31 downto 0);
	signal coprocessor_output_unsigned : unsigned(31 downto 0);

begin

	coprocessor_data_unsigned <= unsigned(coprocessor_data);
	coprocessor_r2_unsigned   <= unsigned(coprocessor_r2);
	coprocessor_output        <= std_logic_vector(coprocessor_output_unsigned);

	core : entity work.riscv_core
		generic map(
			WSIZE                  => WSIZE,
			instructions_init_file => instructions_init_file,
			data_init_file         => data_init_file
		)
		port map(
			clk                     => clk,
			coprocessor_instruction => coprocessor_instruction,
			coprocessor_data        => coprocessor_data,
			coprocessor_r2          => coprocessor_r2,
			coprocessor_output      => coprocessor_output,
			memory_word_addr        => memory_word_addr,
			memory_data_in          => memory_data_in,
			memory_wren             => memory_wren,
			memory_output           => memory_output
		);

	coprocessor : entity work.cryptographic_coprocessor
		port map(
			clk         => clk,
			instruction => coprocessor_instruction,
			data_in     => coprocessor_data_unsigned,
			r2          => coprocessor_r2_unsigned,
			output      => coprocessor_output_unsigned
		);

end architecture riscv_coprocessor_top_arch;

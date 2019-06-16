library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_coprocessor_fpga_top is
	port(
		clk : in std_logic
	);
end entity riscv_coprocessor_fpga_top;

architecture riscv_coprocessor_fpga_top_arch of riscv_coprocessor_fpga_top is
	signal memory_word_addr : std_logic_vector(7 downto 0)  := (others => '0');
	signal memory_data_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal memory_wren      : std_logic                     := '0';
	signal memory_output    : std_logic_vector(31 downto 0) := (others => '0');

begin

	riscv : entity work.riscv_coprocessor_top
		port map(
			clk              => clk,
			memory_word_addr => memory_word_addr,
			memory_data_in   => memory_data_in,
			memory_wren      => memory_wren,
			memory_output    => memory_output
		);

end architecture riscv_coprocessor_fpga_top_arch;

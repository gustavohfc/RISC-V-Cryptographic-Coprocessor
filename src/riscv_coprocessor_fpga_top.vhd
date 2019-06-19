library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The memory mapping is as follows:
-- 0x0 - Used for communication between the RISC-V program and this module
-- 0x4 to 0x16 - MD5 result
-- 0x14 to 0x24 - SHA1 result
-- 0x28 to 0x44 - SHA256 result
-- 0x48 to 0x84 - SHA512 result
-- 0x88 - Message length
-- 0x8C to memory end - Message

entity riscv_coprocessor_fpga_top is
	port(
		clk50                                          : in  std_logic;
		sw                                             : in  std_logic_vector(17 downto 0) := (others => '0');
		hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0 : out std_logic_vector(7 downto 0)  := (others => '0');
		ledr                                           : out std_logic_vector(17 downto 0) := (others => '0')
	);
end entity riscv_coprocessor_fpga_top;

architecture riscv_coprocessor_fpga_top_arch of riscv_coprocessor_fpga_top is

	signal clk25 : std_logic := '0';

	signal memory_word_addr : std_logic_vector(7 downto 0)  := (others => '0');
	signal memory_data_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal memory_wren      : std_logic                     := '0';
	signal memory_output    : std_logic_vector(31 downto 0) := (others => '0');

	alias selected_alg  : std_logic_vector(2 downto 0) is sw(17 downto 15);
	alias selected_word : std_logic_vector(7 downto 0) is sw(7 downto 0);

begin

	ledr <= sw;

	clk_divider : process(clk50) is
	begin
		if rising_edge(clk50) then
			clk25 <= not clk25;
		end if;
	end process;

	HEX_7 : entity work.display7seg_decoder
		port map(memory_output(31 downto 28), hex7);
	HEX_6 : entity work.display7seg_decoder
		port map(memory_output(27 downto 24), hex6);
	HEX_5 : entity work.display7seg_decoder
		port map(memory_output(23 downto 20), hex5);
	HEX_4 : entity work.display7seg_decoder
		port map(memory_output(19 downto 16), hex4);
	HEX_3 : entity work.display7seg_decoder
		port map(memory_output(15 downto 12), hex3);
	HEX_2 : entity work.display7seg_decoder
		port map(memory_output(11 downto 8), hex2);
	HEX_1 : entity work.display7seg_decoder
		port map(memory_output(7 downto 4), hex1);
	HEX_0 : entity work.display7seg_decoder
		port map(memory_output(3 downto 0), hex0);

	riscv : entity work.riscv_coprocessor_top
		port map(
			clk              => clk25,
			memory_word_addr => memory_word_addr,
			memory_data_in   => memory_data_in,
			memory_wren      => memory_wren,
			memory_output    => memory_output
		);

	main : process(selected_alg, selected_word) is
		variable word_offset : unsigned(7 downto 0);
	begin
		case selected_alg is
			when "000" =>               -- MD5
				if unsigned(selected_word) < 3 then
					word_offset := unsigned(selected_word);
				else
					word_offset := to_unsigned(3, 8);
				end if;
				memory_word_addr <= std_logic_vector(to_unsigned(1, 8) + word_offset);

			when "001" =>               -- SHA1
				if unsigned(selected_word) < 4 then
					word_offset := unsigned(selected_word);
				else
					word_offset := to_unsigned(4, 8);
				end if;
				memory_word_addr <= std_logic_vector(to_unsigned(5, 8) + word_offset);

			when "010" =>               -- SHA256
				if unsigned(selected_word) < 7 then
					word_offset := unsigned(selected_word);
				else
					word_offset := to_unsigned(7, 8);
				end if;
				memory_word_addr <= std_logic_vector(to_unsigned(10, 8) + word_offset);

			when "011" =>               -- SHA512
				if unsigned(selected_word) < 15 then
					word_offset := unsigned(selected_word);
				else
					word_offset := to_unsigned(15, 8);
				end if;
				memory_word_addr <= std_logic_vector(to_unsigned(18, 8) + word_offset);

			when others =>
				memory_word_addr <= selected_word;
		end case;
	end process;

end architecture riscv_coprocessor_fpga_top_arch;

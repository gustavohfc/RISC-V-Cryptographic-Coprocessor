library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

entity cryptographic_coprocessor is
	port(
		clk : in std_logic
	);
end entity;

architecture cryptographic_coprocessor_arch of cryptographic_coprocessor is

	-- MD5
	signal md5_start_new_hash        : std_logic;
	signal md5_write_data_in         : std_logic;
	signal md5_data_in               : unsigned(31 downto 0);
	signal md5_data_in_word_position : unsigned(3 downto 0);
	signal md5_calculate_next_block  : std_logic;
	signal md5_is_last_block         : std_logic;
	signal md5_last_block_size       : unsigned(9 downto 0);
	signal md5_is_waiting_next_block : std_logic;
	signal md5_is_busy               : std_logic;
	signal md5_is_complete           : std_logic;
	signal md5_error                 : md5_error_type;
	signal md5_A_out                 : unsigned(31 downto 0);
	signal md5_B_out                 : unsigned(31 downto 0);
	signal md5_C_out                 : unsigned(31 downto 0);
	signal md5_D_out                 : unsigned(31 downto 0);

	-- SHA1
	signal sha1_start_new_hash        : std_logic;
	signal sha1_write_data_in         : std_logic;
	signal sha1_data_in               : unsigned(31 downto 0);
	signal sha1_data_in_word_position : unsigned(3 downto 0);
	signal sha1_calculate_next_block  : std_logic;
	signal sha1_is_last_block         : std_logic;
	signal sha1_last_block_size       : unsigned(9 downto 0);
	signal sha1_is_waiting_next_block : std_logic;
	signal sha1_is_busy               : std_logic;
	signal sha1_is_complete           : std_logic;
	signal sha1_error                 : sha1_error_type;
	signal sha1_H0_out                : unsigned(31 downto 0);
	signal sha1_H1_out                : unsigned(31 downto 0);
	signal sha1_H2_out                : unsigned(31 downto 0);
	signal sha1_H3_out                : unsigned(31 downto 0);
	signal sha1_H4_out                : unsigned(31 downto 0);

	-- SHA256
	signal sha256_start_new_hash        : std_logic;
	signal sha256_write_data_in         : std_logic;
	signal sha256_data_in               : unsigned(31 downto 0);
	signal sha256_data_in_word_position : unsigned(3 downto 0);
	signal sha256_calculate_next_block  : std_logic;
	signal sha256_is_last_block         : std_logic;
	signal sha256_last_block_size       : unsigned(9 downto 0);
	signal sha256_is_waiting_next_block : std_logic;
	signal sha256_is_busy               : std_logic;
	signal sha256_is_complete           : std_logic;
	signal sha256_error                 : sha256_error_type;
	signal sha256_H0_out                : unsigned(31 downto 0);
	signal sha256_H1_out                : unsigned(31 downto 0);
	signal sha256_H2_out                : unsigned(31 downto 0);
	signal sha256_H3_out                : unsigned(31 downto 0);
	signal sha256_H4_out                : unsigned(31 downto 0);
	signal sha256_H5_out                : unsigned(31 downto 0);
	signal sha256_H6_out                : unsigned(31 downto 0);
	signal sha256_H7_out                : unsigned(31 downto 0);

	-- SHA512
	signal sha512_start_new_hash        : std_logic;
	signal sha512_write_data_in         : std_logic;
	signal sha512_data_in               : unsigned(31 downto 0);
	signal sha512_data_in_word_position : unsigned(4 downto 0);
	signal sha512_calculate_next_block  : std_logic;
	signal sha512_is_last_block         : std_logic;
	signal sha512_last_block_size       : unsigned(10 downto 0);
	signal sha512_is_waiting_next_block : std_logic;
	signal sha512_is_busy               : std_logic;
	signal sha512_is_complete           : std_logic;
	signal sha512_error                 : sha512_error_type;
	signal sha512_H0_out                : unsigned(63 downto 0);
	signal sha512_H1_out                : unsigned(63 downto 0);
	signal sha512_H2_out                : unsigned(63 downto 0);
	signal sha512_H3_out                : unsigned(63 downto 0);
	signal sha512_H4_out                : unsigned(63 downto 0);
	signal sha512_H5_out                : unsigned(63 downto 0);
	signal sha512_H6_out                : unsigned(63 downto 0);
	signal sha512_H7_out                : unsigned(63 downto 0);

begin

	md5 : entity work.md5
		port map(
			clk                   => clk,
			start_new_hash        => md5_start_new_hash,
			write_data_in         => md5_write_data_in,
			data_in               => md5_data_in,
			data_in_word_position => md5_data_in_word_position,
			calculate_next_block  => md5_calculate_next_block,
			is_last_block         => md5_is_last_block,
			last_block_size       => md5_last_block_size,
			is_waiting_next_block => md5_is_waiting_next_block,
			is_busy               => md5_is_busy,
			is_complete           => md5_is_complete,
			error                 => md5_error,
			A_out                 => md5_A_out,
			B_out                 => md5_B_out,
			C_out                 => md5_C_out,
			D_out                 => md5_D_out
		);

	sha1 : entity work.sha1
		port map(
			clk                   => clk,
			start_new_hash        => sha1_start_new_hash,
			write_data_in         => sha1_write_data_in,
			data_in               => sha1_data_in,
			data_in_word_position => sha1_data_in_word_position,
			calculate_next_block  => sha1_calculate_next_block,
			is_last_block         => sha1_is_last_block,
			last_block_size       => sha1_last_block_size,
			is_waiting_next_block => sha1_is_waiting_next_block,
			is_busy               => sha1_is_busy,
			is_complete           => sha1_is_complete,
			error                 => sha1_error,
			H0_out                => sha1_H0_out,
			H1_out                => sha1_H1_out,
			H2_out                => sha1_H2_out,
			H3_out                => sha1_H3_out,
			H4_out                => sha1_H4_out
		);

	sha256 : entity work.sha256
		port map(
			clk                   => clk,
			start_new_hash        => sha256_start_new_hash,
			write_data_in         => sha256_write_data_in,
			data_in               => sha256_data_in,
			data_in_word_position => sha256_data_in_word_position,
			calculate_next_block  => sha256_calculate_next_block,
			is_last_block         => sha256_is_last_block,
			last_block_size       => sha256_last_block_size,
			is_waiting_next_block => sha256_is_waiting_next_block,
			is_busy               => sha256_is_busy,
			is_complete           => sha256_is_complete,
			error                 => sha256_error,
			H0_out                => sha256_H0_out,
			H1_out                => sha256_H1_out,
			H2_out                => sha256_H2_out,
			H3_out                => sha256_H3_out,
			H4_out                => sha256_H4_out,
			H5_out                => sha256_H5_out,
			H6_out                => sha256_H6_out,
			H7_out                => sha256_H7_out
		);

	sha512 : entity work.sha512
		port map(
			clk                   => clk,
			start_new_hash        => sha512_start_new_hash,
			write_data_in         => sha512_write_data_in,
			data_in               => sha512_data_in,
			data_in_word_position => sha512_data_in_word_position,
			calculate_next_block  => sha512_calculate_next_block,
			is_last_block         => sha512_is_last_block,
			last_block_size       => sha512_last_block_size,
			is_waiting_next_block => sha512_is_waiting_next_block,
			is_busy               => sha512_is_busy,
			is_complete           => sha512_is_complete,
			error                 => sha512_error,
			H0_out                => sha512_H0_out,
			H1_out                => sha512_H1_out,
			H2_out                => sha512_H2_out,
			H3_out                => sha512_H3_out,
			H4_out                => sha512_H4_out,
			H5_out                => sha512_H5_out,
			H6_out                => sha512_H6_out,
			H7_out                => sha512_H7_out
		);

end architecture cryptographic_coprocessor_arch;

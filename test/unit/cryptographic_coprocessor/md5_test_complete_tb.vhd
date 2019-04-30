library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

entity md5_test_complete_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_complete_tb;

architecture md5_test_complete_tb_arch OF md5_test_complete_tb IS
	signal clk                   : std_logic                     := '0';
	signal start_new_hash        : std_logic                     := '0';
	signal calculate_next_chunk  : std_logic                     := '0';
	signal write_data_in         : std_logic                     := '0';
	signal data_in               : std_logic_vector(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0);
	signal is_last_chunk         : std_logic                     := '0';
	signal is_idle               : std_logic                     := '0';
	signal is_waiting_next_chunk : std_logic                     := '0';
	signal is_busy               : std_logic                     := '0';
	signal is_complete           : std_logic                     := '0';
	signal error                 : md5_error_type;
	signal A                     : std_logic_vector(31 downto 0) := (others => '0');
	signal B                     : std_logic_vector(31 downto 0) := (others => '0');
	signal C                     : std_logic_vector(31 downto 0) := (others => '0');
	signal D                     : std_logic_vector(31 downto 0) := (others => '0');

begin
	md5 : entity work.md5
		port map(
			clk                   => clk,
			start_new_hash        => start_new_hash,
			write_data_in         => write_data_in,
			data_in               => data_in,
			data_in_word_position => data_in_word_position,
			calculate_next_chunk  => calculate_next_chunk,
			is_last_chunk         => is_last_chunk,
			is_idle               => is_idle,
			is_waiting_next_chunk => is_waiting_next_chunk,
			is_busy               => is_busy,
			is_complete           => is_complete,
			error                 => error,
			A_out                 => A,
			B_out                 => B,
			C_out                 => C,
			D_out                 => D
		);

	clk <= not clk after 10 ps;

	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		-- Start new hash
		start_new_hash <= '1';
		wait until rising_edge(clk);
		start_new_hash <= '0';

		-- Write the 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
		write_data_in <= '1';

		data_in               <= x"41424344";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		data_in               <= x"45464748";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"494a4b4c";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"4d4e4f50";
		data_in_word_position <= x"c";
		wait until rising_edge(clk);

		data_in               <= x"51525354";
		data_in_word_position <= x"b";
		wait until rising_edge(clk);

		data_in               <= x"55565758";
		data_in_word_position <= x"a";
		wait until rising_edge(clk);

		data_in               <= x"595a6162";
		data_in_word_position <= x"9";
		wait until rising_edge(clk);

		data_in               <= x"63646566";
		data_in_word_position <= x"8";
		wait until rising_edge(clk);

		data_in               <= x"6768696a";
		data_in_word_position <= x"7";
		wait until rising_edge(clk);

		data_in               <= x"6b6c6d6e";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		data_in               <= x"6f707172";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"73747576";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"7778797a";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"30313233";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"34353637";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"38390000";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_chunk <= '1';
		wait until rising_edge(clk);
		calculate_next_chunk <= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);

		check(A = x"10325476");
		
		wait for 1000 ps;

		test_runner_cleanup(runner);
		--wait;
	end process;

end md5_test_complete_tb_arch;

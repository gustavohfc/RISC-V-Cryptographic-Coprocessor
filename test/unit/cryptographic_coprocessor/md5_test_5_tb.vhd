library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 208 bits message ("abcdefghijklmnopqrstuvwxyz")

entity unit_md5_test_5_tb IS
	generic(
		runner_cfg : string
	);
end unit_md5_test_5_tb;

architecture unit_md5_test_5_tb_arch OF unit_md5_test_5_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal calculate_next_block  : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : md5_error_type;
	signal A                     : unsigned(31 downto 0) := (others => '0');
	signal B                     : unsigned(31 downto 0) := (others => '0');
	signal C                     : unsigned(31 downto 0) := (others => '0');
	signal D                     : unsigned(31 downto 0) := (others => '0');

begin
	md5 : entity work.md5
		port map(
			clk                   => clk,
			start_new_hash        => start_new_hash,
			write_data_in         => write_data_in,
			data_in               => data_in,
			data_in_word_position => data_in_word_position,
			calculate_next_block  => calculate_next_block,
			is_last_block         => is_last_block,
			last_block_size       => last_block_size,
			is_waiting_next_block => is_waiting_next_block,
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

		-- Write the 208 bits message ("abcdefghijklmnopqrstuvwxyz")
		write_data_in <= '1';

		data_in               <= x"61626364";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"65666768";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"696a6b6c";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"6d6e6f70";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"71727374";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"75767778";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"797a0000";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(208, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"d6d117a6");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"aab1aaaa");
		check(C = x"d6d117a6");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"227d8cf1");
		check(C = x"aab1aaaa");
		check(D = x"d6d117a6");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"d6d117a6");
		check(B = x"4503b812");
		check(C = x"227d8cf1");
		check(D = x"aab1aaaa");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"aab1aaaa");
		check(B = x"fe15f787");
		check(C = x"4503b812");
		check(D = x"227d8cf1");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"227d8cf1");
		check(B = x"a811b278");
		check(C = x"fe15f787");
		check(D = x"4503b812");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"4503b812");
		check(B = x"b71122fc");
		check(C = x"a811b278");
		check(D = x"fe15f787");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"fe15f787");
		check(B = x"da9bbb0d");
		check(C = x"b71122fc");
		check(D = x"a811b278");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"a811b278");
		check(B = x"ae752899");
		check(C = x"da9bbb0d");
		check(D = x"b71122fc");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"b71122fc");
		check(B = x"2bbe757f");
		check(C = x"ae752899");
		check(D = x"da9bbb0d");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"da9bbb0d");
		check(B = x"7d4bd80b");
		check(C = x"2bbe757f");
		check(D = x"ae752899");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"ae752899");
		check(B = x"56cfa5cb");
		check(C = x"7d4bd80b");
		check(D = x"2bbe757f");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"2bbe757f");
		check(B = x"1754a316");
		check(C = x"56cfa5cb");
		check(D = x"7d4bd80b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"7d4bd80b");
		check(B = x"85567d90");
		check(C = x"1754a316");
		check(D = x"56cfa5cb");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"56cfa5cb");
		check(B = x"00df74d5");
		check(C = x"85567d90");
		check(D = x"1754a316");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"1754a316");
		check(B = x"608d6b7e");
		check(C = x"00df74d5");
		check(D = x"85567d90");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"85567d90");
		check(B = x"2d8071cc");
		check(C = x"608d6b7e");
		check(D = x"00df74d5");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"00df74d5");
		check(B = x"5dcee119");
		check(C = x"2d8071cc");
		check(D = x"608d6b7e");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"608d6b7e");
		check(B = x"edfe7e4b");
		check(C = x"5dcee119");
		check(D = x"2d8071cc");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"2d8071cc");
		check(B = x"4c2145b3");
		check(C = x"edfe7e4b");
		check(D = x"5dcee119");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"5dcee119");
		check(B = x"570c43e0");
		check(C = x"4c2145b3");
		check(D = x"edfe7e4b");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"edfe7e4b");
		check(B = x"977efd2a");
		check(C = x"570c43e0");
		check(D = x"4c2145b3");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"4c2145b3");
		check(B = x"c28ab49d");
		check(C = x"977efd2a");
		check(D = x"570c43e0");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"570c43e0");
		check(B = x"c9f162d4");
		check(C = x"c28ab49d");
		check(D = x"977efd2a");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"977efd2a");
		check(B = x"25bfae3b");
		check(C = x"c9f162d4");
		check(D = x"c28ab49d");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"c28ab49d");
		check(B = x"89980104");
		check(C = x"25bfae3b");
		check(D = x"c9f162d4");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"c9f162d4");
		check(B = x"f8c8365f");
		check(C = x"89980104");
		check(D = x"25bfae3b");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"25bfae3b");
		check(B = x"e6d3b398");
		check(C = x"f8c8365f");
		check(D = x"89980104");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"89980104");
		check(B = x"f54d8710");
		check(C = x"e6d3b398");
		check(D = x"f8c8365f");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f8c8365f");
		check(B = x"927b72e2");
		check(C = x"f54d8710");
		check(D = x"e6d3b398");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"e6d3b398");
		check(B = x"2e69afc7");
		check(C = x"927b72e2");
		check(D = x"f54d8710");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"f54d8710");
		check(B = x"aeb35766");
		check(C = x"2e69afc7");
		check(D = x"927b72e2");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"927b72e2");
		check(B = x"b4bf680e");
		check(C = x"aeb35766");
		check(D = x"2e69afc7");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"2e69afc7");
		check(B = x"4c8ffa80");
		check(C = x"b4bf680e");
		check(D = x"aeb35766");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"aeb35766");
		check(B = x"2361ed0a");
		check(C = x"4c8ffa80");
		check(D = x"b4bf680e");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b4bf680e");
		check(B = x"06a5e211");
		check(C = x"2361ed0a");
		check(D = x"4c8ffa80");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"4c8ffa80");
		check(B = x"b9c0c733");
		check(C = x"06a5e211");
		check(D = x"2361ed0a");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"2361ed0a");
		check(B = x"f1e6dc7a");
		check(C = x"b9c0c733");
		check(D = x"06a5e211");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"06a5e211");
		check(B = x"23a9451b");
		check(C = x"f1e6dc7a");
		check(D = x"b9c0c733");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"b9c0c733");
		check(B = x"8d41bf99");
		check(C = x"23a9451b");
		check(D = x"f1e6dc7a");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"f1e6dc7a");
		check(B = x"a3e88ead");
		check(C = x"8d41bf99");
		check(D = x"23a9451b");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"23a9451b");
		check(B = x"02c0b11c");
		check(C = x"a3e88ead");
		check(D = x"8d41bf99");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"8d41bf99");
		check(B = x"66f6468d");
		check(C = x"02c0b11c");
		check(D = x"a3e88ead");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"a3e88ead");
		check(B = x"90a35af5");
		check(C = x"66f6468d");
		check(D = x"02c0b11c");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"02c0b11c");
		check(B = x"b5d41f9c");
		check(C = x"90a35af5");
		check(D = x"66f6468d");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"66f6468d");
		check(B = x"a04b4904");
		check(C = x"b5d41f9c");
		check(D = x"90a35af5");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"90a35af5");
		check(B = x"703d54d8");
		check(C = x"a04b4904");
		check(D = x"b5d41f9c");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"b5d41f9c");
		check(B = x"71d10367");
		check(C = x"703d54d8");
		check(D = x"a04b4904");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"a04b4904");
		check(B = x"fc32dd6e");
		check(C = x"71d10367");
		check(D = x"703d54d8");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"703d54d8");
		check(B = x"65456b34");
		check(C = x"fc32dd6e");
		check(D = x"71d10367");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"71d10367");
		check(B = x"b35602cb");
		check(C = x"65456b34");
		check(D = x"fc32dd6e");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"fc32dd6e");
		check(B = x"33edb197");
		check(C = x"b35602cb");
		check(D = x"65456b34");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"65456b34");
		check(B = x"c1e942f1");
		check(C = x"33edb197");
		check(D = x"b35602cb");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"b35602cb");
		check(B = x"d9bb987c");
		check(C = x"c1e942f1");
		check(D = x"33edb197");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"33edb197");
		check(B = x"23a68048");
		check(C = x"d9bb987c");
		check(D = x"c1e942f1");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"c1e942f1");
		check(B = x"83877d1b");
		check(C = x"23a68048");
		check(D = x"d9bb987c");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"d9bb987c");
		check(B = x"0077c208");
		check(C = x"83877d1b");
		check(D = x"23a68048");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"23a68048");
		check(B = x"847fc2e7");
		check(C = x"0077c208");
		check(D = x"83877d1b");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"83877d1b");
		check(B = x"a3e2247f");
		check(C = x"847fc2e7");
		check(D = x"0077c208");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"0077c208");
		check(B = x"5e6bc930");
		check(C = x"a3e2247f");
		check(D = x"847fc2e7");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"847fc2e7");
		check(B = x"708ed9c2");
		check(C = x"5e6bc930");
		check(D = x"a3e2247f");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"a3e2247f");
		check(B = x"2baf1354");
		check(C = x"708ed9c2");
		check(D = x"5e6bc930");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"5e6bc930");
		check(B = x"d38f1e7f");
		check(C = x"2baf1354");
		check(D = x"708ed9c2");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"708ed9c2");
		check(B = x"1116e6d8");
		check(C = x"d38f1e7f");
		check(D = x"2baf1354");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"c3fcd3d7");
		check(B = x"6192e400");
		check(C = x"7dfb496c");
		check(D = x"ca67e13b");

		test_runner_cleanup(runner);
	end process;

end unit_md5_test_5_tb_arch;

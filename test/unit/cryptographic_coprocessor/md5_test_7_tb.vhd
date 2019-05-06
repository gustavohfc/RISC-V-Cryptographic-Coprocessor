library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")

entity md5_test_7_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_7_tb;

architecture md5_test_7_tb_arch OF md5_test_7_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal calculate_next_block  : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_idle               : std_logic             := '0';
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
			is_idle               => is_idle,
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

		-- Write the 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")
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

		data_in               <= x"797a6162";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		data_in               <= x"63646566";
		data_in_word_position <= x"7";
		wait until rising_edge(clk);

		data_in               <= x"6768696a";
		data_in_word_position <= x"8";
		wait until rising_edge(clk);

		data_in               <= x"6b6c6d6e";
		data_in_word_position <= x"9";
		wait until rising_edge(clk);

		data_in               <= x"6f707172";
		data_in_word_position <= x"a";
		wait until rising_edge(clk);

		data_in               <= x"73747576";
		data_in_word_position <= x"b";
		wait until rising_edge(clk);

		data_in               <= x"7778797a";
		data_in_word_position <= x"c";
		wait until rising_edge(clk);

		data_in               <= x"61626364";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"65666768";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"696a6b6c";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(512, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);

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
		check(B = x"b70fe6be");
		check(C = x"a811b278");
		check(D = x"fe15f787");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"fe15f787");
		check(B = x"e2f41717");
		check(C = x"b70fe6be");
		check(D = x"a811b278");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"a811b278");
		check(B = x"e5c3b955");
		check(C = x"e2f41717");
		check(D = x"b70fe6be");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"b70fe6be");
		check(B = x"eca8d29e");
		check(C = x"e5c3b955");
		check(D = x"e2f41717");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"e2f41717");
		check(B = x"7c8ef348");
		check(C = x"eca8d29e");
		check(D = x"e5c3b955");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"e5c3b955");
		check(B = x"d6031757");
		check(C = x"7c8ef348");
		check(D = x"eca8d29e");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"eca8d29e");
		check(B = x"120e727b");
		check(C = x"d6031757");
		check(D = x"7c8ef348");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"7c8ef348");
		check(B = x"85accf4d");
		check(C = x"120e727b");
		check(D = x"d6031757");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"d6031757");
		check(B = x"64da8a4a");
		check(C = x"85accf4d");
		check(D = x"120e727b");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"120e727b");
		check(B = x"7b83362b");
		check(C = x"64da8a4a");
		check(D = x"85accf4d");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"85accf4d");
		check(B = x"c843bfe5");
		check(C = x"7b83362b");
		check(D = x"64da8a4a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"64da8a4a");
		check(B = x"edba8dec");
		check(C = x"c843bfe5");
		check(D = x"7b83362b");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"7b83362b");
		check(B = x"277948c8");
		check(C = x"edba8dec");
		check(D = x"c843bfe5");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"c843bfe5");
		check(B = x"b768422e");
		check(C = x"277948c8");
		check(D = x"edba8dec");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"edba8dec");
		check(B = x"81d91ea5");
		check(C = x"b768422e");
		check(D = x"277948c8");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"277948c8");
		check(B = x"1413c88c");
		check(C = x"81d91ea5");
		check(D = x"b768422e");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"b768422e");
		check(B = x"11a3a8d1");
		check(C = x"1413c88c");
		check(D = x"81d91ea5");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"81d91ea5");
		check(B = x"a0a63c08");
		check(C = x"11a3a8d1");
		check(D = x"1413c88c");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"1413c88c");
		check(B = x"19f665ea");
		check(C = x"a0a63c08");
		check(D = x"11a3a8d1");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"11a3a8d1");
		check(B = x"cacd85cc");
		check(C = x"19f665ea");
		check(D = x"a0a63c08");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"a0a63c08");
		check(B = x"e57949fb");
		check(C = x"cacd85cc");
		check(D = x"19f665ea");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"19f665ea");
		check(B = x"9a1a8832");
		check(C = x"e57949fb");
		check(D = x"cacd85cc");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"cacd85cc");
		check(B = x"88e9b8ac");
		check(C = x"9a1a8832");
		check(D = x"e57949fb");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"e57949fb");
		check(B = x"b1236449");
		check(C = x"88e9b8ac");
		check(D = x"9a1a8832");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"9a1a8832");
		check(B = x"e9943555");
		check(C = x"b1236449");
		check(D = x"88e9b8ac");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"88e9b8ac");
		check(B = x"0119e961");
		check(C = x"e9943555");
		check(D = x"b1236449");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"b1236449");
		check(B = x"b1bbf766");
		check(C = x"0119e961");
		check(D = x"e9943555");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"e9943555");
		check(B = x"59301747");
		check(C = x"b1bbf766");
		check(D = x"0119e961");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"0119e961");
		check(B = x"6d5ace80");
		check(C = x"59301747");
		check(D = x"b1bbf766");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b1bbf766");
		check(B = x"a7516a5b");
		check(C = x"6d5ace80");
		check(D = x"59301747");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"59301747");
		check(B = x"c9312510");
		check(C = x"a7516a5b");
		check(D = x"6d5ace80");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"6d5ace80");
		check(B = x"b00a85f5");
		check(C = x"c9312510");
		check(D = x"a7516a5b");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"a7516a5b");
		check(B = x"f90c2edb");
		check(C = x"b00a85f5");
		check(D = x"c9312510");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"c9312510");
		check(B = x"b5388bed");
		check(C = x"f90c2edb");
		check(D = x"b00a85f5");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"b00a85f5");
		check(B = x"dc1afb92");
		check(C = x"b5388bed");
		check(D = x"f90c2edb");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"f90c2edb");
		check(B = x"c792a00b");
		check(C = x"dc1afb92");
		check(D = x"b5388bed");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"b5388bed");
		check(B = x"65d48d26");
		check(C = x"c792a00b");
		check(D = x"dc1afb92");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"dc1afb92");
		check(B = x"7b21cca3");
		check(C = x"65d48d26");
		check(D = x"c792a00b");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"c792a00b");
		check(B = x"577368f2");
		check(C = x"7b21cca3");
		check(D = x"65d48d26");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"65d48d26");
		check(B = x"c6525c85");
		check(C = x"577368f2");
		check(D = x"7b21cca3");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"7b21cca3");
		check(B = x"33ae3868");
		check(C = x"c6525c85");
		check(D = x"577368f2");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"577368f2");
		check(B = x"fbd59cb4");
		check(C = x"33ae3868");
		check(D = x"c6525c85");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"c6525c85");
		check(B = x"10b2e812");
		check(C = x"fbd59cb4");
		check(D = x"33ae3868");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"33ae3868");
		check(B = x"3581726e");
		check(C = x"10b2e812");
		check(D = x"fbd59cb4");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"fbd59cb4");
		check(B = x"e47a28cf");
		check(C = x"3581726e");
		check(D = x"10b2e812");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"10b2e812");
		check(B = x"00e3a4af");
		check(C = x"e47a28cf");
		check(D = x"3581726e");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"3581726e");
		check(B = x"c43393b6");
		check(C = x"00e3a4af");
		check(D = x"e47a28cf");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"e47a28cf");
		check(B = x"0cb5ac07");
		check(C = x"c43393b6");
		check(D = x"00e3a4af");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"00e3a4af");
		check(B = x"0a03f53b");
		check(C = x"0cb5ac07");
		check(D = x"c43393b6");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"c43393b6");
		check(B = x"5628be72");
		check(C = x"0a03f53b");
		check(D = x"0cb5ac07");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"0cb5ac07");
		check(B = x"41ca09d8");
		check(C = x"5628be72");
		check(D = x"0a03f53b");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"0a03f53b");
		check(B = x"d4960244");
		check(C = x"41ca09d8");
		check(D = x"5628be72");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"5628be72");
		check(B = x"d304e805");
		check(C = x"d4960244");
		check(D = x"41ca09d8");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"41ca09d8");
		check(B = x"adeb6f0a");
		check(C = x"d304e805");
		check(D = x"d4960244");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d4960244");
		check(B = x"4df01154");
		check(C = x"adeb6f0a");
		check(D = x"d304e805");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"d304e805");
		check(B = x"a9779475");
		check(C = x"4df01154");
		check(D = x"adeb6f0a");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"adeb6f0a");
		check(B = x"7edca4dc");
		check(C = x"a9779475");
		check(D = x"4df01154");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"4df01154");
		check(B = x"b0e895e1");
		check(C = x"7edca4dc");
		check(D = x"a9779475");

		-- Round result
		wait until rising_edge(clk);
		check(A = x"b5353455");
		check(B = x"a0b6416a");
		check(C = x"179781da");
		check(D = x"b9a9e8eb");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);    -- Wait the padding

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"b9a9e8eb");
		check(B = x"c077cdbd");
		check(C = x"a0b6416a");
		check(D = x"179781da");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"179781da");
		check(B = x"3e92815f");
		check(C = x"c077cdbd");
		check(D = x"a0b6416a");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"a0b6416a");
		check(B = x"a677f93c");
		check(C = x"3e92815f");
		check(D = x"c077cdbd");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"c077cdbd");
		check(B = x"23ea1ae1");
		check(C = x"a677f93c");
		check(D = x"3e92815f");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"3e92815f");
		check(B = x"5725705b");
		check(C = x"23ea1ae1");
		check(D = x"a677f93c");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"a677f93c");
		check(B = x"253452f3");
		check(C = x"5725705b");
		check(D = x"23ea1ae1");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"23ea1ae1");
		check(B = x"54790020");
		check(C = x"253452f3");
		check(D = x"5725705b");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"5725705b");
		check(B = x"6bc31968");
		check(C = x"54790020");
		check(D = x"253452f3");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"253452f3");
		check(B = x"f9690c6a");
		check(C = x"6bc31968");
		check(D = x"54790020");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"54790020");
		check(B = x"9e99ae46");
		check(C = x"f9690c6a");
		check(D = x"6bc31968");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"6bc31968");
		check(B = x"911049cc");
		check(C = x"9e99ae46");
		check(D = x"f9690c6a");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"f9690c6a");
		check(B = x"f44bb00b");
		check(C = x"911049cc");
		check(D = x"9e99ae46");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"9e99ae46");
		check(B = x"b8e19c8a");
		check(C = x"f44bb00b");
		check(D = x"911049cc");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"911049cc");
		check(B = x"f7f41162");
		check(C = x"b8e19c8a");
		check(D = x"f44bb00b");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"f44bb00b");
		check(B = x"76bfe24c");
		check(C = x"f7f41162");
		check(D = x"b8e19c8a");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"b8e19c8a");
		check(B = x"b24f1f41");
		check(C = x"76bfe24c");
		check(D = x"f7f41162");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"f7f41162");
		check(B = x"dc45c64d");
		check(C = x"b24f1f41");
		check(D = x"76bfe24c");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"76bfe24c");
		check(B = x"d18da565");
		check(C = x"dc45c64d");
		check(D = x"b24f1f41");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"b24f1f41");
		check(B = x"d20843b0");
		check(C = x"d18da565");
		check(D = x"dc45c64d");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"dc45c64d");
		check(B = x"7abf1c94");
		check(C = x"d20843b0");
		check(D = x"d18da565");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"d18da565");
		check(B = x"1b02c454");
		check(C = x"7abf1c94");
		check(D = x"d20843b0");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"d20843b0");
		check(B = x"2d2e5c71");
		check(C = x"1b02c454");
		check(D = x"7abf1c94");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"7abf1c94");
		check(B = x"6eced167");
		check(C = x"2d2e5c71");
		check(D = x"1b02c454");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"1b02c454");
		check(B = x"7ae7dd86");
		check(C = x"6eced167");
		check(D = x"2d2e5c71");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"2d2e5c71");
		check(B = x"7455c59a");
		check(C = x"7ae7dd86");
		check(D = x"6eced167");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"6eced167");
		check(B = x"0abd5863");
		check(C = x"7455c59a");
		check(D = x"7ae7dd86");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"7ae7dd86");
		check(B = x"587f74f9");
		check(C = x"0abd5863");
		check(D = x"7455c59a");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"7455c59a");
		check(B = x"4f4128ed");
		check(C = x"587f74f9");
		check(D = x"0abd5863");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"0abd5863");
		check(B = x"5edc9bfc");
		check(C = x"4f4128ed");
		check(D = x"587f74f9");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"587f74f9");
		check(B = x"71074aca");
		check(C = x"5edc9bfc");
		check(D = x"4f4128ed");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"4f4128ed");
		check(B = x"75f1cf2d");
		check(C = x"71074aca");
		check(D = x"5edc9bfc");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"5edc9bfc");
		check(B = x"8046f321");
		check(C = x"75f1cf2d");
		check(D = x"71074aca");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"71074aca");
		check(B = x"b8bbb36f");
		check(C = x"8046f321");
		check(D = x"75f1cf2d");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"75f1cf2d");
		check(B = x"e741259b");
		check(C = x"b8bbb36f");
		check(D = x"8046f321");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"8046f321");
		check(B = x"7d65e8e6");
		check(C = x"e741259b");
		check(D = x"b8bbb36f");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b8bbb36f");
		check(B = x"1d364ebb");
		check(C = x"7d65e8e6");
		check(D = x"e741259b");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"e741259b");
		check(B = x"66086659");
		check(C = x"1d364ebb");
		check(D = x"7d65e8e6");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"7d65e8e6");
		check(B = x"43b2a824");
		check(C = x"66086659");
		check(D = x"1d364ebb");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"1d364ebb");
		check(B = x"f8bf54d1");
		check(C = x"43b2a824");
		check(D = x"66086659");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"66086659");
		check(B = x"e49bd2a3");
		check(C = x"f8bf54d1");
		check(D = x"43b2a824");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"43b2a824");
		check(B = x"c83d0a01");
		check(C = x"e49bd2a3");
		check(D = x"f8bf54d1");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"f8bf54d1");
		check(B = x"33259214");
		check(C = x"c83d0a01");
		check(D = x"e49bd2a3");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"e49bd2a3");
		check(B = x"03327f45");
		check(C = x"33259214");
		check(D = x"c83d0a01");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"c83d0a01");
		check(B = x"7fa326b0");
		check(C = x"03327f45");
		check(D = x"33259214");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"33259214");
		check(B = x"9c0d886f");
		check(C = x"7fa326b0");
		check(D = x"03327f45");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"03327f45");
		check(B = x"8bfa2843");
		check(C = x"9c0d886f");
		check(D = x"7fa326b0");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"7fa326b0");
		check(B = x"0ed3b36c");
		check(C = x"8bfa2843");
		check(D = x"9c0d886f");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"9c0d886f");
		check(B = x"39826d34");
		check(C = x"0ed3b36c");
		check(D = x"8bfa2843");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"8bfa2843");
		check(B = x"1c406df4");
		check(C = x"39826d34");
		check(D = x"0ed3b36c");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"0ed3b36c");
		check(B = x"68e2e444");
		check(C = x"1c406df4");
		check(D = x"39826d34");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"39826d34");
		check(B = x"230a3ad7");
		check(C = x"68e2e444");
		check(D = x"1c406df4");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"1c406df4");
		check(B = x"a4226944");
		check(C = x"230a3ad7");
		check(D = x"68e2e444");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"68e2e444");
		check(B = x"1864a109");
		check(C = x"a4226944");
		check(D = x"230a3ad7");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"230a3ad7");
		check(B = x"3559aecc");
		check(C = x"1864a109");
		check(D = x"a4226944");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"a4226944");
		check(B = x"dcfef425");
		check(C = x"3559aecc");
		check(D = x"1864a109");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"1864a109");
		check(B = x"c71d7dc7");
		check(C = x"dcfef425");
		check(D = x"3559aecc");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"3559aecc");
		check(B = x"9ac7c86d");
		check(C = x"c71d7dc7");
		check(D = x"dcfef425");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"dcfef425");
		check(B = x"1ff75b2e");
		check(C = x"9ac7c86d");
		check(D = x"c71d7dc7");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"c71d7dc7");
		check(B = x"453d6dc6");
		check(C = x"1ff75b2e");
		check(D = x"9ac7c86d");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"9ac7c86d");
		check(B = x"d14f6bbc");
		check(C = x"453d6dc6");
		check(D = x"1ff75b2e");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"1ff75b2e");
		check(B = x"74c1b64d");
		check(C = x"d14f6bbc");
		check(D = x"453d6dc6");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"453d6dc6");
		check(B = x"716e467f");
		check(C = x"74c1b64d");
		check(D = x"d14f6bbc");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"d14f6bbc");
		check(B = x"c1c80429");
		check(C = x"716e467f");
		check(D = x"74c1b64d");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"74c1b64d");
		check(B = x"23f6f0f2");
		check(C = x"c1c80429");
		check(D = x"716e467f");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"a2eaf629");
		check(B = x"5c32adc4");
		check(C = x"03865fd9");
		check(D = x"6a2f182b");

		test_runner_cleanup(runner);
	end process;

end md5_test_7_tb_arch;

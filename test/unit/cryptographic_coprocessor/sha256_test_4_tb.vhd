library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 208 bits message ("abcdefghijklmnopqrstuvwxyz")

entity sha256_test_4_tb IS
	generic(
		runner_cfg : string
	);
end sha256_test_4_tb;

architecture sha256_test_4_tb_arch OF sha256_test_4_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal calculate_next_block  : std_logic             := '0';
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : sha256_error_type;
	signal H0_out                : unsigned(31 downto 0) := (others => '0');
	signal H1_out                : unsigned(31 downto 0) := (others => '0');
	signal H2_out                : unsigned(31 downto 0) := (others => '0');
	signal H3_out                : unsigned(31 downto 0) := (others => '0');
	signal H4_out                : unsigned(31 downto 0) := (others => '0');
	signal H5_out                : unsigned(31 downto 0) := (others => '0');
	signal H6_out                : unsigned(31 downto 0) := (others => '0');
	signal H7_out                : unsigned(31 downto 0) := (others => '0');

begin
	sha256 : entity work.sha256
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
			H0_out                => H0_out,
			H1_out                => H1_out,
			H2_out                => H2_out,
			H3_out                => H3_out,
			H4_out                => H4_out,
			H5_out                => H5_out,
			H6_out                => H6_out,
			H7_out                => H7_out
		);

	clk <= not clk after 10 ps;

	main : process
		alias A is <<signal sha256.A : unsigned(31 downto 0)>>;
		alias B is <<signal sha256.B : unsigned(31 downto 0)>>;
		alias C is <<signal sha256.C : unsigned(31 downto 0)>>;
		alias D is <<signal sha256.D : unsigned(31 downto 0)>>;
		alias E is <<signal sha256.E : unsigned(31 downto 0)>>;
		alias F is <<signal sha256.F : unsigned(31 downto 0)>>;
		alias G is <<signal sha256.G : unsigned(31 downto 0)>>;
		alias H is <<signal sha256.H : unsigned(31 downto 0)>>;
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

		-------------------------------------------- Round  --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"5d6aebb1");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"fa2a4606");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"323062d2");
		check(B = x"5d6aebb1");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"51b4d2d1");
		check(F = x"fa2a4606");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"a5204460");
		check(B = x"323062d2");
		check(C = x"5d6aebb1");
		check(D = x"6a09e667");
		check(E = x"8ac84df3");
		check(F = x"51b4d2d1");
		check(G = x"fa2a4606");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"edce7fe2");
		check(B = x"a5204460");
		check(C = x"323062d2");
		check(D = x"5d6aebb1");
		check(E = x"975b48cb");
		check(F = x"8ac84df3");
		check(G = x"51b4d2d1");
		check(H = x"fa2a4606");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"25281b47");
		check(B = x"edce7fe2");
		check(C = x"a5204460");
		check(D = x"323062d2");
		check(E = x"5fd725da");
		check(F = x"975b48cb");
		check(G = x"8ac84df3");
		check(H = x"51b4d2d1");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"4a6482e8");
		check(B = x"25281b47");
		check(C = x"edce7fe2");
		check(D = x"a5204460");
		check(E = x"244e5353");
		check(F = x"5fd725da");
		check(G = x"975b48cb");
		check(H = x"8ac84df3");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"34f2621f");
		check(B = x"4a6482e8");
		check(C = x"25281b47");
		check(D = x"edce7fe2");
		check(E = x"d4d5b7e6");
		check(F = x"244e5353");
		check(G = x"5fd725da");
		check(H = x"975b48cb");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"97bd4013");
		check(B = x"34f2621f");
		check(C = x"4a6482e8");
		check(D = x"25281b47");
		check(E = x"4cde79df");
		check(F = x"d4d5b7e6");
		check(G = x"244e5353");
		check(H = x"5fd725da");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"ee00f791");
		check(B = x"97bd4013");
		check(C = x"34f2621f");
		check(D = x"4a6482e8");
		check(E = x"ebc12d0d");
		check(F = x"4cde79df");
		check(G = x"d4d5b7e6");
		check(H = x"244e5353");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"85acd115");
		check(B = x"ee00f791");
		check(C = x"97bd4013");
		check(D = x"34f2621f");
		check(E = x"548fe78f");
		check(F = x"ebc12d0d");
		check(G = x"4cde79df");
		check(H = x"d4d5b7e6");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"af54050f");
		check(B = x"85acd115");
		check(C = x"ee00f791");
		check(D = x"97bd4013");
		check(E = x"021646e8");
		check(F = x"548fe78f");
		check(G = x"ebc12d0d");
		check(H = x"4cde79df");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"449ef174");
		check(B = x"af54050f");
		check(C = x"85acd115");
		check(D = x"ee00f791");
		check(E = x"999b1714");
		check(F = x"021646e8");
		check(G = x"548fe78f");
		check(H = x"ebc12d0d");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"86f2614b");
		check(B = x"449ef174");
		check(C = x"af54050f");
		check(D = x"85acd115");
		check(E = x"0e163e0f");
		check(F = x"999b1714");
		check(G = x"021646e8");
		check(H = x"548fe78f");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"7d837152");
		check(B = x"86f2614b");
		check(C = x"449ef174");
		check(D = x"af54050f");
		check(E = x"59f45f3e");
		check(F = x"0e163e0f");
		check(G = x"999b1714");
		check(H = x"021646e8");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"675dc783");
		check(B = x"7d837152");
		check(C = x"86f2614b");
		check(D = x"449ef174");
		check(E = x"b9e8e187");
		check(F = x"59f45f3e");
		check(G = x"0e163e0f");
		check(H = x"999b1714");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"50336d82");
		check(B = x"675dc783");
		check(C = x"7d837152");
		check(D = x"86f2614b");
		check(E = x"9a2cb720");
		check(F = x"b9e8e187");
		check(G = x"59f45f3e");
		check(H = x"0e163e0f");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"8ea52e10");
		check(B = x"50336d82");
		check(C = x"675dc783");
		check(D = x"7d837152");
		check(E = x"6adbd61e");
		check(F = x"9a2cb720");
		check(G = x"b9e8e187");
		check(H = x"59f45f3e");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"7f3070be");
		check(B = x"8ea52e10");
		check(C = x"50336d82");
		check(D = x"675dc783");
		check(E = x"eee8f5f7");
		check(F = x"6adbd61e");
		check(G = x"9a2cb720");
		check(H = x"b9e8e187");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"65d51a4d");
		check(B = x"7f3070be");
		check(C = x"8ea52e10");
		check(D = x"50336d82");
		check(E = x"930458ee");
		check(F = x"eee8f5f7");
		check(G = x"6adbd61e");
		check(H = x"9a2cb720");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"ee54c86a");
		check(B = x"65d51a4d");
		check(C = x"7f3070be");
		check(D = x"8ea52e10");
		check(E = x"ef5b9e24");
		check(F = x"930458ee");
		check(G = x"eee8f5f7");
		check(H = x"6adbd61e");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"152258ad");
		check(B = x"ee54c86a");
		check(C = x"65d51a4d");
		check(D = x"7f3070be");
		check(E = x"888f434a");
		check(F = x"ef5b9e24");
		check(G = x"930458ee");
		check(H = x"eee8f5f7");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"cf9e3f98");
		check(B = x"152258ad");
		check(C = x"ee54c86a");
		check(D = x"65d51a4d");
		check(E = x"e037cc7c");
		check(F = x"888f434a");
		check(G = x"ef5b9e24");
		check(H = x"930458ee");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"07f22ec3");
		check(B = x"cf9e3f98");
		check(C = x"152258ad");
		check(D = x"ee54c86a");
		check(E = x"e6d1603f");
		check(F = x"e037cc7c");
		check(G = x"888f434a");
		check(H = x"ef5b9e24");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"a752fe8e");
		check(B = x"07f22ec3");
		check(C = x"cf9e3f98");
		check(D = x"152258ad");
		check(E = x"0e95d031");
		check(F = x"e6d1603f");
		check(G = x"e037cc7c");
		check(H = x"888f434a");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"09368895");
		check(B = x"a752fe8e");
		check(C = x"07f22ec3");
		check(D = x"cf9e3f98");
		check(E = x"802ae30f");
		check(F = x"0e95d031");
		check(G = x"e6d1603f");
		check(H = x"e037cc7c");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"1de47653");
		check(B = x"09368895");
		check(C = x"a752fe8e");
		check(D = x"07f22ec3");
		check(E = x"094847af");
		check(F = x"802ae30f");
		check(G = x"0e95d031");
		check(H = x"e6d1603f");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"d2144548");
		check(B = x"1de47653");
		check(C = x"09368895");
		check(D = x"a752fe8e");
		check(E = x"e856b6b4");
		check(F = x"094847af");
		check(G = x"802ae30f");
		check(H = x"0e95d031");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"c51345cb");
		check(B = x"d2144548");
		check(C = x"1de47653");
		check(D = x"09368895");
		check(E = x"035b5d50");
		check(F = x"e856b6b4");
		check(G = x"094847af");
		check(H = x"802ae30f");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"f51dcfb6");
		check(B = x"c51345cb");
		check(C = x"d2144548");
		check(D = x"1de47653");
		check(E = x"97323c04");
		check(F = x"035b5d50");
		check(G = x"e856b6b4");
		check(H = x"094847af");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"66c7078d");
		check(B = x"f51dcfb6");
		check(C = x"c51345cb");
		check(D = x"d2144548");
		check(E = x"f7c8373f");
		check(F = x"97323c04");
		check(G = x"035b5d50");
		check(H = x"e856b6b4");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"e27fbe5f");
		check(B = x"66c7078d");
		check(C = x"f51dcfb6");
		check(D = x"c51345cb");
		check(E = x"55b7f9d8");
		check(F = x"f7c8373f");
		check(G = x"97323c04");
		check(H = x"035b5d50");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"8a599ea0");
		check(B = x"e27fbe5f");
		check(C = x"66c7078d");
		check(D = x"f51dcfb6");
		check(E = x"7473d0e9");
		check(F = x"55b7f9d8");
		check(G = x"f7c8373f");
		check(H = x"97323c04");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"094c6999");
		check(B = x"8a599ea0");
		check(C = x"e27fbe5f");
		check(D = x"66c7078d");
		check(E = x"6a21e375");
		check(F = x"7473d0e9");
		check(G = x"55b7f9d8");
		check(H = x"f7c8373f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"09a0f3bf");
		check(B = x"094c6999");
		check(C = x"8a599ea0");
		check(D = x"e27fbe5f");
		check(E = x"a6cd0893");
		check(F = x"6a21e375");
		check(G = x"7473d0e9");
		check(H = x"55b7f9d8");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"b59a592c");
		check(B = x"09a0f3bf");
		check(C = x"094c6999");
		check(D = x"8a599ea0");
		check(E = x"b2728e04");
		check(F = x"a6cd0893");
		check(G = x"6a21e375");
		check(H = x"7473d0e9");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"06e63a77");
		check(B = x"b59a592c");
		check(C = x"09a0f3bf");
		check(D = x"094c6999");
		check(E = x"fa4fd70b");
		check(F = x"b2728e04");
		check(G = x"a6cd0893");
		check(H = x"6a21e375");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"bcdf60c5");
		check(B = x"06e63a77");
		check(C = x"b59a592c");
		check(D = x"09a0f3bf");
		check(E = x"35a0e968");
		check(F = x"fa4fd70b");
		check(G = x"b2728e04");
		check(H = x"a6cd0893");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"b7f7a01c");
		check(B = x"bcdf60c5");
		check(C = x"06e63a77");
		check(D = x"b59a592c");
		check(E = x"f820f33d");
		check(F = x"35a0e968");
		check(G = x"fa4fd70b");
		check(H = x"b2728e04");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"24f95824");
		check(B = x"b7f7a01c");
		check(C = x"bcdf60c5");
		check(D = x"06e63a77");
		check(E = x"30046b96");
		check(F = x"f820f33d");
		check(G = x"35a0e968");
		check(H = x"fa4fd70b");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"d028cc13");
		check(B = x"24f95824");
		check(C = x"b7f7a01c");
		check(D = x"bcdf60c5");
		check(E = x"f48fc536");
		check(F = x"30046b96");
		check(G = x"f820f33d");
		check(H = x"35a0e968");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"3bde73e6");
		check(B = x"d028cc13");
		check(C = x"24f95824");
		check(D = x"b7f7a01c");
		check(E = x"0c1f0f95");
		check(F = x"f48fc536");
		check(G = x"30046b96");
		check(H = x"f820f33d");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"bf9873cf");
		check(B = x"3bde73e6");
		check(C = x"d028cc13");
		check(D = x"24f95824");
		check(E = x"de8de0e0");
		check(F = x"0c1f0f95");
		check(G = x"f48fc536");
		check(H = x"30046b96");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"abd3c159");
		check(B = x"bf9873cf");
		check(C = x"3bde73e6");
		check(D = x"d028cc13");
		check(E = x"04dfc6e8");
		check(F = x"de8de0e0");
		check(G = x"0c1f0f95");
		check(H = x"f48fc536");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"a9699642");
		check(B = x"abd3c159");
		check(C = x"bf9873cf");
		check(D = x"3bde73e6");
		check(E = x"8e7b261f");
		check(F = x"04dfc6e8");
		check(G = x"de8de0e0");
		check(H = x"0c1f0f95");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"ee44af5a");
		check(B = x"a9699642");
		check(C = x"abd3c159");
		check(D = x"bf9873cf");
		check(E = x"c0332b7c");
		check(F = x"8e7b261f");
		check(G = x"04dfc6e8");
		check(H = x"de8de0e0");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"d92840da");
		check(B = x"ee44af5a");
		check(C = x"a9699642");
		check(D = x"abd3c159");
		check(E = x"1983fb05");
		check(F = x"c0332b7c");
		check(G = x"8e7b261f");
		check(H = x"04dfc6e8");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"3aec1e97");
		check(B = x"d92840da");
		check(C = x"ee44af5a");
		check(D = x"a9699642");
		check(E = x"ebb7a786");
		check(F = x"1983fb05");
		check(G = x"c0332b7c");
		check(H = x"8e7b261f");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"322955cd");
		check(B = x"3aec1e97");
		check(C = x"d92840da");
		check(D = x"ee44af5a");
		check(E = x"56ae5107");
		check(F = x"ebb7a786");
		check(G = x"1983fb05");
		check(H = x"c0332b7c");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"a93c864a");
		check(B = x"322955cd");
		check(C = x"3aec1e97");
		check(D = x"d92840da");
		check(E = x"15a3efd4");
		check(F = x"56ae5107");
		check(G = x"ebb7a786");
		check(H = x"1983fb05");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"294bc7bf");
		check(B = x"a93c864a");
		check(C = x"322955cd");
		check(D = x"3aec1e97");
		check(E = x"5e44aef8");
		check(F = x"15a3efd4");
		check(G = x"56ae5107");
		check(H = x"ebb7a786");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"d20bb107");
		check(B = x"294bc7bf");
		check(C = x"a93c864a");
		check(D = x"322955cd");
		check(E = x"0b18c0bb");
		check(F = x"5e44aef8");
		check(G = x"15a3efd4");
		check(H = x"56ae5107");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"2ecd83ef");
		check(B = x"d20bb107");
		check(C = x"294bc7bf");
		check(D = x"a93c864a");
		check(E = x"6572ef59");
		check(F = x"0b18c0bb");
		check(G = x"5e44aef8");
		check(H = x"15a3efd4");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"114cc8ee");
		check(B = x"2ecd83ef");
		check(C = x"d20bb107");
		check(D = x"294bc7bf");
		check(E = x"ad78215d");
		check(F = x"6572ef59");
		check(G = x"0b18c0bb");
		check(H = x"5e44aef8");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"91c5b8b2");
		check(B = x"114cc8ee");
		check(C = x"2ecd83ef");
		check(D = x"d20bb107");
		check(E = x"b8c3fe6a");
		check(F = x"ad78215d");
		check(G = x"6572ef59");
		check(H = x"0b18c0bb");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"9621d47f");
		check(B = x"91c5b8b2");
		check(C = x"114cc8ee");
		check(D = x"2ecd83ef");
		check(E = x"df58d252");
		check(F = x"b8c3fe6a");
		check(G = x"ad78215d");
		check(H = x"6572ef59");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"f81089fd");
		check(B = x"9621d47f");
		check(C = x"91c5b8b2");
		check(D = x"114cc8ee");
		check(E = x"d472faa5");
		check(F = x"df58d252");
		check(G = x"b8c3fe6a");
		check(H = x"ad78215d");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"754249d1");
		check(B = x"f81089fd");
		check(C = x"9621d47f");
		check(D = x"91c5b8b2");
		check(E = x"82c164a5");
		check(F = x"d472faa5");
		check(G = x"df58d252");
		check(H = x"b8c3fe6a");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"424a02fa");
		check(B = x"754249d1");
		check(C = x"f81089fd");
		check(D = x"9621d47f");
		check(E = x"c51273fc");
		check(F = x"82c164a5");
		check(G = x"d472faa5");
		check(H = x"df58d252");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"972c1989");
		check(B = x"424a02fa");
		check(C = x"754249d1");
		check(D = x"f81089fd");
		check(E = x"0dc06828");
		check(F = x"c51273fc");
		check(G = x"82c164a5");
		check(H = x"d472faa5");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"c82b2ab7");
		check(B = x"972c1989");
		check(C = x"424a02fa");
		check(D = x"754249d1");
		check(E = x"4f10117d");
		check(F = x"0dc06828");
		check(G = x"c51273fc");
		check(H = x"82c164a5");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d716d418");
		check(B = x"c82b2ab7");
		check(C = x"972c1989");
		check(D = x"424a02fa");
		check(E = x"7f10be5a");
		check(F = x"4f10117d");
		check(G = x"0dc06828");
		check(H = x"c51273fc");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"e28bddd2");
		check(B = x"d716d418");
		check(C = x"c82b2ab7");
		check(D = x"972c1989");
		check(E = x"7f545947");
		check(F = x"7f10be5a");
		check(G = x"4f10117d");
		check(H = x"0dc06828");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"d86effaa");
		check(B = x"e28bddd2");
		check(C = x"d716d418");
		check(D = x"c82b2ab7");
		check(E = x"344c9401");
		check(F = x"7f545947");
		check(G = x"7f10be5a");
		check(H = x"4f10117d");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"07ba9a78");
		check(B = x"d86effaa");
		check(C = x"e28bddd2");
		check(D = x"d716d418");
		check(E = x"0d230f99");
		check(F = x"344c9401");
		check(G = x"7f545947");
		check(H = x"7f10be5a");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"71c480df");
		check(H1_out = x"93d6ae2f");
		check(H2_out = x"1efad144");
		check(H3_out = x"7c66c952");
		check(H4_out = x"5e316218");
		check(H5_out = x"cf51fc8d");
		check(H6_out = x"9ed832f2");
		check(H7_out = x"daf18b73");

		test_runner_cleanup(runner);
	end process;

end sha256_test_4_tb_arch;

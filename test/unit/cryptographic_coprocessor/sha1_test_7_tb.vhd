library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 640 bits message ("12345678901234567890123456789012345678901234567890123456789012345678901234567890")

entity unit_sha1_test_7_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha1_test_7_tb;

architecture unit_sha1_test_7_tb_arch OF unit_sha1_test_7_tb IS
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
	signal error                 : sha1_error_type;
	signal H0_out                : unsigned(31 downto 0) := (others => '0');
	signal H1_out                : unsigned(31 downto 0) := (others => '0');
	signal H2_out                : unsigned(31 downto 0) := (others => '0');
	signal H3_out                : unsigned(31 downto 0) := (others => '0');
	signal H4_out                : unsigned(31 downto 0) := (others => '0');

begin
	sha1 : entity work.sha1
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
			H4_out                => H4_out
		);

	clk <= not clk after 10 ps;

	main : process
		alias A is <<signal sha1.A : unsigned(31 downto 0)>>;
		alias B is <<signal sha1.B : unsigned(31 downto 0)>>;
		alias C is <<signal sha1.C : unsigned(31 downto 0)>>;
		alias D is <<signal sha1.D : unsigned(31 downto 0)>>;
		alias E is <<signal sha1.E : unsigned(31 downto 0)>>;
	begin
		test_runner_setup(runner, runner_cfg);

		-- Start new hash
		start_new_hash <= '1';
		wait until rising_edge(clk);
		start_new_hash <= '0';

		-- Write the first 512 bits
		write_data_in <= '1';

		data_in               <= x"31323334";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"7";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"8";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"9";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"a";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"b";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"c";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '0';
		wait until rising_edge(clk);
		calculate_next_block <= '0';

		wait until rising_edge(clk);
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"d0e6cbe7");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"b8c0813f");
		check(B = x"d0e6cbe7");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"c04f1880");
		check(B = x"b8c0813f");
		check(C = x"f439b2f9");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"049ef2c2");
		check(B = x"c04f1880");
		check(C = x"ee30204f");
		check(D = x"f439b2f9");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"739af642");
		check(B = x"049ef2c2");
		check(C = x"3013c620");
		check(D = x"ee30204f");
		check(E = x"f439b2f9");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"dd7fea21");
		check(B = x"739af642");
		check(C = x"8127bcb0");
		check(D = x"3013c620");
		check(E = x"ee30204f");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"2ee9c97b");
		check(B = x"dd7fea21");
		check(C = x"9ce6bd90");
		check(D = x"8127bcb0");
		check(E = x"3013c620");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"3d665ce0");
		check(B = x"2ee9c97b");
		check(C = x"775ffa88");
		check(D = x"9ce6bd90");
		check(E = x"8127bcb0");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"71fa040e");
		check(B = x"3d665ce0");
		check(C = x"cbba725e");
		check(D = x"775ffa88");
		check(E = x"9ce6bd90");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"b91de46f");
		check(B = x"71fa040e");
		check(C = x"0f599738");
		check(D = x"cbba725e");
		check(E = x"775ffa88");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"b229aba4");
		check(B = x"b91de46f");
		check(C = x"9c7e8103");
		check(D = x"0f599738");
		check(E = x"cbba725e");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"3f052ad8");
		check(B = x"b229aba4");
		check(C = x"ee47791b");
		check(D = x"9c7e8103");
		check(E = x"0f599738");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"3208c60d");
		check(B = x"3f052ad8");
		check(C = x"2c8a6ae9");
		check(D = x"ee47791b");
		check(E = x"9c7e8103");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"57906d43");
		check(B = x"3208c60d");
		check(C = x"0fc14ab6");
		check(D = x"2c8a6ae9");
		check(E = x"ee47791b");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"80923f32");
		check(B = x"57906d43");
		check(C = x"4c823183");
		check(D = x"0fc14ab6");
		check(E = x"2c8a6ae9");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"174821bd");
		check(B = x"80923f32");
		check(C = x"d5e41b50");
		check(D = x"4c823183");
		check(E = x"0fc14ab6");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"2fcc1b8e");
		check(B = x"174821bd");
		check(C = x"a0248fcc");
		check(D = x"d5e41b50");
		check(E = x"4c823183");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"6d303cc9");
		check(B = x"2fcc1b8e");
		check(C = x"45d2086f");
		check(D = x"a0248fcc");
		check(E = x"d5e41b50");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"785eca68");
		check(B = x"6d303cc9");
		check(C = x"8bf306e3");
		check(D = x"45d2086f");
		check(E = x"a0248fcc");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"5edac5c7");
		check(B = x"785eca68");
		check(C = x"5b4c0f32");
		check(D = x"8bf306e3");
		check(E = x"45d2086f");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"a75ae700");
		check(B = x"5edac5c7");
		check(C = x"1e17b29a");
		check(D = x"5b4c0f32");
		check(E = x"8bf306e3");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"4ff7996f");
		check(B = x"a75ae700");
		check(C = x"d7b6b171");
		check(D = x"1e17b29a");
		check(E = x"5b4c0f32");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"36b9b04b");
		check(B = x"4ff7996f");
		check(C = x"29d6b9c0");
		check(D = x"d7b6b171");
		check(E = x"1e17b29a");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"b85bd473");
		check(B = x"36b9b04b");
		check(C = x"d3fde65b");
		check(D = x"29d6b9c0");
		check(E = x"d7b6b171");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d73ab425");
		check(B = x"b85bd473");
		check(C = x"cdae6c12");
		check(D = x"d3fde65b");
		check(E = x"29d6b9c0");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"076cd9b6");
		check(B = x"d73ab425");
		check(C = x"ee16f51c");
		check(D = x"cdae6c12");
		check(E = x"d3fde65b");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"921247d4");
		check(B = x"076cd9b6");
		check(C = x"75cead09");
		check(D = x"ee16f51c");
		check(E = x"cdae6c12");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"fd73b545");
		check(B = x"921247d4");
		check(C = x"81db366d");
		check(D = x"75cead09");
		check(E = x"ee16f51c");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"73b1c48b");
		check(B = x"fd73b545");
		check(C = x"248491f5");
		check(D = x"81db366d");
		check(E = x"75cead09");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f5bbf003");
		check(B = x"73b1c48b");
		check(C = x"7f5ced51");
		check(D = x"248491f5");
		check(E = x"81db366d");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"4187d845");
		check(B = x"f5bbf003");
		check(C = x"dcec7122");
		check(D = x"7f5ced51");
		check(E = x"248491f5");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"5636d9b5");
		check(B = x"4187d845");
		check(C = x"fd6efc00");
		check(D = x"dcec7122");
		check(E = x"7f5ced51");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"0163e498");
		check(B = x"5636d9b5");
		check(C = x"5061f611");
		check(D = x"fd6efc00");
		check(E = x"dcec7122");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"1b34489e");
		check(B = x"0163e498");
		check(C = x"558db66d");
		check(D = x"5061f611");
		check(E = x"fd6efc00");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"20b2c18c");
		check(B = x"1b34489e");
		check(C = x"0058f926");
		check(D = x"558db66d");
		check(E = x"5061f611");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"3f8090a3");
		check(B = x"20b2c18c");
		check(C = x"86cd1227");
		check(D = x"0058f926");
		check(E = x"558db66d");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"c4eb0002");
		check(B = x"3f8090a3");
		check(C = x"082cb063");
		check(D = x"86cd1227");
		check(E = x"0058f926");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"8c52a5b3");
		check(B = x"c4eb0002");
		check(C = x"cfe02428");
		check(D = x"082cb063");
		check(E = x"86cd1227");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"ded6ad76");
		check(B = x"8c52a5b3");
		check(C = x"b13ac000");
		check(D = x"cfe02428");
		check(E = x"082cb063");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"6918f39e");
		check(B = x"ded6ad76");
		check(C = x"e314a96c");
		check(D = x"b13ac000");
		check(E = x"cfe02428");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"6457f468");
		check(B = x"6918f39e");
		check(C = x"b7b5ab5d");
		check(D = x"e314a96c");
		check(E = x"b13ac000");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"a7d25943");
		check(B = x"6457f468");
		check(C = x"9a463ce7");
		check(D = x"b7b5ab5d");
		check(E = x"e314a96c");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"28475ecd");
		check(B = x"a7d25943");
		check(C = x"1915fd1a");
		check(D = x"9a463ce7");
		check(E = x"b7b5ab5d");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"99f16311");
		check(B = x"28475ecd");
		check(C = x"e9f49650");
		check(D = x"1915fd1a");
		check(E = x"9a463ce7");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"53f878a3");
		check(B = x"99f16311");
		check(C = x"4a11d7b3");
		check(D = x"e9f49650");
		check(E = x"1915fd1a");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"55de3972");
		check(B = x"53f878a3");
		check(C = x"667c58c4");
		check(D = x"4a11d7b3");
		check(E = x"e9f49650");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"4ae0644f");
		check(B = x"55de3972");
		check(C = x"d4fe1e28");
		check(D = x"667c58c4");
		check(E = x"4a11d7b3");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"81c4ad5a");
		check(B = x"4ae0644f");
		check(C = x"95778e5c");
		check(D = x"d4fe1e28");
		check(E = x"667c58c4");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"60444902");
		check(B = x"81c4ad5a");
		check(C = x"d2b81913");
		check(D = x"95778e5c");
		check(E = x"d4fe1e28");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"2b213b77");
		check(B = x"60444902");
		check(C = x"a0712b56");
		check(D = x"d2b81913");
		check(E = x"95778e5c");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"0cf179f4");
		check(B = x"2b213b77");
		check(C = x"98111240");
		check(D = x"a0712b56");
		check(E = x"d2b81913");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"f58493cc");
		check(B = x"0cf179f4");
		check(C = x"cac84edd");
		check(D = x"98111240");
		check(E = x"a0712b56");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"25baab7d");
		check(B = x"f58493cc");
		check(C = x"033c5e7d");
		check(D = x"cac84edd");
		check(E = x"98111240");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"fd1e2e37");
		check(B = x"25baab7d");
		check(C = x"3d6124f3");
		check(D = x"033c5e7d");
		check(E = x"cac84edd");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"778cbb23");
		check(B = x"fd1e2e37");
		check(C = x"496eaadf");
		check(D = x"3d6124f3");
		check(E = x"033c5e7d");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"2e9067bf");
		check(B = x"778cbb23");
		check(C = x"ff478b8d");
		check(D = x"496eaadf");
		check(E = x"3d6124f3");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"f6d29eda");
		check(B = x"2e9067bf");
		check(C = x"dde32ec8");
		check(D = x"ff478b8d");
		check(E = x"496eaadf");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"11cd88fe");
		check(B = x"f6d29eda");
		check(C = x"cba419ef");
		check(D = x"dde32ec8");
		check(E = x"ff478b8d");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"391ecb5f");
		check(B = x"11cd88fe");
		check(C = x"bdb4a7b6");
		check(D = x"cba419ef");
		check(E = x"dde32ec8");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"ea35b649");
		check(B = x"391ecb5f");
		check(C = x"8473623f");
		check(D = x"bdb4a7b6");
		check(E = x"cba419ef");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"c4594d9d");
		check(B = x"ea35b649");
		check(C = x"ce47b2d7");
		check(D = x"8473623f");
		check(E = x"bdb4a7b6");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"6542f0cb");
		check(B = x"c4594d9d");
		check(C = x"7a8d6d92");
		check(D = x"ce47b2d7");
		check(E = x"8473623f");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"330d0e15");
		check(B = x"6542f0cb");
		check(C = x"71165367");
		check(D = x"7a8d6d92");
		check(E = x"ce47b2d7");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"8b11cea7");
		check(B = x"330d0e15");
		check(C = x"d950bc32");
		check(D = x"71165367");
		check(E = x"7a8d6d92");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"6aaf5a7e");
		check(B = x"8b11cea7");
		check(C = x"4cc34385");
		check(D = x"d950bc32");
		check(E = x"71165367");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"9b485079");
		check(B = x"6aaf5a7e");
		check(C = x"e2c473a9");
		check(D = x"4cc34385");
		check(E = x"d950bc32");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"30ffa24e");
		check(B = x"9b485079");
		check(C = x"9aabd69f");
		check(D = x"e2c473a9");
		check(E = x"4cc34385");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"1dff2de3");
		check(B = x"30ffa24e");
		check(C = x"66d2141e");
		check(D = x"9aabd69f");
		check(E = x"e2c473a9");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"05143c0c");
		check(B = x"1dff2de3");
		check(C = x"8c3fe893");
		check(D = x"66d2141e");
		check(E = x"9aabd69f");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"35f2cadc");
		check(B = x"05143c0c");
		check(C = x"c77fcb78");
		check(D = x"8c3fe893");
		check(E = x"66d2141e");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"c7353acd");
		check(B = x"35f2cadc");
		check(C = x"01450f03");
		check(D = x"c77fcb78");
		check(E = x"8c3fe893");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"61fd30f1");
		check(B = x"c7353acd");
		check(C = x"0d7cb2b7");
		check(D = x"01450f03");
		check(E = x"c77fcb78");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"49db1fb5");
		check(B = x"61fd30f1");
		check(C = x"71cd4eb3");
		check(D = x"0d7cb2b7");
		check(E = x"01450f03");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"29a7b7ce");
		check(B = x"49db1fb5");
		check(C = x"587f4c3c");
		check(D = x"71cd4eb3");
		check(E = x"0d7cb2b7");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"9e705e1a");
		check(B = x"29a7b7ce");
		check(C = x"5276c7ed");
		check(D = x"587f4c3c");
		check(E = x"71cd4eb3");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"746d8b2a");
		check(B = x"9e705e1a");
		check(C = x"8a69edf3");
		check(D = x"5276c7ed");
		check(E = x"587f4c3c");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"bd93c44f");
		check(B = x"746d8b2a");
		check(C = x"a79c1786");
		check(D = x"8a69edf3");
		check(E = x"5276c7ed");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"540fd528");
		check(B = x"bd93c44f");
		check(C = x"9d1b62ca");
		check(D = x"a79c1786");
		check(E = x"8a69edf3");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"b737bc0a");
		check(B = x"540fd528");
		check(C = x"ef64f113");
		check(D = x"9d1b62ca");
		check(E = x"a79c1786");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"f94a04b9");
		check(B = x"b737bc0a");
		check(C = x"1503f54a");
		check(D = x"ef64f113");
		check(E = x"9d1b62ca");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);

		check(is_waiting_next_block = '1');

		-- Write the last 128 bits
		write_data_in <= '1';

		data_in               <= x"35363738";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(128, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';
		
		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"00222edf");
		check(B = x"608f27ba");
		check(C = x"e9c159e4");
		check(D = x"adbed248");
		check(E = x"ff974589");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"85419e14");
		check(B = x"00222edf");
		check(C = x"9823c9ee");
		check(D = x"e9c159e4");
		check(E = x"adbed248");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"cd8c9d95");
		check(B = x"85419e14");
		check(C = x"c0088bb7");
		check(D = x"9823c9ee");
		check(E = x"e9c159e4");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"c5328b64");
		check(B = x"cd8c9d95");
		check(C = x"21506785");
		check(D = x"c0088bb7");
		check(E = x"9823c9ee");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"19f7b7c6");
		check(B = x"c5328b64");
		check(C = x"73632765");
		check(D = x"21506785");
		check(E = x"c0088bb7");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"bae465f8");
		check(B = x"19f7b7c6");
		check(C = x"314ca2d9");
		check(D = x"73632765");
		check(E = x"21506785");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"4ba44316");
		check(B = x"bae465f8");
		check(C = x"867dedf1");
		check(D = x"314ca2d9");
		check(E = x"73632765");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"c5daebb8");
		check(B = x"4ba44316");
		check(C = x"2eb9197e");
		check(D = x"867dedf1");
		check(E = x"314ca2d9");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"d6264181");
		check(B = x"c5daebb8");
		check(C = x"92e910c5");
		check(D = x"2eb9197e");
		check(E = x"867dedf1");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"50b1a88a");
		check(B = x"d6264181");
		check(C = x"3176baee");
		check(D = x"92e910c5");
		check(E = x"2eb9197e");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"b05fb525");
		check(B = x"50b1a88a");
		check(C = x"75899060");
		check(D = x"3176baee");
		check(E = x"92e910c5");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"6b29c178");
		check(B = x"b05fb525");
		check(C = x"942c6a22");
		check(D = x"75899060");
		check(E = x"3176baee");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"c6bd83f4");
		check(B = x"6b29c178");
		check(C = x"6c17ed49");
		check(D = x"942c6a22");
		check(E = x"75899060");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"a3c273db");
		check(B = x"c6bd83f4");
		check(C = x"1aca705e");
		check(D = x"6c17ed49");
		check(E = x"942c6a22");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"9187cb8c");
		check(B = x"a3c273db");
		check(C = x"31af60fd");
		check(D = x"1aca705e");
		check(E = x"6c17ed49");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"311e3bd1");
		check(B = x"9187cb8c");
		check(C = x"e8f09cf6");
		check(D = x"31af60fd");
		check(E = x"1aca705e");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"45c1112e");
		check(B = x"311e3bd1");
		check(C = x"2461f2e3");
		check(D = x"e8f09cf6");
		check(E = x"31af60fd");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"4944c749");
		check(B = x"45c1112e");
		check(C = x"4c478ef4");
		check(D = x"2461f2e3");
		check(E = x"e8f09cf6");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"36d6520a");
		check(B = x"4944c749");
		check(C = x"9170444b");
		check(D = x"4c478ef4");
		check(E = x"2461f2e3");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"d56a7517");
		check(B = x"36d6520a");
		check(C = x"525131d2");
		check(D = x"9170444b");
		check(E = x"4c478ef4");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"9687652b");
		check(B = x"d56a7517");
		check(C = x"8db59482");
		check(D = x"525131d2");
		check(E = x"9170444b");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"a896847f");
		check(B = x"9687652b");
		check(C = x"f55a9d45");
		check(D = x"8db59482");
		check(E = x"525131d2");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"af550f04");
		check(B = x"a896847f");
		check(C = x"e5a1d94a");
		check(D = x"f55a9d45");
		check(E = x"8db59482");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"0fdf663a");
		check(B = x"af550f04");
		check(C = x"ea25a11f");
		check(D = x"e5a1d94a");
		check(E = x"f55a9d45");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"829c7d05");
		check(B = x"0fdf663a");
		check(C = x"2bd543c1");
		check(D = x"ea25a11f");
		check(E = x"e5a1d94a");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"57fcb3e8");
		check(B = x"829c7d05");
		check(C = x"83f7d98e");
		check(D = x"2bd543c1");
		check(E = x"ea25a11f");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"afa54612");
		check(B = x"57fcb3e8");
		check(C = x"60a71f41");
		check(D = x"83f7d98e");
		check(E = x"2bd543c1");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"33a80689");
		check(B = x"afa54612");
		check(C = x"15ff2cfa");
		check(D = x"60a71f41");
		check(E = x"83f7d98e");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"f693debf");
		check(B = x"33a80689");
		check(C = x"abe95184");
		check(D = x"15ff2cfa");
		check(E = x"60a71f41");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f0bc7020");
		check(B = x"f693debf");
		check(C = x"4cea01a2");
		check(D = x"abe95184");
		check(E = x"15ff2cfa");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"cca68960");
		check(B = x"f0bc7020");
		check(C = x"fda4f7af");
		check(D = x"4cea01a2");
		check(E = x"abe95184");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"b0adfa1a");
		check(B = x"cca68960");
		check(C = x"3c2f1c08");
		check(D = x"fda4f7af");
		check(E = x"4cea01a2");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"343a32ca");
		check(B = x"b0adfa1a");
		check(C = x"3329a258");
		check(D = x"3c2f1c08");
		check(E = x"fda4f7af");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"dd7f7b57");
		check(B = x"343a32ca");
		check(C = x"ac2b7e86");
		check(D = x"3329a258");
		check(E = x"3c2f1c08");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"a0af8323");
		check(B = x"dd7f7b57");
		check(C = x"8d0e8cb2");
		check(D = x"ac2b7e86");
		check(E = x"3329a258");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b553c456");
		check(B = x"a0af8323");
		check(C = x"f75fded5");
		check(D = x"8d0e8cb2");
		check(E = x"ac2b7e86");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"3ab8be5f");
		check(B = x"b553c456");
		check(C = x"e82be0c8");
		check(D = x"f75fded5");
		check(E = x"8d0e8cb2");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"cd07905a");
		check(B = x"3ab8be5f");
		check(C = x"ad54f115");
		check(D = x"e82be0c8");
		check(E = x"f75fded5");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"6cd934bb");
		check(B = x"cd07905a");
		check(C = x"ceae2f97");
		check(D = x"ad54f115");
		check(E = x"e82be0c8");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"0a64b043");
		check(B = x"6cd934bb");
		check(C = x"b341e416");
		check(D = x"ceae2f97");
		check(E = x"ad54f115");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"e72e3a81");
		check(B = x"0a64b043");
		check(C = x"db364d2e");
		check(D = x"b341e416");
		check(E = x"ceae2f97");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"62082874");
		check(B = x"e72e3a81");
		check(C = x"c2992c10");
		check(D = x"db364d2e");
		check(E = x"b341e416");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"204f8f00");
		check(B = x"62082874");
		check(C = x"79cb8ea0");
		check(D = x"c2992c10");
		check(E = x"db364d2e");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"58c04a36");
		check(B = x"204f8f00");
		check(C = x"18820a1d");
		check(D = x"79cb8ea0");
		check(E = x"c2992c10");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"0b13a494");
		check(B = x"58c04a36");
		check(C = x"0813e3c0");
		check(D = x"18820a1d");
		check(E = x"79cb8ea0");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"548e1b73");
		check(B = x"0b13a494");
		check(C = x"9630128d");
		check(D = x"0813e3c0");
		check(E = x"18820a1d");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"a1d893d3");
		check(B = x"548e1b73");
		check(C = x"02c4e925");
		check(D = x"9630128d");
		check(E = x"0813e3c0");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"11fc0d56");
		check(B = x"a1d893d3");
		check(C = x"d52386dc");
		check(D = x"02c4e925");
		check(E = x"9630128d");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"c69a21f6");
		check(B = x"11fc0d56");
		check(C = x"e87624f4");
		check(D = x"d52386dc");
		check(E = x"02c4e925");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"238f06f2");
		check(B = x"c69a21f6");
		check(C = x"847f0355");
		check(D = x"e87624f4");
		check(E = x"d52386dc");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"7c5bc19d");
		check(B = x"238f06f2");
		check(C = x"b1a6887d");
		check(D = x"847f0355");
		check(E = x"e87624f4");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"03032aaf");
		check(B = x"7c5bc19d");
		check(C = x"88e3c1bc");
		check(D = x"b1a6887d");
		check(E = x"847f0355");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"242b31a7");
		check(B = x"03032aaf");
		check(C = x"5f16f067");
		check(D = x"88e3c1bc");
		check(E = x"b1a6887d");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"011aa00b");
		check(B = x"242b31a7");
		check(C = x"c0c0caab");
		check(D = x"5f16f067");
		check(E = x"88e3c1bc");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"947b23ea");
		check(B = x"011aa00b");
		check(C = x"c90acc69");
		check(D = x"c0c0caab");
		check(E = x"5f16f067");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"a756dc64");
		check(B = x"947b23ea");
		check(C = x"c046a802");
		check(D = x"c90acc69");
		check(E = x"c0c0caab");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"ed27d26b");
		check(B = x"a756dc64");
		check(C = x"a51ec8fa");
		check(D = x"c046a802");
		check(E = x"c90acc69");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"98dad3b7");
		check(B = x"ed27d26b");
		check(C = x"29d5b719");
		check(D = x"a51ec8fa");
		check(E = x"c046a802");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"883230f8");
		check(B = x"98dad3b7");
		check(C = x"fb49f49a");
		check(D = x"29d5b719");
		check(E = x"a51ec8fa");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"eec22c11");
		check(B = x"883230f8");
		check(C = x"e636b4ed");
		check(D = x"fb49f49a");
		check(E = x"29d5b719");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d167ccb1");
		check(B = x"eec22c11");
		check(C = x"220c8c3e");
		check(D = x"e636b4ed");
		check(E = x"fb49f49a");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"69f2294d");
		check(B = x"d167ccb1");
		check(C = x"7bb08b04");
		check(D = x"220c8c3e");
		check(E = x"e636b4ed");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"1a13b5b7");
		check(B = x"69f2294d");
		check(C = x"7459f32c");
		check(D = x"7bb08b04");
		check(E = x"220c8c3e");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"1ad3dcc9");
		check(B = x"1a13b5b7");
		check(C = x"5a7c8a53");
		check(D = x"7459f32c");
		check(E = x"7bb08b04");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"5454cb7e");
		check(B = x"1ad3dcc9");
		check(C = x"c684ed6d");
		check(D = x"5a7c8a53");
		check(E = x"7459f32c");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"1c8ac666");
		check(B = x"5454cb7e");
		check(C = x"46b4f732");
		check(D = x"c684ed6d");
		check(E = x"5a7c8a53");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"51872b78");
		check(B = x"1c8ac666");
		check(C = x"951532df");
		check(D = x"46b4f732");
		check(E = x"c684ed6d");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"7991a2fd");
		check(B = x"51872b78");
		check(C = x"8722b199");
		check(D = x"951532df");
		check(E = x"46b4f732");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"08eba083");
		check(B = x"7991a2fd");
		check(C = x"1461cade");
		check(D = x"8722b199");
		check(E = x"951532df");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"03853333");
		check(B = x"08eba083");
		check(C = x"5e6468bf");
		check(D = x"1461cade");
		check(E = x"8722b199");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"609cb91a");
		check(B = x"03853333");
		check(C = x"c23ae820");
		check(D = x"5e6468bf");
		check(E = x"1461cade");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"c80e6d55");
		check(B = x"609cb91a");
		check(C = x"c0e14ccc");
		check(D = x"c23ae820");
		check(E = x"5e6468bf");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"593faa64");
		check(B = x"c80e6d55");
		check(C = x"98272e46");
		check(D = x"c0e14ccc");
		check(E = x"c23ae820");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"7a780c0d");
		check(B = x"593faa64");
		check(C = x"72039b55");
		check(D = x"98272e46");
		check(E = x"c0e14ccc");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"675a04f9");
		check(B = x"7a780c0d");
		check(C = x"164fea99");
		check(D = x"72039b55");
		check(E = x"98272e46");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"919c09e0");
		check(B = x"675a04f9");
		check(C = x"5e9e0303");
		check(D = x"164fea99");
		check(E = x"72039b55");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"91e16d72");
		check(B = x"919c09e0");
		check(C = x"59d6813e");
		check(D = x"5e9e0303");
		check(E = x"164fea99");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"cb31685b");
		check(B = x"91e16d72");
		check(C = x"24670278");
		check(D = x"59d6813e");
		check(E = x"5e9e0303");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"c30fa1fd");
		check(B = x"cb31685b");
		check(C = x"a4785b5c");
		check(D = x"24670278");
		check(E = x"59d6813e");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"f01ccdb6");
		check(B = x"c30fa1fd");
		check(C = x"f2cc5a16");
		check(D = x"a4785b5c");
		check(E = x"24670278");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"50abf570");
		check(H1_out = x"6a150990");
		check(H2_out = x"a08b2c5e");
		check(H3_out = x"a40fa0e5");
		check(H4_out = x"85554732");

		test_runner_cleanup(runner);
	end process;

end unit_sha1_test_7_tb_arch;

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")

entity sha1_test_6_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_6_tb;

architecture sha1_test_6_tb_arch OF sha1_test_6_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal calculate_next_block  : std_logic             := '0';
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_idle               : std_logic             := '0';
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
			is_idle               => is_idle,
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
		check(A = x"0116fc17");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"eef6b755");
		check(B = x"0116fc17");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"b76ff7a0");
		check(B = x"eef6b755");
		check(C = x"c045bf05");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"03294786");
		check(B = x"b76ff7a0");
		check(C = x"7bbdadd5");
		check(D = x"c045bf05");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"fe1cd412");
		check(B = x"03294786");
		check(C = x"2ddbfde8");
		check(D = x"7bbdadd5");
		check(E = x"c045bf05");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"cd772046");
		check(B = x"fe1cd412");
		check(C = x"80ca51e1");
		check(D = x"2ddbfde8");
		check(E = x"7bbdadd5");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"806a0b91");
		check(B = x"cd772046");
		check(C = x"bf873504");
		check(D = x"80ca51e1");
		check(E = x"2ddbfde8");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"8693c0bc");
		check(B = x"806a0b91");
		check(C = x"b35dc811");
		check(D = x"bf873504");
		check(E = x"80ca51e1");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"d4fa8889");
		check(B = x"8693c0bc");
		check(C = x"601a82e4");
		check(D = x"b35dc811");
		check(E = x"bf873504");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"5625b5ea");
		check(B = x"d4fa8889");
		check(C = x"21a4f02f");
		check(D = x"601a82e4");
		check(E = x"b35dc811");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"62a7f2d3");
		check(B = x"5625b5ea");
		check(C = x"753ea222");
		check(D = x"21a4f02f");
		check(E = x"601a82e4");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"f8b4ac86");
		check(B = x"62a7f2d3");
		check(C = x"95896d7a");
		check(D = x"753ea222");
		check(E = x"21a4f02f");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"1fced493");
		check(B = x"f8b4ac86");
		check(C = x"d8a9fcb4");
		check(D = x"95896d7a");
		check(E = x"753ea222");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"08a7ff7e");
		check(B = x"1fced493");
		check(C = x"be2d2b21");
		check(D = x"d8a9fcb4");
		check(E = x"95896d7a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"489f6661");
		check(B = x"08a7ff7e");
		check(C = x"c7f3b524");
		check(D = x"be2d2b21");
		check(E = x"d8a9fcb4");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"672f6307");
		check(B = x"489f6661");
		check(C = x"8229ffdf");
		check(D = x"c7f3b524");
		check(E = x"be2d2b21");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"a20a00f7");
		check(B = x"672f6307");
		check(C = x"5227d998");
		check(D = x"8229ffdf");
		check(E = x"c7f3b524");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"31e22fc5");
		check(B = x"a20a00f7");
		check(C = x"d9cbd8c1");
		check(D = x"5227d998");
		check(E = x"8229ffdf");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"25264ff3");
		check(B = x"31e22fc5");
		check(C = x"e882803d");
		check(D = x"d9cbd8c1");
		check(E = x"5227d998");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"28d0f47e");
		check(B = x"25264ff3");
		check(C = x"4c788bf1");
		check(D = x"e882803d");
		check(E = x"d9cbd8c1");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"cb897706");
		check(B = x"28d0f47e");
		check(C = x"c94993fc");
		check(D = x"4c788bf1");
		check(E = x"e882803d");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"0d562416");
		check(B = x"cb897706");
		check(C = x"8a343d1f");
		check(D = x"c94993fc");
		check(E = x"4c788bf1");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"1a554f41");
		check(B = x"0d562416");
		check(C = x"b2e25dc1");
		check(D = x"8a343d1f");
		check(E = x"c94993fc");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"c7632811");
		check(B = x"1a554f41");
		check(C = x"83558905");
		check(D = x"b2e25dc1");
		check(E = x"8a343d1f");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"173fb46e");
		check(B = x"c7632811");
		check(C = x"469553d0");
		check(D = x"83558905");
		check(E = x"b2e25dc1");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"8b019842");
		check(B = x"173fb46e");
		check(C = x"71d8ca04");
		check(D = x"469553d0");
		check(E = x"83558905");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"c90799cb");
		check(B = x"8b019842");
		check(C = x"85cfed1b");
		check(D = x"71d8ca04");
		check(E = x"469553d0");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"47d78a56");
		check(B = x"c90799cb");
		check(C = x"a2c06610");
		check(D = x"85cfed1b");
		check(E = x"71d8ca04");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"de6430fe");
		check(B = x"47d78a56");
		check(C = x"f241e672");
		check(D = x"a2c06610");
		check(E = x"85cfed1b");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"6a2a1ec8");
		check(B = x"de6430fe");
		check(C = x"91f5e295");
		check(D = x"f241e672");
		check(E = x"a2c06610");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"5598f39c");
		check(B = x"6a2a1ec8");
		check(C = x"b7990c3f");
		check(D = x"91f5e295");
		check(E = x"f241e672");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"5e07480f");
		check(B = x"5598f39c");
		check(C = x"1a8a87b2");
		check(D = x"b7990c3f");
		check(E = x"91f5e295");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"22e0344b");
		check(B = x"5e07480f");
		check(C = x"15663ce7");
		check(D = x"1a8a87b2");
		check(E = x"b7990c3f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"8d8e8d2d");
		check(B = x"22e0344b");
		check(C = x"d781d203");
		check(D = x"15663ce7");
		check(E = x"1a8a87b2");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"fdee42ff");
		check(B = x"8d8e8d2d");
		check(C = x"c8b80d12");
		check(D = x"d781d203");
		check(E = x"15663ce7");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"9abae700");
		check(B = x"fdee42ff");
		check(C = x"6363a34b");
		check(D = x"c8b80d12");
		check(E = x"d781d203");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"b44fcc4b");
		check(B = x"9abae700");
		check(C = x"ff7b90bf");
		check(D = x"6363a34b");
		check(E = x"c8b80d12");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"9e01e2c6");
		check(B = x"b44fcc4b");
		check(C = x"26aeb9c0");
		check(D = x"ff7b90bf");
		check(E = x"6363a34b");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"5776e8f4");
		check(B = x"9e01e2c6");
		check(C = x"ed13f312");
		check(D = x"26aeb9c0");
		check(E = x"ff7b90bf");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"4ba10f58");
		check(B = x"5776e8f4");
		check(C = x"a78078b1");
		check(D = x"ed13f312");
		check(E = x"26aeb9c0");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"ee26250c");
		check(B = x"4ba10f58");
		check(C = x"15ddba3d");
		check(D = x"a78078b1");
		check(E = x"ed13f312");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"0df4bd7a");
		check(B = x"ee26250c");
		check(C = x"12e843d6");
		check(D = x"15ddba3d");
		check(E = x"a78078b1");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"7d36eba4");
		check(B = x"0df4bd7a");
		check(C = x"3b898943");
		check(D = x"12e843d6");
		check(E = x"15ddba3d");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"5e0e93ea");
		check(B = x"7d36eba4");
		check(C = x"837d2f5e");
		check(D = x"3b898943");
		check(E = x"12e843d6");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"41ae1bdb");
		check(B = x"5e0e93ea");
		check(C = x"1f4dbae9");
		check(D = x"837d2f5e");
		check(E = x"3b898943");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"b185416e");
		check(B = x"41ae1bdb");
		check(C = x"9783a4fa");
		check(D = x"1f4dbae9");
		check(E = x"837d2f5e");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"6d89c966");
		check(B = x"b185416e");
		check(C = x"d06b86f6");
		check(D = x"9783a4fa");
		check(E = x"1f4dbae9");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"ee34924a");
		check(B = x"6d89c966");
		check(C = x"ac61505b");
		check(D = x"d06b86f6");
		check(E = x"9783a4fa");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"6722bfe8");
		check(B = x"ee34924a");
		check(C = x"9b627259");
		check(D = x"ac61505b");
		check(E = x"d06b86f6");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"486b35f8");
		check(B = x"6722bfe8");
		check(C = x"bb8d2492");
		check(D = x"9b627259");
		check(E = x"ac61505b");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"61990e5d");
		check(B = x"486b35f8");
		check(C = x"19c8affa");
		check(D = x"bb8d2492");
		check(E = x"9b627259");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"4f2abb91");
		check(B = x"61990e5d");
		check(C = x"121acd7e");
		check(D = x"19c8affa");
		check(E = x"bb8d2492");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"08fafea5");
		check(B = x"4f2abb91");
		check(C = x"58664397");
		check(D = x"121acd7e");
		check(E = x"19c8affa");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"24ee2ba5");
		check(B = x"08fafea5");
		check(C = x"53caaee4");
		check(D = x"58664397");
		check(E = x"121acd7e");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"36625e59");
		check(B = x"24ee2ba5");
		check(C = x"423ebfa9");
		check(D = x"53caaee4");
		check(E = x"58664397");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"c60198ca");
		check(B = x"36625e59");
		check(C = x"493b8ae9");
		check(D = x"423ebfa9");
		check(E = x"53caaee4");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"2ce4eb4b");
		check(B = x"c60198ca");
		check(C = x"4d989796");
		check(D = x"493b8ae9");
		check(E = x"423ebfa9");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"b1d37b53");
		check(B = x"2ce4eb4b");
		check(C = x"b1806632");
		check(D = x"4d989796");
		check(E = x"493b8ae9");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"c2f9a923");
		check(B = x"b1d37b53");
		check(C = x"cb393ad2");
		check(D = x"b1806632");
		check(E = x"4d989796");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"dd1bf51f");
		check(B = x"c2f9a923");
		check(C = x"ec74ded4");
		check(D = x"cb393ad2");
		check(E = x"b1806632");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"081be8c1");
		check(B = x"dd1bf51f");
		check(C = x"f0be6a48");
		check(D = x"ec74ded4");
		check(E = x"cb393ad2");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"3305ca59");
		check(B = x"081be8c1");
		check(C = x"f746fd47");
		check(D = x"f0be6a48");
		check(E = x"ec74ded4");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"05400e01");
		check(B = x"3305ca59");
		check(C = x"4206fa30");
		check(D = x"f746fd47");
		check(E = x"f0be6a48");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"b832e98c");
		check(B = x"05400e01");
		check(C = x"4cc17296");
		check(D = x"4206fa30");
		check(E = x"f746fd47");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"72ce4fd5");
		check(B = x"b832e98c");
		check(C = x"41500380");
		check(D = x"4cc17296");
		check(E = x"4206fa30");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"71981139");
		check(B = x"72ce4fd5");
		check(C = x"2e0cba63");
		check(D = x"41500380");
		check(E = x"4cc17296");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"14cbb017");
		check(B = x"71981139");
		check(C = x"5cb393f5");
		check(D = x"2e0cba63");
		check(E = x"41500380");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"f290bc58");
		check(B = x"14cbb017");
		check(C = x"5c66044e");
		check(D = x"5cb393f5");
		check(E = x"2e0cba63");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"7e5df9ab");
		check(B = x"f290bc58");
		check(C = x"c532ec05");
		check(D = x"5c66044e");
		check(E = x"5cb393f5");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"cf0031f0");
		check(B = x"7e5df9ab");
		check(C = x"3ca42f16");
		check(D = x"c532ec05");
		check(E = x"5c66044e");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"2b5b9cd1");
		check(B = x"cf0031f0");
		check(C = x"df977e6a");
		check(D = x"3ca42f16");
		check(E = x"c532ec05");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"f928e3c3");
		check(B = x"2b5b9cd1");
		check(C = x"33c00c7c");
		check(D = x"df977e6a");
		check(E = x"3ca42f16");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"4826dcbc");
		check(B = x"f928e3c3");
		check(C = x"4ad6e734");
		check(D = x"33c00c7c");
		check(E = x"df977e6a");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"cfd6aeeb");
		check(B = x"4826dcbc");
		check(C = x"fe4a38f0");
		check(D = x"4ad6e734");
		check(E = x"33c00c7c");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"f045f9c2");
		check(B = x"cfd6aeeb");
		check(C = x"1209b72f");
		check(D = x"fe4a38f0");
		check(E = x"4ad6e734");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"93a696c6");
		check(B = x"f045f9c2");
		check(C = x"f3f5abba");
		check(D = x"1209b72f");
		check(E = x"fe4a38f0");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"12a28c79");
		check(B = x"93a696c6");
		check(C = x"bc117e70");
		check(D = x"f3f5abba");
		check(E = x"1209b72f");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"45490516");
		check(B = x"12a28c79");
		check(C = x"a4e9a5b1");
		check(D = x"bc117e70");
		check(E = x"f3f5abba");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"8a2ecfef");
		check(B = x"45490516");
		check(C = x"44a8a31e");
		check(D = x"a4e9a5b1");
		check(E = x"bc117e70");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"847274dd");
		check(B = x"8a2ecfef");
		check(C = x"91524145");
		check(D = x"44a8a31e");
		check(E = x"a4e9a5b1");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);
		wait until rising_edge(clk);

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"e6409bdb");
		check(B = x"ebb797de");
		check(C = x"1e7f1ede");
		check(D = x"2a0d1e43");
		check(E = x"54daf794");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"81b00b88");
		check(B = x"e6409bdb");
		check(C = x"baede5f7");
		check(D = x"1e7f1ede");
		check(E = x"2a0d1e43");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"75108ec3");
		check(B = x"81b00b88");
		check(C = x"f99026f6");
		check(D = x"baede5f7");
		check(E = x"1e7f1ede");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"d6f157dc");
		check(B = x"75108ec3");
		check(C = x"206c02e2");
		check(D = x"f99026f6");
		check(E = x"baede5f7");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"9c1b7e20");
		check(B = x"d6f157dc");
		check(C = x"dd4423b0");
		check(D = x"206c02e2");
		check(E = x"f99026f6");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"cbce6854");
		check(B = x"9c1b7e20");
		check(C = x"35bc55f7");
		check(D = x"dd4423b0");
		check(E = x"206c02e2");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"4a17dcc4");
		check(B = x"cbce6854");
		check(C = x"2706df88");
		check(D = x"35bc55f7");
		check(E = x"dd4423b0");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"b1f89375");
		check(B = x"4a17dcc4");
		check(C = x"32f39a15");
		check(D = x"2706df88");
		check(E = x"35bc55f7");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"f664d952");
		check(B = x"b1f89375");
		check(C = x"1285f731");
		check(D = x"32f39a15");
		check(E = x"2706df88");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"60a81eb0");
		check(B = x"f664d952");
		check(C = x"6c7e24dd");
		check(D = x"1285f731");
		check(E = x"32f39a15");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"075f102b");
		check(B = x"60a81eb0");
		check(C = x"bd993654");
		check(D = x"6c7e24dd");
		check(E = x"1285f731");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"85c8ac87");
		check(B = x"075f102b");
		check(C = x"182a07ac");
		check(D = x"bd993654");
		check(E = x"6c7e24dd");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"38a055e2");
		check(B = x"85c8ac87");
		check(C = x"c1d7c40a");
		check(D = x"182a07ac");
		check(E = x"bd993654");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"c608f35e");
		check(B = x"38a055e2");
		check(C = x"e1722b21");
		check(D = x"c1d7c40a");
		check(E = x"182a07ac");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"15426e45");
		check(B = x"c608f35e");
		check(C = x"8e281578");
		check(D = x"e1722b21");
		check(E = x"c1d7c40a");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"6c2221be");
		check(B = x"15426e45");
		check(C = x"b1823cd7");
		check(D = x"8e281578");
		check(E = x"e1722b21");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"5b631a05");
		check(B = x"6c2221be");
		check(C = x"45509b91");
		check(D = x"b1823cd7");
		check(E = x"8e281578");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"2a8ded8d");
		check(B = x"5b631a05");
		check(C = x"9b08886f");
		check(D = x"45509b91");
		check(E = x"b1823cd7");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"7cd2f5aa");
		check(B = x"2a8ded8d");
		check(C = x"56d8c681");
		check(D = x"9b08886f");
		check(E = x"45509b91");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"cdba8f5e");
		check(B = x"7cd2f5aa");
		check(C = x"4aa37b63");
		check(D = x"56d8c681");
		check(E = x"9b08886f");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"21dda831");
		check(B = x"cdba8f5e");
		check(C = x"9f34bd6a");
		check(D = x"4aa37b63");
		check(E = x"56d8c681");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"1995099d");
		check(B = x"21dda831");
		check(C = x"b36ea3d7");
		check(D = x"9f34bd6a");
		check(E = x"4aa37b63");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"f9a65137");
		check(B = x"1995099d");
		check(C = x"48776a0c");
		check(D = x"b36ea3d7");
		check(E = x"9f34bd6a");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"25659450");
		check(B = x"f9a65137");
		check(C = x"46654267");
		check(D = x"48776a0c");
		check(E = x"b36ea3d7");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"c6afa2da");
		check(B = x"25659450");
		check(C = x"fe69944d");
		check(D = x"46654267");
		check(E = x"48776a0c");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"2aaef387");
		check(B = x"c6afa2da");
		check(C = x"09596514");
		check(D = x"fe69944d");
		check(E = x"46654267");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"3cbcf270");
		check(B = x"2aaef387");
		check(C = x"b1abe8b6");
		check(D = x"09596514");
		check(E = x"fe69944d");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"973e6c1a");
		check(B = x"3cbcf270");
		check(C = x"caabbce1");
		check(D = x"b1abe8b6");
		check(E = x"09596514");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"a7bd7a3e");
		check(B = x"973e6c1a");
		check(C = x"0f2f3c9c");
		check(D = x"caabbce1");
		check(E = x"b1abe8b6");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"6af01c92");
		check(B = x"a7bd7a3e");
		check(C = x"a5cf9b06");
		check(D = x"0f2f3c9c");
		check(E = x"caabbce1");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"a4e7587d");
		check(B = x"6af01c92");
		check(C = x"a9ef5e8f");
		check(D = x"a5cf9b06");
		check(E = x"0f2f3c9c");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"81c51d2c");
		check(B = x"a4e7587d");
		check(C = x"9abc0724");
		check(D = x"a9ef5e8f");
		check(E = x"a5cf9b06");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"e5012e13");
		check(B = x"81c51d2c");
		check(C = x"6939d61f");
		check(D = x"9abc0724");
		check(E = x"a9ef5e8f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"2b3058c3");
		check(B = x"e5012e13");
		check(C = x"2071474b");
		check(D = x"6939d61f");
		check(E = x"9abc0724");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"1beadab1");
		check(B = x"2b3058c3");
		check(C = x"f9404b84");
		check(D = x"2071474b");
		check(E = x"6939d61f");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"4770bbf7");
		check(B = x"1beadab1");
		check(C = x"cacc1630");
		check(D = x"f9404b84");
		check(E = x"2071474b");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"a5ca3901");
		check(B = x"4770bbf7");
		check(C = x"46fab6ac");
		check(D = x"cacc1630");
		check(E = x"f9404b84");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"eca78344");
		check(B = x"a5ca3901");
		check(C = x"d1dc2efd");
		check(D = x"46fab6ac");
		check(E = x"cacc1630");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"01830bc6");
		check(B = x"eca78344");
		check(C = x"69728e40");
		check(D = x"d1dc2efd");
		check(E = x"46fab6ac");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"3a414f06");
		check(B = x"01830bc6");
		check(C = x"3b29e0d1");
		check(D = x"69728e40");
		check(E = x"d1dc2efd");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"d2455868");
		check(B = x"3a414f06");
		check(C = x"8060c2f1");
		check(D = x"3b29e0d1");
		check(E = x"69728e40");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"7b9c5b07");
		check(B = x"d2455868");
		check(C = x"8e9053c1");
		check(D = x"8060c2f1");
		check(E = x"3b29e0d1");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"c015521d");
		check(B = x"7b9c5b07");
		check(C = x"3491561a");
		check(D = x"8e9053c1");
		check(E = x"8060c2f1");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"50b7e088");
		check(B = x"c015521d");
		check(C = x"dee716c1");
		check(D = x"3491561a");
		check(E = x"8e9053c1");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"093d7824");
		check(B = x"50b7e088");
		check(C = x"70055487");
		check(D = x"dee716c1");
		check(E = x"3491561a");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"3c0b7bf8");
		check(B = x"093d7824");
		check(C = x"142df822");
		check(D = x"70055487");
		check(E = x"dee716c1");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"ffa0ded2");
		check(B = x"3c0b7bf8");
		check(C = x"024f5e09");
		check(D = x"142df822");
		check(E = x"70055487");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"07519e72");
		check(B = x"ffa0ded2");
		check(C = x"0f02defe");
		check(D = x"024f5e09");
		check(E = x"142df822");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"9c9064b4");
		check(B = x"07519e72");
		check(C = x"bfe837b4");
		check(D = x"0f02defe");
		check(E = x"024f5e09");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"32b9586e");
		check(B = x"9c9064b4");
		check(C = x"81d4679c");
		check(D = x"bfe837b4");
		check(E = x"0f02defe");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"931a61d4");
		check(B = x"32b9586e");
		check(C = x"2724192d");
		check(D = x"81d4679c");
		check(E = x"bfe837b4");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"d6259876");
		check(B = x"931a61d4");
		check(C = x"8cae561b");
		check(D = x"2724192d");
		check(E = x"81d4679c");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"5cd194f7");
		check(B = x"d6259876");
		check(C = x"24c69875");
		check(D = x"8cae561b");
		check(E = x"2724192d");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"d52d8d6b");
		check(B = x"5cd194f7");
		check(C = x"b589661d");
		check(D = x"24c69875");
		check(E = x"8cae561b");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"f67d5f26");
		check(B = x"d52d8d6b");
		check(C = x"d734653d");
		check(D = x"b589661d");
		check(E = x"24c69875");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"58c88f6c");
		check(B = x"f67d5f26");
		check(C = x"f54b635a");
		check(D = x"d734653d");
		check(E = x"b589661d");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"55357e2a");
		check(B = x"58c88f6c");
		check(C = x"bd9f57c9");
		check(D = x"f54b635a");
		check(E = x"d734653d");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"0b4c3f2b");
		check(B = x"55357e2a");
		check(C = x"163223db");
		check(D = x"bd9f57c9");
		check(E = x"f54b635a");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"0337bdea");
		check(B = x"0b4c3f2b");
		check(C = x"954d5f8a");
		check(D = x"163223db");
		check(E = x"bd9f57c9");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"cb50a9f0");
		check(B = x"0337bdea");
		check(C = x"c2d30fca");
		check(D = x"954d5f8a");
		check(E = x"163223db");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"a0543a3c");
		check(B = x"cb50a9f0");
		check(C = x"80cdef7a");
		check(D = x"c2d30fca");
		check(E = x"954d5f8a");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"f3978234");
		check(B = x"a0543a3c");
		check(C = x"32d42a7c");
		check(D = x"80cdef7a");
		check(E = x"c2d30fca");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"12752020");
		check(B = x"f3978234");
		check(C = x"28150e8f");
		check(D = x"32d42a7c");
		check(E = x"80cdef7a");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"853d2c99");
		check(B = x"12752020");
		check(C = x"3ce5e08d");
		check(D = x"28150e8f");
		check(E = x"32d42a7c");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"ab63568c");
		check(B = x"853d2c99");
		check(C = x"049d4808");
		check(D = x"3ce5e08d");
		check(E = x"28150e8f");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"1d682616");
		check(B = x"ab63568c");
		check(C = x"614f4b26");
		check(D = x"049d4808");
		check(E = x"3ce5e08d");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"87005ac8");
		check(B = x"1d682616");
		check(C = x"2ad8d5a3");
		check(D = x"614f4b26");
		check(E = x"049d4808");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"06d51c01");
		check(B = x"87005ac8");
		check(C = x"875a0985");
		check(D = x"2ad8d5a3");
		check(E = x"614f4b26");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"30d8780a");
		check(B = x"06d51c01");
		check(C = x"21c016b2");
		check(D = x"875a0985");
		check(E = x"2ad8d5a3");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"b8a99bf5");
		check(B = x"30d8780a");
		check(C = x"41b54700");
		check(D = x"21c016b2");
		check(E = x"875a0985");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"b8b17bca");
		check(B = x"b8a99bf5");
		check(C = x"8c361e02");
		check(D = x"41b54700");
		check(E = x"21c016b2");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"7cb5bcd6");
		check(B = x"b8b17bca");
		check(C = x"6e2a66fd");
		check(D = x"8c361e02");
		check(E = x"41b54700");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"0d7f42ea");
		check(B = x"7cb5bcd6");
		check(C = x"ae2c5ef2");
		check(D = x"6e2a66fd");
		check(E = x"8c361e02");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"c43dc1f2");
		check(B = x"0d7f42ea");
		check(C = x"9f2d6f35");
		check(D = x"ae2c5ef2");
		check(E = x"6e2a66fd");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"fd149ad8");
		check(B = x"c43dc1f2");
		check(C = x"835fd0ba");
		check(D = x"9f2d6f35");
		check(E = x"ae2c5ef2");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"1483a284");
		check(B = x"fd149ad8");
		check(C = x"b10f707c");
		check(D = x"835fd0ba");
		check(E = x"9f2d6f35");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"c959446b");
		check(B = x"1483a284");
		check(C = x"3f4526b6");
		check(D = x"b10f707c");
		check(E = x"835fd0ba");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"28369457");
		check(B = x"c959446b");
		check(C = x"0520e8a1");
		check(D = x"3f4526b6");
		check(E = x"b10f707c");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"b58c8873");
		check(B = x"28369457");
		check(C = x"f256511a");
		check(D = x"0520e8a1");
		check(E = x"3f4526b6");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"a76d056e");
		check(B = x"b58c8873");
		check(C = x"ca0da515");
		check(D = x"f256511a");
		check(E = x"0520e8a1");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"93249d4c");
		check(H1_out = x"2f8903eb");
		check(H2_out = x"f41ac358");
		check(H3_out = x"473148ae");
		check(H4_out = x"6ddd7042");

		test_runner_cleanup(runner);
	end process;

end sha1_test_6_tb_arch;

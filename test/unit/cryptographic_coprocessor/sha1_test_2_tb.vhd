library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 24 bits message ("abc")

entity sha1_test_2_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_2_tb;

architecture sha1_test_2_tb_arch OF sha1_test_2_tb IS
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

		-- Write the 24 bits message ("abc")
		write_data_in <= '1';

		data_in               <= x"61626300";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(24, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"0116fc33");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"8990536d");
		check(B = x"0116fc33");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"a1390f08");
		check(B = x"8990536d");
		check(C = x"c045bf0c");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"cdd8e11b");
		check(B = x"a1390f08");
		check(C = x"626414db");
		check(D = x"c045bf0c");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"cfd499de");
		check(B = x"cdd8e11b");
		check(C = x"284e43c2");
		check(D = x"626414db");
		check(E = x"c045bf0c");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"3fc7ca40");
		check(B = x"cfd499de");
		check(C = x"f3763846");
		check(D = x"284e43c2");
		check(E = x"626414db");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"993e30c1");
		check(B = x"3fc7ca40");
		check(C = x"b3f52677");
		check(D = x"f3763846");
		check(E = x"284e43c2");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"9e8c07d4");
		check(B = x"993e30c1");
		check(C = x"0ff1f290");
		check(D = x"b3f52677");
		check(E = x"f3763846");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"4b6ae328");
		check(B = x"9e8c07d4");
		check(C = x"664f8c30");
		check(D = x"0ff1f290");
		check(E = x"b3f52677");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"8351f929");
		check(B = x"4b6ae328");
		check(C = x"27a301f5");
		check(D = x"664f8c30");
		check(E = x"0ff1f290");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"fbda9e89");
		check(B = x"8351f929");
		check(C = x"12dab8ca");
		check(D = x"27a301f5");
		check(E = x"664f8c30");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"63188fe4");
		check(B = x"fbda9e89");
		check(C = x"60d47e4a");
		check(D = x"12dab8ca");
		check(E = x"27a301f5");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"4607b664");
		check(B = x"63188fe4");
		check(C = x"7ef6a7a2");
		check(D = x"60d47e4a");
		check(E = x"12dab8ca");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"9128f695");
		check(B = x"4607b664");
		check(C = x"18c623f9");
		check(D = x"7ef6a7a2");
		check(E = x"60d47e4a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"196bee77");
		check(B = x"9128f695");
		check(C = x"1181ed99");
		check(D = x"18c623f9");
		check(E = x"7ef6a7a2");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"20bdd62f");
		check(B = x"196bee77");
		check(C = x"644a3da5");
		check(D = x"1181ed99");
		check(E = x"18c623f9");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"4e925823");
		check(B = x"20bdd62f");
		check(C = x"c65afb9d");
		check(D = x"644a3da5");
		check(E = x"1181ed99");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"82aa6728");
		check(B = x"4e925823");
		check(C = x"c82f758b");
		check(D = x"c65afb9d");
		check(E = x"644a3da5");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"dc64901d");
		check(B = x"82aa6728");
		check(C = x"d3a49608");
		check(D = x"c82f758b");
		check(E = x"c65afb9d");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"fd9e1d7d");
		check(B = x"dc64901d");
		check(C = x"20aa99ca");
		check(D = x"d3a49608");
		check(E = x"c82f758b");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"1a37b0ca");
		check(B = x"fd9e1d7d");
		check(C = x"77192407");
		check(D = x"20aa99ca");
		check(E = x"d3a49608");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"33a23bfc");
		check(B = x"1a37b0ca");
		check(C = x"7f67875f");
		check(D = x"77192407");
		check(E = x"20aa99ca");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"21283486");
		check(B = x"33a23bfc");
		check(C = x"868dec32");
		check(D = x"7f67875f");
		check(E = x"77192407");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"d541f12d");
		check(B = x"21283486");
		check(C = x"0ce88eff");
		check(D = x"868dec32");
		check(E = x"7f67875f");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"c7567dc6");
		check(B = x"d541f12d");
		check(C = x"884a0d21");
		check(D = x"0ce88eff");
		check(E = x"868dec32");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"48413ba4");
		check(B = x"c7567dc6");
		check(C = x"75507c4b");
		check(D = x"884a0d21");
		check(E = x"0ce88eff");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"be35fbd5");
		check(B = x"48413ba4");
		check(C = x"b1d59f71");
		check(D = x"75507c4b");
		check(E = x"884a0d21");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"4aa84d97");
		check(B = x"be35fbd5");
		check(C = x"12104ee9");
		check(D = x"b1d59f71");
		check(E = x"75507c4b");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"8370b52e");
		check(B = x"4aa84d97");
		check(C = x"6f8d7ef5");
		check(D = x"12104ee9");
		check(E = x"b1d59f71");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"c5fbaf5d");
		check(B = x"8370b52e");
		check(C = x"d2aa1365");
		check(D = x"6f8d7ef5");
		check(E = x"12104ee9");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"1267b407");
		check(B = x"c5fbaf5d");
		check(C = x"a0dc2d4b");
		check(D = x"d2aa1365");
		check(E = x"6f8d7ef5");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"3b845d33");
		check(B = x"1267b407");
		check(C = x"717eebd7");
		check(D = x"a0dc2d4b");
		check(E = x"d2aa1365");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"046faa0a");
		check(B = x"3b845d33");
		check(C = x"c499ed01");
		check(D = x"717eebd7");
		check(E = x"a0dc2d4b");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"2c0ebc11");
		check(B = x"046faa0a");
		check(C = x"cee1174c");
		check(D = x"c499ed01");
		check(E = x"717eebd7");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"21796ad4");
		check(B = x"2c0ebc11");
		check(C = x"811bea82");
		check(D = x"cee1174c");
		check(E = x"c499ed01");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"dcbbb0cb");
		check(B = x"21796ad4");
		check(C = x"4b03af04");
		check(D = x"811bea82");
		check(E = x"cee1174c");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"0f511fd8");
		check(B = x"dcbbb0cb");
		check(C = x"085e5ab5");
		check(D = x"4b03af04");
		check(E = x"811bea82");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"dc63973f");
		check(B = x"0f511fd8");
		check(C = x"f72eec32");
		check(D = x"085e5ab5");
		check(E = x"4b03af04");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"4c986405");
		check(B = x"dc63973f");
		check(C = x"03d447f6");
		check(D = x"f72eec32");
		check(E = x"085e5ab5");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"32de1cba");
		check(B = x"4c986405");
		check(C = x"f718e5cf");
		check(D = x"03d447f6");
		check(E = x"f72eec32");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"fc87dedf");
		check(B = x"32de1cba");
		check(C = x"53261901");
		check(D = x"f718e5cf");
		check(E = x"03d447f6");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"970a0d5c");
		check(B = x"fc87dedf");
		check(C = x"8cb7872e");
		check(D = x"53261901");
		check(E = x"f718e5cf");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"7f193dc5");
		check(B = x"970a0d5c");
		check(C = x"ff21f7b7");
		check(D = x"8cb7872e");
		check(E = x"53261901");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"ee1b1aaf");
		check(B = x"7f193dc5");
		check(C = x"25c28357");
		check(D = x"ff21f7b7");
		check(E = x"8cb7872e");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"40f28e09");
		check(B = x"ee1b1aaf");
		check(C = x"5fc64f71");
		check(D = x"25c28357");
		check(E = x"ff21f7b7");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"1c51e1f2");
		check(B = x"40f28e09");
		check(C = x"fb86c6ab");
		check(D = x"5fc64f71");
		check(E = x"25c28357");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"a01b846c");
		check(B = x"1c51e1f2");
		check(C = x"503ca382");
		check(D = x"fb86c6ab");
		check(E = x"5fc64f71");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"bead02ca");
		check(B = x"a01b846c");
		check(C = x"8714787c");
		check(D = x"503ca382");
		check(E = x"fb86c6ab");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"baf39337");
		check(B = x"bead02ca");
		check(C = x"2806e11b");
		check(D = x"8714787c");
		check(E = x"503ca382");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"120731c5");
		check(B = x"baf39337");
		check(C = x"afab40b2");
		check(D = x"2806e11b");
		check(E = x"8714787c");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"641db2ce");
		check(B = x"120731c5");
		check(C = x"eebce4cd");
		check(D = x"afab40b2");
		check(E = x"2806e11b");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"3847ad66");
		check(B = x"641db2ce");
		check(C = x"4481cc71");
		check(D = x"eebce4cd");
		check(E = x"afab40b2");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"e490436d");
		check(B = x"3847ad66");
		check(C = x"99076cb3");
		check(D = x"4481cc71");
		check(E = x"eebce4cd");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"27e9f1d8");
		check(B = x"e490436d");
		check(C = x"8e11eb59");
		check(D = x"99076cb3");
		check(E = x"4481cc71");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"7b71f76d");
		check(B = x"27e9f1d8");
		check(C = x"792410db");
		check(D = x"8e11eb59");
		check(E = x"99076cb3");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"5e6456af");
		check(B = x"7b71f76d");
		check(C = x"09fa7c76");
		check(D = x"792410db");
		check(E = x"8e11eb59");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"c846093f");
		check(B = x"5e6456af");
		check(C = x"5edc7ddb");
		check(D = x"09fa7c76");
		check(E = x"792410db");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"d262ff50");
		check(B = x"c846093f");
		check(C = x"d79915ab");
		check(D = x"5edc7ddb");
		check(E = x"09fa7c76");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"09d785fd");
		check(B = x"d262ff50");
		check(C = x"f211824f");
		check(D = x"d79915ab");
		check(E = x"5edc7ddb");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"3f52de5a");
		check(B = x"09d785fd");
		check(C = x"3498bfd4");
		check(D = x"f211824f");
		check(E = x"d79915ab");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d756c147");
		check(B = x"3f52de5a");
		check(C = x"4275e17f");
		check(D = x"3498bfd4");
		check(E = x"f211824f");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"548c9cb2");
		check(B = x"d756c147");
		check(C = x"8fd4b796");
		check(D = x"4275e17f");
		check(E = x"3498bfd4");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"b66c020b");
		check(B = x"548c9cb2");
		check(C = x"f5d5b051");
		check(D = x"8fd4b796");
		check(E = x"4275e17f");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"6b61c9e1");
		check(B = x"b66c020b");
		check(C = x"9523272c");
		check(D = x"f5d5b051");
		check(E = x"8fd4b796");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"19dfa7ac");
		check(B = x"6b61c9e1");
		check(C = x"ed9b0082");
		check(D = x"9523272c");
		check(E = x"f5d5b051");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"101655f9");
		check(B = x"19dfa7ac");
		check(C = x"5ad87278");
		check(D = x"ed9b0082");
		check(E = x"9523272c");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"0c3df2b4");
		check(B = x"101655f9");
		check(C = x"0677e9eb");
		check(D = x"5ad87278");
		check(E = x"ed9b0082");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"78dd4d2b");
		check(B = x"0c3df2b4");
		check(C = x"4405957e");
		check(D = x"0677e9eb");
		check(E = x"5ad87278");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"497093c0");
		check(B = x"78dd4d2b");
		check(C = x"030f7cad");
		check(D = x"4405957e");
		check(E = x"0677e9eb");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"3f2588c2");
		check(B = x"497093c0");
		check(C = x"de37534a");
		check(D = x"030f7cad");
		check(E = x"4405957e");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"c199f8c7");
		check(B = x"3f2588c2");
		check(C = x"125c24f0");
		check(D = x"de37534a");
		check(E = x"030f7cad");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"39859de7");
		check(B = x"c199f8c7");
		check(C = x"8fc96230");
		check(D = x"125c24f0");
		check(E = x"de37534a");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"edb42de4");
		check(B = x"39859de7");
		check(C = x"f0667e31");
		check(D = x"8fc96230");
		check(E = x"125c24f0");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"11793f6f");
		check(B = x"edb42de4");
		check(C = x"ce616779");
		check(D = x"f0667e31");
		check(E = x"8fc96230");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"5ee76897");
		check(B = x"11793f6f");
		check(C = x"3b6d0b79");
		check(D = x"ce616779");
		check(E = x"f0667e31");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"63f7dab7");
		check(B = x"5ee76897");
		check(C = x"c45e4fdb");
		check(D = x"3b6d0b79");
		check(E = x"ce616779");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"a079b7d9");
		check(B = x"63f7dab7");
		check(C = x"d7b9da25");
		check(D = x"c45e4fdb");
		check(E = x"3b6d0b79");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"860d21cc");
		check(B = x"a079b7d9");
		check(C = x"d8fdf6ad");
		check(D = x"d7b9da25");
		check(E = x"c45e4fdb");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"5738d5e1");
		check(B = x"860d21cc");
		check(C = x"681e6df6");
		check(D = x"d8fdf6ad");
		check(E = x"d7b9da25");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"42541b35");
		check(B = x"5738d5e1");
		check(C = x"21834873");
		check(D = x"681e6df6");
		check(E = x"d8fdf6ad");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"a9993e36");
		check(H1_out = x"4706816a");
		check(H2_out = x"ba3e2571");
		check(H3_out = x"7850c26c");
		check(H4_out = x"9cd0d89d");

		test_runner_cleanup(runner);
	end process;

end sha1_test_2_tb_arch;

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 208 bits message ("abcdefghijklmnopqrstuvwxyz")

entity sha1_test_4_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_4_tb;

architecture sha1_test_4_tb_arch OF sha1_test_4_tb IS
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
	signal error                 : md5_error_type;
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
		check(A = x"806a2a2f");
		check(B = x"cd772046");
		check(C = x"bf873504");
		check(D = x"80ca51e1");
		check(E = x"2ddbfde8");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"23332f16");
		check(B = x"806a2a2f");
		check(C = x"b35dc811");
		check(D = x"bf873504");
		check(E = x"80ca51e1");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"017fcb3f");
		check(B = x"23332f16");
		check(C = x"e01a8a8b");
		check(D = x"b35dc811");
		check(E = x"bf873504");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"fa61e080");
		check(B = x"017fcb3f");
		check(C = x"88cccbc5");
		check(D = x"e01a8a8b");
		check(E = x"b35dc811");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"3a691d4e");
		check(B = x"fa61e080");
		check(C = x"c05ff2cf");
		check(D = x"88cccbc5");
		check(E = x"e01a8a8b");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"488e99b0");
		check(B = x"3a691d4e");
		check(C = x"3e987820");
		check(D = x"c05ff2cf");
		check(E = x"88cccbc5");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"ef4175e8");
		check(B = x"488e99b0");
		check(C = x"8e9a4753");
		check(D = x"3e987820");
		check(E = x"c05ff2cf");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"41ab8a95");
		check(B = x"ef4175e8");
		check(C = x"1223a66c");
		check(D = x"8e9a4753");
		check(E = x"3e987820");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"d1276adc");
		check(B = x"41ab8a95");
		check(C = x"3bd05d7a");
		check(D = x"1223a66c");
		check(E = x"8e9a4753");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"218a49ce");
		check(B = x"d1276adc");
		check(C = x"506ae2a5");
		check(D = x"3bd05d7a");
		check(E = x"1223a66c");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"28f1e17f");
		check(B = x"218a49ce");
		check(C = x"3449dab7");
		check(D = x"506ae2a5");
		check(E = x"3bd05d7a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"350801cf");
		check(B = x"28f1e17f");
		check(C = x"88629273");
		check(D = x"3449dab7");
		check(E = x"506ae2a5");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"988662a7");
		check(B = x"350801cf");
		check(C = x"ca3c785f");
		check(D = x"88629273");
		check(E = x"3449dab7");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"38134bf2");
		check(B = x"988662a7");
		check(C = x"cd420073");
		check(D = x"ca3c785f");
		check(E = x"88629273");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"c9cfdd6e");
		check(B = x"38134bf2");
		check(C = x"e62198a9");
		check(D = x"cd420073");
		check(E = x"ca3c785f");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"110f72d1");
		check(B = x"c9cfdd6e");
		check(C = x"8e04d2fc");
		check(D = x"e62198a9");
		check(E = x"cd420073");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"d2c9fdd1");
		check(B = x"110f72d1");
		check(C = x"b273f75b");
		check(D = x"8e04d2fc");
		check(E = x"e62198a9");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"3c1722aa");
		check(B = x"d2c9fdd1");
		check(C = x"4443dcb4");
		check(D = x"b273f75b");
		check(E = x"8e04d2fc");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d9f625a3");
		check(B = x"3c1722aa");
		check(C = x"74b27f74");
		check(D = x"4443dcb4");
		check(E = x"b273f75b");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"f2837982");
		check(B = x"d9f625a3");
		check(C = x"8f05c8aa");
		check(D = x"74b27f74");
		check(E = x"4443dcb4");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"c6760570");
		check(B = x"f2837982");
		check(C = x"f67d8968");
		check(D = x"8f05c8aa");
		check(E = x"74b27f74");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"889aa8cf");
		check(B = x"c6760570");
		check(C = x"bca0de60");
		check(D = x"f67d8968");
		check(E = x"8f05c8aa");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"09576d07");
		check(B = x"889aa8cf");
		check(C = x"319d815c");
		check(D = x"bca0de60");
		check(E = x"f67d8968");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"ea44fc5d");
		check(B = x"09576d07");
		check(C = x"e226aa33");
		check(D = x"319d815c");
		check(E = x"bca0de60");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"60356a4b");
		check(B = x"ea44fc5d");
		check(C = x"c255db41");
		check(D = x"e226aa33");
		check(E = x"319d815c");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"a765e39e");
		check(B = x"60356a4b");
		check(C = x"7a913f17");
		check(D = x"c255db41");
		check(E = x"e226aa33");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"994c80c7");
		check(B = x"a765e39e");
		check(C = x"d80d5a92");
		check(D = x"7a913f17");
		check(E = x"c255db41");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"8a02c2f9");
		check(B = x"994c80c7");
		check(C = x"a9d978e7");
		check(D = x"d80d5a92");
		check(E = x"7a913f17");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"3fba8758");
		check(B = x"8a02c2f9");
		check(C = x"e6532031");
		check(D = x"a9d978e7");
		check(E = x"d80d5a92");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"a8671269");
		check(B = x"3fba8758");
		check(C = x"6280b0be");
		check(D = x"e6532031");
		check(E = x"a9d978e7");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"22b4b8f9");
		check(B = x"a8671269");
		check(C = x"0feea1d6");
		check(D = x"6280b0be");
		check(E = x"e6532031");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"989a98b2");
		check(B = x"22b4b8f9");
		check(C = x"6a19c49a");
		check(D = x"0feea1d6");
		check(E = x"6280b0be");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"d0bab5ef");
		check(B = x"989a98b2");
		check(C = x"48ad2e3e");
		check(D = x"6a19c49a");
		check(E = x"0feea1d6");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"74f9046c");
		check(B = x"d0bab5ef");
		check(C = x"a626a62c");
		check(D = x"48ad2e3e");
		check(E = x"6a19c49a");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"baa23a22");
		check(B = x"74f9046c");
		check(C = x"f42ead7b");
		check(D = x"a626a62c");
		check(E = x"48ad2e3e");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"a4ef7261");
		check(B = x"baa23a22");
		check(C = x"1d3e411b");
		check(D = x"f42ead7b");
		check(E = x"a626a62c");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"13a92d0e");
		check(B = x"a4ef7261");
		check(C = x"aea88e88");
		check(D = x"1d3e411b");
		check(E = x"f42ead7b");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"5b9b4247");
		check(B = x"13a92d0e");
		check(C = x"693bdc98");
		check(D = x"aea88e88");
		check(E = x"1d3e411b");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"ca25ba99");
		check(B = x"5b9b4247");
		check(C = x"84ea4b43");
		check(D = x"693bdc98");
		check(E = x"aea88e88");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"4fe9ca35");
		check(B = x"ca25ba99");
		check(C = x"d6e6d091");
		check(D = x"84ea4b43");
		check(E = x"693bdc98");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"be85a7c3");
		check(B = x"4fe9ca35");
		check(C = x"72896ea6");
		check(D = x"d6e6d091");
		check(E = x"84ea4b43");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"c64984d5");
		check(B = x"be85a7c3");
		check(C = x"53fa728d");
		check(D = x"72896ea6");
		check(E = x"d6e6d091");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"3d963ae0");
		check(B = x"c64984d5");
		check(C = x"efa169f0");
		check(D = x"53fa728d");
		check(E = x"72896ea6");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"92fabb8e");
		check(B = x"3d963ae0");
		check(C = x"71926135");
		check(D = x"efa169f0");
		check(E = x"53fa728d");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"840abcb5");
		check(B = x"92fabb8e");
		check(C = x"0f658eb8");
		check(D = x"71926135");
		check(E = x"efa169f0");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"71a4548d");
		check(B = x"840abcb5");
		check(C = x"a4beaee3");
		check(D = x"0f658eb8");
		check(E = x"71926135");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"d42b5c55");
		check(B = x"71a4548d");
		check(C = x"6102af2d");
		check(D = x"a4beaee3");
		check(E = x"0f658eb8");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"0f507dfd");
		check(B = x"d42b5c55");
		check(C = x"5c691523");
		check(D = x"6102af2d");
		check(E = x"a4beaee3");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"a7a096f6");
		check(B = x"0f507dfd");
		check(C = x"750ad715");
		check(D = x"5c691523");
		check(E = x"6102af2d");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"a272d82e");
		check(B = x"a7a096f6");
		check(C = x"43d41f7f");
		check(D = x"750ad715");
		check(E = x"5c691523");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"90c579ed");
		check(B = x"a272d82e");
		check(C = x"a9e825bd");
		check(D = x"43d41f7f");
		check(E = x"750ad715");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"e48ddea2");
		check(B = x"90c579ed");
		check(C = x"a89cb60b");
		check(D = x"a9e825bd");
		check(E = x"43d41f7f");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"c9785ac0");
		check(B = x"e48ddea2");
		check(C = x"64315e7b");
		check(D = x"a89cb60b");
		check(E = x"a9e825bd");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"5b1d01ea");
		check(B = x"c9785ac0");
		check(C = x"b92377a8");
		check(D = x"64315e7b");
		check(E = x"a89cb60b");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"766a587d");
		check(B = x"5b1d01ea");
		check(C = x"325e16b0");
		check(D = x"b92377a8");
		check(E = x"64315e7b");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"45953bf3");
		check(B = x"766a587d");
		check(C = x"96c7407a");
		check(D = x"325e16b0");
		check(E = x"b92377a8");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"4d829358");
		check(B = x"45953bf3");
		check(C = x"5d9a961f");
		check(D = x"96c7407a");
		check(E = x"325e16b0");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"2b0ef655");
		check(B = x"4d829358");
		check(C = x"d1654efc");
		check(D = x"5d9a961f");
		check(E = x"96c7407a");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"184d90ef");
		check(B = x"2b0ef655");
		check(C = x"1360a4d6");
		check(D = x"d1654efc");
		check(E = x"5d9a961f");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"73f6c893");
		check(B = x"184d90ef");
		check(C = x"4ac3bd95");
		check(D = x"1360a4d6");
		check(E = x"d1654efc");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"7887a6f3");
		check(B = x"73f6c893");
		check(C = x"c613643b");
		check(D = x"4ac3bd95");
		check(E = x"1360a4d6");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"80ef5d22");
		check(B = x"7887a6f3");
		check(C = x"dcfdb224");
		check(D = x"c613643b");
		check(E = x"4ac3bd95");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"8fa4ffd4");
		check(B = x"80ef5d22");
		check(C = x"de21e9bc");
		check(D = x"dcfdb224");
		check(E = x"c613643b");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"1f184793");
		check(B = x"8fa4ffd4");
		check(C = x"a03bd748");
		check(D = x"de21e9bc");
		check(E = x"dcfdb224");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"976544c3");
		check(B = x"1f184793");
		check(C = x"23e93ff5");
		check(D = x"a03bd748");
		check(E = x"de21e9bc");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"de42e6b4");
		check(B = x"976544c3");
		check(C = x"c7c611e4");
		check(D = x"23e93ff5");
		check(E = x"a03bd748");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"5520287a");
		check(B = x"de42e6b4");
		check(C = x"e5d95130");
		check(D = x"c7c611e4");
		check(E = x"23e93ff5");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"6e0112e3");
		check(B = x"5520287a");
		check(C = x"3790b9ad");
		check(D = x"e5d95130");
		check(E = x"c7c611e4");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"db6f8cdd");
		check(B = x"6e0112e3");
		check(C = x"95480a1e");
		check(D = x"3790b9ad");
		check(E = x"e5d95130");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"80e96265");
		check(B = x"db6f8cdd");
		check(C = x"db8044b8");
		check(D = x"95480a1e");
		check(E = x"3790b9ad");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"89bd243b");
		check(B = x"80e96265");
		check(C = x"76dbe337");
		check(D = x"db8044b8");
		check(E = x"95480a1e");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"c527c4e4");
		check(B = x"89bd243b");
		check(C = x"603a5899");
		check(D = x"76dbe337");
		check(E = x"db8044b8");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"9d2bb9e7");
		check(B = x"c527c4e4");
		check(C = x"e26f490e");
		check(D = x"603a5899");
		check(E = x"76dbe337");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"cb8be97a");
		check(B = x"9d2bb9e7");
		check(C = x"3149f139");
		check(D = x"e26f490e");
		check(E = x"603a5899");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"32d10c7b");
		check(H1_out = x"8cf96570");
		check(H2_out = x"ca04ce37");
		check(H3_out = x"f2a19d84");
		check(H4_out = x"240d3a89");

		test_runner_cleanup(runner);
	end process;

end sha1_test_4_tb_arch;

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
	signal last_chunk_size       : unsigned(9 downto 0)          := (others => '0');
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
			last_chunk_size       => last_chunk_size,
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
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"45464748";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"494a4b4c";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"4d4e4f50";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"51525354";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"55565758";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"595a6162";
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

		data_in               <= x"30313233";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"34353637";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"38390000";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_chunk <= '1';
		is_last_chunk        <= '1';
		last_chunk_size      <= to_unsigned(496, 10);
		wait until rising_edge(clk);
		calculate_next_chunk <= '0';
		is_last_chunk        <= '0';

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"c6c10796");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"99a09999");
		check(C = x"c6c10796");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"11067980");
		check(C = x"99a09999");
		check(D = x"c6c10796");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"c6c10796");
		check(B = x"27bce07a");
		check(C = x"11067980");
		check(D = x"99a09999");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"99a09999");
		check(B = x"f22e6c4e");
		check(C = x"27bce07a");
		check(D = x"11067980");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"11067980");
		check(B = x"b4ac9218");
		check(C = x"f22e6c4e");
		check(D = x"27bce07a");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"27bce07a");
		check(B = x"a95a2fc0");
		check(C = x"b4ac9218");
		check(D = x"f22e6c4e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"f22e6c4e");
		check(B = x"a4799506");
		check(C = x"a95a2fc0");
		check(D = x"b4ac9218");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"b4ac9218");
		check(B = x"1eb3e7c1");
		check(C = x"a4799506");
		check(D = x"a95a2fc0");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"a95a2fc0");
		check(B = x"a6e70cfe");
		check(C = x"1eb3e7c1");
		check(D = x"a4799506");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"a4799506");
		check(B = x"ca27520b");
		check(C = x"a6e70cfe");
		check(D = x"1eb3e7c1");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"1eb3e7c1");
		check(B = x"8a7612ec");
		check(C = x"ca27520b");
		check(D = x"a6e70cfe");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"a6e70cfe");
		check(B = x"3cbdcd45");
		check(C = x"8a7612ec");
		check(D = x"ca27520b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"ca27520b");
		check(B = x"b8dec763");
		check(C = x"3cbdcd45");
		check(D = x"8a7612ec");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"8a7612ec");
		check(B = x"fa148c8a");
		check(C = x"b8dec763");
		check(D = x"3cbdcd45");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"3cbdcd45");
		check(B = x"5d38e690");
		check(C = x"fa148c8a");
		check(D = x"b8dec763");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"b8dec763");
		check(B = x"04b9d52a");
		check(C = x"5d38e690");
		check(D = x"fa148c8a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"fa148c8a");
		check(B = x"783002eb");
		check(C = x"04b9d52a");
		check(D = x"5d38e690");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"5d38e690");
		check(B = x"d3ee3ed1");
		check(C = x"783002eb");
		check(D = x"04b9d52a");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"04b9d52a");
		check(B = x"47ae7c81");
		check(C = x"d3ee3ed1");
		check(D = x"783002eb");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"783002eb");
		check(B = x"2d7d8a3f");
		check(C = x"47ae7c81");
		check(D = x"d3ee3ed1");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"d3ee3ed1");
		check(B = x"d1210823");
		check(C = x"2d7d8a3f");
		check(D = x"47ae7c81");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"47ae7c81");
		check(B = x"4b534dc3");
		check(C = x"d1210823");
		check(D = x"2d7d8a3f");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"2d7d8a3f");
		check(B = x"75292030");
		check(C = x"4b534dc3");
		check(D = x"d1210823");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d1210823");
		check(B = x"9d2a6e33");
		check(C = x"75292030");
		check(D = x"4b534dc3");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"4b534dc3");
		check(B = x"0e8d2e44");
		check(C = x"9d2a6e33");
		check(D = x"75292030");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"75292030");
		check(B = x"d473b564");
		check(C = x"0e8d2e44");
		check(D = x"9d2a6e33");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"9d2a6e33");
		check(B = x"f2ff6ea0");
		check(C = x"d473b564");
		check(D = x"0e8d2e44");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"0e8d2e44");
		check(B = x"9b085fa9");
		check(C = x"f2ff6ea0");
		check(D = x"d473b564");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"d473b564");
		check(B = x"4400a9bd");
		check(C = x"9b085fa9");
		check(D = x"f2ff6ea0");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"f2ff6ea0");
		check(B = x"5993248f");
		check(C = x"4400a9bd");
		check(D = x"9b085fa9");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"9b085fa9");
		check(B = x"dd789ecc");
		check(C = x"5993248f");
		check(D = x"4400a9bd");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"4400a9bd");
		check(B = x"21c8d2b7");
		check(C = x"dd789ecc");
		check(D = x"5993248f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"5993248f");
		check(B = x"1d55a18e");
		check(C = x"21c8d2b7");
		check(D = x"dd789ecc");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"dd789ecc");
		check(B = x"056ec119");
		check(C = x"1d55a18e");
		check(D = x"21c8d2b7");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"21c8d2b7");
		check(B = x"1b9504f8");
		check(C = x"056ec119");
		check(D = x"1d55a18e");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"1d55a18e");
		check(B = x"436b7fe9");
		check(C = x"1b9504f8");
		check(D = x"056ec119");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"056ec119");
		check(B = x"075800c1");
		check(C = x"436b7fe9");
		check(D = x"1b9504f8");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"1b9504f8");
		check(B = x"f404c2f6");
		check(C = x"075800c1");
		check(D = x"436b7fe9");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"436b7fe9");
		check(B = x"cf0341ed");
		check(C = x"f404c2f6");
		check(D = x"075800c1");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"075800c1");
		check(B = x"888e7d8a");
		check(C = x"cf0341ed");
		check(D = x"f404c2f6");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"f404c2f6");
		check(B = x"bbdaecd8");
		check(C = x"888e7d8a");
		check(D = x"cf0341ed");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"cf0341ed");
		check(B = x"ce620273");
		check(C = x"bbdaecd8");
		check(D = x"888e7d8a");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"888e7d8a");
		check(B = x"047b9419");
		check(C = x"ce620273");
		check(D = x"bbdaecd8");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"bbdaecd8");
		check(B = x"2dbee21d");
		check(C = x"047b9419");
		check(D = x"ce620273");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"ce620273");
		check(B = x"e95c3a43");
		check(C = x"2dbee21d");
		check(D = x"047b9419");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"047b9419");
		check(B = x"ee46e961");
		check(C = x"e95c3a43");
		check(D = x"2dbee21d");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"2dbee21d");
		check(B = x"f166f514");
		check(C = x"ee46e961");
		check(D = x"e95c3a43");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"e95c3a43");
		check(B = x"e47fd4f3");
		check(C = x"f166f514");
		check(D = x"ee46e961");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"ee46e961");
		check(B = x"fb887751");
		check(C = x"e47fd4f3");
		check(D = x"f166f514");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"f166f514");
		check(B = x"f22aedcc");
		check(C = x"fb887751");
		check(D = x"e47fd4f3");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"e47fd4f3");
		check(B = x"7a13bc5c");
		check(C = x"f22aedcc");
		check(D = x"fb887751");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"fb887751");
		check(B = x"a691d430");
		check(C = x"7a13bc5c");
		check(D = x"f22aedcc");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"f22aedcc");
		check(B = x"528452f2");
		check(C = x"a691d430");
		check(D = x"7a13bc5c");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"7a13bc5c");
		check(B = x"3fc23df6");
		check(C = x"528452f2");
		check(D = x"a691d430");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"a691d430");
		check(B = x"efb0e72f");
		check(C = x"3fc23df6");
		check(D = x"528452f2");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"528452f2");
		check(B = x"27145703");
		check(C = x"efb0e72f");
		check(D = x"3fc23df6");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"3fc23df6");
		check(B = x"21a11069");
		check(C = x"27145703");
		check(D = x"efb0e72f");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"efb0e72f");
		check(B = x"374fbe79");
		check(C = x"21a11069");
		check(D = x"27145703");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"27145703");
		check(B = x"49d9a5b4");
		check(C = x"374fbe79");
		check(D = x"21a11069");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"21a11069");
		check(B = x"1cb80f0a");
		check(C = x"49d9a5b4");
		check(D = x"374fbe79");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"374fbe79");
		check(B = x"ea3d3eb4");
		check(C = x"1cb80f0a");
		check(D = x"49d9a5b4");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"49d9a5b4");
		check(B = x"10f68731");
		check(C = x"ea3d3eb4");
		check(D = x"1cb80f0a");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"1cb80f0a");
		check(B = x"ef2e3a46");
		check(C = x"10f68731");
		check(D = x"ea3d3eb4");

		-----------------------------------------------------------------------
		-- Step 0
		wait until rising_edge(clk);
		check(A = x"fa6f932a");
		check(B = x"eda23ed1");
		check(C = x"defbe5cf");
		check(D = x"a9b1642f");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"a9b1642f");
		check(B = x"989939cf");
		check(C = x"eda23ed1");
		check(D = x"defbe5cf");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"defbe5cf");
		check(B = x"3c307338");
		check(C = x"989939cf");
		check(D = x"eda23ed1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"eda23ed1");
		check(B = x"ddcf0634");
		check(C = x"3c307338");
		check(D = x"989939cf");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"989939cf");
		check(B = x"75144433");
		check(C = x"ddcf0634");
		check(D = x"3c307338");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"3c307338");
		check(B = x"c8875807");
		check(C = x"75144433");
		check(D = x"ddcf0634");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"ddcf0634");
		check(B = x"c783cb60");
		check(C = x"c8875807");
		check(D = x"75144433");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"75144433");
		check(B = x"99b6b699");
		check(C = x"c783cb60");
		check(D = x"c8875807");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"c8875807");
		check(B = x"a60a3f69");
		check(C = x"99b6b699");
		check(D = x"c783cb60");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"c783cb60");
		check(B = x"aa6630be");
		check(C = x"a60a3f69");
		check(D = x"99b6b699");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"99b6b699");
		check(B = x"64db26e9");
		check(C = x"aa6630be");
		check(D = x"a60a3f69");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"a60a3f69");
		check(B = x"64cc7c5a");
		check(C = x"64db26e9");
		check(D = x"aa6630be");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"aa6630be");
		check(B = x"a70737da");
		check(C = x"64cc7c5a");
		check(D = x"64db26e9");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"64db26e9");
		check(B = x"5473f8a7");
		check(C = x"a70737da");
		check(D = x"64cc7c5a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"64cc7c5a");
		check(B = x"96f6586e");
		check(C = x"5473f8a7");
		check(D = x"a70737da");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"a70737da");
		check(B = x"a36f556f");
		check(C = x"96f6586e");
		check(D = x"5473f8a7");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"5473f8a7");
		check(B = x"a5050ad3");
		check(C = x"a36f556f");
		check(D = x"96f6586e");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"96f6586e");
		check(B = x"28776046");
		check(C = x"a5050ad3");
		check(D = x"a36f556f");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"a36f556f");
		check(B = x"27dcd8b4");
		check(C = x"28776046");
		check(D = x"a5050ad3");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"a5050ad3");
		check(B = x"82b8827c");
		check(C = x"27dcd8b4");
		check(D = x"28776046");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"28776046");
		check(B = x"e04f070c");
		check(C = x"82b8827c");
		check(D = x"27dcd8b4");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"27dcd8b4");
		check(B = x"2f3cd2a2");
		check(C = x"e04f070c");
		check(D = x"82b8827c");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"82b8827c");
		check(B = x"c0d22b61");
		check(C = x"2f3cd2a2");
		check(D = x"e04f070c");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"e04f070c");
		check(B = x"df35cb56");
		check(C = x"c0d22b61");
		check(D = x"2f3cd2a2");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"2f3cd2a2");
		check(B = x"242dd210");
		check(C = x"df35cb56");
		check(D = x"c0d22b61");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"c0d22b61");
		check(B = x"576ace33");
		check(C = x"242dd210");
		check(D = x"df35cb56");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"df35cb56");
		check(B = x"5c295967");
		check(C = x"576ace33");
		check(D = x"242dd210");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"242dd210");
		check(B = x"2291191a");
		check(C = x"5c295967");
		check(D = x"576ace33");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"576ace33");
		check(B = x"24eba695");
		check(C = x"2291191a");
		check(D = x"5c295967");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"5c295967");
		check(B = x"4bd0378b");
		check(C = x"24eba695");
		check(D = x"2291191a");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"2291191a");
		check(B = x"10c42a2f");
		check(C = x"4bd0378b");
		check(D = x"24eba695");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"24eba695");
		check(B = x"9c03e2e8");
		check(C = x"10c42a2f");
		check(D = x"4bd0378b");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"4bd0378b");
		check(B = x"5be1d526");
		check(C = x"9c03e2e8");
		check(D = x"10c42a2f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"10c42a2f");
		check(B = x"9e414279");
		check(C = x"5be1d526");
		check(D = x"9c03e2e8");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"9c03e2e8");
		check(B = x"9f4a1a7e");
		check(C = x"9e414279");
		check(D = x"5be1d526");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"5be1d526");
		check(B = x"a2448453");
		check(C = x"9f4a1a7e");
		check(D = x"9e414279");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"9e414279");
		check(B = x"e14e403d");
		check(C = x"a2448453");
		check(D = x"9f4a1a7e");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"9f4a1a7e");
		check(B = x"e8cfd670");
		check(C = x"e14e403d");
		check(D = x"a2448453");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"a2448453");
		check(B = x"60cc183a");
		check(C = x"e8cfd670");
		check(D = x"e14e403d");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"e14e403d");
		check(B = x"fe314121");
		check(C = x"60cc183a");
		check(D = x"e8cfd670");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"e8cfd670");
		check(B = x"fff62809");
		check(C = x"fe314121");
		check(D = x"60cc183a");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"60cc183a");
		check(B = x"e37209ac");
		check(C = x"fff62809");
		check(D = x"fe314121");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"fe314121");
		check(B = x"8cb5221c");
		check(C = x"e37209ac");
		check(D = x"fff62809");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"fff62809");
		check(B = x"7c7e974c");
		check(C = x"8cb5221c");
		check(D = x"e37209ac");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"e37209ac");
		check(B = x"54c9eb3a");
		check(C = x"7c7e974c");
		check(D = x"8cb5221c");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"8cb5221c");
		check(B = x"d4d9c6ac");
		check(C = x"54c9eb3a");
		check(D = x"7c7e974c");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"7c7e974c");
		check(B = x"2ec86f72");
		check(C = x"d4d9c6ac");
		check(D = x"54c9eb3a");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"54c9eb3a");
		check(B = x"79c0710a");
		check(C = x"2ec86f72");
		check(D = x"d4d9c6ac");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"d4d9c6ac");
		check(B = x"02095af1");
		check(C = x"79c0710a");
		check(D = x"2ec86f72");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"2ec86f72");
		check(B = x"13d245fd");
		check(C = x"02095af1");
		check(D = x"79c0710a");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"79c0710a");
		check(B = x"a8dcfe26");
		check(C = x"13d245fd");
		check(D = x"02095af1");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"02095af1");
		check(B = x"2ba98e3f");
		check(C = x"a8dcfe26");
		check(D = x"13d245fd");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"13d245fd");
		check(B = x"e126c1aa");
		check(C = x"2ba98e3f");
		check(D = x"a8dcfe26");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"a8dcfe26");
		check(B = x"96b00fa7");
		check(C = x"e126c1aa");
		check(D = x"2ba98e3f");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"2ba98e3f");
		check(B = x"6f287ff5");
		check(C = x"96b00fa7");
		check(D = x"e126c1aa");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"e126c1aa");
		check(B = x"fb7bcee0");
		check(C = x"6f287ff5");
		check(D = x"96b00fa7");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"96b00fa7");
		check(B = x"452c1099");
		check(C = x"fb7bcee0");
		check(D = x"6f287ff5");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"6f287ff5");
		check(B = x"ca801ba6");
		check(C = x"452c1099");
		check(D = x"fb7bcee0");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"fb7bcee0");
		check(B = x"c197ea8e");
		check(C = x"ca801ba6");
		check(D = x"452c1099");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"452c1099");
		check(B = x"5ac74608");
		check(C = x"c197ea8e");
		check(D = x"ca801ba6");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"ca801ba6");
		check(B = x"14ae42c6");
		check(C = x"5ac74608");
		check(D = x"c197ea8e");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"c197ea8e");
		check(B = x"a52dae75");
		check(C = x"14ae42c6");
		check(D = x"5ac74608");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"5ac74608");
		check(B = x"826afd76");
		check(C = x"a52dae75");
		check(D = x"14ae42c6");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"14ae42c6");
		check(B = x"16dd9203");
		check(C = x"826afd76");
		check(D = x"a52dae75");
		

		wait for 1000 ps;

		test_runner_cleanup(runner);
	end process;

end md5_test_complete_tb_arch;

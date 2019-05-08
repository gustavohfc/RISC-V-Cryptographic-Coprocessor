library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

entity sha1_test_5_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_5_tb;

architecture sha1_test_5_tb_arch OF sha1_test_5_tb IS
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
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(496, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"e0f6dbf7");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"cad29351");
		check(B = x"e0f6dbf7");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"f2ab74dc");
		check(B = x"cad29351");
		check(C = x"f83db6fd");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"5244aa3a");
		check(B = x"f2ab74dc");
		check(C = x"72b4a4d4");
		check(D = x"f83db6fd");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"c8f003ec");
		check(B = x"5244aa3a");
		check(C = x"3caadd37");
		check(D = x"72b4a4d4");
		check(E = x"f83db6fd");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"f6c7927d");
		check(B = x"c8f003ec");
		check(C = x"94912a8e");
		check(D = x"3caadd37");
		check(E = x"72b4a4d4");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"b41eae2c");
		check(B = x"f6c7927d");
		check(C = x"323c00fb");
		check(D = x"94912a8e");
		check(E = x"3caadd37");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"b07baac7");
		check(B = x"b41eae2c");
		check(C = x"7db1e49f");
		check(D = x"323c00fb");
		check(E = x"94912a8e");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"9c220b66");
		check(B = x"b07baac7");
		check(C = x"2d07ab8b");
		check(D = x"7db1e49f");
		check(E = x"323c00fb");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"e9f04370");
		check(B = x"9c220b66");
		check(C = x"ec1eeab1");
		check(D = x"2d07ab8b");
		check(E = x"7db1e49f");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"32b4e870");
		check(B = x"e9f04370");
		check(C = x"a70882d9");
		check(D = x"ec1eeab1");
		check(E = x"2d07ab8b");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"f6aa5371");
		check(B = x"32b4e870");
		check(C = x"3a7c10dc");
		check(D = x"a70882d9");
		check(E = x"ec1eeab1");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"4aa04edb");
		check(B = x"f6aa5371");
		check(C = x"0cad3a1c");
		check(D = x"3a7c10dc");
		check(E = x"a70882d9");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"92c21caa");
		check(B = x"4aa04edb");
		check(C = x"7daa94dc");
		check(D = x"0cad3a1c");
		check(E = x"3a7c10dc");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"6e248ada");
		check(B = x"92c21caa");
		check(C = x"d2a813b6");
		check(D = x"7daa94dc");
		check(E = x"0cad3a1c");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"63a31ff8");
		check(B = x"6e248ada");
		check(C = x"a4b0872a");
		check(D = x"d2a813b6");
		check(E = x"7daa94dc");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"bfdc4751");
		check(B = x"63a31ff8");
		check(C = x"9b8922b6");
		check(D = x"a4b0872a");
		check(E = x"d2a813b6");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"5ee7a0ba");
		check(B = x"bfdc4751");
		check(C = x"18e8c7fe");
		check(D = x"9b8922b6");
		check(E = x"a4b0872a");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"939452d8");
		check(B = x"5ee7a0ba");
		check(C = x"6ff711d4");
		check(D = x"18e8c7fe");
		check(E = x"9b8922b6");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"6322d6ee");
		check(B = x"939452d8");
		check(C = x"97b9e82e");
		check(D = x"6ff711d4");
		check(E = x"18e8c7fe");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"fb9e182a");
		check(B = x"6322d6ee");
		check(C = x"24e514b6");
		check(D = x"97b9e82e");
		check(E = x"6ff711d4");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"5453d2fd");
		check(B = x"fb9e182a");
		check(C = x"98c8b5bb");
		check(D = x"24e514b6");
		check(E = x"97b9e82e");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"1bf73fad");
		check(B = x"5453d2fd");
		check(C = x"bee7860a");
		check(D = x"98c8b5bb");
		check(E = x"24e514b6");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"ac4c7e71");
		check(B = x"1bf73fad");
		check(C = x"5514f4bf");
		check(D = x"bee7860a");
		check(E = x"98c8b5bb");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"912cf2bc");
		check(B = x"ac4c7e71");
		check(C = x"46fdcfeb");
		check(D = x"5514f4bf");
		check(E = x"bee7860a");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"fe24e991");
		check(B = x"912cf2bc");
		check(C = x"6b131f9c");
		check(D = x"46fdcfeb");
		check(E = x"5514f4bf");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"88553159");
		check(B = x"fe24e991");
		check(C = x"244b3caf");
		check(D = x"6b131f9c");
		check(E = x"46fdcfeb");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"40587f3e");
		check(B = x"88553159");
		check(C = x"7f893a64");
		check(D = x"244b3caf");
		check(E = x"6b131f9c");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"d082ca95");
		check(B = x"40587f3e");
		check(C = x"62154c56");
		check(D = x"7f893a64");
		check(E = x"244b3caf");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f5e25cf4");
		check(B = x"d082ca95");
		check(C = x"90161fcf");
		check(D = x"62154c56");
		check(E = x"7f893a64");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"dd2e7a3d");
		check(B = x"f5e25cf4");
		check(C = x"7420b2a5");
		check(D = x"90161fcf");
		check(E = x"62154c56");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"d54dadff");
		check(B = x"dd2e7a3d");
		check(C = x"3d78973d");
		check(D = x"7420b2a5");
		check(E = x"90161fcf");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"f3ed6086");
		check(B = x"d54dadff");
		check(C = x"774b9e8f");
		check(D = x"3d78973d");
		check(E = x"7420b2a5");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"c3e340a6");
		check(B = x"f3ed6086");
		check(C = x"f5536b7f");
		check(D = x"774b9e8f");
		check(E = x"3d78973d");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"0025c93e");
		check(B = x"c3e340a6");
		check(C = x"bcfb5821");
		check(D = x"f5536b7f");
		check(E = x"774b9e8f");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"39cbbb2d");
		check(B = x"0025c93e");
		check(C = x"b0f8d029");
		check(D = x"bcfb5821");
		check(E = x"f5536b7f");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"1352f2b3");
		check(B = x"39cbbb2d");
		check(C = x"8009724f");
		check(D = x"b0f8d029");
		check(E = x"bcfb5821");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"ae744018");
		check(B = x"1352f2b3");
		check(C = x"4e72eecb");
		check(D = x"8009724f");
		check(E = x"b0f8d029");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"dabe06c1");
		check(B = x"ae744018");
		check(C = x"c4d4bcac");
		check(D = x"4e72eecb");
		check(E = x"8009724f");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"3d8bb0e5");
		check(B = x"dabe06c1");
		check(C = x"2b9d1006");
		check(D = x"c4d4bcac");
		check(E = x"4e72eecb");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"43efc517");
		check(B = x"3d8bb0e5");
		check(C = x"76af81b0");
		check(D = x"2b9d1006");
		check(E = x"c4d4bcac");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"e504f1f1");
		check(B = x"43efc517");
		check(C = x"4f62ec39");
		check(D = x"76af81b0");
		check(E = x"2b9d1006");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"6a57f0c0");
		check(B = x"e504f1f1");
		check(C = x"d0fbf145");
		check(D = x"4f62ec39");
		check(E = x"76af81b0");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"3e87180c");
		check(B = x"6a57f0c0");
		check(C = x"79413c7c");
		check(D = x"d0fbf145");
		check(E = x"4f62ec39");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"6bec0117");
		check(B = x"3e87180c");
		check(C = x"1a95fc30");
		check(D = x"79413c7c");
		check(E = x"d0fbf145");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"f8819e9c");
		check(B = x"6bec0117");
		check(C = x"0fa1c603");
		check(D = x"1a95fc30");
		check(E = x"79413c7c");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"60ced1ab");
		check(B = x"f8819e9c");
		check(C = x"dafb0045");
		check(D = x"0fa1c603");
		check(E = x"1a95fc30");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"d07733a9");
		check(B = x"60ced1ab");
		check(C = x"3e2067a7");
		check(D = x"dafb0045");
		check(E = x"0fa1c603");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"dbabdaa5");
		check(B = x"d07733a9");
		check(C = x"d833b46a");
		check(D = x"3e2067a7");
		check(E = x"dafb0045");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"87d641a0");
		check(B = x"dbabdaa5");
		check(C = x"741dccea");
		check(D = x"d833b46a");
		check(E = x"3e2067a7");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"93962570");
		check(B = x"87d641a0");
		check(C = x"76eaf6a9");
		check(D = x"741dccea");
		check(E = x"d833b46a");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"f2b3b616");
		check(B = x"93962570");
		check(C = x"21f59068");
		check(D = x"76eaf6a9");
		check(E = x"741dccea");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"72d86773");
		check(B = x"f2b3b616");
		check(C = x"24e5895c");
		check(D = x"21f59068");
		check(E = x"76eaf6a9");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"1e4e66b6");
		check(B = x"72d86773");
		check(C = x"bcaced85");
		check(D = x"24e5895c");
		check(E = x"21f59068");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"a02a580e");
		check(B = x"1e4e66b6");
		check(C = x"dcb619dc");
		check(D = x"bcaced85");
		check(E = x"24e5895c");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"03bea0fb");
		check(B = x"a02a580e");
		check(C = x"879399ad");
		check(D = x"dcb619dc");
		check(E = x"bcaced85");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"4c5d9cb9");
		check(B = x"03bea0fb");
		check(C = x"a80a9603");
		check(D = x"879399ad");
		check(E = x"dcb619dc");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"32525375");
		check(B = x"4c5d9cb9");
		check(C = x"c0efa83e");
		check(D = x"a80a9603");
		check(E = x"879399ad");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"e4abe747");
		check(B = x"32525375");
		check(C = x"5317672e");
		check(D = x"c0efa83e");
		check(E = x"a80a9603");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"fadaf36d");
		check(B = x"e4abe747");
		check(C = x"4c9494dd");
		check(D = x"5317672e");
		check(E = x"c0efa83e");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"373314b7");
		check(B = x"fadaf36d");
		check(C = x"f92af9d1");
		check(D = x"4c9494dd");
		check(E = x"5317672e");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"3d569dd4");
		check(B = x"373314b7");
		check(C = x"7eb6bcdb");
		check(D = x"f92af9d1");
		check(E = x"4c9494dd");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"baf0483c");
		check(B = x"3d569dd4");
		check(C = x"cdccc52d");
		check(D = x"7eb6bcdb");
		check(E = x"f92af9d1");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"e544b01c");
		check(B = x"baf0483c");
		check(C = x"0f55a775");
		check(D = x"cdccc52d");
		check(E = x"7eb6bcdb");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"c6c04098");
		check(B = x"e544b01c");
		check(C = x"2ebc120f");
		check(D = x"0f55a775");
		check(E = x"cdccc52d");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"5213d6c8");
		check(B = x"c6c04098");
		check(C = x"39512c07");
		check(D = x"2ebc120f");
		check(E = x"0f55a775");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"1e6ecad0");
		check(B = x"5213d6c8");
		check(C = x"31b01026");
		check(D = x"39512c07");
		check(E = x"2ebc120f");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"976f5c56");
		check(B = x"1e6ecad0");
		check(C = x"1484f5b2");
		check(D = x"31b01026");
		check(E = x"39512c07");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"e7302737");
		check(B = x"976f5c56");
		check(C = x"079bb2b4");
		check(D = x"1484f5b2");
		check(E = x"31b01026");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"3bc3a705");
		check(B = x"e7302737");
		check(C = x"a5dbd715");
		check(D = x"079bb2b4");
		check(E = x"1484f5b2");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"300d8d02");
		check(B = x"3bc3a705");
		check(C = x"f9cc09cd");
		check(D = x"a5dbd715");
		check(E = x"079bb2b4");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"66121f42");
		check(B = x"300d8d02");
		check(C = x"4ef0e9c1");
		check(D = x"f9cc09cd");
		check(E = x"a5dbd715");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"2794ea1b");
		check(B = x"66121f42");
		check(C = x"8c036340");
		check(D = x"4ef0e9c1");
		check(E = x"f9cc09cd");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"2128b059");
		check(B = x"2794ea1b");
		check(C = x"998487d0");
		check(D = x"8c036340");
		check(E = x"4ef0e9c1");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"5bf32e6d");
		check(B = x"2128b059");
		check(C = x"c9e53a86");
		check(D = x"998487d0");
		check(E = x"8c036340");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"9938a6ec");
		check(B = x"5bf32e6d");
		check(C = x"484a2c16");
		check(D = x"c9e53a86");
		check(E = x"998487d0");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"2a1dd3b2");
		check(B = x"9938a6ec");
		check(C = x"56fccb9b");
		check(D = x"484a2c16");
		check(E = x"c9e53a86");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"2343cd61");
		check(B = x"2a1dd3b2");
		check(C = x"264e29bb");
		check(D = x"56fccb9b");
		check(E = x"484a2c16");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"7f3892a9");
		check(B = x"2343cd61");
		check(C = x"8a8774ec");
		check(D = x"264e29bb");
		check(E = x"56fccb9b");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"25ca2afb");
		check(B = x"7f3892a9");
		check(C = x"48d0f358");
		check(D = x"8a8774ec");
		check(E = x"264e29bb");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);    -- Wait the padding
		wait until rising_edge(clk);

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"d8491627");
		check(B = x"8d0f4dfc");
		check(C = x"9bc18f8c");
		check(D = x"e18bd056");
		check(E = x"9ab9c962");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"e7e0a584");
		check(B = x"d8491627");
		check(C = x"2343d37f");
		check(D = x"9bc18f8c");
		check(E = x"e18bd056");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"3be4963a");
		check(B = x"e7e0a584");
		check(C = x"f6124589");
		check(D = x"2343d37f");
		check(E = x"9bc18f8c");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"58da2867");
		check(B = x"3be4963a");
		check(C = x"39f82961");
		check(D = x"f6124589");
		check(E = x"2343d37f");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"96fd9ba4");
		check(B = x"58da2867");
		check(C = x"8ef9258e");
		check(D = x"39f82961");
		check(E = x"f6124589");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"5a4054ba");
		check(B = x"96fd9ba4");
		check(C = x"d6368a19");
		check(D = x"8ef9258e");
		check(E = x"39f82961");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"7ab9e84f");
		check(B = x"5a4054ba");
		check(C = x"25bf66e9");
		check(D = x"d6368a19");
		check(E = x"8ef9258e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"c4ef77bf");
		check(B = x"7ab9e84f");
		check(C = x"9690152e");
		check(D = x"25bf66e9");
		check(E = x"d6368a19");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"e63e0258");
		check(B = x"c4ef77bf");
		check(C = x"deae7a13");
		check(D = x"9690152e");
		check(E = x"25bf66e9");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"1ec09db1");
		check(B = x"e63e0258");
		check(C = x"f13bddef");
		check(D = x"deae7a13");
		check(E = x"9690152e");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"c1e0bd35");
		check(B = x"1ec09db1");
		check(C = x"398f8096");
		check(D = x"f13bddef");
		check(E = x"deae7a13");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"6f045b42");
		check(B = x"c1e0bd35");
		check(C = x"47b0276c");
		check(D = x"398f8096");
		check(E = x"f13bddef");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"a5f8e57b");
		check(B = x"6f045b42");
		check(C = x"70782f4d");
		check(D = x"47b0276c");
		check(E = x"398f8096");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"b3ded90f");
		check(B = x"a5f8e57b");
		check(C = x"9bc116d0");
		check(D = x"70782f4d");
		check(E = x"47b0276c");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"efcdd14f");
		check(B = x"b3ded90f");
		check(C = x"e97e395e");
		check(D = x"9bc116d0");
		check(E = x"70782f4d");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"6e13f4b1");
		check(B = x"efcdd14f");
		check(C = x"ecf7b643");
		check(D = x"e97e395e");
		check(E = x"9bc116d0");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"a5b9dee9");
		check(B = x"6e13f4b1");
		check(C = x"fbf37453");
		check(D = x"ecf7b643");
		check(E = x"e97e395e");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"e634067e");
		check(B = x"a5b9dee9");
		check(C = x"5b84fd2c");
		check(D = x"fbf37453");
		check(E = x"ecf7b643");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"69bdffd2");
		check(B = x"e634067e");
		check(C = x"696e77ba");
		check(D = x"5b84fd2c");
		check(E = x"fbf37453");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"07dae773");
		check(B = x"69bdffd2");
		check(C = x"b98d019f");
		check(D = x"696e77ba");
		check(E = x"5b84fd2c");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"7f1a6124");
		check(B = x"07dae773");
		check(C = x"9a6f7ff4");
		check(D = x"b98d019f");
		check(E = x"696e77ba");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"dfcd28c2");
		check(B = x"7f1a6124");
		check(C = x"c1f6b9dc");
		check(D = x"9a6f7ff4");
		check(E = x"b98d019f");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"468faca7");
		check(B = x"dfcd28c2");
		check(C = x"1fc69849");
		check(D = x"c1f6b9dc");
		check(E = x"9a6f7ff4");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"dd3c0db4");
		check(B = x"468faca7");
		check(C = x"b7f34a30");
		check(D = x"1fc69849");
		check(E = x"c1f6b9dc");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"c70cea76");
		check(B = x"dd3c0db4");
		check(C = x"d1a3eb29");
		check(D = x"b7f34a30");
		check(E = x"1fc69849");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"2baa7f6f");
		check(B = x"c70cea76");
		check(C = x"374f036d");
		check(D = x"d1a3eb29");
		check(E = x"b7f34a30");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"bdfd25e8");
		check(B = x"2baa7f6f");
		check(C = x"b1c33a9d");
		check(D = x"374f036d");
		check(E = x"d1a3eb29");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"ad48f980");
		check(B = x"bdfd25e8");
		check(C = x"caea9fdb");
		check(D = x"b1c33a9d");
		check(E = x"374f036d");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"161c9fd1");
		check(B = x"ad48f980");
		check(C = x"2f7f497a");
		check(D = x"caea9fdb");
		check(E = x"b1c33a9d");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"2d0e5be1");
		check(B = x"161c9fd1");
		check(C = x"2b523e60");
		check(D = x"2f7f497a");
		check(E = x"caea9fdb");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"edc22e6c");
		check(B = x"2d0e5be1");
		check(C = x"458727f4");
		check(D = x"2b523e60");
		check(E = x"2f7f497a");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"9a7a494d");
		check(B = x"edc22e6c");
		check(C = x"4b4396f8");
		check(D = x"458727f4");
		check(E = x"2b523e60");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"cc7bf314");
		check(B = x"9a7a494d");
		check(C = x"3b708b9b");
		check(D = x"4b4396f8");
		check(E = x"458727f4");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"2e29465c");
		check(B = x"cc7bf314");
		check(C = x"669e9253");
		check(D = x"3b708b9b");
		check(E = x"4b4396f8");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"10dc487a");
		check(B = x"2e29465c");
		check(C = x"331efcc5");
		check(D = x"669e9253");
		check(E = x"3b708b9b");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"417ce0c8");
		check(B = x"10dc487a");
		check(C = x"0b8a5197");
		check(D = x"331efcc5");
		check(E = x"669e9253");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"2d5e7424");
		check(B = x"417ce0c8");
		check(C = x"8437121e");
		check(D = x"0b8a5197");
		check(E = x"331efcc5");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"1c891fac");
		check(B = x"2d5e7424");
		check(C = x"105f3832");
		check(D = x"8437121e");
		check(E = x"0b8a5197");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"c4be90c3");
		check(B = x"1c891fac");
		check(C = x"0b579d09");
		check(D = x"105f3832");
		check(E = x"8437121e");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"9266d04e");
		check(B = x"c4be90c3");
		check(C = x"072247eb");
		check(D = x"0b579d09");
		check(E = x"105f3832");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"f38b94ab");
		check(B = x"9266d04e");
		check(C = x"f12fa430");
		check(D = x"072247eb");
		check(E = x"0b579d09");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"9f0d79cd");
		check(B = x"f38b94ab");
		check(C = x"a499b413");
		check(D = x"f12fa430");
		check(E = x"072247eb");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"697cd2ad");
		check(B = x"9f0d79cd");
		check(C = x"fce2e52a");
		check(D = x"a499b413");
		check(E = x"f12fa430");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"6c6ff184");
		check(B = x"697cd2ad");
		check(C = x"67c35e73");
		check(D = x"fce2e52a");
		check(E = x"a499b413");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"2f9677a7");
		check(B = x"6c6ff184");
		check(C = x"5a5f34ab");
		check(D = x"67c35e73");
		check(E = x"fce2e52a");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"ed24db0e");
		check(B = x"2f9677a7");
		check(C = x"1b1bfc61");
		check(D = x"5a5f34ab");
		check(E = x"67c35e73");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"b69ae94f");
		check(B = x"ed24db0e");
		check(C = x"cbe59de9");
		check(D = x"1b1bfc61");
		check(E = x"5a5f34ab");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"88010826");
		check(B = x"b69ae94f");
		check(C = x"bb4936c3");
		check(D = x"cbe59de9");
		check(E = x"1b1bfc61");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"6631fbd9");
		check(B = x"88010826");
		check(C = x"eda6ba53");
		check(D = x"bb4936c3");
		check(E = x"cbe59de9");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"ca430834");
		check(B = x"6631fbd9");
		check(C = x"a2004209");
		check(D = x"eda6ba53");
		check(E = x"bb4936c3");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"78e72611");
		check(B = x"ca430834");
		check(C = x"598c7ef6");
		check(D = x"a2004209");
		check(E = x"eda6ba53");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"63c77b12");
		check(B = x"78e72611");
		check(C = x"3290c20d");
		check(D = x"598c7ef6");
		check(E = x"a2004209");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"228fc746");
		check(B = x"63c77b12");
		check(C = x"5e39c984");
		check(D = x"3290c20d");
		check(E = x"598c7ef6");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"ad3f0b9a");
		check(B = x"228fc746");
		check(C = x"98f1dec4");
		check(D = x"5e39c984");
		check(E = x"3290c20d");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"8485c202");
		check(B = x"ad3f0b9a");
		check(C = x"88a3f1d1");
		check(D = x"98f1dec4");
		check(E = x"5e39c984");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"06c61000");
		check(B = x"8485c202");
		check(C = x"ab4fc2e6");
		check(D = x"88a3f1d1");
		check(E = x"98f1dec4");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"89585662");
		check(B = x"06c61000");
		check(C = x"a1217080");
		check(D = x"ab4fc2e6");
		check(E = x"88a3f1d1");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"e68ec2fe");
		check(B = x"89585662");
		check(C = x"01b18400");
		check(D = x"a1217080");
		check(E = x"ab4fc2e6");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"8d84ab9e");
		check(B = x"e68ec2fe");
		check(C = x"a2561598");
		check(D = x"01b18400");
		check(E = x"a1217080");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"839a3145");
		check(B = x"8d84ab9e");
		check(C = x"b9a3b0bf");
		check(D = x"a2561598");
		check(E = x"01b18400");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d6c37d3f");
		check(B = x"839a3145");
		check(C = x"a3612ae7");
		check(D = x"b9a3b0bf");
		check(E = x"a2561598");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"de907405");
		check(B = x"d6c37d3f");
		check(C = x"60e68c51");
		check(D = x"a3612ae7");
		check(E = x"b9a3b0bf");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"6b5ac6d9");
		check(B = x"de907405");
		check(C = x"f5b0df4f");
		check(D = x"60e68c51");
		check(E = x"a3612ae7");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"26e22485");
		check(B = x"6b5ac6d9");
		check(C = x"77a41d01");
		check(D = x"f5b0df4f");
		check(E = x"60e68c51");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"f0dbe362");
		check(B = x"26e22485");
		check(C = x"5ad6b1b6");
		check(D = x"77a41d01");
		check(E = x"f5b0df4f");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"e7e695b5");
		check(B = x"f0dbe362");
		check(C = x"49b88921");
		check(D = x"5ad6b1b6");
		check(E = x"77a41d01");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"26706988");
		check(B = x"e7e695b5");
		check(C = x"bc36f8d8");
		check(D = x"49b88921");
		check(E = x"5ad6b1b6");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"05f548dc");
		check(B = x"26706988");
		check(C = x"79f9a56d");
		check(D = x"bc36f8d8");
		check(E = x"49b88921");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"b6839ab4");
		check(B = x"05f548dc");
		check(C = x"099c1a62");
		check(D = x"79f9a56d");
		check(E = x"bc36f8d8");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"d46d8917");
		check(B = x"b6839ab4");
		check(C = x"017d5237");
		check(D = x"099c1a62");
		check(E = x"79f9a56d");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"9167dd1e");
		check(B = x"d46d8917");
		check(C = x"2da0e6ad");
		check(D = x"017d5237");
		check(E = x"099c1a62");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"fcba1c97");
		check(B = x"9167dd1e");
		check(C = x"f51b6245");
		check(D = x"2da0e6ad");
		check(E = x"017d5237");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"bc800102");
		check(B = x"fcba1c97");
		check(C = x"a459f747");
		check(D = x"f51b6245");
		check(E = x"2da0e6ad");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"36f54a6f");
		check(B = x"bc800102");
		check(C = x"ff2e8725");
		check(D = x"a459f747");
		check(E = x"f51b6245");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"8650a161");
		check(B = x"36f54a6f");
		check(C = x"af200040");
		check(D = x"ff2e8725");
		check(E = x"a459f747");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"bfc3b657");
		check(B = x"8650a161");
		check(C = x"cdbd529b");
		check(D = x"af200040");
		check(E = x"ff2e8725");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"a6d607ac");
		check(B = x"bfc3b657");
		check(C = x"61942858");
		check(D = x"cdbd529b");
		check(E = x"af200040");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"744b083e");
		check(B = x"a6d607ac");
		check(C = x"eff0ed95");
		check(D = x"61942858");
		check(E = x"cdbd529b");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"8834d6a0");
		check(B = x"744b083e");
		check(C = x"29b581eb");
		check(D = x"eff0ed95");
		check(E = x"61942858");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"e90cf77f");
		check(B = x"8834d6a0");
		check(C = x"9d12c20f");
		check(D = x"29b581eb");
		check(E = x"eff0ed95");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"761c457b");
		check(H1_out = x"f73b14d2");
		check(H2_out = x"7e9e9265");
		check(H3_out = x"c46f4b4d");
		check(H4_out = x"da11f940");

		test_runner_cleanup(runner);
	end process;

end sha1_test_5_tb_arch;

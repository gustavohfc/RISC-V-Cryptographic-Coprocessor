library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 112 bits message ("message digest")

entity sha1_test_3_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_3_tb;

architecture sha1_test_3_tb_arch OF sha1_test_3_tb IS
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

		-- Write the 112 bits message ("message digest")
		write_data_in <= '1';

		data_in               <= x"6d657373";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"61676520";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"64696765";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"73740000";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(112, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"0d1a0c26");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"6b59b6ee");
		check(B = x"0d1a0c26");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"3ecf0689");
		check(B = x"6b59b6ee");
		check(C = x"83468309");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"378bffaa");
		check(B = x"3ecf0689");
		check(C = x"9ad66dbb");
		check(D = x"83468309");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"419a3d28");
		check(B = x"378bffaa");
		check(C = x"4fb3c1a2");
		check(D = x"9ad66dbb");
		check(E = x"83468309");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"a0e8635d");
		check(B = x"419a3d28");
		check(C = x"8de2ffea");
		check(D = x"4fb3c1a2");
		check(E = x"9ad66dbb");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"220950b2");
		check(B = x"a0e8635d");
		check(C = x"10668f4a");
		check(D = x"8de2ffea");
		check(E = x"4fb3c1a2");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"f8c2f169");
		check(B = x"220950b2");
		check(C = x"683a18d7");
		check(D = x"10668f4a");
		check(E = x"8de2ffea");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"3132469c");
		check(B = x"f8c2f169");
		check(C = x"8882542c");
		check(D = x"683a18d7");
		check(E = x"10668f4a");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"19ec3527");
		check(B = x"3132469c");
		check(C = x"7e30bc5a");
		check(D = x"8882542c");
		check(E = x"683a18d7");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"b8f34b8b");
		check(B = x"19ec3527");
		check(C = x"0c4c91a7");
		check(D = x"7e30bc5a");
		check(E = x"8882542c");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"6fcad8bb");
		check(B = x"b8f34b8b");
		check(C = x"c67b0d49");
		check(D = x"0c4c91a7");
		check(E = x"7e30bc5a");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"568de68d");
		check(B = x"6fcad8bb");
		check(C = x"ee3cd2e2");
		check(D = x"c67b0d49");
		check(E = x"0c4c91a7");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"26c5b2cc");
		check(B = x"568de68d");
		check(C = x"dbf2b62e");
		check(D = x"ee3cd2e2");
		check(E = x"c67b0d49");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"f46496d4");
		check(B = x"26c5b2cc");
		check(C = x"55a379a3");
		check(D = x"dbf2b62e");
		check(E = x"ee3cd2e2");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"b3055c2b");
		check(B = x"f46496d4");
		check(C = x"09b16cb3");
		check(D = x"55a379a3");
		check(E = x"dbf2b62e");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"aadc4b1c");
		check(B = x"b3055c2b");
		check(C = x"3d1925b5");
		check(D = x"09b16cb3");
		check(E = x"55a379a3");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"698845c2");
		check(B = x"aadc4b1c");
		check(C = x"ecc1570a");
		check(D = x"3d1925b5");
		check(E = x"09b16cb3");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"1bd0d46c");
		check(B = x"698845c2");
		check(C = x"2ab712c7");
		check(D = x"ecc1570a");
		check(E = x"3d1925b5");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"81508ff3");
		check(B = x"1bd0d46c");
		check(C = x"9a621170");
		check(D = x"2ab712c7");
		check(E = x"ecc1570a");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"7902ad76");
		check(B = x"81508ff3");
		check(C = x"06f4351b");
		check(D = x"9a621170");
		check(E = x"2ab712c7");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"6952f524");
		check(B = x"7902ad76");
		check(C = x"e05423fc");
		check(D = x"06f4351b");
		check(E = x"9a621170");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"58effde0");
		check(B = x"6952f524");
		check(C = x"9e40ab5d");
		check(D = x"e05423fc");
		check(E = x"06f4351b");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"3bb3842c");
		check(B = x"58effde0");
		check(C = x"1a54bd49");
		check(D = x"9e40ab5d");
		check(E = x"e05423fc");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"aa15ea0b");
		check(B = x"3bb3842c");
		check(C = x"163bff78");
		check(D = x"1a54bd49");
		check(E = x"9e40ab5d");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"cadf7473");
		check(B = x"aa15ea0b");
		check(C = x"0eece10b");
		check(D = x"163bff78");
		check(E = x"1a54bd49");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"487bfb6f");
		check(B = x"cadf7473");
		check(C = x"ea857a82");
		check(D = x"0eece10b");
		check(E = x"163bff78");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"4e90ba53");
		check(B = x"487bfb6f");
		check(C = x"f2b7dd1c");
		check(D = x"ea857a82");
		check(E = x"0eece10b");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"b6f1f6cc");
		check(B = x"4e90ba53");
		check(C = x"d21efedb");
		check(D = x"f2b7dd1c");
		check(E = x"ea857a82");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"e85480af");
		check(B = x"b6f1f6cc");
		check(C = x"d3a42e94");
		check(D = x"d21efedb");
		check(E = x"f2b7dd1c");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"5d4af8d1");
		check(B = x"e85480af");
		check(C = x"2dbc7db3");
		check(D = x"d3a42e94");
		check(E = x"d21efedb");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"45899a5c");
		check(B = x"5d4af8d1");
		check(C = x"fa15202b");
		check(D = x"2dbc7db3");
		check(E = x"d3a42e94");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"be2f5e35");
		check(B = x"45899a5c");
		check(C = x"5752be34");
		check(D = x"fa15202b");
		check(E = x"2dbc7db3");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"8363ad2d");
		check(B = x"be2f5e35");
		check(C = x"11626697");
		check(D = x"5752be34");
		check(E = x"fa15202b");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"b748e638");
		check(B = x"8363ad2d");
		check(C = x"6f8bd78d");
		check(D = x"11626697");
		check(E = x"5752be34");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"7c196a0d");
		check(B = x"b748e638");
		check(C = x"60d8eb4b");
		check(D = x"6f8bd78d");
		check(E = x"11626697");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"81cf0b36");
		check(B = x"7c196a0d");
		check(C = x"2dd2398e");
		check(D = x"60d8eb4b");
		check(E = x"6f8bd78d");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"9e605ca9");
		check(B = x"81cf0b36");
		check(C = x"5f065a83");
		check(D = x"2dd2398e");
		check(E = x"60d8eb4b");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"777da2d4");
		check(B = x"9e605ca9");
		check(C = x"a073c2cd");
		check(D = x"5f065a83");
		check(E = x"2dd2398e");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"8fa789a2");
		check(B = x"777da2d4");
		check(C = x"6798172a");
		check(D = x"a073c2cd");
		check(E = x"5f065a83");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"058be9d3");
		check(B = x"8fa789a2");
		check(C = x"1ddf68b5");
		check(D = x"6798172a");
		check(E = x"a073c2cd");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"2267e7cd");
		check(B = x"058be9d3");
		check(C = x"a3e9e268");
		check(D = x"1ddf68b5");
		check(E = x"6798172a");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"24c605b0");
		check(B = x"2267e7cd");
		check(C = x"c162fa74");
		check(D = x"a3e9e268");
		check(E = x"1ddf68b5");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"6223e114");
		check(B = x"24c605b0");
		check(C = x"4899f9f3");
		check(D = x"c162fa74");
		check(E = x"a3e9e268");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"6a0a4e03");
		check(B = x"6223e114");
		check(C = x"0931816c");
		check(D = x"4899f9f3");
		check(E = x"c162fa74");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"eba300a4");
		check(B = x"6a0a4e03");
		check(C = x"1888f845");
		check(D = x"0931816c");
		check(E = x"4899f9f3");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"83df2f56");
		check(B = x"eba300a4");
		check(C = x"da829380");
		check(D = x"1888f845");
		check(E = x"0931816c");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"ccbc923a");
		check(B = x"83df2f56");
		check(C = x"3ae8c029");
		check(D = x"da829380");
		check(E = x"1888f845");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"d41401d4");
		check(B = x"ccbc923a");
		check(C = x"a0f7cbd5");
		check(D = x"3ae8c029");
		check(E = x"da829380");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"676f8496");
		check(B = x"d41401d4");
		check(C = x"b32f248e");
		check(D = x"a0f7cbd5");
		check(E = x"3ae8c029");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"bdb15d9d");
		check(B = x"676f8496");
		check(C = x"35050075");
		check(D = x"b32f248e");
		check(E = x"a0f7cbd5");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"501a4980");
		check(B = x"bdb15d9d");
		check(C = x"99dbe125");
		check(D = x"35050075");
		check(E = x"b32f248e");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"9e1d40c7");
		check(B = x"501a4980");
		check(C = x"6f6c5767");
		check(D = x"99dbe125");
		check(E = x"35050075");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"4756ba96");
		check(B = x"9e1d40c7");
		check(C = x"14069260");
		check(D = x"6f6c5767");
		check(E = x"99dbe125");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"d03bcf44");
		check(B = x"4756ba96");
		check(C = x"e7875031");
		check(D = x"14069260");
		check(E = x"6f6c5767");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"fc013bc6");
		check(B = x"d03bcf44");
		check(C = x"91d5aea5");
		check(D = x"e7875031");
		check(E = x"14069260");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"f01080ab");
		check(B = x"fc013bc6");
		check(C = x"340ef3d1");
		check(D = x"91d5aea5");
		check(E = x"e7875031");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"35d256d4");
		check(B = x"f01080ab");
		check(C = x"bf004ef1");
		check(D = x"340ef3d1");
		check(E = x"91d5aea5");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"b31f7d27");
		check(B = x"35d256d4");
		check(C = x"fc04202a");
		check(D = x"bf004ef1");
		check(E = x"340ef3d1");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"267769a6");
		check(B = x"b31f7d27");
		check(C = x"0d7495b5");
		check(D = x"fc04202a");
		check(E = x"bf004ef1");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"b6974d3b");
		check(B = x"267769a6");
		check(C = x"ecc7df49");
		check(D = x"0d7495b5");
		check(E = x"fc04202a");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"7613feaf");
		check(B = x"b6974d3b");
		check(C = x"899dda69");
		check(D = x"ecc7df49");
		check(E = x"0d7495b5");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"82012784");
		check(B = x"7613feaf");
		check(C = x"eda5d34e");
		check(D = x"899dda69");
		check(E = x"ecc7df49");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"7c7684a8");
		check(B = x"82012784");
		check(C = x"dd84ffab");
		check(D = x"eda5d34e");
		check(E = x"899dda69");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"157e20db");
		check(B = x"7c7684a8");
		check(C = x"208049e1");
		check(D = x"dd84ffab");
		check(E = x"eda5d34e");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"ddbad08b");
		check(B = x"157e20db");
		check(C = x"1f1da12a");
		check(D = x"208049e1");
		check(E = x"dd84ffab");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"c6f9f07d");
		check(B = x"ddbad08b");
		check(C = x"c55f8836");
		check(D = x"1f1da12a");
		check(E = x"208049e1");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"feb91a27");
		check(B = x"c6f9f07d");
		check(C = x"f76eb422");
		check(D = x"c55f8836");
		check(E = x"1f1da12a");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"8be3d80b");
		check(B = x"feb91a27");
		check(C = x"71be7c1f");
		check(D = x"f76eb422");
		check(E = x"c55f8836");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"4667340c");
		check(B = x"8be3d80b");
		check(C = x"ffae4689");
		check(D = x"71be7c1f");
		check(E = x"f76eb422");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"48c77f79");
		check(B = x"4667340c");
		check(C = x"e2f8f602");
		check(D = x"ffae4689");
		check(E = x"71be7c1f");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"b71b4b83");
		check(B = x"48c77f79");
		check(C = x"1199cd03");
		check(D = x"e2f8f602");
		check(E = x"ffae4689");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"9c219588");
		check(B = x"b71b4b83");
		check(C = x"5231dfde");
		check(D = x"1199cd03");
		check(E = x"e2f8f602");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"3c8dbe19");
		check(B = x"9c219588");
		check(C = x"edc6d2e0");
		check(D = x"5231dfde");
		check(E = x"1199cd03");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"95fdf7a6");
		check(B = x"3c8dbe19");
		check(C = x"27086562");
		check(D = x"edc6d2e0");
		check(E = x"5231dfde");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"650f23cd");
		check(B = x"95fdf7a6");
		check(C = x"4f236f86");
		check(D = x"27086562");
		check(E = x"edc6d2e0");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"e8533a9b");
		check(B = x"650f23cd");
		check(C = x"a57f7de9");
		check(D = x"4f236f86");
		check(E = x"27086562");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"d2930cae");
		check(B = x"e8533a9b");
		check(C = x"5943c8f3");
		check(D = x"a57f7de9");
		check(E = x"4f236f86");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"eabe3d10");
		check(B = x"d2930cae");
		check(C = x"fa14cea6");
		check(D = x"5943c8f3");
		check(E = x"a57f7de9");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"59dd2fcd");
		check(B = x"eabe3d10");
		check(C = x"b4a4c32b");
		check(D = x"fa14cea6");
		check(E = x"5943c8f3");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"c12252ce");
		check(H1_out = x"da8be899");
		check(H2_out = x"4d5fa029");
		check(H3_out = x"0a47231c");
		check(H4_out = x"1d16aae3");

		test_runner_cleanup(runner);
	end process;

end sha1_test_3_tb_arch;

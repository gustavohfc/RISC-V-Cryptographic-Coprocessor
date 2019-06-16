library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

entity unit_sha256_test_5_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha256_test_5_tb;

architecture unit_sha256_test_5_tb_arch OF unit_sha256_test_5_tb IS
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

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"3d4acb91");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"da0a25e6");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"bdf3537c");
		check(B = x"3d4acb91");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"86213c22");
		check(F = x"da0a25e6");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"4315f4e1");
		check(B = x"bdf3537c");
		check(C = x"3d4acb91");
		check(D = x"6a09e667");
		check(E = x"475d163f");
		check(F = x"86213c22");
		check(G = x"da0a25e6");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"9804e83b");
		check(B = x"4315f4e1");
		check(C = x"bdf3537c");
		check(D = x"3d4acb91");
		check(E = x"249e1a16");
		check(F = x"475d163f");
		check(G = x"86213c22");
		check(H = x"da0a25e6");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"8ddf5746");
		check(B = x"9804e83b");
		check(C = x"4315f4e1");
		check(D = x"bdf3537c");
		check(E = x"7d971e15");
		check(F = x"249e1a16");
		check(G = x"475d163f");
		check(H = x"86213c22");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"a652394d");
		check(B = x"8ddf5746");
		check(C = x"9804e83b");
		check(D = x"4315f4e1");
		check(E = x"7710f74a");
		check(F = x"7d971e15");
		check(G = x"249e1a16");
		check(H = x"475d163f");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"68f120fb");
		check(B = x"a652394d");
		check(C = x"8ddf5746");
		check(D = x"9804e83b");
		check(E = x"34941232");
		check(F = x"7710f74a");
		check(G = x"7d971e15");
		check(H = x"249e1a16");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"3b07eb8b");
		check(B = x"68f120fb");
		check(C = x"a652394d");
		check(D = x"8ddf5746");
		check(E = x"0cd4c063");
		check(F = x"34941232");
		check(G = x"7710f74a");
		check(H = x"7d971e15");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"d657995c");
		check(B = x"3b07eb8b");
		check(C = x"68f120fb");
		check(D = x"a652394d");
		check(E = x"acadb8a6");
		check(F = x"0cd4c063");
		check(G = x"34941232");
		check(H = x"7710f74a");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"05be837b");
		check(B = x"d657995c");
		check(C = x"3b07eb8b");
		check(D = x"68f120fb");
		check(E = x"90a2eb3b");
		check(F = x"acadb8a6");
		check(G = x"0cd4c063");
		check(H = x"34941232");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"6541a094");
		check(B = x"05be837b");
		check(C = x"d657995c");
		check(D = x"3b07eb8b");
		check(E = x"9660d4f8");
		check(F = x"90a2eb3b");
		check(G = x"acadb8a6");
		check(H = x"0cd4c063");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"3bed63f5");
		check(B = x"6541a094");
		check(C = x"05be837b");
		check(D = x"d657995c");
		check(E = x"162cba67");
		check(F = x"9660d4f8");
		check(G = x"90a2eb3b");
		check(H = x"acadb8a6");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"ff399d6f");
		check(B = x"3bed63f5");
		check(C = x"6541a094");
		check(D = x"05be837b");
		check(E = x"cac63f5d");
		check(F = x"162cba67");
		check(G = x"9660d4f8");
		check(H = x"90a2eb3b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"c9937c90");
		check(B = x"ff399d6f");
		check(C = x"3bed63f5");
		check(D = x"6541a094");
		check(E = x"5d243cab");
		check(F = x"cac63f5d");
		check(G = x"162cba67");
		check(H = x"9660d4f8");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"f14a808c");
		check(B = x"c9937c90");
		check(C = x"ff399d6f");
		check(D = x"3bed63f5");
		check(E = x"bfc1d292");
		check(F = x"5d243cab");
		check(G = x"cac63f5d");
		check(H = x"162cba67");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"709cd617");
		check(B = x"f14a808c");
		check(C = x"c9937c90");
		check(D = x"ff399d6f");
		check(E = x"a13783ce");
		check(F = x"bfc1d292");
		check(G = x"5d243cab");
		check(H = x"cac63f5d");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"8ac3c05e");
		check(B = x"709cd617");
		check(C = x"f14a808c");
		check(D = x"c9937c90");
		check(E = x"789d9c98");
		check(F = x"a13783ce");
		check(G = x"bfc1d292");
		check(H = x"5d243cab");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"f899aada");
		check(B = x"8ac3c05e");
		check(C = x"709cd617");
		check(D = x"f14a808c");
		check(E = x"221c8b2a");
		check(F = x"789d9c98");
		check(G = x"a13783ce");
		check(H = x"bfc1d292");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"07fe0c17");
		check(B = x"f899aada");
		check(C = x"8ac3c05e");
		check(D = x"709cd617");
		check(E = x"725404ac");
		check(F = x"221c8b2a");
		check(G = x"789d9c98");
		check(H = x"a13783ce");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"5b06419b");
		check(B = x"07fe0c17");
		check(C = x"f899aada");
		check(D = x"8ac3c05e");
		check(E = x"e74fae6a");
		check(F = x"725404ac");
		check(G = x"221c8b2a");
		check(H = x"789d9c98");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"89f7d7c8");
		check(B = x"5b06419b");
		check(C = x"07fe0c17");
		check(D = x"f899aada");
		check(E = x"f6006a53");
		check(F = x"e74fae6a");
		check(G = x"725404ac");
		check(H = x"221c8b2a");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"2872d315");
		check(B = x"89f7d7c8");
		check(C = x"5b06419b");
		check(D = x"07fe0c17");
		check(E = x"d1af9fe9");
		check(F = x"f6006a53");
		check(G = x"e74fae6a");
		check(H = x"725404ac");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"05cc040d");
		check(B = x"2872d315");
		check(C = x"89f7d7c8");
		check(D = x"5b06419b");
		check(E = x"ea599899");
		check(F = x"d1af9fe9");
		check(G = x"f6006a53");
		check(H = x"e74fae6a");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"ff655ee6");
		check(B = x"05cc040d");
		check(C = x"2872d315");
		check(D = x"89f7d7c8");
		check(E = x"ff69ae00");
		check(F = x"ea599899");
		check(G = x"d1af9fe9");
		check(H = x"f6006a53");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d234747b");
		check(B = x"ff655ee6");
		check(C = x"05cc040d");
		check(D = x"2872d315");
		check(E = x"5132bed0");
		check(F = x"ff69ae00");
		check(G = x"ea599899");
		check(H = x"d1af9fe9");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"9a223c30");
		check(B = x"d234747b");
		check(C = x"ff655ee6");
		check(D = x"05cc040d");
		check(E = x"64ae56e1");
		check(F = x"5132bed0");
		check(G = x"ff69ae00");
		check(H = x"ea599899");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"e089fa80");
		check(B = x"9a223c30");
		check(C = x"d234747b");
		check(D = x"ff655ee6");
		check(E = x"bc34e5a6");
		check(F = x"64ae56e1");
		check(G = x"5132bed0");
		check(H = x"ff69ae00");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"9766c6f6");
		check(B = x"e089fa80");
		check(C = x"9a223c30");
		check(D = x"d234747b");
		check(E = x"f8dc303f");
		check(F = x"bc34e5a6");
		check(G = x"64ae56e1");
		check(H = x"5132bed0");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"0ed40109");
		check(B = x"9766c6f6");
		check(C = x"e089fa80");
		check(D = x"9a223c30");
		check(E = x"456ea5fe");
		check(F = x"f8dc303f");
		check(G = x"bc34e5a6");
		check(H = x"64ae56e1");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"d4be779f");
		check(B = x"0ed40109");
		check(C = x"9766c6f6");
		check(D = x"e089fa80");
		check(E = x"cc229e76");
		check(F = x"456ea5fe");
		check(G = x"f8dc303f");
		check(H = x"bc34e5a6");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"0e044be7");
		check(B = x"d4be779f");
		check(C = x"0ed40109");
		check(D = x"9766c6f6");
		check(E = x"a788b782");
		check(F = x"cc229e76");
		check(G = x"456ea5fe");
		check(H = x"f8dc303f");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"4a7760a0");
		check(B = x"0e044be7");
		check(C = x"d4be779f");
		check(D = x"0ed40109");
		check(E = x"45b2e524");
		check(F = x"a788b782");
		check(G = x"cc229e76");
		check(H = x"456ea5fe");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"8ead360e");
		check(B = x"4a7760a0");
		check(C = x"0e044be7");
		check(D = x"d4be779f");
		check(E = x"852dc8b6");
		check(F = x"45b2e524");
		check(G = x"a788b782");
		check(H = x"cc229e76");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"0b04afa9");
		check(B = x"8ead360e");
		check(C = x"4a7760a0");
		check(D = x"0e044be7");
		check(E = x"2a96c1d2");
		check(F = x"852dc8b6");
		check(G = x"45b2e524");
		check(H = x"a788b782");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"e87aa54c");
		check(B = x"0b04afa9");
		check(C = x"8ead360e");
		check(D = x"4a7760a0");
		check(E = x"bf21f2a8");
		check(F = x"2a96c1d2");
		check(G = x"852dc8b6");
		check(H = x"45b2e524");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"6368efb7");
		check(B = x"e87aa54c");
		check(C = x"0b04afa9");
		check(D = x"8ead360e");
		check(E = x"28c6d024");
		check(F = x"bf21f2a8");
		check(G = x"2a96c1d2");
		check(H = x"852dc8b6");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"d5e88ce6");
		check(B = x"6368efb7");
		check(C = x"e87aa54c");
		check(D = x"0b04afa9");
		check(E = x"f24d1620");
		check(F = x"28c6d024");
		check(G = x"bf21f2a8");
		check(H = x"2a96c1d2");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"19927925");
		check(B = x"d5e88ce6");
		check(C = x"6368efb7");
		check(D = x"e87aa54c");
		check(E = x"d2af63be");
		check(F = x"f24d1620");
		check(G = x"28c6d024");
		check(H = x"bf21f2a8");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"6603c125");
		check(B = x"19927925");
		check(C = x"d5e88ce6");
		check(D = x"6368efb7");
		check(E = x"35ecb20e");
		check(F = x"d2af63be");
		check(G = x"f24d1620");
		check(H = x"28c6d024");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"aa904161");
		check(B = x"6603c125");
		check(C = x"19927925");
		check(D = x"d5e88ce6");
		check(E = x"58c71224");
		check(F = x"35ecb20e");
		check(G = x"d2af63be");
		check(H = x"f24d1620");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"df27a816");
		check(B = x"aa904161");
		check(C = x"6603c125");
		check(D = x"19927925");
		check(E = x"69d13167");
		check(F = x"58c71224");
		check(G = x"35ecb20e");
		check(H = x"d2af63be");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"ff2820d2");
		check(B = x"df27a816");
		check(C = x"aa904161");
		check(D = x"6603c125");
		check(E = x"c0d7908e");
		check(F = x"69d13167");
		check(G = x"58c71224");
		check(H = x"35ecb20e");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"c6fb9298");
		check(B = x"ff2820d2");
		check(C = x"df27a816");
		check(D = x"aa904161");
		check(E = x"140078e2");
		check(F = x"c0d7908e");
		check(G = x"69d13167");
		check(H = x"58c71224");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"d0defb17");
		check(B = x"c6fb9298");
		check(C = x"ff2820d2");
		check(D = x"df27a816");
		check(E = x"5110eb85");
		check(F = x"140078e2");
		check(G = x"c0d7908e");
		check(H = x"69d13167");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"3b9b335c");
		check(B = x"d0defb17");
		check(C = x"c6fb9298");
		check(D = x"ff2820d2");
		check(E = x"ec62c16f");
		check(F = x"5110eb85");
		check(G = x"140078e2");
		check(H = x"c0d7908e");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"db951987");
		check(B = x"3b9b335c");
		check(C = x"d0defb17");
		check(D = x"c6fb9298");
		check(E = x"0f17265d");
		check(F = x"ec62c16f");
		check(G = x"5110eb85");
		check(H = x"140078e2");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"ddbe7574");
		check(B = x"db951987");
		check(C = x"3b9b335c");
		check(D = x"d0defb17");
		check(E = x"5a5d474e");
		check(F = x"0f17265d");
		check(G = x"ec62c16f");
		check(H = x"5110eb85");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"726d41e7");
		check(B = x"ddbe7574");
		check(C = x"db951987");
		check(D = x"3b9b335c");
		check(E = x"029067d2");
		check(F = x"5a5d474e");
		check(G = x"0f17265d");
		check(H = x"ec62c16f");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"8ff52b68");
		check(B = x"726d41e7");
		check(C = x"ddbe7574");
		check(D = x"db951987");
		check(E = x"892bae03");
		check(F = x"029067d2");
		check(G = x"5a5d474e");
		check(H = x"0f17265d");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"c49f5451");
		check(B = x"8ff52b68");
		check(C = x"726d41e7");
		check(D = x"ddbe7574");
		check(E = x"14227528");
		check(F = x"892bae03");
		check(G = x"029067d2");
		check(H = x"5a5d474e");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"534243fe");
		check(B = x"c49f5451");
		check(C = x"8ff52b68");
		check(D = x"726d41e7");
		check(E = x"bb0ac115");
		check(F = x"14227528");
		check(G = x"892bae03");
		check(H = x"029067d2");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"c70b68de");
		check(B = x"534243fe");
		check(C = x"c49f5451");
		check(D = x"8ff52b68");
		check(E = x"ef7373ad");
		check(F = x"bb0ac115");
		check(G = x"14227528");
		check(H = x"892bae03");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"a35d227b");
		check(B = x"c70b68de");
		check(C = x"534243fe");
		check(D = x"c49f5451");
		check(E = x"91af7395");
		check(F = x"ef7373ad");
		check(G = x"bb0ac115");
		check(H = x"14227528");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"625bfeb5");
		check(B = x"a35d227b");
		check(C = x"c70b68de");
		check(D = x"534243fe");
		check(E = x"d42c330e");
		check(F = x"91af7395");
		check(G = x"ef7373ad");
		check(H = x"bb0ac115");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"47467d8d");
		check(B = x"625bfeb5");
		check(C = x"a35d227b");
		check(D = x"c70b68de");
		check(E = x"f4661d91");
		check(F = x"d42c330e");
		check(G = x"91af7395");
		check(H = x"ef7373ad");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"10bb30ad");
		check(B = x"47467d8d");
		check(C = x"625bfeb5");
		check(D = x"a35d227b");
		check(E = x"d0198a81");
		check(F = x"f4661d91");
		check(G = x"d42c330e");
		check(H = x"91af7395");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"793cc424");
		check(B = x"10bb30ad");
		check(C = x"47467d8d");
		check(D = x"625bfeb5");
		check(E = x"acb96c42");
		check(F = x"d0198a81");
		check(G = x"f4661d91");
		check(H = x"d42c330e");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"46686699");
		check(B = x"793cc424");
		check(C = x"10bb30ad");
		check(D = x"47467d8d");
		check(E = x"8b098796");
		check(F = x"acb96c42");
		check(G = x"d0198a81");
		check(H = x"f4661d91");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"5b623332");
		check(B = x"46686699");
		check(C = x"793cc424");
		check(D = x"10bb30ad");
		check(E = x"8da5fc16");
		check(F = x"8b098796");
		check(G = x"acb96c42");
		check(H = x"d0198a81");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"d1fa5e36");
		check(B = x"5b623332");
		check(C = x"46686699");
		check(D = x"793cc424");
		check(E = x"ffc68a03");
		check(F = x"8da5fc16");
		check(G = x"8b098796");
		check(H = x"acb96c42");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"ce0de69f");
		check(B = x"d1fa5e36");
		check(C = x"5b623332");
		check(D = x"46686699");
		check(E = x"472f7179");
		check(F = x"ffc68a03");
		check(G = x"8da5fc16");
		check(H = x"8b098796");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"a902d2ea");
		check(B = x"ce0de69f");
		check(C = x"d1fa5e36");
		check(D = x"5b623332");
		check(E = x"23194c5d");
		check(F = x"472f7179");
		check(G = x"ffc68a03");
		check(H = x"8da5fc16");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"17b203b8");
		check(B = x"a902d2ea");
		check(C = x"ce0de69f");
		check(D = x"d1fa5e36");
		check(E = x"73ab0a24");
		check(F = x"23194c5d");
		check(G = x"472f7179");
		check(H = x"ffc68a03");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"5d29b3c1");
		check(B = x"17b203b8");
		check(C = x"a902d2ea");
		check(D = x"ce0de69f");
		check(E = x"cffe721d");
		check(F = x"73ab0a24");
		check(G = x"23194c5d");
		check(H = x"472f7179");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"83a23b9a");
		check(B = x"c7339a28");
		check(C = x"d319b23d");
		check(D = x"e571c65c");
		check(E = x"00ec092d");
		check(F = x"210cc49c");
		check(G = x"0eb072b0");
		check(H = x"429d2608");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"619ecc8b");
		check(B = x"83a23b9a");
		check(C = x"c7339a28");
		check(D = x"d319b23d");
		check(E = x"8f09deb6");
		check(F = x"00ec092d");
		check(G = x"210cc49c");
		check(H = x"0eb072b0");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"f741408d");
		check(B = x"619ecc8b");
		check(C = x"83a23b9a");
		check(D = x"c7339a28");
		check(E = x"3f99c5ee");
		check(F = x"8f09deb6");
		check(G = x"00ec092d");
		check(H = x"210cc49c");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"444bf697");
		check(B = x"f741408d");
		check(C = x"619ecc8b");
		check(D = x"83a23b9a");
		check(E = x"ab3f6a40");
		check(F = x"3f99c5ee");
		check(G = x"8f09deb6");
		check(H = x"00ec092d");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"ee27a209");
		check(B = x"444bf697");
		check(C = x"f741408d");
		check(D = x"619ecc8b");
		check(E = x"c20b9629");
		check(F = x"ab3f6a40");
		check(G = x"3f99c5ee");
		check(H = x"8f09deb6");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"ec2450cc");
		check(B = x"ee27a209");
		check(C = x"444bf697");
		check(D = x"f741408d");
		check(E = x"72307cc3");
		check(F = x"c20b9629");
		check(G = x"ab3f6a40");
		check(H = x"3f99c5ee");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"42d67e06");
		check(B = x"ec2450cc");
		check(C = x"ee27a209");
		check(D = x"444bf697");
		check(E = x"21c28565");
		check(F = x"72307cc3");
		check(G = x"c20b9629");
		check(H = x"ab3f6a40");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"396c6278");
		check(B = x"42d67e06");
		check(C = x"ec2450cc");
		check(D = x"ee27a209");
		check(E = x"561256ca");
		check(F = x"21c28565");
		check(G = x"72307cc3");
		check(H = x"c20b9629");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"c7e700a0");
		check(B = x"396c6278");
		check(C = x"42d67e06");
		check(D = x"ec2450cc");
		check(E = x"a196fd45");
		check(F = x"561256ca");
		check(G = x"21c28565");
		check(H = x"72307cc3");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"e736d64d");
		check(B = x"c7e700a0");
		check(C = x"396c6278");
		check(D = x"42d67e06");
		check(E = x"e67748ea");
		check(F = x"a196fd45");
		check(G = x"561256ca");
		check(H = x"21c28565");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"7bcdce3d");
		check(B = x"e736d64d");
		check(C = x"c7e700a0");
		check(D = x"396c6278");
		check(E = x"c6424e22");
		check(F = x"e67748ea");
		check(G = x"a196fd45");
		check(H = x"561256ca");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"0164bc41");
		check(B = x"7bcdce3d");
		check(C = x"e736d64d");
		check(D = x"c7e700a0");
		check(E = x"3ac9007e");
		check(F = x"c6424e22");
		check(G = x"e67748ea");
		check(H = x"a196fd45");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"027ce414");
		check(B = x"0164bc41");
		check(C = x"7bcdce3d");
		check(D = x"e736d64d");
		check(E = x"365ee637");
		check(F = x"3ac9007e");
		check(G = x"c6424e22");
		check(H = x"e67748ea");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"660715fd");
		check(B = x"027ce414");
		check(C = x"0164bc41");
		check(D = x"7bcdce3d");
		check(E = x"7621854a");
		check(F = x"365ee637");
		check(G = x"3ac9007e");
		check(H = x"c6424e22");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"1ddd7551");
		check(B = x"660715fd");
		check(C = x"027ce414");
		check(D = x"0164bc41");
		check(E = x"ad098e5a");
		check(F = x"7621854a");
		check(G = x"365ee637");
		check(H = x"3ac9007e");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"f66befcc");
		check(B = x"1ddd7551");
		check(C = x"660715fd");
		check(D = x"027ce414");
		check(E = x"59483ef0");
		check(F = x"ad098e5a");
		check(G = x"7621854a");
		check(H = x"365ee637");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"68274274");
		check(B = x"f66befcc");
		check(C = x"1ddd7551");
		check(D = x"660715fd");
		check(E = x"08123536");
		check(F = x"59483ef0");
		check(G = x"ad098e5a");
		check(H = x"7621854a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"9cbe0439");
		check(B = x"68274274");
		check(C = x"f66befcc");
		check(D = x"1ddd7551");
		check(E = x"f1b272db");
		check(F = x"08123536");
		check(G = x"59483ef0");
		check(H = x"ad098e5a");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"6dc9c3d7");
		check(B = x"9cbe0439");
		check(C = x"68274274");
		check(D = x"f66befcc");
		check(E = x"d0847020");
		check(F = x"f1b272db");
		check(G = x"08123536");
		check(H = x"59483ef0");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"2abd1e74");
		check(B = x"6dc9c3d7");
		check(C = x"9cbe0439");
		check(D = x"68274274");
		check(E = x"d1b388bf");
		check(F = x"d0847020");
		check(G = x"f1b272db");
		check(H = x"08123536");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"92294514");
		check(B = x"2abd1e74");
		check(C = x"6dc9c3d7");
		check(D = x"9cbe0439");
		check(E = x"c01bbe34");
		check(F = x"d1b388bf");
		check(G = x"d0847020");
		check(H = x"f1b272db");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"17dca94f");
		check(B = x"92294514");
		check(C = x"2abd1e74");
		check(D = x"6dc9c3d7");
		check(E = x"e0b6d3ed");
		check(F = x"c01bbe34");
		check(G = x"d1b388bf");
		check(H = x"d0847020");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"9f87a7c4");
		check(B = x"17dca94f");
		check(C = x"92294514");
		check(D = x"2abd1e74");
		check(E = x"fd69b55e");
		check(F = x"e0b6d3ed");
		check(G = x"c01bbe34");
		check(H = x"d1b388bf");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"4bb82e99");
		check(B = x"9f87a7c4");
		check(C = x"17dca94f");
		check(D = x"92294514");
		check(E = x"d78da017");
		check(F = x"fd69b55e");
		check(G = x"e0b6d3ed");
		check(H = x"c01bbe34");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d0d1b379");
		check(B = x"4bb82e99");
		check(C = x"9f87a7c4");
		check(D = x"17dca94f");
		check(E = x"7cc01577");
		check(F = x"d78da017");
		check(G = x"fd69b55e");
		check(H = x"e0b6d3ed");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"14787fb7");
		check(B = x"d0d1b379");
		check(C = x"4bb82e99");
		check(D = x"9f87a7c4");
		check(E = x"a78c741d");
		check(F = x"7cc01577");
		check(G = x"d78da017");
		check(H = x"fd69b55e");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"bf5075f4");
		check(B = x"14787fb7");
		check(C = x"d0d1b379");
		check(D = x"4bb82e99");
		check(E = x"34877d80");
		check(F = x"a78c741d");
		check(G = x"7cc01577");
		check(H = x"d78da017");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"a8c89b68");
		check(B = x"bf5075f4");
		check(C = x"14787fb7");
		check(D = x"d0d1b379");
		check(E = x"9e8a1d09");
		check(F = x"34877d80");
		check(G = x"a78c741d");
		check(H = x"7cc01577");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"422b5ed8");
		check(B = x"a8c89b68");
		check(C = x"bf5075f4");
		check(D = x"14787fb7");
		check(E = x"8389d020");
		check(F = x"9e8a1d09");
		check(G = x"34877d80");
		check(H = x"a78c741d");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f36e5c95");
		check(B = x"422b5ed8");
		check(C = x"a8c89b68");
		check(D = x"bf5075f4");
		check(E = x"126ad470");
		check(F = x"8389d020");
		check(G = x"9e8a1d09");
		check(H = x"34877d80");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"87ecca78");
		check(B = x"f36e5c95");
		check(C = x"422b5ed8");
		check(D = x"a8c89b68");
		check(E = x"43cc85fa");
		check(F = x"126ad470");
		check(G = x"8389d020");
		check(H = x"9e8a1d09");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"47b3ff3e");
		check(B = x"87ecca78");
		check(C = x"f36e5c95");
		check(D = x"422b5ed8");
		check(E = x"6bf74be7");
		check(F = x"43cc85fa");
		check(G = x"126ad470");
		check(H = x"8389d020");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"7af21abf");
		check(B = x"47b3ff3e");
		check(C = x"87ecca78");
		check(D = x"f36e5c95");
		check(E = x"4d4c600d");
		check(F = x"6bf74be7");
		check(G = x"43cc85fa");
		check(H = x"126ad470");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"ff72d574");
		check(B = x"7af21abf");
		check(C = x"47b3ff3e");
		check(D = x"87ecca78");
		check(E = x"e7c0aaf7");
		check(F = x"4d4c600d");
		check(G = x"6bf74be7");
		check(H = x"43cc85fa");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"06b023d3");
		check(B = x"ff72d574");
		check(C = x"7af21abf");
		check(D = x"47b3ff3e");
		check(E = x"af7b71d7");
		check(F = x"e7c0aaf7");
		check(G = x"4d4c600d");
		check(H = x"6bf74be7");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"7b16a1a4");
		check(B = x"06b023d3");
		check(C = x"ff72d574");
		check(D = x"7af21abf");
		check(E = x"241d1b7c");
		check(F = x"af7b71d7");
		check(G = x"e7c0aaf7");
		check(H = x"4d4c600d");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"4c08c65a");
		check(B = x"7b16a1a4");
		check(C = x"06b023d3");
		check(D = x"ff72d574");
		check(E = x"fe675df5");
		check(F = x"241d1b7c");
		check(G = x"af7b71d7");
		check(H = x"e7c0aaf7");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"b970cc3c");
		check(B = x"4c08c65a");
		check(C = x"7b16a1a4");
		check(D = x"06b023d3");
		check(E = x"e809c4fe");
		check(F = x"fe675df5");
		check(G = x"241d1b7c");
		check(H = x"af7b71d7");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"44177186");
		check(B = x"b970cc3c");
		check(C = x"4c08c65a");
		check(D = x"7b16a1a4");
		check(E = x"452dc6b1");
		check(F = x"e809c4fe");
		check(G = x"fe675df5");
		check(H = x"241d1b7c");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"b4ff2056");
		check(B = x"44177186");
		check(C = x"b970cc3c");
		check(D = x"4c08c65a");
		check(E = x"a3131812");
		check(F = x"452dc6b1");
		check(G = x"e809c4fe");
		check(H = x"fe675df5");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"8d7a3c25");
		check(B = x"b4ff2056");
		check(C = x"44177186");
		check(D = x"b970cc3c");
		check(E = x"d2006d2a");
		check(F = x"a3131812");
		check(G = x"452dc6b1");
		check(H = x"e809c4fe");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"283384bf");
		check(B = x"8d7a3c25");
		check(C = x"b4ff2056");
		check(D = x"44177186");
		check(E = x"f2a2ae08");
		check(F = x"d2006d2a");
		check(G = x"a3131812");
		check(H = x"452dc6b1");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"a8ba9233");
		check(B = x"283384bf");
		check(C = x"8d7a3c25");
		check(D = x"b4ff2056");
		check(E = x"1e6f836f");
		check(F = x"f2a2ae08");
		check(G = x"d2006d2a");
		check(H = x"a3131812");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"be17d0ed");
		check(B = x"a8ba9233");
		check(C = x"283384bf");
		check(D = x"8d7a3c25");
		check(E = x"38e12d12");
		check(F = x"1e6f836f");
		check(G = x"f2a2ae08");
		check(H = x"d2006d2a");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"3285eb37");
		check(B = x"be17d0ed");
		check(C = x"a8ba9233");
		check(D = x"283384bf");
		check(E = x"6020e420");
		check(F = x"38e12d12");
		check(G = x"1e6f836f");
		check(H = x"f2a2ae08");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"f69cb475");
		check(B = x"3285eb37");
		check(C = x"be17d0ed");
		check(D = x"a8ba9233");
		check(E = x"e18434d5");
		check(F = x"6020e420");
		check(G = x"38e12d12");
		check(H = x"1e6f836f");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"b6f1bebb");
		check(B = x"f69cb475");
		check(C = x"3285eb37");
		check(D = x"be17d0ed");
		check(E = x"fc3d1257");
		check(F = x"e18434d5");
		check(G = x"6020e420");
		check(H = x"38e12d12");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"56466656");
		check(B = x"b6f1bebb");
		check(C = x"f69cb475");
		check(D = x"3285eb37");
		check(E = x"7f2d4214");
		check(F = x"fc3d1257");
		check(G = x"e18434d5");
		check(H = x"6020e420");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"18df20ca");
		check(B = x"56466656");
		check(C = x"b6f1bebb");
		check(D = x"f69cb475");
		check(E = x"95d5e28b");
		check(F = x"7f2d4214");
		check(G = x"fc3d1257");
		check(H = x"e18434d5");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"f0e20b68");
		check(B = x"18df20ca");
		check(C = x"56466656");
		check(D = x"b6f1bebb");
		check(E = x"d3c3725b");
		check(F = x"95d5e28b");
		check(G = x"7f2d4214");
		check(H = x"fc3d1257");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"533ed537");
		check(B = x"f0e20b68");
		check(C = x"18df20ca");
		check(D = x"56466656");
		check(E = x"ca17cb9f");
		check(F = x"d3c3725b");
		check(G = x"95d5e28b");
		check(H = x"7f2d4214");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"c8a49136");
		check(B = x"533ed537");
		check(C = x"f0e20b68");
		check(D = x"18df20ca");
		check(E = x"47cb042b");
		check(F = x"ca17cb9f");
		check(G = x"d3c3725b");
		check(H = x"95d5e28b");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"049d95c2");
		check(B = x"c8a49136");
		check(C = x"533ed537");
		check(D = x"f0e20b68");
		check(E = x"a2fa6b0b");
		check(F = x"47cb042b");
		check(G = x"ca17cb9f");
		check(H = x"d3c3725b");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"b48e3387");
		check(B = x"049d95c2");
		check(C = x"c8a49136");
		check(D = x"533ed537");
		check(E = x"0b53602b");
		check(F = x"a2fa6b0b");
		check(G = x"47cb042b");
		check(H = x"ca17cb9f");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"0c1c9555");
		check(B = x"b48e3387");
		check(C = x"049d95c2");
		check(D = x"c8a49136");
		check(E = x"90fea2c4");
		check(F = x"0b53602b");
		check(G = x"a2fa6b0b");
		check(H = x"47cb042b");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"11624b6c");
		check(B = x"0c1c9555");
		check(C = x"b48e3387");
		check(D = x"049d95c2");
		check(E = x"3970355a");
		check(F = x"90fea2c4");
		check(G = x"0b53602b");
		check(H = x"a2fa6b0b");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"90d19c77");
		check(B = x"11624b6c");
		check(C = x"0c1c9555");
		check(D = x"b48e3387");
		check(E = x"ab4b7568");
		check(F = x"3970355a");
		check(G = x"90fea2c4");
		check(H = x"0b53602b");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"098825b1");
		check(B = x"90d19c77");
		check(C = x"11624b6c");
		check(D = x"0c1c9555");
		check(E = x"6bcc7bf1");
		check(F = x"ab4b7568");
		check(G = x"3970355a");
		check(H = x"90fea2c4");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"d543e3a8");
		check(B = x"098825b1");
		check(C = x"90d19c77");
		check(D = x"11624b6c");
		check(E = x"8023ea7d");
		check(F = x"6bcc7bf1");
		check(G = x"ab4b7568");
		check(H = x"3970355a");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"60817af9");
		check(B = x"d543e3a8");
		check(C = x"098825b1");
		check(D = x"90d19c77");
		check(E = x"b8892f14");
		check(F = x"8023ea7d");
		check(G = x"6bcc7bf1");
		check(H = x"ab4b7568");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"609dfca7");
		check(B = x"60817af9");
		check(C = x"d543e3a8");
		check(D = x"098825b1");
		check(E = x"25ed762e");
		check(F = x"b8892f14");
		check(G = x"8023ea7d");
		check(H = x"6bcc7bf1");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"c09a75db");
		check(B = x"609dfca7");
		check(C = x"60817af9");
		check(D = x"d543e3a8");
		check(E = x"1eb1ba9f");
		check(F = x"25ed762e");
		check(G = x"b8892f14");
		check(H = x"8023ea7d");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"7a871b48");
		check(B = x"c09a75db");
		check(C = x"609dfca7");
		check(D = x"60817af9");
		check(E = x"b8018b4e");
		check(F = x"1eb1ba9f");
		check(G = x"25ed762e");
		check(H = x"b8892f14");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"14186295");
		check(B = x"7a871b48");
		check(C = x"c09a75db");
		check(D = x"609dfca7");
		check(E = x"3b6b2cc3");
		check(F = x"b8018b4e");
		check(G = x"1eb1ba9f");
		check(H = x"25ed762e");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"db4bfcbd");
		check(H1_out = x"4da0cd85");
		check(H2_out = x"a60c3c37");
		check(H3_out = x"d3fbd880");
		check(H4_out = x"5c77f15f");
		check(H5_out = x"c6b1fdfe");
		check(H6_out = x"614ee0a7");
		check(H7_out = x"c8fdb4c0");

		test_runner_cleanup(runner);
	end process;

end unit_sha256_test_5_tb_arch;

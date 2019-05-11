library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

entity sha512_test_5_tb IS
	generic(
		runner_cfg : string
	);
end sha512_test_5_tb;

architecture sha512_test_5_tb_arch OF sha512_test_5_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(4 downto 0)  := (others => '0');
	signal calculate_next_block  : std_logic             := '0';
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(10 downto 0) := (others => '0');
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : sha512_error_type;
	signal H0_out                : unsigned(63 downto 0) := (others => '0');
	signal H1_out                : unsigned(63 downto 0) := (others => '0');
	signal H2_out                : unsigned(63 downto 0) := (others => '0');
	signal H3_out                : unsigned(63 downto 0) := (others => '0');
	signal H4_out                : unsigned(63 downto 0) := (others => '0');
	signal H5_out                : unsigned(63 downto 0) := (others => '0');
	signal H6_out                : unsigned(63 downto 0) := (others => '0');
	signal H7_out                : unsigned(63 downto 0) := (others => '0');

begin
	sha512 : entity work.sha512
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
		alias A is <<signal sha512.A : unsigned(63 downto 0)>>;
		alias B is <<signal sha512.B : unsigned(63 downto 0)>>;
		alias C is <<signal sha512.C : unsigned(63 downto 0)>>;
		alias D is <<signal sha512.D : unsigned(63 downto 0)>>;
		alias E is <<signal sha512.E : unsigned(63 downto 0)>>;
		alias F is <<signal sha512.F : unsigned(63 downto 0)>>;
		alias G is <<signal sha512.G : unsigned(63 downto 0)>>;
		alias H is <<signal sha512.H : unsigned(63 downto 0)>>;
	begin
		test_runner_setup(runner, runner_cfg);

		-- Start new hash
		start_new_hash <= '1';
		wait until rising_edge(clk);
		start_new_hash <= '0';

		-- Write the 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
		write_data_in <= '1';

		data_in               <= x"41424344";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		data_in               <= x"45464748";
		data_in_word_position <= to_unsigned(1, 5);
		wait until rising_edge(clk);

		data_in               <= x"494a4b4c";
		data_in_word_position <= to_unsigned(2, 5);
		wait until rising_edge(clk);

		data_in               <= x"4d4e4f50";
		data_in_word_position <= to_unsigned(3, 5);
		wait until rising_edge(clk);

		data_in               <= x"51525354";
		data_in_word_position <= to_unsigned(4, 5);
		wait until rising_edge(clk);

		data_in               <= x"55565758";
		data_in_word_position <= to_unsigned(5, 5);
		wait until rising_edge(clk);

		data_in               <= x"595a6162";
		data_in_word_position <= to_unsigned(6, 5);
		wait until rising_edge(clk);

		data_in               <= x"63646566";
		data_in_word_position <= to_unsigned(7, 5);
		wait until rising_edge(clk);

		data_in               <= x"6768696a";
		data_in_word_position <= to_unsigned(8, 5);
		wait until rising_edge(clk);

		data_in               <= x"6b6c6d6e";
		data_in_word_position <= to_unsigned(9, 5);
		wait until rising_edge(clk);

		data_in               <= x"6f707172";
		data_in_word_position <= to_unsigned(10, 5);
		wait until rising_edge(clk);

		data_in               <= x"73747576";
		data_in_word_position <= to_unsigned(11, 5);
		wait until rising_edge(clk);

		data_in               <= x"7778797a";
		data_in_word_position <= to_unsigned(12, 5);
		wait until rising_edge(clk);

		data_in               <= x"30313233";
		data_in_word_position <= to_unsigned(13, 5);
		wait until rising_edge(clk);

		data_in               <= x"34353637";
		data_in_word_position <= to_unsigned(14, 5);
		wait until rising_edge(clk);

		data_in               <= x"38390000";
		data_in_word_position <= to_unsigned(15, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(496, 11);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"d68fae7d0243253d");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"38aae1f8bffb66d9");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"c457ce765724bb0e");
		check(B = x"d68fae7d0243253d");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"6810f6ab6bfafaed");
		check(F = x"38aae1f8bffb66d9");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"ad1f65b8eb9a435d");
		check(B = x"c457ce765724bb0e");
		check(C = x"d68fae7d0243253d");
		check(D = x"6a09e667f3bcc908");
		check(E = x"974a4e6d335e8628");
		check(F = x"6810f6ab6bfafaed");
		check(G = x"38aae1f8bffb66d9");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"326cf014622aabe");
		check(B = x"ad1f65b8eb9a435d");
		check(C = x"c457ce765724bb0e");
		check(D = x"d68fae7d0243253d");
		check(E = x"b67b3561f4f1947e");
		check(F = x"974a4e6d335e8628");
		check(G = x"6810f6ab6bfafaed");
		check(H = x"38aae1f8bffb66d9");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"f219f4ad9755c4f0");
		check(B = x"326cf014622aabe");
		check(C = x"ad1f65b8eb9a435d");
		check(D = x"c457ce765724bb0e");
		check(E = x"12638fdf83d330c5");
		check(F = x"b67b3561f4f1947e");
		check(G = x"974a4e6d335e8628");
		check(H = x"6810f6ab6bfafaed");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"988a1f64c8637c7e");
		check(B = x"f219f4ad9755c4f0");
		check(C = x"326cf014622aabe");
		check(D = x"ad1f65b8eb9a435d");
		check(E = x"6e1a72765b787075");
		check(F = x"12638fdf83d330c5");
		check(G = x"b67b3561f4f1947e");
		check(H = x"974a4e6d335e8628");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"2a156eefc48504f4");
		check(B = x"988a1f64c8637c7e");
		check(C = x"f219f4ad9755c4f0");
		check(D = x"326cf014622aabe");
		check(E = x"c76a17741608f5a8");
		check(F = x"6e1a72765b787075");
		check(G = x"12638fdf83d330c5");
		check(H = x"b67b3561f4f1947e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"5eac10daafafd333");
		check(B = x"2a156eefc48504f4");
		check(C = x"988a1f64c8637c7e");
		check(D = x"f219f4ad9755c4f0");
		check(E = x"40c15c77ee059963");
		check(F = x"c76a17741608f5a8");
		check(G = x"6e1a72765b787075");
		check(H = x"12638fdf83d330c5");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"8fbdfa33fe2feda7");
		check(B = x"5eac10daafafd333");
		check(C = x"2a156eefc48504f4");
		check(D = x"988a1f64c8637c7e");
		check(E = x"830237936d070c64");
		check(F = x"40c15c77ee059963");
		check(G = x"c76a17741608f5a8");
		check(H = x"6e1a72765b787075");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"898a8b03c6bf345f");
		check(B = x"8fbdfa33fe2feda7");
		check(C = x"5eac10daafafd333");
		check(D = x"2a156eefc48504f4");
		check(E = x"98cdb0a2494344df");
		check(F = x"830237936d070c64");
		check(G = x"40c15c77ee059963");
		check(H = x"c76a17741608f5a8");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"6c87cf4dc9ec143e");
		check(B = x"898a8b03c6bf345f");
		check(C = x"8fbdfa33fe2feda7");
		check(D = x"5eac10daafafd333");
		check(E = x"691eada1d9e81c11");
		check(F = x"98cdb0a2494344df");
		check(G = x"830237936d070c64");
		check(H = x"40c15c77ee059963");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"cc4100e644db2e16");
		check(B = x"6c87cf4dc9ec143e");
		check(C = x"898a8b03c6bf345f");
		check(D = x"8fbdfa33fe2feda7");
		check(E = x"2633a7fbf657c479");
		check(F = x"691eada1d9e81c11");
		check(G = x"98cdb0a2494344df");
		check(H = x"830237936d070c64");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"a8326d47a2dcd7fd");
		check(B = x"cc4100e644db2e16");
		check(C = x"6c87cf4dc9ec143e");
		check(D = x"898a8b03c6bf345f");
		check(E = x"5b5f3f7e8174c52a");
		check(F = x"2633a7fbf657c479");
		check(G = x"691eada1d9e81c11");
		check(H = x"98cdb0a2494344df");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"ca68d37d7950409");
		check(B = x"a8326d47a2dcd7fd");
		check(C = x"cc4100e644db2e16");
		check(D = x"6c87cf4dc9ec143e");
		check(E = x"5fedd769cafdf639");
		check(F = x"5b5f3f7e8174c52a");
		check(G = x"2633a7fbf657c479");
		check(H = x"691eada1d9e81c11");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"1247bfd4b2de598");
		check(B = x"ca68d37d7950409");
		check(C = x"a8326d47a2dcd7fd");
		check(D = x"cc4100e644db2e16");
		check(E = x"fe701248b2e4b68f");
		check(F = x"5fedd769cafdf639");
		check(G = x"5b5f3f7e8174c52a");
		check(H = x"2633a7fbf657c479");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"3dae359b39b072bd");
		check(B = x"1247bfd4b2de598");
		check(C = x"ca68d37d7950409");
		check(D = x"a8326d47a2dcd7fd");
		check(E = x"e7454ddc98e0f15e");
		check(F = x"fe701248b2e4b68f");
		check(G = x"5fedd769cafdf639");
		check(H = x"5b5f3f7e8174c52a");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"7cc36480423ad760");
		check(B = x"3dae359b39b072bd");
		check(C = x"1247bfd4b2de598");
		check(D = x"ca68d37d7950409");
		check(E = x"b4373c6e996ec206");
		check(F = x"e7454ddc98e0f15e");
		check(G = x"fe701248b2e4b68f");
		check(H = x"5fedd769cafdf639");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"f8fa4ea37f0528fa");
		check(B = x"7cc36480423ad760");
		check(C = x"3dae359b39b072bd");
		check(D = x"1247bfd4b2de598");
		check(E = x"9452afd0f7621d5e");
		check(F = x"b4373c6e996ec206");
		check(G = x"e7454ddc98e0f15e");
		check(H = x"fe701248b2e4b68f");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"ecd78b9a5b1b66c7");
		check(B = x"f8fa4ea37f0528fa");
		check(C = x"7cc36480423ad760");
		check(D = x"3dae359b39b072bd");
		check(E = x"7a3d35366ad4c65");
		check(F = x"9452afd0f7621d5e");
		check(G = x"b4373c6e996ec206");
		check(H = x"e7454ddc98e0f15e");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"fdb3b6d566ed7b6d");
		check(B = x"ecd78b9a5b1b66c7");
		check(C = x"f8fa4ea37f0528fa");
		check(D = x"7cc36480423ad760");
		check(E = x"2ac81aeb8bed92f4");
		check(F = x"7a3d35366ad4c65");
		check(G = x"9452afd0f7621d5e");
		check(H = x"b4373c6e996ec206");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"a9ad98e8fb60f0ff");
		check(B = x"fdb3b6d566ed7b6d");
		check(C = x"ecd78b9a5b1b66c7");
		check(D = x"f8fa4ea37f0528fa");
		check(E = x"8bdc3be33ee175e2");
		check(F = x"2ac81aeb8bed92f4");
		check(G = x"7a3d35366ad4c65");
		check(H = x"9452afd0f7621d5e");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"3c7834c52f2b1b7");
		check(B = x"a9ad98e8fb60f0ff");
		check(C = x"fdb3b6d566ed7b6d");
		check(D = x"ecd78b9a5b1b66c7");
		check(E = x"b5e844f2c6acb43e");
		check(F = x"8bdc3be33ee175e2");
		check(G = x"2ac81aeb8bed92f4");
		check(H = x"7a3d35366ad4c65");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"acbb145e5d5d8fd7");
		check(B = x"3c7834c52f2b1b7");
		check(C = x"a9ad98e8fb60f0ff");
		check(D = x"fdb3b6d566ed7b6d");
		check(E = x"4cb8baadb309a98f");
		check(F = x"b5e844f2c6acb43e");
		check(G = x"8bdc3be33ee175e2");
		check(H = x"2ac81aeb8bed92f4");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"c3f3ea581d9d79c6");
		check(B = x"acbb145e5d5d8fd7");
		check(C = x"3c7834c52f2b1b7");
		check(D = x"a9ad98e8fb60f0ff");
		check(E = x"19c2eb5099534c62");
		check(F = x"4cb8baadb309a98f");
		check(G = x"b5e844f2c6acb43e");
		check(H = x"8bdc3be33ee175e2");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"1e53e220d22b55a5");
		check(B = x"c3f3ea581d9d79c6");
		check(C = x"acbb145e5d5d8fd7");
		check(D = x"3c7834c52f2b1b7");
		check(E = x"d581ffbf6d68d40a");
		check(F = x"19c2eb5099534c62");
		check(G = x"4cb8baadb309a98f");
		check(H = x"b5e844f2c6acb43e");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"808c8e9d0a77ab35");
		check(B = x"1e53e220d22b55a5");
		check(C = x"c3f3ea581d9d79c6");
		check(D = x"acbb145e5d5d8fd7");
		check(E = x"9dc455fd17b681e4");
		check(F = x"d581ffbf6d68d40a");
		check(G = x"19c2eb5099534c62");
		check(H = x"4cb8baadb309a98f");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"18938b248e6d91d8");
		check(B = x"808c8e9d0a77ab35");
		check(C = x"1e53e220d22b55a5");
		check(D = x"c3f3ea581d9d79c6");
		check(E = x"6286fea7cda0d4a0");
		check(F = x"9dc455fd17b681e4");
		check(G = x"d581ffbf6d68d40a");
		check(H = x"19c2eb5099534c62");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"a7a0dfe4f84e16e8");
		check(B = x"18938b248e6d91d8");
		check(C = x"808c8e9d0a77ab35");
		check(D = x"1e53e220d22b55a5");
		check(E = x"c6a29d444c4e8762");
		check(F = x"6286fea7cda0d4a0");
		check(G = x"9dc455fd17b681e4");
		check(H = x"d581ffbf6d68d40a");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"e2bf34486e326f2d");
		check(B = x"a7a0dfe4f84e16e8");
		check(C = x"18938b248e6d91d8");
		check(D = x"808c8e9d0a77ab35");
		check(E = x"d900fa73343a8d1");
		check(F = x"c6a29d444c4e8762");
		check(G = x"6286fea7cda0d4a0");
		check(H = x"9dc455fd17b681e4");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"9525585f3f80ac99");
		check(B = x"e2bf34486e326f2d");
		check(C = x"a7a0dfe4f84e16e8");
		check(D = x"18938b248e6d91d8");
		check(E = x"a8839cc52f047ea");
		check(F = x"d900fa73343a8d1");
		check(G = x"c6a29d444c4e8762");
		check(H = x"6286fea7cda0d4a0");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"30ea3262f882a461");
		check(B = x"9525585f3f80ac99");
		check(C = x"e2bf34486e326f2d");
		check(D = x"a7a0dfe4f84e16e8");
		check(E = x"18427d5504b76e3c");
		check(F = x"a8839cc52f047ea");
		check(G = x"d900fa73343a8d1");
		check(H = x"c6a29d444c4e8762");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"3385aee17ca45e1f");
		check(B = x"30ea3262f882a461");
		check(C = x"9525585f3f80ac99");
		check(D = x"e2bf34486e326f2d");
		check(E = x"367b743875774a0b");
		check(F = x"18427d5504b76e3c");
		check(G = x"a8839cc52f047ea");
		check(H = x"d900fa73343a8d1");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"43bca5836eba2915");
		check(B = x"3385aee17ca45e1f");
		check(C = x"30ea3262f882a461");
		check(D = x"9525585f3f80ac99");
		check(E = x"9d40e09f958f5d37");
		check(F = x"367b743875774a0b");
		check(G = x"18427d5504b76e3c");
		check(H = x"a8839cc52f047ea");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"5d1d7d4b782ce271");
		check(B = x"43bca5836eba2915");
		check(C = x"3385aee17ca45e1f");
		check(D = x"30ea3262f882a461");
		check(E = x"87c4bf83f9695ad8");
		check(F = x"9d40e09f958f5d37");
		check(G = x"367b743875774a0b");
		check(H = x"18427d5504b76e3c");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"7932d3f8364a490b");
		check(B = x"5d1d7d4b782ce271");
		check(C = x"43bca5836eba2915");
		check(D = x"3385aee17ca45e1f");
		check(E = x"8c4a124a4df5d238");
		check(F = x"87c4bf83f9695ad8");
		check(G = x"9d40e09f958f5d37");
		check(H = x"367b743875774a0b");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"d494d7ad13963e36");
		check(B = x"7932d3f8364a490b");
		check(C = x"5d1d7d4b782ce271");
		check(D = x"43bca5836eba2915");
		check(E = x"1582fa5bb67c446a");
		check(F = x"8c4a124a4df5d238");
		check(G = x"87c4bf83f9695ad8");
		check(H = x"9d40e09f958f5d37");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"4dc9fc375b50f4bd");
		check(B = x"d494d7ad13963e36");
		check(C = x"7932d3f8364a490b");
		check(D = x"5d1d7d4b782ce271");
		check(E = x"cd08935063b4d0a");
		check(F = x"1582fa5bb67c446a");
		check(G = x"8c4a124a4df5d238");
		check(H = x"87c4bf83f9695ad8");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"b7129914b02dde56");
		check(B = x"4dc9fc375b50f4bd");
		check(C = x"d494d7ad13963e36");
		check(D = x"7932d3f8364a490b");
		check(E = x"a93167901f921508");
		check(F = x"cd08935063b4d0a");
		check(G = x"1582fa5bb67c446a");
		check(H = x"8c4a124a4df5d238");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"52063208aa8da71d");
		check(B = x"b7129914b02dde56");
		check(C = x"4dc9fc375b50f4bd");
		check(D = x"d494d7ad13963e36");
		check(E = x"edf15f895c3fdfb6");
		check(F = x"a93167901f921508");
		check(G = x"cd08935063b4d0a");
		check(H = x"1582fa5bb67c446a");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"bbf32ccbeab14c7b");
		check(B = x"52063208aa8da71d");
		check(C = x"b7129914b02dde56");
		check(D = x"4dc9fc375b50f4bd");
		check(E = x"a6594907f5f2f428");
		check(F = x"edf15f895c3fdfb6");
		check(G = x"a93167901f921508");
		check(H = x"cd08935063b4d0a");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"c833921cc13a9463");
		check(B = x"bbf32ccbeab14c7b");
		check(C = x"52063208aa8da71d");
		check(D = x"b7129914b02dde56");
		check(E = x"9c7d600dcb23d8ec");
		check(F = x"a6594907f5f2f428");
		check(G = x"edf15f895c3fdfb6");
		check(H = x"a93167901f921508");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"f365bee0e807ce21");
		check(B = x"c833921cc13a9463");
		check(C = x"bbf32ccbeab14c7b");
		check(D = x"52063208aa8da71d");
		check(E = x"b5df8fdff6d6858d");
		check(F = x"9c7d600dcb23d8ec");
		check(G = x"a6594907f5f2f428");
		check(H = x"edf15f895c3fdfb6");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"8f77d1d3752ad053");
		check(B = x"f365bee0e807ce21");
		check(C = x"c833921cc13a9463");
		check(D = x"bbf32ccbeab14c7b");
		check(E = x"6a5d27082e206042");
		check(F = x"b5df8fdff6d6858d");
		check(G = x"9c7d600dcb23d8ec");
		check(H = x"a6594907f5f2f428");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"230b8b0845fa2e6e");
		check(B = x"8f77d1d3752ad053");
		check(C = x"f365bee0e807ce21");
		check(D = x"c833921cc13a9463");
		check(E = x"ea7940769bc29fa6");
		check(F = x"6a5d27082e206042");
		check(G = x"b5df8fdff6d6858d");
		check(H = x"9c7d600dcb23d8ec");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"4838a8e35a2df25c");
		check(B = x"230b8b0845fa2e6e");
		check(C = x"8f77d1d3752ad053");
		check(D = x"f365bee0e807ce21");
		check(E = x"ead061a5201730c");
		check(F = x"ea7940769bc29fa6");
		check(G = x"6a5d27082e206042");
		check(H = x"b5df8fdff6d6858d");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"95b82ff610719393");
		check(B = x"4838a8e35a2df25c");
		check(C = x"230b8b0845fa2e6e");
		check(D = x"8f77d1d3752ad053");
		check(E = x"cb02625c7a3999fa");
		check(F = x"ead061a5201730c");
		check(G = x"ea7940769bc29fa6");
		check(H = x"6a5d27082e206042");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"56b18f80d5788a1c");
		check(B = x"95b82ff610719393");
		check(C = x"4838a8e35a2df25c");
		check(D = x"230b8b0845fa2e6e");
		check(E = x"75caf6776062234e");
		check(F = x"cb02625c7a3999fa");
		check(G = x"ead061a5201730c");
		check(H = x"ea7940769bc29fa6");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"7d6be60d164196c6");
		check(B = x"56b18f80d5788a1c");
		check(C = x"95b82ff610719393");
		check(D = x"4838a8e35a2df25c");
		check(E = x"e8424edcc5a83a26");
		check(F = x"75caf6776062234e");
		check(G = x"cb02625c7a3999fa");
		check(H = x"ead061a5201730c");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"90fe9c34890f3db0");
		check(B = x"7d6be60d164196c6");
		check(C = x"56b18f80d5788a1c");
		check(D = x"95b82ff610719393");
		check(E = x"47d80a9809ad4ed8");
		check(F = x"e8424edcc5a83a26");
		check(G = x"75caf6776062234e");
		check(H = x"cb02625c7a3999fa");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"b156c6dbcac01661");
		check(B = x"90fe9c34890f3db0");
		check(C = x"7d6be60d164196c6");
		check(D = x"56b18f80d5788a1c");
		check(E = x"16715eaefaf071e3");
		check(F = x"47d80a9809ad4ed8");
		check(G = x"e8424edcc5a83a26");
		check(H = x"75caf6776062234e");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"a2ffcd7bf97ca9b4");
		check(B = x"b156c6dbcac01661");
		check(C = x"90fe9c34890f3db0");
		check(D = x"7d6be60d164196c6");
		check(E = x"5f0db32f8a58ab69");
		check(F = x"16715eaefaf071e3");
		check(G = x"47d80a9809ad4ed8");
		check(H = x"e8424edcc5a83a26");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"b88ef3f96eb20537");
		check(B = x"a2ffcd7bf97ca9b4");
		check(C = x"b156c6dbcac01661");
		check(D = x"90fe9c34890f3db0");
		check(E = x"e694c5164da082d2");
		check(F = x"5f0db32f8a58ab69");
		check(G = x"16715eaefaf071e3");
		check(H = x"47d80a9809ad4ed8");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"4050f5796ca4ec9f");
		check(B = x"b88ef3f96eb20537");
		check(C = x"a2ffcd7bf97ca9b4");
		check(D = x"b156c6dbcac01661");
		check(E = x"de1f13760106868b");
		check(F = x"e694c5164da082d2");
		check(G = x"5f0db32f8a58ab69");
		check(H = x"16715eaefaf071e3");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"19c9c1c1de0f01fe");
		check(B = x"4050f5796ca4ec9f");
		check(C = x"b88ef3f96eb20537");
		check(D = x"a2ffcd7bf97ca9b4");
		check(E = x"c682d819507e9f86");
		check(F = x"de1f13760106868b");
		check(G = x"e694c5164da082d2");
		check(H = x"5f0db32f8a58ab69");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"68a8353b76af67c3");
		check(B = x"19c9c1c1de0f01fe");
		check(C = x"4050f5796ca4ec9f");
		check(D = x"b88ef3f96eb20537");
		check(E = x"de0f4f201aa80bca");
		check(F = x"c682d819507e9f86");
		check(G = x"de1f13760106868b");
		check(H = x"e694c5164da082d2");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"f6aa1aaf6847430d");
		check(B = x"68a8353b76af67c3");
		check(C = x"19c9c1c1de0f01fe");
		check(D = x"4050f5796ca4ec9f");
		check(E = x"a4bf1e2581d1d3d2");
		check(F = x"de0f4f201aa80bca");
		check(G = x"c682d819507e9f86");
		check(H = x"de1f13760106868b");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"2af1efe01afd431");
		check(B = x"f6aa1aaf6847430d");
		check(C = x"68a8353b76af67c3");
		check(D = x"19c9c1c1de0f01fe");
		check(E = x"c9a29431e35f0499");
		check(F = x"a4bf1e2581d1d3d2");
		check(G = x"de0f4f201aa80bca");
		check(H = x"c682d819507e9f86");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"e42725a3a36229e7");
		check(B = x"2af1efe01afd431");
		check(C = x"f6aa1aaf6847430d");
		check(D = x"68a8353b76af67c3");
		check(E = x"34b0def218626e82");
		check(F = x"c9a29431e35f0499");
		check(G = x"a4bf1e2581d1d3d2");
		check(H = x"de0f4f201aa80bca");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"fd8999a3a0152f");
		check(B = x"e42725a3a36229e7");
		check(C = x"2af1efe01afd431");
		check(D = x"f6aa1aaf6847430d");
		check(E = x"e939cfd184345eb4");
		check(F = x"34b0def218626e82");
		check(G = x"c9a29431e35f0499");
		check(H = x"a4bf1e2581d1d3d2");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"e0bec3b266d0aa59");
		check(B = x"fd8999a3a0152f");
		check(C = x"e42725a3a36229e7");
		check(D = x"2af1efe01afd431");
		check(E = x"750bb914998fd750");
		check(F = x"e939cfd184345eb4");
		check(G = x"34b0def218626e82");
		check(H = x"c9a29431e35f0499");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"9f644d16a44f7532");
		check(B = x"e0bec3b266d0aa59");
		check(C = x"fd8999a3a0152f");
		check(D = x"e42725a3a36229e7");
		check(E = x"30e0bc04421c29a7");
		check(F = x"750bb914998fd750");
		check(G = x"e939cfd184345eb4");
		check(H = x"34b0def218626e82");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"3f9bee4984445c36");
		check(B = x"9f644d16a44f7532");
		check(C = x"e0bec3b266d0aa59");
		check(D = x"fd8999a3a0152f");
		check(E = x"e21a39cb4c43462d");
		check(F = x"30e0bc04421c29a7");
		check(G = x"750bb914998fd750");
		check(H = x"e939cfd184345eb4");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"d1e32df5426c742f");
		check(B = x"3f9bee4984445c36");
		check(C = x"9f644d16a44f7532");
		check(D = x"e0bec3b266d0aa59");
		check(E = x"5cc58ba627a0e456");
		check(F = x"e21a39cb4c43462d");
		check(G = x"30e0bc04421c29a7");
		check(H = x"750bb914998fd750");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"157db77204cc9ddf");
		check(B = x"d1e32df5426c742f");
		check(C = x"3f9bee4984445c36");
		check(D = x"9f644d16a44f7532");
		check(E = x"b98086b031670190");
		check(F = x"5cc58ba627a0e456");
		check(G = x"e21a39cb4c43462d");
		check(H = x"30e0bc04421c29a7");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"7c56fc55b6a6fbfd");
		check(B = x"157db77204cc9ddf");
		check(C = x"d1e32df5426c742f");
		check(D = x"3f9bee4984445c36");
		check(E = x"dbcc363e29fb335e");
		check(F = x"b98086b031670190");
		check(G = x"5cc58ba627a0e456");
		check(H = x"e21a39cb4c43462d");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"61f5b52e0f434d35");
		check(B = x"7c56fc55b6a6fbfd");
		check(C = x"157db77204cc9ddf");
		check(D = x"d1e32df5426c742f");
		check(E = x"9f6e99232c17d3b6");
		check(F = x"dbcc363e29fb335e");
		check(G = x"b98086b031670190");
		check(H = x"5cc58ba627a0e456");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"f3031e5dfc40d356");
		check(B = x"61f5b52e0f434d35");
		check(C = x"7c56fc55b6a6fbfd");
		check(D = x"157db77204cc9ddf");
		check(E = x"2376105c0a0094c7");
		check(F = x"9f6e99232c17d3b6");
		check(G = x"dbcc363e29fb335e");
		check(H = x"b98086b031670190");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"8cee82d547230169");
		check(B = x"f3031e5dfc40d356");
		check(C = x"61f5b52e0f434d35");
		check(D = x"7c56fc55b6a6fbfd");
		check(E = x"302efdcd6c959f5f");
		check(F = x"2376105c0a0094c7");
		check(G = x"9f6e99232c17d3b6");
		check(H = x"dbcc363e29fb335e");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"fc3a380f12f094be");
		check(B = x"8cee82d547230169");
		check(C = x"f3031e5dfc40d356");
		check(D = x"61f5b52e0f434d35");
		check(E = x"d330d46fb89fe62");
		check(F = x"302efdcd6c959f5f");
		check(G = x"2376105c0a0094c7");
		check(H = x"9f6e99232c17d3b6");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"fadfac3d663be7cc");
		check(B = x"fc3a380f12f094be");
		check(C = x"8cee82d547230169");
		check(D = x"f3031e5dfc40d356");
		check(E = x"6b1ab7251dc92901");
		check(F = x"d330d46fb89fe62");
		check(G = x"302efdcd6c959f5f");
		check(H = x"2376105c0a0094c7");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"4fbf5841ab4ffcbc");
		check(B = x"fadfac3d663be7cc");
		check(C = x"fc3a380f12f094be");
		check(D = x"8cee82d547230169");
		check(E = x"4c6db8f56a4b2a5");
		check(F = x"6b1ab7251dc92901");
		check(G = x"d330d46fb89fe62");
		check(H = x"302efdcd6c959f5f");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"e23f396540df15c2");
		check(B = x"4fbf5841ab4ffcbc");
		check(C = x"fadfac3d663be7cc");
		check(D = x"fc3a380f12f094be");
		check(E = x"12f3d91ad500f5b5");
		check(F = x"4c6db8f56a4b2a5");
		check(G = x"6b1ab7251dc92901");
		check(H = x"d330d46fb89fe62");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"5838faf4a97950ac");
		check(B = x"e23f396540df15c2");
		check(C = x"4fbf5841ab4ffcbc");
		check(D = x"fadfac3d663be7cc");
		check(E = x"d26cd3293b51c91f");
		check(F = x"12f3d91ad500f5b5");
		check(G = x"4c6db8f56a4b2a5");
		check(H = x"6b1ab7251dc92901");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"c26d184a6d1a8171");
		check(B = x"5838faf4a97950ac");
		check(C = x"e23f396540df15c2");
		check(D = x"4fbf5841ab4ffcbc");
		check(E = x"1e739fd25cc5348f");
		check(F = x"d26cd3293b51c91f");
		check(G = x"12f3d91ad500f5b5");
		check(H = x"4c6db8f56a4b2a5");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"eec05534115c1812");
		check(B = x"c26d184a6d1a8171");
		check(C = x"5838faf4a97950ac");
		check(D = x"e23f396540df15c2");
		check(E = x"9e0df2ce9d82ea6a");
		check(F = x"1e739fd25cc5348f");
		check(G = x"d26cd3293b51c91f");
		check(H = x"12f3d91ad500f5b5");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"79b180635672d8e");
		check(B = x"eec05534115c1812");
		check(C = x"c26d184a6d1a8171");
		check(D = x"5838faf4a97950ac");
		check(E = x"a5bdb9dcda856c7a");
		check(F = x"9e0df2ce9d82ea6a");
		check(G = x"1e739fd25cc5348f");
		check(H = x"d26cd3293b51c91f");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"ca0377c21b7c5fd3");
		check(B = x"79b180635672d8e");
		check(C = x"eec05534115c1812");
		check(D = x"c26d184a6d1a8171");
		check(E = x"84317cd7ab3f371b");
		check(F = x"a5bdb9dcda856c7a");
		check(G = x"9e0df2ce9d82ea6a");
		check(H = x"1e739fd25cc5348f");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"15e267240ffd5b97");
		check(B = x"ca0377c21b7c5fd3");
		check(C = x"79b180635672d8e");
		check(D = x"eec05534115c1812");
		check(E = x"54a017f076781838");
		check(F = x"84317cd7ab3f371b");
		check(G = x"a5bdb9dcda856c7a");
		check(H = x"9e0df2ce9d82ea6a");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"7c82d28709fcd958");
		check(B = x"15e267240ffd5b97");
		check(C = x"ca0377c21b7c5fd3");
		check(D = x"79b180635672d8e");
		check(E = x"af8a9b914666628c");
		check(F = x"54a017f076781838");
		check(G = x"84317cd7ab3f371b");
		check(H = x"a5bdb9dcda856c7a");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"b3fdd7bbceadbde2");
		check(B = x"7c82d28709fcd958");
		check(C = x"15e267240ffd5b97");
		check(D = x"ca0377c21b7c5fd3");
		check(E = x"b751dd89023f629");
		check(F = x"af8a9b914666628c");
		check(G = x"54a017f076781838");
		check(H = x"84317cd7ab3f371b");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"1e07be23c26a86ea");
		check(H1_out = x"37ea810c8ec78093");
		check(H2_out = x"52515a970e9253c2");
		check(H3_out = x"6f536cfc7a9996c4");
		check(H4_out = x"5c8370583e0a78fa");
		check(H5_out = x"4a90041d71a4ceab");
		check(H6_out = x"7423f19c71b9d5a3");
		check(H7_out = x"e01249f0bebd5894");

		test_runner_cleanup(runner);
	end process;

end sha512_test_5_tb_arch;

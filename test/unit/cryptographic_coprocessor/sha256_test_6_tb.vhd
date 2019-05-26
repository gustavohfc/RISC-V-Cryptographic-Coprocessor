library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")

entity sha256_test_6_tb IS
	generic(
		runner_cfg : string
	);
end sha256_test_6_tb;

architecture sha256_test_6_tb_arch OF sha256_test_6_tb IS
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

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

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
		check(A = x"34f24381");
		check(B = x"4a6482e8");
		check(C = x"25281b47");
		check(D = x"edce7fe2");
		check(E = x"d4d59948");
		check(F = x"244e5353");
		check(G = x"5fd725da");
		check(H = x"975b48cb");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"d242e2f6");
		check(B = x"34f24381");
		check(C = x"4a6482e8");
		check(D = x"25281b47");
		check(E = x"03762b76");
		check(F = x"d4d59948");
		check(G = x"244e5353");
		check(H = x"5fd725da");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"cc8c5549");
		check(B = x"d242e2f6");
		check(C = x"34f24381");
		check(D = x"4a6482e8");
		check(E = x"f6a3bbcd");
		check(F = x"03762b76");
		check(G = x"d4d59948");
		check(H = x"244e5353");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"81689d2c");
		check(B = x"cc8c5549");
		check(C = x"d242e2f6");
		check(D = x"34f24381");
		check(E = x"0ed28651");
		check(F = x"f6a3bbcd");
		check(G = x"03762b76");
		check(H = x"d4d59948");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"830b6823");
		check(B = x"81689d2c");
		check(C = x"cc8c5549");
		check(D = x"d242e2f6");
		check(E = x"8c6a382e");
		check(F = x"0ed28651");
		check(G = x"f6a3bbcd");
		check(H = x"03762b76");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"e33d7ed9");
		check(B = x"830b6823");
		check(C = x"81689d2c");
		check(D = x"cc8c5549");
		check(E = x"a7f9b847");
		check(F = x"8c6a382e");
		check(G = x"0ed28651");
		check(H = x"f6a3bbcd");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"5720a8d0");
		check(B = x"e33d7ed9");
		check(C = x"830b6823");
		check(D = x"81689d2c");
		check(E = x"2488601f");
		check(F = x"a7f9b847");
		check(G = x"8c6a382e");
		check(H = x"0ed28651");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"6e57ce36");
		check(B = x"5720a8d0");
		check(C = x"e33d7ed9");
		check(D = x"830b6823");
		check(E = x"5aad3024");
		check(F = x"2488601f");
		check(G = x"a7f9b847");
		check(H = x"8c6a382e");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"13538929");
		check(B = x"6e57ce36");
		check(C = x"5720a8d0");
		check(D = x"e33d7ed9");
		check(E = x"7a0aa9f2");
		check(F = x"5aad3024");
		check(G = x"2488601f");
		check(H = x"a7f9b847");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"bf886cee");
		check(B = x"13538929");
		check(C = x"6e57ce36");
		check(D = x"5720a8d0");
		check(E = x"07b986fc");
		check(F = x"7a0aa9f2");
		check(G = x"5aad3024");
		check(H = x"2488601f");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"90d1657e");
		check(B = x"bf886cee");
		check(C = x"13538929");
		check(D = x"6e57ce36");
		check(E = x"bf79e49a");
		check(F = x"07b986fc");
		check(G = x"7a0aa9f2");
		check(H = x"5aad3024");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"d1e31e55");
		check(B = x"90d1657e");
		check(C = x"bf886cee");
		check(D = x"13538929");
		check(E = x"e2145986");
		check(F = x"bf79e49a");
		check(G = x"07b986fc");
		check(H = x"7a0aa9f2");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"05d08eeb");
		check(B = x"d1e31e55");
		check(C = x"90d1657e");
		check(D = x"bf886cee");
		check(E = x"7cb38bcc");
		check(F = x"e2145986");
		check(G = x"bf79e49a");
		check(H = x"07b986fc");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"3dc6f6aa");
		check(B = x"05d08eeb");
		check(C = x"d1e31e55");
		check(D = x"90d1657e");
		check(E = x"7766b3f0");
		check(F = x"7cb38bcc");
		check(G = x"e2145986");
		check(H = x"bf79e49a");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"1212cd2e");
		check(B = x"3dc6f6aa");
		check(C = x"05d08eeb");
		check(D = x"d1e31e55");
		check(E = x"6b269857");
		check(F = x"7766b3f0");
		check(G = x"7cb38bcc");
		check(H = x"e2145986");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"fa92cfbd");
		check(B = x"1212cd2e");
		check(C = x"3dc6f6aa");
		check(D = x"05d08eeb");
		check(E = x"0fe283d3");
		check(F = x"6b269857");
		check(G = x"7766b3f0");
		check(H = x"7cb38bcc");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"56bdf66e");
		check(B = x"fa92cfbd");
		check(C = x"1212cd2e");
		check(D = x"3dc6f6aa");
		check(E = x"d9862518");
		check(F = x"0fe283d3");
		check(G = x"6b269857");
		check(H = x"7766b3f0");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"2582323f");
		check(B = x"56bdf66e");
		check(C = x"fa92cfbd");
		check(D = x"1212cd2e");
		check(E = x"3fb1e88d");
		check(F = x"d9862518");
		check(G = x"0fe283d3");
		check(H = x"6b269857");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"9af358dd");
		check(B = x"2582323f");
		check(C = x"56bdf66e");
		check(D = x"fa92cfbd");
		check(E = x"e621d3c4");
		check(F = x"3fb1e88d");
		check(G = x"d9862518");
		check(H = x"0fe283d3");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"a3d570a8");
		check(B = x"9af358dd");
		check(C = x"2582323f");
		check(D = x"56bdf66e");
		check(E = x"1a815620");
		check(F = x"e621d3c4");
		check(G = x"3fb1e88d");
		check(H = x"d9862518");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"69472120");
		check(B = x"a3d570a8");
		check(C = x"9af358dd");
		check(D = x"2582323f");
		check(E = x"23bec6c3");
		check(F = x"1a815620");
		check(G = x"e621d3c4");
		check(H = x"3fb1e88d");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"9e88b30e");
		check(B = x"69472120");
		check(C = x"a3d570a8");
		check(D = x"9af358dd");
		check(E = x"085d70d1");
		check(F = x"23bec6c3");
		check(G = x"1a815620");
		check(H = x"e621d3c4");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"6c73c461");
		check(B = x"9e88b30e");
		check(C = x"69472120");
		check(D = x"a3d570a8");
		check(E = x"3e87091a");
		check(F = x"085d70d1");
		check(G = x"23bec6c3");
		check(H = x"1a815620");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"5ee0b17f");
		check(B = x"6c73c461");
		check(C = x"9e88b30e");
		check(D = x"69472120");
		check(E = x"df6c69d0");
		check(F = x"3e87091a");
		check(G = x"085d70d1");
		check(H = x"23bec6c3");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"0571aa6e");
		check(B = x"5ee0b17f");
		check(C = x"6c73c461");
		check(D = x"9e88b30e");
		check(E = x"3150f3fe");
		check(F = x"df6c69d0");
		check(G = x"3e87091a");
		check(H = x"085d70d1");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"c77b4134");
		check(B = x"0571aa6e");
		check(C = x"5ee0b17f");
		check(D = x"6c73c461");
		check(E = x"050c5ad0");
		check(F = x"3150f3fe");
		check(G = x"df6c69d0");
		check(H = x"3e87091a");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"5710e58c");
		check(B = x"c77b4134");
		check(C = x"0571aa6e");
		check(D = x"5ee0b17f");
		check(E = x"a696cfe5");
		check(F = x"050c5ad0");
		check(G = x"3150f3fe");
		check(H = x"df6c69d0");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"8206a69e");
		check(B = x"5710e58c");
		check(C = x"c77b4134");
		check(D = x"0571aa6e");
		check(E = x"1f44c639");
		check(F = x"a696cfe5");
		check(G = x"050c5ad0");
		check(H = x"3150f3fe");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"c03953d8");
		check(B = x"8206a69e");
		check(C = x"5710e58c");
		check(D = x"c77b4134");
		check(E = x"6fa85510");
		check(F = x"1f44c639");
		check(G = x"a696cfe5");
		check(H = x"050c5ad0");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"d03122a2");
		check(B = x"c03953d8");
		check(C = x"8206a69e");
		check(D = x"5710e58c");
		check(E = x"8a1445fe");
		check(F = x"6fa85510");
		check(G = x"1f44c639");
		check(H = x"a696cfe5");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"da4406d4");
		check(B = x"d03122a2");
		check(C = x"c03953d8");
		check(D = x"8206a69e");
		check(E = x"0b938765");
		check(F = x"8a1445fe");
		check(G = x"6fa85510");
		check(H = x"1f44c639");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"48b81a7d");
		check(B = x"da4406d4");
		check(C = x"d03122a2");
		check(D = x"c03953d8");
		check(E = x"ea613d4f");
		check(F = x"0b938765");
		check(G = x"8a1445fe");
		check(H = x"6fa85510");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"5b973be7");
		check(B = x"48b81a7d");
		check(C = x"da4406d4");
		check(D = x"d03122a2");
		check(E = x"e1f2d64e");
		check(F = x"ea613d4f");
		check(G = x"0b938765");
		check(H = x"8a1445fe");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"4041f8a9");
		check(B = x"5b973be7");
		check(C = x"48b81a7d");
		check(D = x"da4406d4");
		check(E = x"60ae7128");
		check(F = x"e1f2d64e");
		check(G = x"ea613d4f");
		check(H = x"0b938765");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"3ba30f73");
		check(B = x"4041f8a9");
		check(C = x"5b973be7");
		check(D = x"48b81a7d");
		check(E = x"3a9d0236");
		check(F = x"60ae7128");
		check(G = x"e1f2d64e");
		check(H = x"ea613d4f");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"cf2a30cb");
		check(B = x"3ba30f73");
		check(C = x"4041f8a9");
		check(D = x"5b973be7");
		check(E = x"83123d3b");
		check(F = x"3a9d0236");
		check(G = x"60ae7128");
		check(H = x"e1f2d64e");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"26f01e32");
		check(B = x"cf2a30cb");
		check(C = x"3ba30f73");
		check(D = x"4041f8a9");
		check(E = x"5a0c46cf");
		check(F = x"83123d3b");
		check(G = x"3a9d0236");
		check(H = x"60ae7128");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"65fa4f3a");
		check(B = x"26f01e32");
		check(C = x"cf2a30cb");
		check(D = x"3ba30f73");
		check(E = x"be4430d9");
		check(F = x"5a0c46cf");
		check(G = x"83123d3b");
		check(H = x"3a9d0236");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"37130e88");
		check(B = x"65fa4f3a");
		check(C = x"26f01e32");
		check(D = x"cf2a30cb");
		check(E = x"012aaa36");
		check(F = x"be4430d9");
		check(G = x"5a0c46cf");
		check(H = x"83123d3b");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"87f5f640");
		check(B = x"37130e88");
		check(C = x"65fa4f3a");
		check(D = x"26f01e32");
		check(E = x"f96ebceb");
		check(F = x"012aaa36");
		check(G = x"be4430d9");
		check(H = x"5a0c46cf");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"e07fb087");
		check(B = x"87f5f640");
		check(C = x"37130e88");
		check(D = x"65fa4f3a");
		check(E = x"9b5c4091");
		check(F = x"f96ebceb");
		check(G = x"012aaa36");
		check(H = x"be4430d9");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"19cca46c");
		check(B = x"e07fb087");
		check(C = x"87f5f640");
		check(D = x"37130e88");
		check(E = x"556c4cc9");
		check(F = x"9b5c4091");
		check(G = x"f96ebceb");
		check(H = x"012aaa36");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"05e60ff1");
		check(B = x"19cca46c");
		check(C = x"e07fb087");
		check(D = x"87f5f640");
		check(E = x"a379131c");
		check(F = x"556c4cc9");
		check(G = x"9b5c4091");
		check(H = x"f96ebceb");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"ea153867");
		check(B = x"05e60ff1");
		check(C = x"19cca46c");
		check(D = x"e07fb087");
		check(E = x"c94e20e7");
		check(F = x"a379131c");
		check(G = x"556c4cc9");
		check(H = x"9b5c4091");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"82ea4ead");
		check(B = x"ea153867");
		check(C = x"05e60ff1");
		check(D = x"19cca46c");
		check(E = x"ec4a51b7");
		check(F = x"c94e20e7");
		check(G = x"a379131c");
		check(H = x"556c4cc9");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"f6570c4a");
		check(B = x"82ea4ead");
		check(C = x"ea153867");
		check(D = x"05e60ff1");
		check(E = x"d0516edf");
		check(F = x"ec4a51b7");
		check(G = x"c94e20e7");
		check(H = x"a379131c");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"64824995");
		check(B = x"f6570c4a");
		check(C = x"82ea4ead");
		check(D = x"ea153867");
		check(E = x"041df2a4");
		check(F = x"d0516edf");
		check(G = x"ec4a51b7");
		check(H = x"c94e20e7");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"e0fc143d");
		check(B = x"64824995");
		check(C = x"f6570c4a");
		check(D = x"82ea4ead");
		check(E = x"c7a11c32");
		check(F = x"041df2a4");
		check(G = x"d0516edf");
		check(H = x"ec4a51b7");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"c1a5eeca");
		check(B = x"e0fc143d");
		check(C = x"64824995");
		check(D = x"f6570c4a");
		check(E = x"36393bee");
		check(F = x"c7a11c32");
		check(G = x"041df2a4");
		check(H = x"d0516edf");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"a17831a4");
		check(B = x"c1a5eeca");
		check(C = x"e0fc143d");
		check(D = x"64824995");
		check(E = x"65a693b6");
		check(F = x"36393bee");
		check(G = x"c7a11c32");
		check(H = x"041df2a4");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"2783f6bc");
		check(B = x"a17831a4");
		check(C = x"c1a5eeca");
		check(D = x"e0fc143d");
		check(E = x"644c7678");
		check(F = x"65a693b6");
		check(G = x"36393bee");
		check(H = x"c7a11c32");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"c2750cdf");
		check(B = x"2783f6bc");
		check(C = x"a17831a4");
		check(D = x"c1a5eeca");
		check(E = x"4df3f942");
		check(F = x"644c7678");
		check(G = x"65a693b6");
		check(H = x"36393bee");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"12cf2a80");
		check(B = x"c2750cdf");
		check(C = x"2783f6bc");
		check(D = x"a17831a4");
		check(E = x"eeb3b4f8");
		check(F = x"4df3f942");
		check(G = x"644c7678");
		check(H = x"65a693b6");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"adbb11b6");
		check(B = x"12cf2a80");
		check(C = x"c2750cdf");
		check(D = x"2783f6bc");
		check(E = x"e052b82c");
		check(F = x"eeb3b4f8");
		check(G = x"4df3f942");
		check(H = x"644c7678");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"27b9b971");
		check(B = x"adbb11b6");
		check(C = x"12cf2a80");
		check(D = x"c2750cdf");
		check(E = x"01a13494");
		check(F = x"e052b82c");
		check(G = x"eeb3b4f8");
		check(H = x"4df3f942");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"79bf138f");
		check(B = x"27b9b971");
		check(C = x"adbb11b6");
		check(D = x"12cf2a80");
		check(E = x"aff64faf");
		check(F = x"01a13494");
		check(G = x"e052b82c");
		check(H = x"eeb3b4f8");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"5818a57f");
		check(B = x"79bf138f");
		check(C = x"27b9b971");
		check(D = x"adbb11b6");
		check(E = x"7ed2894b");
		check(F = x"aff64faf");
		check(G = x"01a13494");
		check(H = x"e052b82c");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"44a2f709");
		check(B = x"5818a57f");
		check(C = x"79bf138f");
		check(D = x"27b9b971");
		check(E = x"d93b4246");
		check(F = x"7ed2894b");
		check(G = x"aff64faf");
		check(H = x"01a13494");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"c04dce98");
		check(B = x"aeacdd70");
		check(C = x"13805404");
		check(D = x"b62e0701");
		check(E = x"634fa7c3");
		check(F = x"2a4994c5");
		check(G = x"19d7f1d7");
		check(H = x"cf7a295a");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"c439e873");
		check(B = x"c04dce98");
		check(C = x"aeacdd70");
		check(D = x"13805404");
		check(E = x"83ec009b");
		check(F = x"634fa7c3");
		check(G = x"2a4994c5");
		check(H = x"19d7f1d7");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"9fc563e3");
		check(B = x"c439e873");
		check(C = x"c04dce98");
		check(D = x"aeacdd70");
		check(E = x"99e656b4");
		check(F = x"83ec009b");
		check(G = x"634fa7c3");
		check(H = x"2a4994c5");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"a17d25b8");
		check(B = x"9fc563e3");
		check(C = x"c439e873");
		check(D = x"c04dce98");
		check(E = x"9e79ef89");
		check(F = x"99e656b4");
		check(G = x"83ec009b");
		check(H = x"634fa7c3");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"98d29ef1");
		check(B = x"a17d25b8");
		check(C = x"9fc563e3");
		check(D = x"c439e873");
		check(E = x"e2966b94");
		check(F = x"9e79ef89");
		check(G = x"99e656b4");
		check(H = x"83ec009b");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"590a227a");
		check(B = x"98d29ef1");
		check(C = x"a17d25b8");
		check(D = x"9fc563e3");
		check(E = x"a7ab3bb1");
		check(F = x"e2966b94");
		check(G = x"9e79ef89");
		check(H = x"99e656b4");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"92a41aed");
		check(B = x"590a227a");
		check(C = x"98d29ef1");
		check(D = x"a17d25b8");
		check(E = x"ebf5ae2d");
		check(F = x"a7ab3bb1");
		check(G = x"e2966b94");
		check(H = x"9e79ef89");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"322fb9d1");
		check(B = x"92a41aed");
		check(C = x"590a227a");
		check(D = x"98d29ef1");
		check(E = x"177c9ebf");
		check(F = x"ebf5ae2d");
		check(G = x"a7ab3bb1");
		check(H = x"e2966b94");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"43997e75");
		check(B = x"322fb9d1");
		check(C = x"92a41aed");
		check(D = x"590a227a");
		check(E = x"8d58a6ac");
		check(F = x"177c9ebf");
		check(G = x"ebf5ae2d");
		check(H = x"a7ab3bb1");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"c7869674");
		check(B = x"43997e75");
		check(C = x"322fb9d1");
		check(D = x"92a41aed");
		check(E = x"472de7a1");
		check(F = x"8d58a6ac");
		check(G = x"177c9ebf");
		check(H = x"ebf5ae2d");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"e8f57e56");
		check(B = x"c7869674");
		check(C = x"43997e75");
		check(D = x"322fb9d1");
		check(E = x"9feb9017");
		check(F = x"472de7a1");
		check(G = x"8d58a6ac");
		check(H = x"177c9ebf");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"7e0fde39");
		check(B = x"e8f57e56");
		check(C = x"c7869674");
		check(D = x"43997e75");
		check(E = x"4f36d5f9");
		check(F = x"9feb9017");
		check(G = x"472de7a1");
		check(H = x"8d58a6ac");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"507b37d7");
		check(B = x"7e0fde39");
		check(C = x"e8f57e56");
		check(D = x"c7869674");
		check(E = x"145bf5d0");
		check(F = x"4f36d5f9");
		check(G = x"9feb9017");
		check(H = x"472de7a1");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"2e630ddd");
		check(B = x"507b37d7");
		check(C = x"7e0fde39");
		check(D = x"e8f57e56");
		check(E = x"f6ef128d");
		check(F = x"145bf5d0");
		check(G = x"4f36d5f9");
		check(H = x"9feb9017");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"92c178b4");
		check(B = x"2e630ddd");
		check(C = x"507b37d7");
		check(D = x"7e0fde39");
		check(E = x"54051257");
		check(F = x"f6ef128d");
		check(G = x"145bf5d0");
		check(H = x"4f36d5f9");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"71bfd875");
		check(B = x"92c178b4");
		check(C = x"2e630ddd");
		check(D = x"507b37d7");
		check(E = x"f8765e6c");
		check(F = x"54051257");
		check(G = x"f6ef128d");
		check(H = x"145bf5d0");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"a85f5b3e");
		check(B = x"71bfd875");
		check(C = x"92c178b4");
		check(D = x"2e630ddd");
		check(E = x"65518bfb");
		check(F = x"f8765e6c");
		check(G = x"54051257");
		check(H = x"f6ef128d");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"51eb4cf3");
		check(B = x"a85f5b3e");
		check(C = x"71bfd875");
		check(D = x"92c178b4");
		check(E = x"c0e09408");
		check(F = x"65518bfb");
		check(G = x"f8765e6c");
		check(H = x"54051257");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"3f624e43");
		check(B = x"51eb4cf3");
		check(C = x"a85f5b3e");
		check(D = x"71bfd875");
		check(E = x"4150dd5f");
		check(F = x"c0e09408");
		check(G = x"65518bfb");
		check(H = x"f8765e6c");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"6dac6128");
		check(B = x"3f624e43");
		check(C = x"51eb4cf3");
		check(D = x"a85f5b3e");
		check(E = x"710886ab");
		check(F = x"4150dd5f");
		check(G = x"c0e09408");
		check(H = x"65518bfb");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"959bcc29");
		check(B = x"6dac6128");
		check(C = x"3f624e43");
		check(D = x"51eb4cf3");
		check(E = x"1c640665");
		check(F = x"710886ab");
		check(G = x"4150dd5f");
		check(H = x"c0e09408");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"92516bc3");
		check(B = x"959bcc29");
		check(C = x"6dac6128");
		check(D = x"3f624e43");
		check(E = x"3b77730b");
		check(F = x"1c640665");
		check(G = x"710886ab");
		check(H = x"4150dd5f");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"866b0b38");
		check(B = x"92516bc3");
		check(C = x"959bcc29");
		check(D = x"6dac6128");
		check(E = x"310c2a20");
		check(F = x"3b77730b");
		check(G = x"1c640665");
		check(H = x"710886ab");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"730a95d7");
		check(B = x"866b0b38");
		check(C = x"92516bc3");
		check(D = x"959bcc29");
		check(E = x"75e99847");
		check(F = x"310c2a20");
		check(G = x"3b77730b");
		check(H = x"1c640665");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"16b76867");
		check(B = x"730a95d7");
		check(C = x"866b0b38");
		check(D = x"92516bc3");
		check(E = x"c1d9c7d0");
		check(F = x"75e99847");
		check(G = x"310c2a20");
		check(H = x"3b77730b");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"1d30278e");
		check(B = x"16b76867");
		check(C = x"730a95d7");
		check(D = x"866b0b38");
		check(E = x"3e2195e2");
		check(F = x"c1d9c7d0");
		check(G = x"75e99847");
		check(H = x"310c2a20");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"da3a65a1");
		check(B = x"1d30278e");
		check(C = x"16b76867");
		check(D = x"730a95d7");
		check(E = x"cdd072fc");
		check(F = x"3e2195e2");
		check(G = x"c1d9c7d0");
		check(H = x"75e99847");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"50ad880b");
		check(B = x"da3a65a1");
		check(C = x"1d30278e");
		check(D = x"16b76867");
		check(E = x"f36ee868");
		check(F = x"cdd072fc");
		check(G = x"3e2195e2");
		check(H = x"c1d9c7d0");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"bd5f4139");
		check(B = x"50ad880b");
		check(C = x"da3a65a1");
		check(D = x"1d30278e");
		check(E = x"598cb9e9");
		check(F = x"f36ee868");
		check(G = x"cdd072fc");
		check(H = x"3e2195e2");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"4c7d8044");
		check(B = x"bd5f4139");
		check(C = x"50ad880b");
		check(D = x"da3a65a1");
		check(E = x"75cf8a68");
		check(F = x"598cb9e9");
		check(G = x"f36ee868");
		check(H = x"cdd072fc");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"ee04c546");
		check(B = x"4c7d8044");
		check(C = x"bd5f4139");
		check(D = x"50ad880b");
		check(E = x"84859812");
		check(F = x"75cf8a68");
		check(G = x"598cb9e9");
		check(H = x"f36ee868");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"91c17ca5");
		check(B = x"ee04c546");
		check(C = x"4c7d8044");
		check(D = x"bd5f4139");
		check(E = x"736de89d");
		check(F = x"84859812");
		check(G = x"75cf8a68");
		check(H = x"598cb9e9");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"b0099f7d");
		check(B = x"91c17ca5");
		check(C = x"ee04c546");
		check(D = x"4c7d8044");
		check(E = x"1c74d50d");
		check(F = x"736de89d");
		check(G = x"84859812");
		check(H = x"75cf8a68");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"e39989de");
		check(B = x"b0099f7d");
		check(C = x"91c17ca5");
		check(D = x"ee04c546");
		check(E = x"ce831b6a");
		check(F = x"1c74d50d");
		check(G = x"736de89d");
		check(H = x"84859812");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"e5afa7d9");
		check(B = x"e39989de");
		check(C = x"b0099f7d");
		check(D = x"91c17ca5");
		check(E = x"91f4c9ed");
		check(F = x"ce831b6a");
		check(G = x"1c74d50d");
		check(H = x"736de89d");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"28634372");
		check(B = x"e5afa7d9");
		check(C = x"e39989de");
		check(D = x"b0099f7d");
		check(E = x"df5f8d1d");
		check(F = x"91f4c9ed");
		check(G = x"ce831b6a");
		check(H = x"1c74d50d");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"31af2170");
		check(B = x"28634372");
		check(C = x"e5afa7d9");
		check(D = x"e39989de");
		check(E = x"e388e1ac");
		check(F = x"df5f8d1d");
		check(G = x"91f4c9ed");
		check(H = x"ce831b6a");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"9f8c4cf9");
		check(B = x"31af2170");
		check(C = x"28634372");
		check(D = x"e5afa7d9");
		check(E = x"a6072d84");
		check(F = x"e388e1ac");
		check(G = x"df5f8d1d");
		check(H = x"91f4c9ed");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"f2a79eb9");
		check(B = x"9f8c4cf9");
		check(C = x"31af2170");
		check(D = x"28634372");
		check(E = x"6d8bfc00");
		check(F = x"a6072d84");
		check(G = x"e388e1ac");
		check(H = x"df5f8d1d");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"75d156e9");
		check(B = x"f2a79eb9");
		check(C = x"9f8c4cf9");
		check(D = x"31af2170");
		check(E = x"d368f80a");
		check(F = x"6d8bfc00");
		check(G = x"a6072d84");
		check(H = x"e388e1ac");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"8e6da72c");
		check(B = x"75d156e9");
		check(C = x"f2a79eb9");
		check(D = x"9f8c4cf9");
		check(E = x"19330abc");
		check(F = x"d368f80a");
		check(G = x"6d8bfc00");
		check(H = x"a6072d84");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"3464a69b");
		check(B = x"8e6da72c");
		check(C = x"75d156e9");
		check(D = x"f2a79eb9");
		check(E = x"30a7b44c");
		check(F = x"19330abc");
		check(G = x"d368f80a");
		check(H = x"6d8bfc00");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"705e677a");
		check(B = x"3464a69b");
		check(C = x"8e6da72c");
		check(D = x"75d156e9");
		check(E = x"c3457938");
		check(F = x"30a7b44c");
		check(G = x"19330abc");
		check(H = x"d368f80a");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"d4bc3b1d");
		check(B = x"705e677a");
		check(C = x"3464a69b");
		check(D = x"8e6da72c");
		check(E = x"37c6f7e0");
		check(F = x"c3457938");
		check(G = x"30a7b44c");
		check(H = x"19330abc");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"a524f3a1");
		check(B = x"d4bc3b1d");
		check(C = x"705e677a");
		check(D = x"3464a69b");
		check(E = x"61e8973e");
		check(F = x"37c6f7e0");
		check(G = x"c3457938");
		check(H = x"30a7b44c");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"27c1916f");
		check(B = x"a524f3a1");
		check(C = x"d4bc3b1d");
		check(D = x"705e677a");
		check(E = x"005f3176");
		check(F = x"61e8973e");
		check(G = x"37c6f7e0");
		check(H = x"c3457938");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"8c83f273");
		check(B = x"27c1916f");
		check(C = x"a524f3a1");
		check(D = x"d4bc3b1d");
		check(E = x"1270bff8");
		check(F = x"005f3176");
		check(G = x"61e8973e");
		check(H = x"37c6f7e0");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"a666a282");
		check(B = x"8c83f273");
		check(C = x"27c1916f");
		check(D = x"a524f3a1");
		check(E = x"562b938b");
		check(F = x"1270bff8");
		check(G = x"005f3176");
		check(H = x"61e8973e");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"0f84791a");
		check(B = x"a666a282");
		check(C = x"8c83f273");
		check(D = x"27c1916f");
		check(E = x"e6df294c");
		check(F = x"562b938b");
		check(G = x"1270bff8");
		check(H = x"005f3176");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"90c26a31");
		check(B = x"0f84791a");
		check(C = x"a666a282");
		check(D = x"8c83f273");
		check(E = x"cf27ff33");
		check(F = x"e6df294c");
		check(G = x"562b938b");
		check(H = x"1270bff8");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"7118fa83");
		check(B = x"90c26a31");
		check(C = x"0f84791a");
		check(D = x"a666a282");
		check(E = x"3ac1a808");
		check(F = x"cf27ff33");
		check(G = x"e6df294c");
		check(H = x"562b938b");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"528d29b4");
		check(B = x"7118fa83");
		check(C = x"90c26a31");
		check(D = x"0f84791a");
		check(E = x"7bbb9680");
		check(F = x"3ac1a808");
		check(G = x"cf27ff33");
		check(H = x"e6df294c");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"c1da605d");
		check(B = x"528d29b4");
		check(C = x"7118fa83");
		check(D = x"90c26a31");
		check(E = x"132f5f78");
		check(F = x"7bbb9680");
		check(G = x"3ac1a808");
		check(H = x"cf27ff33");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"41dae85b");
		check(B = x"c1da605d");
		check(C = x"528d29b4");
		check(D = x"7118fa83");
		check(E = x"65eb0834");
		check(F = x"132f5f78");
		check(G = x"7bbb9680");
		check(H = x"3ac1a808");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"2258aee3");
		check(B = x"41dae85b");
		check(C = x"c1da605d");
		check(D = x"528d29b4");
		check(E = x"58896743");
		check(F = x"65eb0834");
		check(G = x"132f5f78");
		check(H = x"7bbb9680");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"ed785ab4");
		check(B = x"2258aee3");
		check(C = x"41dae85b");
		check(D = x"c1da605d");
		check(E = x"20f5e619");
		check(F = x"58896743");
		check(G = x"65eb0834");
		check(H = x"132f5f78");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"6a98bf10");
		check(B = x"ed785ab4");
		check(C = x"2258aee3");
		check(D = x"41dae85b");
		check(E = x"bb8685a0");
		check(F = x"20f5e619");
		check(G = x"58896743");
		check(H = x"65eb0834");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"46334e2a");
		check(B = x"6a98bf10");
		check(C = x"ed785ab4");
		check(D = x"2258aee3");
		check(E = x"9cdc3d2a");
		check(F = x"bb8685a0");
		check(G = x"20f5e619");
		check(H = x"58896743");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"c455f6cf");
		check(B = x"46334e2a");
		check(C = x"6a98bf10");
		check(D = x"ed785ab4");
		check(E = x"4a8ffc7a");
		check(F = x"9cdc3d2a");
		check(G = x"bb8685a0");
		check(H = x"20f5e619");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"a6118b41");
		check(B = x"c455f6cf");
		check(C = x"46334e2a");
		check(D = x"6a98bf10");
		check(E = x"3cc787de");
		check(F = x"4a8ffc7a");
		check(G = x"9cdc3d2a");
		check(H = x"bb8685a0");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"339b10e0");
		check(B = x"a6118b41");
		check(C = x"c455f6cf");
		check(D = x"46334e2a");
		check(E = x"627dace1");
		check(F = x"3cc787de");
		check(G = x"4a8ffc7a");
		check(H = x"9cdc3d2a");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"81f1c54d");
		check(B = x"339b10e0");
		check(C = x"a6118b41");
		check(D = x"c455f6cf");
		check(E = x"3a6ea888");
		check(F = x"627dace1");
		check(G = x"3cc787de");
		check(H = x"4a8ffc7a");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"4d64753d");
		check(B = x"81f1c54d");
		check(C = x"339b10e0");
		check(D = x"a6118b41");
		check(E = x"e123a1f1");
		check(F = x"3a6ea888");
		check(G = x"627dace1");
		check(H = x"3cc787de");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"81207c9d");
		check(B = x"4d64753d");
		check(C = x"81f1c54d");
		check(D = x"339b10e0");
		check(E = x"b9d92f18");
		check(F = x"e123a1f1");
		check(G = x"3a6ea888");
		check(H = x"627dace1");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"2fcd5a0d");
		check(H1_out = x"60e4c941");
		check(H2_out = x"381fcc4e");
		check(H3_out = x"00a4bf8b");
		check(H4_out = x"e422c3dd");
		check(H5_out = x"fafb93c8");
		check(H6_out = x"09e8d1e2");
		check(H7_out = x"bfffae8e");

		test_runner_cleanup(runner);
	end process;

end sha256_test_6_tb_arch;

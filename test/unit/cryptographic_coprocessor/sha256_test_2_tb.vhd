library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 24 bits message ("abc")

entity sha256_test_2_tb IS
	generic(
		runner_cfg : string
	);
end sha256_test_2_tb;

architecture sha256_test_2_tb_arch OF sha256_test_2_tb IS
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
		check(A = x"5d6aebcd");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"fa2a4622");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"5a6ad9ad");
		check(B = x"5d6aebcd");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"78ce7989");
		check(F = x"fa2a4622");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"c8c347a7");
		check(B = x"5a6ad9ad");
		check(C = x"5d6aebcd");
		check(D = x"6a09e667");
		check(E = x"f92939eb");
		check(F = x"78ce7989");
		check(G = x"fa2a4622");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"d550f666");
		check(B = x"c8c347a7");
		check(C = x"5a6ad9ad");
		check(D = x"5d6aebcd");
		check(E = x"24e00850");
		check(F = x"f92939eb");
		check(G = x"78ce7989");
		check(H = x"fa2a4622");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"04409a6a");
		check(B = x"d550f666");
		check(C = x"c8c347a7");
		check(D = x"5a6ad9ad");
		check(E = x"43ada245");
		check(F = x"24e00850");
		check(G = x"f92939eb");
		check(H = x"78ce7989");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"2b4209f5");
		check(B = x"04409a6a");
		check(C = x"d550f666");
		check(D = x"c8c347a7");
		check(E = x"714260ad");
		check(F = x"43ada245");
		check(G = x"24e00850");
		check(H = x"f92939eb");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"e5030380");
		check(B = x"2b4209f5");
		check(C = x"04409a6a");
		check(D = x"d550f666");
		check(E = x"9b27a401");
		check(F = x"714260ad");
		check(G = x"43ada245");
		check(H = x"24e00850");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"85a07b5f");
		check(B = x"e5030380");
		check(C = x"2b4209f5");
		check(D = x"04409a6a");
		check(E = x"0c657a79");
		check(F = x"9b27a401");
		check(G = x"714260ad");
		check(H = x"43ada245");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"8e04ecb9");
		check(B = x"85a07b5f");
		check(C = x"e5030380");
		check(D = x"2b4209f5");
		check(E = x"32ca2d8c");
		check(F = x"0c657a79");
		check(G = x"9b27a401");
		check(H = x"714260ad");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"8c87346b");
		check(B = x"8e04ecb9");
		check(C = x"85a07b5f");
		check(D = x"e5030380");
		check(E = x"1cc92596");
		check(F = x"32ca2d8c");
		check(G = x"0c657a79");
		check(H = x"9b27a401");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"4798a3f4");
		check(B = x"8c87346b");
		check(C = x"8e04ecb9");
		check(D = x"85a07b5f");
		check(E = x"436b23e8");
		check(F = x"1cc92596");
		check(G = x"32ca2d8c");
		check(H = x"0c657a79");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"f71fc5a9");
		check(B = x"4798a3f4");
		check(C = x"8c87346b");
		check(D = x"8e04ecb9");
		check(E = x"816fd6e9");
		check(F = x"436b23e8");
		check(G = x"1cc92596");
		check(H = x"32ca2d8c");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"87912990");
		check(B = x"f71fc5a9");
		check(C = x"4798a3f4");
		check(D = x"8c87346b");
		check(E = x"1e578218");
		check(F = x"816fd6e9");
		check(G = x"436b23e8");
		check(H = x"1cc92596");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"d932eb16");
		check(B = x"87912990");
		check(C = x"f71fc5a9");
		check(D = x"4798a3f4");
		check(E = x"745a48de");
		check(F = x"1e578218");
		check(G = x"816fd6e9");
		check(H = x"436b23e8");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"c0645fde");
		check(B = x"d932eb16");
		check(C = x"87912990");
		check(D = x"f71fc5a9");
		check(E = x"0b92f20c");
		check(F = x"745a48de");
		check(G = x"1e578218");
		check(H = x"816fd6e9");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"b0fa238e");
		check(B = x"c0645fde");
		check(C = x"d932eb16");
		check(D = x"87912990");
		check(E = x"07590dcd");
		check(F = x"0b92f20c");
		check(G = x"745a48de");
		check(H = x"1e578218");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"21da9a9b");
		check(B = x"b0fa238e");
		check(C = x"c0645fde");
		check(D = x"d932eb16");
		check(E = x"8034229c");
		check(F = x"07590dcd");
		check(G = x"0b92f20c");
		check(H = x"745a48de");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"c2fbd9d1");
		check(B = x"21da9a9b");
		check(C = x"b0fa238e");
		check(D = x"c0645fde");
		check(E = x"846ee454");
		check(F = x"8034229c");
		check(G = x"07590dcd");
		check(H = x"0b92f20c");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"fe777bbf");
		check(B = x"c2fbd9d1");
		check(C = x"21da9a9b");
		check(D = x"b0fa238e");
		check(E = x"cc899961");
		check(F = x"846ee454");
		check(G = x"8034229c");
		check(H = x"07590dcd");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"e1f20c33");
		check(B = x"fe777bbf");
		check(C = x"c2fbd9d1");
		check(D = x"21da9a9b");
		check(E = x"b0638179");
		check(F = x"cc899961");
		check(G = x"846ee454");
		check(H = x"8034229c");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"9dc68b63");
		check(B = x"e1f20c33");
		check(C = x"fe777bbf");
		check(D = x"c2fbd9d1");
		check(E = x"8ada8930");
		check(F = x"b0638179");
		check(G = x"cc899961");
		check(H = x"846ee454");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"c2606d6d");
		check(B = x"9dc68b63");
		check(C = x"e1f20c33");
		check(D = x"fe777bbf");
		check(E = x"e1257970");
		check(F = x"8ada8930");
		check(G = x"b0638179");
		check(H = x"cc899961");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"a7a3623f");
		check(B = x"c2606d6d");
		check(C = x"9dc68b63");
		check(D = x"e1f20c33");
		check(E = x"49f5114a");
		check(F = x"e1257970");
		check(G = x"8ada8930");
		check(H = x"b0638179");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"c5d53d8d");
		check(B = x"a7a3623f");
		check(C = x"c2606d6d");
		check(D = x"9dc68b63");
		check(E = x"aa47c347");
		check(F = x"49f5114a");
		check(G = x"e1257970");
		check(H = x"8ada8930");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"1c2c2838");
		check(B = x"c5d53d8d");
		check(C = x"a7a3623f");
		check(D = x"c2606d6d");
		check(E = x"2823ef91");
		check(F = x"aa47c347");
		check(G = x"49f5114a");
		check(H = x"e1257970");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"cde8037d");
		check(B = x"1c2c2838");
		check(C = x"c5d53d8d");
		check(D = x"a7a3623f");
		check(E = x"14383d8e");
		check(F = x"2823ef91");
		check(G = x"aa47c347");
		check(H = x"49f5114a");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"b62ec4bc");
		check(B = x"cde8037d");
		check(C = x"1c2c2838");
		check(D = x"c5d53d8d");
		check(E = x"c74c6516");
		check(F = x"14383d8e");
		check(G = x"2823ef91");
		check(H = x"aa47c347");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"77d37528");
		check(B = x"b62ec4bc");
		check(C = x"cde8037d");
		check(D = x"1c2c2838");
		check(E = x"edffbff8");
		check(F = x"c74c6516");
		check(G = x"14383d8e");
		check(H = x"2823ef91");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"363482c9");
		check(B = x"77d37528");
		check(C = x"b62ec4bc");
		check(D = x"cde8037d");
		check(E = x"6112a3b7");
		check(F = x"edffbff8");
		check(G = x"c74c6516");
		check(H = x"14383d8e");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"a0060b30");
		check(B = x"363482c9");
		check(C = x"77d37528");
		check(D = x"b62ec4bc");
		check(E = x"ade79437");
		check(F = x"6112a3b7");
		check(G = x"edffbff8");
		check(H = x"c74c6516");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"ea992a22");
		check(B = x"a0060b30");
		check(C = x"363482c9");
		check(D = x"77d37528");
		check(E = x"0109ab3a");
		check(F = x"ade79437");
		check(G = x"6112a3b7");
		check(H = x"edffbff8");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"73b33bf5");
		check(B = x"ea992a22");
		check(C = x"a0060b30");
		check(D = x"363482c9");
		check(E = x"ba591112");
		check(F = x"0109ab3a");
		check(G = x"ade79437");
		check(H = x"6112a3b7");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"98e12507");
		check(B = x"73b33bf5");
		check(C = x"ea992a22");
		check(D = x"a0060b30");
		check(E = x"9cd9f5f6");
		check(F = x"ba591112");
		check(G = x"0109ab3a");
		check(H = x"ade79437");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"fe604df5");
		check(B = x"98e12507");
		check(C = x"73b33bf5");
		check(D = x"ea992a22");
		check(E = x"59249dd3");
		check(F = x"9cd9f5f6");
		check(G = x"ba591112");
		check(H = x"0109ab3a");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"a9a7738c");
		check(B = x"fe604df5");
		check(C = x"98e12507");
		check(D = x"73b33bf5");
		check(E = x"085f3833");
		check(F = x"59249dd3");
		check(G = x"9cd9f5f6");
		check(H = x"ba591112");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"65a0cfe4");
		check(B = x"a9a7738c");
		check(C = x"fe604df5");
		check(D = x"98e12507");
		check(E = x"f4b002d6");
		check(F = x"085f3833");
		check(G = x"59249dd3");
		check(H = x"9cd9f5f6");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"41a65cb1");
		check(B = x"65a0cfe4");
		check(C = x"a9a7738c");
		check(D = x"fe604df5");
		check(E = x"0772a26b");
		check(F = x"f4b002d6");
		check(G = x"085f3833");
		check(H = x"59249dd3");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"34df1604");
		check(B = x"41a65cb1");
		check(C = x"65a0cfe4");
		check(D = x"a9a7738c");
		check(E = x"a507a53d");
		check(F = x"0772a26b");
		check(G = x"f4b002d6");
		check(H = x"085f3833");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"6dc57a8a");
		check(B = x"34df1604");
		check(C = x"41a65cb1");
		check(D = x"65a0cfe4");
		check(E = x"f0781bc8");
		check(F = x"a507a53d");
		check(G = x"0772a26b");
		check(H = x"f4b002d6");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"79ea687a");
		check(B = x"6dc57a8a");
		check(C = x"34df1604");
		check(D = x"41a65cb1");
		check(E = x"1efbc0a0");
		check(F = x"f0781bc8");
		check(G = x"a507a53d");
		check(H = x"0772a26b");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"d6670766");
		check(B = x"79ea687a");
		check(C = x"6dc57a8a");
		check(D = x"34df1604");
		check(E = x"26352d63");
		check(F = x"1efbc0a0");
		check(G = x"f0781bc8");
		check(H = x"a507a53d");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"df46652f");
		check(B = x"d6670766");
		check(C = x"79ea687a");
		check(D = x"6dc57a8a");
		check(E = x"838b2711");
		check(F = x"26352d63");
		check(G = x"1efbc0a0");
		check(H = x"f0781bc8");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"17aa0dfe");
		check(B = x"df46652f");
		check(C = x"d6670766");
		check(D = x"79ea687a");
		check(E = x"decd4715");
		check(F = x"838b2711");
		check(G = x"26352d63");
		check(H = x"1efbc0a0");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"9d4baf93");
		check(B = x"17aa0dfe");
		check(C = x"df46652f");
		check(D = x"d6670766");
		check(E = x"fda24c2e");
		check(F = x"decd4715");
		check(G = x"838b2711");
		check(H = x"26352d63");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"26628815");
		check(B = x"9d4baf93");
		check(C = x"17aa0dfe");
		check(D = x"df46652f");
		check(E = x"a80f11f0");
		check(F = x"fda24c2e");
		check(G = x"decd4715");
		check(H = x"838b2711");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"72ab4b91");
		check(B = x"26628815");
		check(C = x"9d4baf93");
		check(D = x"17aa0dfe");
		check(E = x"b7755da1");
		check(F = x"a80f11f0");
		check(G = x"fda24c2e");
		check(H = x"decd4715");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"a14c14b0");
		check(B = x"72ab4b91");
		check(C = x"26628815");
		check(D = x"9d4baf93");
		check(E = x"d57b94a9");
		check(F = x"b7755da1");
		check(G = x"a80f11f0");
		check(H = x"fda24c2e");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"4172328d");
		check(B = x"a14c14b0");
		check(C = x"72ab4b91");
		check(D = x"26628815");
		check(E = x"fecf0bc6");
		check(F = x"d57b94a9");
		check(G = x"b7755da1");
		check(H = x"a80f11f0");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"05757ceb");
		check(B = x"4172328d");
		check(C = x"a14c14b0");
		check(D = x"72ab4b91");
		check(E = x"bd714038");
		check(F = x"fecf0bc6");
		check(G = x"d57b94a9");
		check(H = x"b7755da1");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"f11bfaa8");
		check(B = x"05757ceb");
		check(C = x"4172328d");
		check(D = x"a14c14b0");
		check(E = x"6e5c390c");
		check(F = x"bd714038");
		check(G = x"fecf0bc6");
		check(H = x"d57b94a9");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"7a0508a1");
		check(B = x"f11bfaa8");
		check(C = x"05757ceb");
		check(D = x"4172328d");
		check(E = x"52f1ccf7");
		check(F = x"6e5c390c");
		check(G = x"bd714038");
		check(H = x"fecf0bc6");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"886e7a22");
		check(B = x"7a0508a1");
		check(C = x"f11bfaa8");
		check(D = x"05757ceb");
		check(E = x"49231c1e");
		check(F = x"52f1ccf7");
		check(G = x"6e5c390c");
		check(H = x"bd714038");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"101fd28f");
		check(B = x"886e7a22");
		check(C = x"7a0508a1");
		check(D = x"f11bfaa8");
		check(E = x"529e7d00");
		check(F = x"49231c1e");
		check(G = x"52f1ccf7");
		check(H = x"6e5c390c");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"f5702fdb");
		check(B = x"101fd28f");
		check(C = x"886e7a22");
		check(D = x"7a0508a1");
		check(E = x"9f4787c3");
		check(F = x"529e7d00");
		check(G = x"49231c1e");
		check(H = x"52f1ccf7");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"3ec45cdb");
		check(B = x"f5702fdb");
		check(C = x"101fd28f");
		check(D = x"886e7a22");
		check(E = x"e50e1b4f");
		check(F = x"9f4787c3");
		check(G = x"529e7d00");
		check(H = x"49231c1e");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"38cc9913");
		check(B = x"3ec45cdb");
		check(C = x"f5702fdb");
		check(D = x"101fd28f");
		check(E = x"54cb266b");
		check(F = x"e50e1b4f");
		check(G = x"9f4787c3");
		check(H = x"529e7d00");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"fcd1887b");
		check(B = x"38cc9913");
		check(C = x"3ec45cdb");
		check(D = x"f5702fdb");
		check(E = x"9b5e906c");
		check(F = x"54cb266b");
		check(G = x"e50e1b4f");
		check(H = x"9f4787c3");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"c062d46f");
		check(B = x"fcd1887b");
		check(C = x"38cc9913");
		check(D = x"3ec45cdb");
		check(E = x"7e44008e");
		check(F = x"9b5e906c");
		check(G = x"54cb266b");
		check(H = x"e50e1b4f");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"ffb70472");
		check(B = x"c062d46f");
		check(C = x"fcd1887b");
		check(D = x"38cc9913");
		check(E = x"6d83bfc6");
		check(F = x"7e44008e");
		check(G = x"9b5e906c");
		check(H = x"54cb266b");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"b6ae8fff");
		check(B = x"ffb70472");
		check(C = x"c062d46f");
		check(D = x"fcd1887b");
		check(E = x"b21bad3d");
		check(F = x"6d83bfc6");
		check(G = x"7e44008e");
		check(H = x"9b5e906c");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"b85e2ce9");
		check(B = x"b6ae8fff");
		check(C = x"ffb70472");
		check(D = x"c062d46f");
		check(E = x"961f4894");
		check(F = x"b21bad3d");
		check(G = x"6d83bfc6");
		check(H = x"7e44008e");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"04d24d6c");
		check(B = x"b85e2ce9");
		check(C = x"b6ae8fff");
		check(D = x"ffb70472");
		check(E = x"948d25b6");
		check(F = x"961f4894");
		check(G = x"b21bad3d");
		check(H = x"6d83bfc6");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"d39a2165");
		check(B = x"04d24d6c");
		check(C = x"b85e2ce9");
		check(D = x"b6ae8fff");
		check(E = x"fb121210");
		check(F = x"948d25b6");
		check(G = x"961f4894");
		check(H = x"b21bad3d");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"506e3058");
		check(B = x"d39a2165");
		check(C = x"04d24d6c");
		check(D = x"b85e2ce9");
		check(E = x"5ef50f24");
		check(F = x"fb121210");
		check(G = x"948d25b6");
		check(H = x"961f4894");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"ba7816bf");
		check(H1_out = x"8f01cfea");
		check(H2_out = x"414140de");
		check(H3_out = x"5dae2223");
		check(H4_out = x"b00361a3");
		check(H5_out = x"96177a9c");
		check(H6_out = x"b410ff61");
		check(H7_out = x"f20015ad");

		test_runner_cleanup(runner);
	end process;

end sha256_test_2_tb_arch;

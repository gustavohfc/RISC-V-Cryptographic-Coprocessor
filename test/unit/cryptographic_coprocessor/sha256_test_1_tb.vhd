library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 8 bits message ("a")

entity sha256_test_1_tb IS
	generic(
		runner_cfg : string
	);
end sha256_test_1_tb;

architecture sha256_test_1_tb_arch OF sha256_test_1_tb IS
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

		-- Write the 8 bits message ("a")
		write_data_in <= '1';

		data_in               <= x"61000000";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(8, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"5d88884d");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"fa47e2a2");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"903c17db");
		check(B = x"5d88884d");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"1a7761e7");
		check(F = x"fa47e2a2");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"49e5a8a0");
		check(B = x"903c17db");
		check(C = x"5d88884d");
		check(D = x"6a09e667");
		check(E = x"02b7e680");
		check(F = x"1a7761e7");
		check(G = x"fa47e2a2");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"dcbb8518");
		check(B = x"49e5a8a0");
		check(C = x"903c17db");
		check(D = x"5d88884d");
		check(E = x"2b3f3e94");
		check(F = x"02b7e680");
		check(G = x"1a7761e7");
		check(H = x"fa47e2a2");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"2e86cb68");
		check(B = x"dcbb8518");
		check(C = x"49e5a8a0");
		check(D = x"903c17db");
		check(E = x"c1556635");
		check(F = x"2b3f3e94");
		check(G = x"02b7e680");
		check(H = x"1a7761e7");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"cba36fbe");
		check(B = x"2e86cb68");
		check(C = x"dcbb8518");
		check(D = x"49e5a8a0");
		check(E = x"c36a981b");
		check(F = x"c1556635");
		check(G = x"2b3f3e94");
		check(H = x"02b7e680");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"68caa79d");
		check(B = x"cba36fbe");
		check(C = x"2e86cb68");
		check(D = x"dcbb8518");
		check(E = x"a16c032b");
		check(F = x"c36a981b");
		check(G = x"c1556635");
		check(H = x"2b3f3e94");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"cc8f93b1");
		check(B = x"68caa79d");
		check(C = x"cba36fbe");
		check(D = x"2e86cb68");
		check(E = x"f2808efc");
		check(F = x"a16c032b");
		check(G = x"c36a981b");
		check(H = x"c1556635");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"40493eaa");
		check(B = x"cc8f93b1");
		check(C = x"68caa79d");
		check(D = x"cba36fbe");
		check(E = x"d5611ab3");
		check(F = x"f2808efc");
		check(G = x"a16c032b");
		check(H = x"c36a981b");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"7a230d12");
		check(B = x"40493eaa");
		check(C = x"cc8f93b1");
		check(D = x"68caa79d");
		check(E = x"bb3fe035");
		check(F = x"d5611ab3");
		check(G = x"f2808efc");
		check(H = x"a16c032b");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"a92495e9");
		check(B = x"7a230d12");
		check(C = x"40493eaa");
		check(D = x"cc8f93b1");
		check(E = x"4fb4c220");
		check(F = x"bb3fe035");
		check(G = x"d5611ab3");
		check(H = x"f2808efc");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"c1ce03cd");
		check(B = x"a92495e9");
		check(C = x"7a230d12");
		check(D = x"40493eaa");
		check(E = x"cee8aeda");
		check(F = x"4fb4c220");
		check(G = x"bb3fe035");
		check(H = x"d5611ab3");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"cb450c62");
		check(B = x"c1ce03cd");
		check(C = x"a92495e9");
		check(D = x"7a230d12");
		check(E = x"cc558bbf");
		check(F = x"cee8aeda");
		check(G = x"4fb4c220");
		check(H = x"bb3fe035");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"3d46f84c");
		check(B = x"cb450c62");
		check(C = x"c1ce03cd");
		check(D = x"a92495e9");
		check(E = x"282f6d58");
		check(F = x"cc558bbf");
		check(G = x"cee8aeda");
		check(H = x"4fb4c220");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"3680d5ca");
		check(B = x"3d46f84c");
		check(C = x"cb450c62");
		check(D = x"c1ce03cd");
		check(E = x"3f8dfe96");
		check(F = x"282f6d58");
		check(G = x"cc558bbf");
		check(H = x"cee8aeda");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"259420e1");
		check(B = x"3680d5ca");
		check(C = x"3d46f84c");
		check(D = x"cb450c62");
		check(E = x"87769eb6");
		check(F = x"3f8dfe96");
		check(G = x"282f6d58");
		check(H = x"cc558bbf");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"4d75f61f");
		check(B = x"259420e1");
		check(C = x"3680d5ca");
		check(D = x"3d46f84c");
		check(E = x"c44671aa");
		check(F = x"87769eb6");
		check(G = x"3f8dfe96");
		check(H = x"282f6d58");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"6f47f7e6");
		check(B = x"4d75f61f");
		check(C = x"259420e1");
		check(D = x"3680d5ca");
		check(E = x"d27a904a");
		check(F = x"c44671aa");
		check(G = x"87769eb6");
		check(H = x"3f8dfe96");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"dc9cade6");
		check(B = x"6f47f7e6");
		check(C = x"4d75f61f");
		check(D = x"259420e1");
		check(E = x"6a8a6e4e");
		check(F = x"d27a904a");
		check(G = x"c44671aa");
		check(H = x"87769eb6");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"3f1e0043");
		check(B = x"dc9cade6");
		check(C = x"6f47f7e6");
		check(D = x"4d75f61f");
		check(E = x"6cb5d450");
		check(F = x"6a8a6e4e");
		check(G = x"d27a904a");
		check(H = x"c44671aa");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"d9336c5a");
		check(B = x"3f1e0043");
		check(C = x"dc9cade6");
		check(D = x"6f47f7e6");
		check(E = x"f1ab4877");
		check(F = x"6cb5d450");
		check(G = x"6a8a6e4e");
		check(H = x"d27a904a");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"82f81927");
		check(B = x"d9336c5a");
		check(C = x"3f1e0043");
		check(D = x"dc9cade6");
		check(E = x"fbf66ae2");
		check(F = x"f1ab4877");
		check(G = x"6cb5d450");
		check(H = x"6a8a6e4e");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"124bd252");
		check(B = x"82f81927");
		check(C = x"d9336c5a");
		check(D = x"3f1e0043");
		check(E = x"89c7e873");
		check(F = x"fbf66ae2");
		check(G = x"f1ab4877");
		check(H = x"6cb5d450");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"af068b02");
		check(B = x"124bd252");
		check(C = x"82f81927");
		check(D = x"d9336c5a");
		check(E = x"225e0470");
		check(F = x"89c7e873");
		check(G = x"fbf66ae2");
		check(H = x"f1ab4877");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"2bc8c3c5");
		check(B = x"af068b02");
		check(C = x"124bd252");
		check(D = x"82f81927");
		check(E = x"98b8c4d5");
		check(F = x"225e0470");
		check(G = x"89c7e873");
		check(H = x"fbf66ae2");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"edad641a");
		check(B = x"2bc8c3c5");
		check(C = x"af068b02");
		check(D = x"124bd252");
		check(E = x"cd863fe7");
		check(F = x"98b8c4d5");
		check(G = x"225e0470");
		check(H = x"89c7e873");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"706b80d2");
		check(B = x"edad641a");
		check(C = x"2bc8c3c5");
		check(D = x"af068b02");
		check(E = x"a4fe3047");
		check(F = x"cd863fe7");
		check(G = x"98b8c4d5");
		check(H = x"225e0470");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"9c75cbdf");
		check(B = x"706b80d2");
		check(C = x"edad641a");
		check(D = x"2bc8c3c5");
		check(E = x"ad086b66");
		check(F = x"a4fe3047");
		check(G = x"cd863fe7");
		check(H = x"98b8c4d5");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"cd59660a");
		check(B = x"9c75cbdf");
		check(C = x"706b80d2");
		check(D = x"edad641a");
		check(E = x"8de579cd");
		check(F = x"ad086b66");
		check(G = x"a4fe3047");
		check(H = x"cd863fe7");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"69708e10");
		check(B = x"cd59660a");
		check(C = x"9c75cbdf");
		check(D = x"706b80d2");
		check(E = x"940c16d4");
		check(F = x"8de579cd");
		check(G = x"ad086b66");
		check(H = x"a4fe3047");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"e1ed49d1");
		check(B = x"69708e10");
		check(C = x"cd59660a");
		check(D = x"9c75cbdf");
		check(E = x"dbffd2e4");
		check(F = x"940c16d4");
		check(G = x"8de579cd");
		check(H = x"ad086b66");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"9b1e9e23");
		check(B = x"e1ed49d1");
		check(C = x"69708e10");
		check(D = x"cd59660a");
		check(E = x"ca480159");
		check(F = x"dbffd2e4");
		check(G = x"940c16d4");
		check(H = x"8de579cd");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"226dc32b");
		check(B = x"9b1e9e23");
		check(C = x"e1ed49d1");
		check(D = x"69708e10");
		check(E = x"98a6aa14");
		check(F = x"ca480159");
		check(G = x"dbffd2e4");
		check(H = x"940c16d4");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"d74dac4e");
		check(B = x"226dc32b");
		check(C = x"9b1e9e23");
		check(D = x"e1ed49d1");
		check(E = x"3681a00e");
		check(F = x"98a6aa14");
		check(G = x"ca480159");
		check(H = x"dbffd2e4");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"146c5e88");
		check(B = x"d74dac4e");
		check(C = x"226dc32b");
		check(D = x"9b1e9e23");
		check(E = x"81f7300b");
		check(F = x"3681a00e");
		check(G = x"98a6aa14");
		check(H = x"ca480159");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"655fc010");
		check(B = x"146c5e88");
		check(C = x"d74dac4e");
		check(D = x"226dc32b");
		check(E = x"a9eefb98");
		check(F = x"81f7300b");
		check(G = x"3681a00e");
		check(H = x"98a6aa14");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"2bc59acb");
		check(B = x"655fc010");
		check(C = x"146c5e88");
		check(D = x"d74dac4e");
		check(E = x"9210f67f");
		check(F = x"a9eefb98");
		check(G = x"81f7300b");
		check(H = x"3681a00e");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"d4524eb8");
		check(B = x"2bc59acb");
		check(C = x"655fc010");
		check(D = x"146c5e88");
		check(E = x"7b8f0c4d");
		check(F = x"9210f67f");
		check(G = x"a9eefb98");
		check(H = x"81f7300b");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"cbd4613e");
		check(B = x"d4524eb8");
		check(C = x"2bc59acb");
		check(D = x"655fc010");
		check(E = x"710022c1");
		check(F = x"7b8f0c4d");
		check(G = x"9210f67f");
		check(H = x"a9eefb98");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"d3f2f504");
		check(B = x"cbd4613e");
		check(C = x"d4524eb8");
		check(D = x"2bc59acb");
		check(E = x"82f6ac97");
		check(F = x"710022c1");
		check(G = x"7b8f0c4d");
		check(H = x"9210f67f");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"dde6b993");
		check(B = x"d3f2f504");
		check(C = x"cbd4613e");
		check(D = x"d4524eb8");
		check(E = x"decbbd89");
		check(F = x"82f6ac97");
		check(G = x"710022c1");
		check(H = x"7b8f0c4d");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"07c29440");
		check(B = x"dde6b993");
		check(C = x"d3f2f504");
		check(D = x"cbd4613e");
		check(E = x"5f1ce3bc");
		check(F = x"decbbd89");
		check(G = x"82f6ac97");
		check(H = x"710022c1");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"9983fe28");
		check(B = x"07c29440");
		check(C = x"dde6b993");
		check(D = x"d3f2f504");
		check(E = x"e3d40f4b");
		check(F = x"5f1ce3bc");
		check(G = x"decbbd89");
		check(H = x"82f6ac97");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"cbc48285");
		check(B = x"9983fe28");
		check(C = x"07c29440");
		check(D = x"dde6b993");
		check(E = x"29182996");
		check(F = x"e3d40f4b");
		check(G = x"5f1ce3bc");
		check(H = x"decbbd89");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"6a0b80f8");
		check(B = x"cbc48285");
		check(C = x"9983fe28");
		check(D = x"07c29440");
		check(E = x"475a3ae1");
		check(F = x"29182996");
		check(G = x"e3d40f4b");
		check(H = x"5f1ce3bc");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"7eb4a265");
		check(B = x"6a0b80f8");
		check(C = x"cbc48285");
		check(D = x"9983fe28");
		check(E = x"87b16233");
		check(F = x"475a3ae1");
		check(G = x"29182996");
		check(H = x"e3d40f4b");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"887dac0a");
		check(B = x"7eb4a265");
		check(C = x"6a0b80f8");
		check(D = x"cbc48285");
		check(E = x"196dde87");
		check(F = x"87b16233");
		check(G = x"475a3ae1");
		check(H = x"29182996");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"f2de96d6");
		check(B = x"887dac0a");
		check(C = x"7eb4a265");
		check(D = x"6a0b80f8");
		check(E = x"1f6a7625");
		check(F = x"196dde87");
		check(G = x"87b16233");
		check(H = x"475a3ae1");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"d383f5cb");
		check(B = x"f2de96d6");
		check(C = x"887dac0a");
		check(D = x"7eb4a265");
		check(E = x"d23767f3");
		check(F = x"1f6a7625");
		check(G = x"196dde87");
		check(H = x"87b16233");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"fcffa031");
		check(B = x"d383f5cb");
		check(C = x"f2de96d6");
		check(D = x"887dac0a");
		check(E = x"536b3fa9");
		check(F = x"d23767f3");
		check(G = x"1f6a7625");
		check(H = x"196dde87");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"18a6a044");
		check(B = x"fcffa031");
		check(C = x"d383f5cb");
		check(D = x"f2de96d6");
		check(E = x"2e13cf79");
		check(F = x"536b3fa9");
		check(G = x"d23767f3");
		check(H = x"1f6a7625");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"a58b807d");
		check(B = x"18a6a044");
		check(C = x"fcffa031");
		check(D = x"d383f5cb");
		check(E = x"2139f9cc");
		check(F = x"2e13cf79");
		check(G = x"536b3fa9");
		check(H = x"d23767f3");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"e54ab1c5");
		check(B = x"a58b807d");
		check(C = x"18a6a044");
		check(D = x"fcffa031");
		check(E = x"b790cc46");
		check(F = x"2139f9cc");
		check(G = x"2e13cf79");
		check(H = x"536b3fa9");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"0794c6d0");
		check(B = x"e54ab1c5");
		check(C = x"a58b807d");
		check(D = x"18a6a044");
		check(E = x"814f350b");
		check(F = x"b790cc46");
		check(G = x"2139f9cc");
		check(H = x"2e13cf79");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"9b6c6607");
		check(B = x"0794c6d0");
		check(C = x"e54ab1c5");
		check(D = x"a58b807d");
		check(E = x"aa0a386a");
		check(F = x"814f350b");
		check(G = x"b790cc46");
		check(H = x"2139f9cc");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"9c1b38fe");
		check(B = x"9b6c6607");
		check(C = x"0794c6d0");
		check(D = x"e54ab1c5");
		check(E = x"52d9f627");
		check(F = x"aa0a386a");
		check(G = x"814f350b");
		check(H = x"b790cc46");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"3cc865dc");
		check(B = x"9c1b38fe");
		check(C = x"9b6c6607");
		check(D = x"0794c6d0");
		check(E = x"76e4dc35");
		check(F = x"52d9f627");
		check(G = x"aa0a386a");
		check(H = x"814f350b");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"64573473");
		check(B = x"3cc865dc");
		check(C = x"9c1b38fe");
		check(D = x"9b6c6607");
		check(E = x"cf5f069e");
		check(F = x"76e4dc35");
		check(G = x"52d9f627");
		check(H = x"aa0a386a");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"fa76c8e4");
		check(B = x"64573473");
		check(C = x"3cc865dc");
		check(D = x"9c1b38fe");
		check(E = x"3328d7b9");
		check(F = x"cf5f069e");
		check(G = x"76e4dc35");
		check(H = x"52d9f627");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"9e76945a");
		check(B = x"fa76c8e4");
		check(C = x"64573473");
		check(D = x"3cc865dc");
		check(E = x"1ba175fe");
		check(F = x"3328d7b9");
		check(G = x"cf5f069e");
		check(H = x"76e4dc35");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"f4d3e713");
		check(B = x"9e76945a");
		check(C = x"fa76c8e4");
		check(D = x"64573473");
		check(E = x"540d7ba2");
		check(F = x"1ba175fe");
		check(G = x"3328d7b9");
		check(H = x"cf5f069e");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"be533e41");
		check(B = x"f4d3e713");
		check(C = x"9e76945a");
		check(D = x"fa76c8e4");
		check(E = x"99fc9dda");
		check(F = x"540d7ba2");
		check(G = x"1ba175fe");
		check(H = x"3328d7b9");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"0eb40f45");
		check(B = x"be533e41");
		check(C = x"f4d3e713");
		check(D = x"9e76945a");
		check(E = x"7976e5e6");
		check(F = x"99fc9dda");
		check(G = x"540d7ba2");
		check(H = x"1ba175fe");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"608d9aab");
		check(B = x"0eb40f45");
		check(C = x"be533e41");
		check(D = x"f4d3e713");
		check(E = x"56789d79");
		check(F = x"7976e5e6");
		check(G = x"99fc9dda");
		check(H = x"540d7ba2");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"ca978112");
		check(H1_out = x"ca1bbdca");
		check(H2_out = x"fac231b3");
		check(H3_out = x"9a23dc4d");
		check(H4_out = x"a786eff8");
		check(H5_out = x"147c4e72");
		check(H6_out = x"b9807785");
		check(H7_out = x"afee48bb");

		test_runner_cleanup(runner);
	end process;

end sha256_test_1_tb_arch;

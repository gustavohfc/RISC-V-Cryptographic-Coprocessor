library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 640 bits message ("12345678901234567890123456789012345678901234567890123456789012345678901234567890")

entity unit_sha256_test_7_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha256_test_7_tb;

architecture unit_sha256_test_7_tb_arch OF unit_sha256_test_7_tb IS
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

		-- Write the first 512 bits
		write_data_in <= '1';

		data_in               <= x"31323334";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"7";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"8";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"9";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"a";
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= x"b";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"c";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '0';
		wait until rising_edge(clk);
		calculate_next_block <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"2d3abb81");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"c9fa15d6");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"deca7c49");
		check(B = x"2d3abb81");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"7263fdb5");
		check(F = x"c9fa15d6");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"48161316");
		check(B = x"deca7c49");
		check(C = x"2d3abb81");
		check(D = x"6a09e667");
		check(E = x"d9657520");
		check(F = x"7263fdb5");
		check(G = x"c9fa15d6");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"f3cddabc");
		check(B = x"48161316");
		check(C = x"deca7c49");
		check(D = x"2d3abb81");
		check(E = x"bec1e8cd");
		check(F = x"d9657520");
		check(G = x"7263fdb5");
		check(H = x"c9fa15d6");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"1bf1b4fc");
		check(B = x"f3cddabc");
		check(C = x"48161316");
		check(D = x"deca7c49");
		check(E = x"8fdffb53");
		check(F = x"bec1e8cd");
		check(G = x"d9657520");
		check(H = x"7263fdb5");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"6bc132a9");
		check(B = x"1bf1b4fc");
		check(C = x"f3cddabc");
		check(D = x"48161316");
		check(E = x"86e6d959");
		check(F = x"8fdffb53");
		check(G = x"bec1e8cd");
		check(H = x"d9657520");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"e51e7e16");
		check(B = x"6bc132a9");
		check(C = x"1bf1b4fc");
		check(D = x"f3cddabc");
		check(E = x"e6012764");
		check(F = x"86e6d959");
		check(G = x"8fdffb53");
		check(H = x"bec1e8cd");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"4e5eec8f");
		check(B = x"e51e7e16");
		check(C = x"6bc132a9");
		check(D = x"1bf1b4fc");
		check(E = x"a652a3ad");
		check(F = x"e6012764");
		check(G = x"86e6d959");
		check(H = x"8fdffb53");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"67fb201a");
		check(B = x"4e5eec8f");
		check(C = x"e51e7e16");
		check(D = x"6bc132a9");
		check(E = x"482e619a");
		check(F = x"a652a3ad");
		check(G = x"e6012764");
		check(H = x"86e6d959");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"a10b1142");
		check(B = x"67fb201a");
		check(C = x"4e5eec8f");
		check(D = x"e51e7e16");
		check(E = x"2fc0398d");
		check(F = x"482e619a");
		check(G = x"a652a3ad");
		check(H = x"e6012764");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"1deba90a");
		check(B = x"a10b1142");
		check(C = x"67fb201a");
		check(D = x"4e5eec8f");
		check(E = x"8d9c408a");
		check(F = x"2fc0398d");
		check(G = x"482e619a");
		check(H = x"a652a3ad");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"faf8507e");
		check(B = x"1deba90a");
		check(C = x"a10b1142");
		check(D = x"67fb201a");
		check(E = x"c1ddee9b");
		check(F = x"8d9c408a");
		check(G = x"2fc0398d");
		check(H = x"482e619a");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"8c348d35");
		check(B = x"faf8507e");
		check(C = x"1deba90a");
		check(D = x"a10b1142");
		check(E = x"5e3c63cf");
		check(F = x"c1ddee9b");
		check(G = x"8d9c408a");
		check(H = x"2fc0398d");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"75a0730f");
		check(B = x"8c348d35");
		check(C = x"faf8507e");
		check(D = x"1deba90a");
		check(E = x"a11d663a");
		check(F = x"5e3c63cf");
		check(G = x"c1ddee9b");
		check(H = x"8d9c408a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"068093a5");
		check(B = x"75a0730f");
		check(C = x"8c348d35");
		check(D = x"faf8507e");
		check(E = x"62dc5f5a");
		check(F = x"a11d663a");
		check(G = x"5e3c63cf");
		check(H = x"c1ddee9b");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"c13819c5");
		check(B = x"068093a5");
		check(C = x"75a0730f");
		check(D = x"8c348d35");
		check(E = x"d8c95227");
		check(F = x"62dc5f5a");
		check(G = x"a11d663a");
		check(H = x"5e3c63cf");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"86ad870f");
		check(B = x"c13819c5");
		check(C = x"068093a5");
		check(D = x"75a0730f");
		check(E = x"6f3ae80a");
		check(F = x"d8c95227");
		check(G = x"62dc5f5a");
		check(H = x"a11d663a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"bb1331bd");
		check(B = x"86ad870f");
		check(C = x"c13819c5");
		check(D = x"068093a5");
		check(E = x"3a3fa692");
		check(F = x"6f3ae80a");
		check(G = x"d8c95227");
		check(H = x"62dc5f5a");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"5b157419");
		check(B = x"bb1331bd");
		check(C = x"86ad870f");
		check(D = x"c13819c5");
		check(E = x"2e6d1417");
		check(F = x"3a3fa692");
		check(G = x"6f3ae80a");
		check(H = x"d8c95227");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"bbd569f0");
		check(B = x"5b157419");
		check(C = x"bb1331bd");
		check(D = x"86ad870f");
		check(E = x"3e186dd7");
		check(F = x"2e6d1417");
		check(G = x"3a3fa692");
		check(H = x"6f3ae80a");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"777957b1");
		check(B = x"bbd569f0");
		check(C = x"5b157419");
		check(D = x"bb1331bd");
		check(E = x"0e3a26cf");
		check(F = x"3e186dd7");
		check(G = x"2e6d1417");
		check(H = x"3a3fa692");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"10984bc3");
		check(B = x"777957b1");
		check(C = x"bbd569f0");
		check(D = x"5b157419");
		check(E = x"4b4adbd4");
		check(F = x"0e3a26cf");
		check(G = x"3e186dd7");
		check(H = x"2e6d1417");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"861dd649");
		check(B = x"10984bc3");
		check(C = x"777957b1");
		check(D = x"bbd569f0");
		check(E = x"b2486401");
		check(F = x"4b4adbd4");
		check(G = x"0e3a26cf");
		check(H = x"3e186dd7");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"c17ed15e");
		check(B = x"861dd649");
		check(C = x"10984bc3");
		check(D = x"777957b1");
		check(E = x"c2a88029");
		check(F = x"b2486401");
		check(G = x"4b4adbd4");
		check(H = x"0e3a26cf");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"d97db073");
		check(B = x"c17ed15e");
		check(C = x"861dd649");
		check(D = x"10984bc3");
		check(E = x"0eed7035");
		check(F = x"c2a88029");
		check(G = x"b2486401");
		check(H = x"4b4adbd4");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"81f9d6dc");
		check(B = x"d97db073");
		check(C = x"c17ed15e");
		check(D = x"861dd649");
		check(E = x"4e13e9b0");
		check(F = x"0eed7035");
		check(G = x"c2a88029");
		check(H = x"b2486401");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"7768cd52");
		check(B = x"81f9d6dc");
		check(C = x"d97db073");
		check(D = x"c17ed15e");
		check(E = x"ca47cabf");
		check(F = x"4e13e9b0");
		check(G = x"0eed7035");
		check(H = x"c2a88029");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"cb325d1f");
		check(B = x"7768cd52");
		check(C = x"81f9d6dc");
		check(D = x"d97db073");
		check(E = x"66ba985c");
		check(F = x"ca47cabf");
		check(G = x"4e13e9b0");
		check(H = x"0eed7035");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"922ad871");
		check(B = x"cb325d1f");
		check(C = x"7768cd52");
		check(D = x"81f9d6dc");
		check(E = x"d4e8f98d");
		check(F = x"66ba985c");
		check(G = x"ca47cabf");
		check(H = x"4e13e9b0");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"db825a40");
		check(B = x"922ad871");
		check(C = x"cb325d1f");
		check(D = x"7768cd52");
		check(E = x"7de972c7");
		check(F = x"d4e8f98d");
		check(G = x"66ba985c");
		check(H = x"ca47cabf");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"6ecc83a2");
		check(B = x"db825a40");
		check(C = x"922ad871");
		check(D = x"cb325d1f");
		check(E = x"1d83aeb7");
		check(F = x"7de972c7");
		check(G = x"d4e8f98d");
		check(H = x"66ba985c");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"f737bcf8");
		check(B = x"6ecc83a2");
		check(C = x"db825a40");
		check(D = x"922ad871");
		check(E = x"33306080");
		check(F = x"1d83aeb7");
		check(G = x"7de972c7");
		check(H = x"d4e8f98d");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"b49d8d23");
		check(B = x"f737bcf8");
		check(C = x"6ecc83a2");
		check(D = x"db825a40");
		check(E = x"42481555");
		check(F = x"33306080");
		check(G = x"1d83aeb7");
		check(H = x"7de972c7");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"33ed2be6");
		check(B = x"b49d8d23");
		check(C = x"f737bcf8");
		check(D = x"6ecc83a2");
		check(E = x"26c3af0e");
		check(F = x"42481555");
		check(G = x"33306080");
		check(H = x"1d83aeb7");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"d6044c88");
		check(B = x"33ed2be6");
		check(C = x"b49d8d23");
		check(D = x"f737bcf8");
		check(E = x"25add4e9");
		check(F = x"26c3af0e");
		check(G = x"42481555");
		check(H = x"33306080");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"9a940b46");
		check(B = x"d6044c88");
		check(C = x"33ed2be6");
		check(D = x"b49d8d23");
		check(E = x"9a493a44");
		check(F = x"25add4e9");
		check(G = x"26c3af0e");
		check(H = x"42481555");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"14ca2f62");
		check(B = x"9a940b46");
		check(C = x"d6044c88");
		check(D = x"33ed2be6");
		check(E = x"8a26e4a4");
		check(F = x"9a493a44");
		check(G = x"25add4e9");
		check(H = x"26c3af0e");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"65f23702");
		check(B = x"14ca2f62");
		check(C = x"9a940b46");
		check(D = x"d6044c88");
		check(E = x"2cbbadcc");
		check(F = x"8a26e4a4");
		check(G = x"9a493a44");
		check(H = x"25add4e9");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"8313340d");
		check(B = x"65f23702");
		check(C = x"14ca2f62");
		check(D = x"9a940b46");
		check(E = x"5a91a58d");
		check(F = x"2cbbadcc");
		check(G = x"8a26e4a4");
		check(H = x"9a493a44");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"b443a20f");
		check(B = x"8313340d");
		check(C = x"65f23702");
		check(D = x"14ca2f62");
		check(E = x"bc8c92bd");
		check(F = x"5a91a58d");
		check(G = x"2cbbadcc");
		check(H = x"8a26e4a4");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"9296a7e8");
		check(B = x"b443a20f");
		check(C = x"8313340d");
		check(D = x"65f23702");
		check(E = x"0e282cec");
		check(F = x"bc8c92bd");
		check(G = x"5a91a58d");
		check(H = x"2cbbadcc");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"622904fb");
		check(B = x"9296a7e8");
		check(C = x"b443a20f");
		check(D = x"8313340d");
		check(E = x"f488f6eb");
		check(F = x"0e282cec");
		check(G = x"bc8c92bd");
		check(H = x"5a91a58d");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"825e1646");
		check(B = x"622904fb");
		check(C = x"9296a7e8");
		check(D = x"b443a20f");
		check(E = x"f82ae56a");
		check(F = x"f488f6eb");
		check(G = x"0e282cec");
		check(H = x"bc8c92bd");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"e3636607");
		check(B = x"825e1646");
		check(C = x"622904fb");
		check(D = x"9296a7e8");
		check(E = x"aa8e73c4");
		check(F = x"f82ae56a");
		check(G = x"f488f6eb");
		check(H = x"0e282cec");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"fb2f8a32");
		check(B = x"e3636607");
		check(C = x"825e1646");
		check(D = x"622904fb");
		check(E = x"65db4ebc");
		check(F = x"aa8e73c4");
		check(G = x"f82ae56a");
		check(H = x"f488f6eb");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"45cbe6ea");
		check(B = x"fb2f8a32");
		check(C = x"e3636607");
		check(D = x"825e1646");
		check(E = x"7310f5c3");
		check(F = x"65db4ebc");
		check(G = x"aa8e73c4");
		check(H = x"f82ae56a");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"f1f807f5");
		check(B = x"45cbe6ea");
		check(C = x"fb2f8a32");
		check(D = x"e3636607");
		check(E = x"072eb927");
		check(F = x"7310f5c3");
		check(G = x"65db4ebc");
		check(H = x"aa8e73c4");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"3f68f9ac");
		check(B = x"f1f807f5");
		check(C = x"45cbe6ea");
		check(D = x"fb2f8a32");
		check(E = x"8d127ec7");
		check(F = x"072eb927");
		check(G = x"7310f5c3");
		check(H = x"65db4ebc");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"8db5fc65");
		check(B = x"3f68f9ac");
		check(C = x"f1f807f5");
		check(D = x"45cbe6ea");
		check(E = x"b19f28da");
		check(F = x"8d127ec7");
		check(G = x"072eb927");
		check(H = x"7310f5c3");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"c815bf3c");
		check(B = x"8db5fc65");
		check(C = x"3f68f9ac");
		check(D = x"f1f807f5");
		check(E = x"f83823c1");
		check(F = x"b19f28da");
		check(G = x"8d127ec7");
		check(H = x"072eb927");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"61dd43a9");
		check(B = x"c815bf3c");
		check(C = x"8db5fc65");
		check(D = x"3f68f9ac");
		check(E = x"297f7230");
		check(F = x"f83823c1");
		check(G = x"b19f28da");
		check(H = x"8d127ec7");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"1bb76757");
		check(B = x"61dd43a9");
		check(C = x"c815bf3c");
		check(D = x"8db5fc65");
		check(E = x"6157664f");
		check(F = x"297f7230");
		check(G = x"f83823c1");
		check(H = x"b19f28da");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"83b22784");
		check(B = x"1bb76757");
		check(C = x"61dd43a9");
		check(D = x"c815bf3c");
		check(E = x"a60a64ac");
		check(F = x"6157664f");
		check(G = x"297f7230");
		check(H = x"f83823c1");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"6411f04f");
		check(B = x"83b22784");
		check(C = x"1bb76757");
		check(D = x"61dd43a9");
		check(E = x"5419c188");
		check(F = x"a60a64ac");
		check(G = x"6157664f");
		check(H = x"297f7230");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"ab157fa6");
		check(B = x"6411f04f");
		check(C = x"83b22784");
		check(D = x"1bb76757");
		check(E = x"ec80fafc");
		check(F = x"5419c188");
		check(G = x"a60a64ac");
		check(H = x"6157664f");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"eebb8f1f");
		check(B = x"ab157fa6");
		check(C = x"6411f04f");
		check(D = x"83b22784");
		check(E = x"6552e102");
		check(F = x"ec80fafc");
		check(G = x"5419c188");
		check(H = x"a60a64ac");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"a4db96dd");
		check(B = x"eebb8f1f");
		check(C = x"ab157fa6");
		check(D = x"6411f04f");
		check(E = x"cd0dd5b1");
		check(F = x"6552e102");
		check(G = x"ec80fafc");
		check(H = x"5419c188");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"9203dd6d");
		check(B = x"a4db96dd");
		check(C = x"eebb8f1f");
		check(D = x"ab157fa6");
		check(E = x"95f97825");
		check(F = x"cd0dd5b1");
		check(G = x"6552e102");
		check(H = x"ec80fafc");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"92c1181a");
		check(B = x"9203dd6d");
		check(C = x"a4db96dd");
		check(D = x"eebb8f1f");
		check(E = x"16a12756");
		check(F = x"95f97825");
		check(G = x"cd0dd5b1");
		check(H = x"6552e102");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"63aba2d4");
		check(B = x"92c1181a");
		check(C = x"9203dd6d");
		check(D = x"a4db96dd");
		check(E = x"5f9edb51");
		check(F = x"16a12756");
		check(G = x"95f97825");
		check(H = x"cd0dd5b1");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"972a463f");
		check(B = x"63aba2d4");
		check(C = x"92c1181a");
		check(D = x"9203dd6d");
		check(E = x"08bfa05a");
		check(F = x"5f9edb51");
		check(G = x"16a12756");
		check(H = x"95f97825");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"502a7e06");
		check(B = x"972a463f");
		check(C = x"63aba2d4");
		check(D = x"92c1181a");
		check(E = x"d15482d4");
		check(F = x"08bfa05a");
		check(G = x"5f9edb51");
		check(H = x"16a12756");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"077319cb");
		check(B = x"502a7e06");
		check(C = x"972a463f");
		check(D = x"63aba2d4");
		check(E = x"7949c43d");
		check(F = x"d15482d4");
		check(G = x"08bfa05a");
		check(H = x"5f9edb51");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"98775e53");
		check(B = x"077319cb");
		check(C = x"502a7e06");
		check(D = x"972a463f");
		check(E = x"2114d121");
		check(F = x"7949c43d");
		check(G = x"d15482d4");
		check(H = x"08bfa05a");

		-------------------------------------------- Round 2 --------------------------------------------

		wait until rising_edge(clk);

		check(is_waiting_next_block = '1');

		-- Write the last 128 bits
		write_data_in <= '1';

		data_in               <= x"35363738";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(128, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"748f579b");
		check(B = x"028144ba");
		check(C = x"c2dac850");
		check(D = x"8c997178");
		check(E = x"8e0da56e");
		check(F = x"722323a0");
		check(G = x"144f2cc9");
		check(H = x"f0d85c7f");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"5def9d31");
		check(B = x"748f579b");
		check(C = x"028144ba");
		check(D = x"c2dac850");
		check(E = x"4b57adc1");
		check(F = x"8e0da56e");
		check(G = x"722323a0");
		check(H = x"144f2cc9");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"a351fd17");
		check(B = x"5def9d31");
		check(C = x"748f579b");
		check(D = x"028144ba");
		check(E = x"1117a265");
		check(F = x"4b57adc1");
		check(G = x"8e0da56e");
		check(H = x"722323a0");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"32d5450f");
		check(B = x"a351fd17");
		check(C = x"5def9d31");
		check(D = x"748f579b");
		check(E = x"77e9716f");
		check(F = x"1117a265");
		check(G = x"4b57adc1");
		check(H = x"8e0da56e");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"aab4dc37");
		check(B = x"32d5450f");
		check(C = x"a351fd17");
		check(D = x"5def9d31");
		check(E = x"39955b99");
		check(F = x"77e9716f");
		check(G = x"1117a265");
		check(H = x"4b57adc1");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"2f6ff590");
		check(B = x"aab4dc37");
		check(C = x"32d5450f");
		check(D = x"a351fd17");
		check(E = x"1228f9a9");
		check(F = x"39955b99");
		check(G = x"77e9716f");
		check(H = x"1117a265");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"e1b14d05");
		check(B = x"2f6ff590");
		check(C = x"aab4dc37");
		check(D = x"32d5450f");
		check(E = x"4180ae5f");
		check(F = x"1228f9a9");
		check(G = x"39955b99");
		check(H = x"77e9716f");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"53020d3b");
		check(B = x"e1b14d05");
		check(C = x"2f6ff590");
		check(D = x"aab4dc37");
		check(E = x"04aa2be8");
		check(F = x"4180ae5f");
		check(G = x"1228f9a9");
		check(H = x"39955b99");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"c4780d85");
		check(B = x"53020d3b");
		check(C = x"e1b14d05");
		check(D = x"2f6ff590");
		check(E = x"56daa699");
		check(F = x"04aa2be8");
		check(G = x"4180ae5f");
		check(H = x"1228f9a9");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"c38fc192");
		check(B = x"c4780d85");
		check(C = x"53020d3b");
		check(D = x"e1b14d05");
		check(E = x"34c9726d");
		check(F = x"56daa699");
		check(G = x"04aa2be8");
		check(H = x"4180ae5f");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"5ee69eca");
		check(B = x"c38fc192");
		check(C = x"c4780d85");
		check(D = x"53020d3b");
		check(E = x"fa1a3728");
		check(F = x"34c9726d");
		check(G = x"56daa699");
		check(H = x"04aa2be8");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"9ceb23ca");
		check(B = x"5ee69eca");
		check(C = x"c38fc192");
		check(D = x"c4780d85");
		check(E = x"2d6e2986");
		check(F = x"fa1a3728");
		check(G = x"34c9726d");
		check(H = x"56daa699");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"9659d78d");
		check(B = x"9ceb23ca");
		check(C = x"5ee69eca");
		check(D = x"c38fc192");
		check(E = x"66015b70");
		check(F = x"2d6e2986");
		check(G = x"fa1a3728");
		check(H = x"34c9726d");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"7e8c5826");
		check(B = x"9659d78d");
		check(C = x"9ceb23ca");
		check(D = x"5ee69eca");
		check(E = x"e48b907a");
		check(F = x"66015b70");
		check(G = x"2d6e2986");
		check(H = x"fa1a3728");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"b31bc923");
		check(B = x"7e8c5826");
		check(C = x"9659d78d");
		check(D = x"9ceb23ca");
		check(E = x"034898ce");
		check(F = x"e48b907a");
		check(G = x"66015b70");
		check(H = x"2d6e2986");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"59aedae6");
		check(B = x"b31bc923");
		check(C = x"7e8c5826");
		check(D = x"9659d78d");
		check(E = x"7580412f");
		check(F = x"034898ce");
		check(G = x"e48b907a");
		check(H = x"66015b70");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"3dd15654");
		check(B = x"59aedae6");
		check(C = x"b31bc923");
		check(D = x"7e8c5826");
		check(E = x"5e697312");
		check(F = x"7580412f");
		check(G = x"034898ce");
		check(H = x"e48b907a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"1c8cdd1c");
		check(B = x"3dd15654");
		check(C = x"59aedae6");
		check(D = x"b31bc923");
		check(E = x"68f06ef4");
		check(F = x"5e697312");
		check(G = x"7580412f");
		check(H = x"034898ce");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"ea23c611");
		check(B = x"1c8cdd1c");
		check(C = x"3dd15654");
		check(D = x"59aedae6");
		check(E = x"a2fb0d8d");
		check(F = x"68f06ef4");
		check(G = x"5e697312");
		check(H = x"7580412f");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"d6e8b520");
		check(B = x"ea23c611");
		check(C = x"1c8cdd1c");
		check(D = x"3dd15654");
		check(E = x"2ef5d2c0");
		check(F = x"a2fb0d8d");
		check(G = x"68f06ef4");
		check(H = x"5e697312");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"90e5d868");
		check(B = x"d6e8b520");
		check(C = x"ea23c611");
		check(D = x"1c8cdd1c");
		check(E = x"b1a64056");
		check(F = x"2ef5d2c0");
		check(G = x"a2fb0d8d");
		check(H = x"68f06ef4");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"b0d98e11");
		check(B = x"90e5d868");
		check(C = x"d6e8b520");
		check(D = x"ea23c611");
		check(E = x"8a684396");
		check(F = x"b1a64056");
		check(G = x"2ef5d2c0");
		check(H = x"a2fb0d8d");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"bc3fc464");
		check(B = x"b0d98e11");
		check(C = x"90e5d868");
		check(D = x"d6e8b520");
		check(E = x"9af64aca");
		check(F = x"8a684396");
		check(G = x"b1a64056");
		check(H = x"2ef5d2c0");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"fe8a4920");
		check(B = x"bc3fc464");
		check(C = x"b0d98e11");
		check(D = x"90e5d868");
		check(E = x"3139afc9");
		check(F = x"9af64aca");
		check(G = x"8a684396");
		check(H = x"b1a64056");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"f38c3697");
		check(B = x"fe8a4920");
		check(C = x"bc3fc464");
		check(D = x"b0d98e11");
		check(E = x"68545cff");
		check(F = x"3139afc9");
		check(G = x"9af64aca");
		check(H = x"8a684396");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"80facd32");
		check(B = x"f38c3697");
		check(C = x"fe8a4920");
		check(D = x"bc3fc464");
		check(E = x"babf4915");
		check(F = x"68545cff");
		check(G = x"3139afc9");
		check(H = x"9af64aca");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"4a4cc5fb");
		check(B = x"80facd32");
		check(C = x"f38c3697");
		check(D = x"fe8a4920");
		check(E = x"f163be94");
		check(F = x"babf4915");
		check(G = x"68545cff");
		check(H = x"3139afc9");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"1e316111");
		check(B = x"4a4cc5fb");
		check(C = x"80facd32");
		check(D = x"f38c3697");
		check(E = x"8b90564d");
		check(F = x"f163be94");
		check(G = x"babf4915");
		check(H = x"68545cff");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"74c5ae3b");
		check(B = x"1e316111");
		check(C = x"4a4cc5fb");
		check(D = x"80facd32");
		check(E = x"d35831e8");
		check(F = x"8b90564d");
		check(G = x"f163be94");
		check(H = x"babf4915");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"f1d755c8");
		check(B = x"74c5ae3b");
		check(C = x"1e316111");
		check(D = x"4a4cc5fb");
		check(E = x"5a3a1d4f");
		check(F = x"d35831e8");
		check(G = x"8b90564d");
		check(H = x"f163be94");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"406f8b4a");
		check(B = x"f1d755c8");
		check(C = x"74c5ae3b");
		check(D = x"1e316111");
		check(E = x"4681741d");
		check(F = x"5a3a1d4f");
		check(G = x"d35831e8");
		check(H = x"8b90564d");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"03726630");
		check(B = x"406f8b4a");
		check(C = x"f1d755c8");
		check(D = x"74c5ae3b");
		check(E = x"3c776f48");
		check(F = x"4681741d");
		check(G = x"5a3a1d4f");
		check(H = x"d35831e8");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"c3eacf53");
		check(B = x"03726630");
		check(C = x"406f8b4a");
		check(D = x"f1d755c8");
		check(E = x"fe74f434");
		check(F = x"3c776f48");
		check(G = x"4681741d");
		check(H = x"5a3a1d4f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"3f318c16");
		check(B = x"c3eacf53");
		check(C = x"03726630");
		check(D = x"406f8b4a");
		check(E = x"cc442eff");
		check(F = x"fe74f434");
		check(G = x"3c776f48");
		check(H = x"4681741d");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"efda1b32");
		check(B = x"3f318c16");
		check(C = x"c3eacf53");
		check(D = x"03726630");
		check(E = x"038915f5");
		check(F = x"cc442eff");
		check(G = x"fe74f434");
		check(H = x"3c776f48");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"410bf64e");
		check(B = x"efda1b32");
		check(C = x"3f318c16");
		check(D = x"c3eacf53");
		check(E = x"4a7699c9");
		check(F = x"038915f5");
		check(G = x"cc442eff");
		check(H = x"fe74f434");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"2b20e92f");
		check(B = x"410bf64e");
		check(C = x"efda1b32");
		check(D = x"3f318c16");
		check(E = x"72064da4");
		check(F = x"4a7699c9");
		check(G = x"038915f5");
		check(H = x"cc442eff");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"4f8bc135");
		check(B = x"2b20e92f");
		check(C = x"410bf64e");
		check(D = x"efda1b32");
		check(E = x"239c723d");
		check(F = x"72064da4");
		check(G = x"4a7699c9");
		check(H = x"038915f5");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"b6f04bf1");
		check(B = x"4f8bc135");
		check(C = x"2b20e92f");
		check(D = x"410bf64e");
		check(E = x"e6722cc7");
		check(F = x"239c723d");
		check(G = x"72064da4");
		check(H = x"4a7699c9");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"3504b4cc");
		check(B = x"b6f04bf1");
		check(C = x"4f8bc135");
		check(D = x"2b20e92f");
		check(E = x"53517e40");
		check(F = x"e6722cc7");
		check(G = x"239c723d");
		check(H = x"72064da4");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"acce9479");
		check(B = x"3504b4cc");
		check(C = x"b6f04bf1");
		check(D = x"4f8bc135");
		check(E = x"e67b05f1");
		check(F = x"53517e40");
		check(G = x"e6722cc7");
		check(H = x"239c723d");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"5858a704");
		check(B = x"acce9479");
		check(C = x"3504b4cc");
		check(D = x"b6f04bf1");
		check(E = x"0070ad67");
		check(F = x"e67b05f1");
		check(G = x"53517e40");
		check(H = x"e6722cc7");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"3e484fa1");
		check(B = x"5858a704");
		check(C = x"acce9479");
		check(D = x"3504b4cc");
		check(E = x"6c42ece1");
		check(F = x"0070ad67");
		check(G = x"e67b05f1");
		check(H = x"53517e40");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"ffc694b8");
		check(B = x"3e484fa1");
		check(C = x"5858a704");
		check(D = x"acce9479");
		check(E = x"e4dd5d10");
		check(F = x"6c42ece1");
		check(G = x"0070ad67");
		check(H = x"e67b05f1");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"7699aafa");
		check(B = x"ffc694b8");
		check(C = x"3e484fa1");
		check(D = x"5858a704");
		check(E = x"24bafeee");
		check(F = x"e4dd5d10");
		check(G = x"6c42ece1");
		check(H = x"0070ad67");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"6f696d4a");
		check(B = x"7699aafa");
		check(C = x"ffc694b8");
		check(D = x"3e484fa1");
		check(E = x"9c1b4ded");
		check(F = x"24bafeee");
		check(G = x"e4dd5d10");
		check(H = x"6c42ece1");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"a703dcea");
		check(B = x"6f696d4a");
		check(C = x"7699aafa");
		check(D = x"ffc694b8");
		check(E = x"114675ed");
		check(F = x"9c1b4ded");
		check(G = x"24bafeee");
		check(H = x"e4dd5d10");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"fd411517");
		check(B = x"a703dcea");
		check(C = x"6f696d4a");
		check(D = x"7699aafa");
		check(E = x"5417572d");
		check(F = x"114675ed");
		check(G = x"9c1b4ded");
		check(H = x"24bafeee");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"92ff5889");
		check(B = x"fd411517");
		check(C = x"a703dcea");
		check(D = x"6f696d4a");
		check(E = x"c69bb581");
		check(F = x"5417572d");
		check(G = x"114675ed");
		check(H = x"9c1b4ded");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"a5788e90");
		check(B = x"92ff5889");
		check(C = x"fd411517");
		check(D = x"a703dcea");
		check(E = x"000d37bc");
		check(F = x"c69bb581");
		check(G = x"5417572d");
		check(H = x"114675ed");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"75dc7637");
		check(B = x"a5788e90");
		check(C = x"92ff5889");
		check(D = x"fd411517");
		check(E = x"a785eb9b");
		check(F = x"000d37bc");
		check(G = x"c69bb581");
		check(H = x"5417572d");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"58d09715");
		check(B = x"75dc7637");
		check(C = x"a5788e90");
		check(D = x"92ff5889");
		check(E = x"8300dee2");
		check(F = x"a785eb9b");
		check(G = x"000d37bc");
		check(H = x"c69bb581");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"63ebb7b0");
		check(B = x"58d09715");
		check(C = x"75dc7637");
		check(D = x"a5788e90");
		check(E = x"d44fc402");
		check(F = x"8300dee2");
		check(G = x"a785eb9b");
		check(H = x"000d37bc");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"cc58d39a");
		check(B = x"63ebb7b0");
		check(C = x"58d09715");
		check(D = x"75dc7637");
		check(E = x"f45177b7");
		check(F = x"d44fc402");
		check(G = x"8300dee2");
		check(H = x"a785eb9b");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"5df9487a");
		check(B = x"cc58d39a");
		check(C = x"63ebb7b0");
		check(D = x"58d09715");
		check(E = x"3e6eea10");
		check(F = x"f45177b7");
		check(G = x"d44fc402");
		check(H = x"8300dee2");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"29390d4a");
		check(B = x"5df9487a");
		check(C = x"cc58d39a");
		check(D = x"63ebb7b0");
		check(E = x"02827c02");
		check(F = x"3e6eea10");
		check(G = x"f45177b7");
		check(H = x"d44fc402");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"20fde937");
		check(B = x"29390d4a");
		check(C = x"5df9487a");
		check(D = x"cc58d39a");
		check(E = x"3346354f");
		check(F = x"02827c02");
		check(G = x"3e6eea10");
		check(H = x"f45177b7");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"f59cd3d4");
		check(B = x"20fde937");
		check(C = x"29390d4a");
		check(D = x"5df9487a");
		check(E = x"21d9bcd3");
		check(F = x"3346354f");
		check(G = x"02827c02");
		check(H = x"3e6eea10");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"1ff5f9e3");
		check(B = x"f59cd3d4");
		check(C = x"20fde937");
		check(D = x"29390d4a");
		check(E = x"8ba1ad42");
		check(F = x"21d9bcd3");
		check(G = x"3346354f");
		check(H = x"02827c02");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"022b7527");
		check(B = x"1ff5f9e3");
		check(C = x"f59cd3d4");
		check(D = x"20fde937");
		check(E = x"16647ad2");
		check(F = x"8ba1ad42");
		check(G = x"21d9bcd3");
		check(H = x"3346354f");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"9bc26c95");
		check(B = x"022b7527");
		check(C = x"1ff5f9e3");
		check(D = x"f59cd3d4");
		check(E = x"e09c13cb");
		check(F = x"16647ad2");
		check(G = x"8ba1ad42");
		check(H = x"21d9bcd3");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"125623b5");
		check(B = x"9bc26c95");
		check(C = x"022b7527");
		check(D = x"1ff5f9e3");
		check(E = x"e0216689");
		check(F = x"e09c13cb");
		check(G = x"16647ad2");
		check(H = x"8ba1ad42");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"6e4462b0");
		check(B = x"125623b5");
		check(C = x"9bc26c95");
		check(D = x"022b7527");
		check(E = x"7a4428c9");
		check(F = x"e0216689");
		check(G = x"e09c13cb");
		check(H = x"16647ad2");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"f0f07790");
		check(B = x"6e4462b0");
		check(C = x"125623b5");
		check(D = x"9bc26c95");
		check(E = x"b93cdecc");
		check(F = x"7a4428c9");
		check(G = x"e0216689");
		check(H = x"e09c13cb");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"f371bc4a");
		check(H1_out = x"311f2b00");
		check(H2_out = x"9eef952d");
		check(H3_out = x"d83ca80e");
		check(H4_out = x"2b60026c");
		check(H5_out = x"8e935592");
		check(H6_out = x"d0f9c308");
		check(H7_out = x"453c813e");

		test_runner_cleanup(runner);
	end process;

end unit_sha256_test_7_tb_arch;

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 640 bits message ("12345678901234567890123456789012345678901234567890123456789012345678901234567890")

entity unit_md5_test_6_tb IS
	generic(
		runner_cfg : string
	);
end unit_md5_test_6_tb;

architecture unit_md5_test_6_tb_arch OF unit_md5_test_6_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal calculate_next_block  : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : md5_error_type;
	signal A                     : unsigned(31 downto 0) := (others => '0');
	signal B                     : unsigned(31 downto 0) := (others => '0');
	signal C                     : unsigned(31 downto 0) := (others => '0');
	signal D                     : unsigned(31 downto 0) := (others => '0');

begin
	md5 : entity work.md5
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

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"beb8ff8e");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"7d989d89");
		check(C = x"beb8ff8e");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"f8cdf95d");
		check(C = x"7d989d89");
		check(D = x"beb8ff8e");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"beb8ff8e");
		check(B = x"862797b0");
		check(C = x"f8cdf95d");
		check(D = x"7d989d89");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"7d989d89");
		check(B = x"8c17de9f");
		check(C = x"862797b0");
		check(D = x"f8cdf95d");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"f8cdf95d");
		check(B = x"c0f32d81");
		check(C = x"8c17de9f");
		check(D = x"862797b0");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"862797b0");
		check(B = x"e99fec1b");
		check(C = x"c0f32d81");
		check(D = x"8c17de9f");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"8c17de9f");
		check(B = x"c57e78c1");
		check(C = x"e99fec1b");
		check(D = x"c0f32d81");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"c0f32d81");
		check(B = x"7c0aceb7");
		check(C = x"c57e78c1");
		check(D = x"e99fec1b");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"e99fec1b");
		check(B = x"8869d2d8");
		check(C = x"7c0aceb7");
		check(D = x"c57e78c1");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"c57e78c1");
		check(B = x"5186a8ba");
		check(C = x"8869d2d8");
		check(D = x"7c0aceb7");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"7c0aceb7");
		check(B = x"a5f36f8d");
		check(C = x"5186a8ba");
		check(D = x"8869d2d8");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"8869d2d8");
		check(B = x"5157e49e");
		check(C = x"a5f36f8d");
		check(D = x"5186a8ba");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"5186a8ba");
		check(B = x"ffac907e");
		check(C = x"5157e49e");
		check(D = x"a5f36f8d");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"a5f36f8d");
		check(B = x"27e983a0");
		check(C = x"ffac907e");
		check(D = x"5157e49e");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"5157e49e");
		check(B = x"af506a03");
		check(C = x"27e983a0");
		check(D = x"ffac907e");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"ffac907e");
		check(B = x"8d18e0e8");
		check(C = x"af506a03");
		check(D = x"27e983a0");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"27e983a0");
		check(B = x"07de0df2");
		check(C = x"8d18e0e8");
		check(D = x"af506a03");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"af506a03");
		check(B = x"ef223167");
		check(C = x"07de0df2");
		check(D = x"8d18e0e8");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"8d18e0e8");
		check(B = x"04280170");
		check(C = x"ef223167");
		check(D = x"07de0df2");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"07de0df2");
		check(B = x"78929ee0");
		check(C = x"04280170");
		check(D = x"ef223167");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"ef223167");
		check(B = x"375c6c2c");
		check(C = x"78929ee0");
		check(D = x"04280170");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"04280170");
		check(B = x"b18aca50");
		check(C = x"375c6c2c");
		check(D = x"78929ee0");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"78929ee0");
		check(B = x"ad400a91");
		check(C = x"b18aca50");
		check(D = x"375c6c2c");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"375c6c2c");
		check(B = x"bb45f43f");
		check(C = x"ad400a91");
		check(D = x"b18aca50");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"b18aca50");
		check(B = x"d61f8a0f");
		check(C = x"bb45f43f");
		check(D = x"ad400a91");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"ad400a91");
		check(B = x"98ade6b5");
		check(C = x"d61f8a0f");
		check(D = x"bb45f43f");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"bb45f43f");
		check(B = x"b70e35a9");
		check(C = x"98ade6b5");
		check(D = x"d61f8a0f");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"d61f8a0f");
		check(B = x"f8bcfbb0");
		check(C = x"b70e35a9");
		check(D = x"98ade6b5");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"98ade6b5");
		check(B = x"d760ed39");
		check(C = x"f8bcfbb0");
		check(D = x"b70e35a9");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"b70e35a9");
		check(B = x"99a0f1b8");
		check(C = x"d760ed39");
		check(D = x"f8bcfbb0");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"f8bcfbb0");
		check(B = x"1bf25662");
		check(C = x"99a0f1b8");
		check(D = x"d760ed39");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"d760ed39");
		check(B = x"3dbd76ca");
		check(C = x"1bf25662");
		check(D = x"99a0f1b8");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"99a0f1b8");
		check(B = x"fd056171");
		check(C = x"3dbd76ca");
		check(D = x"1bf25662");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"1bf25662");
		check(B = x"c7ed7c30");
		check(C = x"fd056171");
		check(D = x"3dbd76ca");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"3dbd76ca");
		check(B = x"e0162f49");
		check(C = x"c7ed7c30");
		check(D = x"fd056171");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"fd056171");
		check(B = x"3b32c408");
		check(C = x"e0162f49");
		check(D = x"c7ed7c30");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"c7ed7c30");
		check(B = x"7338d8b7");
		check(C = x"3b32c408");
		check(D = x"e0162f49");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"e0162f49");
		check(B = x"9ef871ad");
		check(C = x"7338d8b7");
		check(D = x"3b32c408");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"3b32c408");
		check(B = x"1d4d6f72");
		check(C = x"9ef871ad");
		check(D = x"7338d8b7");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"7338d8b7");
		check(B = x"c661460a");
		check(C = x"1d4d6f72");
		check(D = x"9ef871ad");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"9ef871ad");
		check(B = x"d2bf04c9");
		check(C = x"c661460a");
		check(D = x"1d4d6f72");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"1d4d6f72");
		check(B = x"d6d5b879");
		check(C = x"d2bf04c9");
		check(D = x"c661460a");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"c661460a");
		check(B = x"89e3c4d7");
		check(C = x"d6d5b879");
		check(D = x"d2bf04c9");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"d2bf04c9");
		check(B = x"697032ec");
		check(C = x"89e3c4d7");
		check(D = x"d6d5b879");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"d6d5b879");
		check(B = x"fa597bfc");
		check(C = x"697032ec");
		check(D = x"89e3c4d7");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"89e3c4d7");
		check(B = x"efc2c171");
		check(C = x"fa597bfc");
		check(D = x"697032ec");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"697032ec");
		check(B = x"db4197da");
		check(C = x"efc2c171");
		check(D = x"fa597bfc");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"fa597bfc");
		check(B = x"57b91aca");
		check(C = x"db4197da");
		check(D = x"efc2c171");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"efc2c171");
		check(B = x"210c9ebc");
		check(C = x"57b91aca");
		check(D = x"db4197da");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"db4197da");
		check(B = x"21efbd88");
		check(C = x"210c9ebc");
		check(D = x"57b91aca");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"57b91aca");
		check(B = x"caa25b01");
		check(C = x"21efbd88");
		check(D = x"210c9ebc");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"210c9ebc");
		check(B = x"633d3f7c");
		check(C = x"caa25b01");
		check(D = x"21efbd88");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"21efbd88");
		check(B = x"1a4d3beb");
		check(C = x"633d3f7c");
		check(D = x"caa25b01");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"caa25b01");
		check(B = x"ccaa1524");
		check(C = x"1a4d3beb");
		check(D = x"633d3f7c");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"633d3f7c");
		check(B = x"7713f5df");
		check(C = x"ccaa1524");
		check(D = x"1a4d3beb");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"1a4d3beb");
		check(B = x"8448b430");
		check(C = x"7713f5df");
		check(D = x"ccaa1524");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"ccaa1524");
		check(B = x"71c93463");
		check(C = x"8448b430");
		check(D = x"7713f5df");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"7713f5df");
		check(B = x"7e294727");
		check(C = x"71c93463");
		check(D = x"8448b430");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"8448b430");
		check(B = x"660a801d");
		check(C = x"7e294727");
		check(D = x"71c93463");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"71c93463");
		check(B = x"614868eb");
		check(C = x"660a801d");
		check(D = x"7e294727");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"7e294727");
		check(B = x"a09f38a7");
		check(C = x"614868eb");
		check(D = x"660a801d");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"660a801d");
		check(B = x"5133129b");
		check(C = x"a09f38a7");
		check(D = x"614868eb");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"614868eb");
		check(B = x"b4d33102");
		check(C = x"5133129b");
		check(D = x"a09f38a7");

		-- Round result
		wait until rising_edge(clk);
		check(A = x"c88d8bec");
		check(B = x"a4a0dc8b");
		check(C = x"e9edef99");
		check(D = x"b0d18d1d");

		-------------------------------------------- Round 2 --------------------------------------------

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
		check(A = x"b0d18d1d");
		check(B = x"353af7cf");
		check(C = x"a4a0dc8b");
		check(D = x"e9edef99");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"e9edef99");
		check(B = x"3a4f735a");
		check(C = x"353af7cf");
		check(D = x"a4a0dc8b");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"a4a0dc8b");
		check(B = x"63356537");
		check(C = x"3a4f735a");
		check(D = x"353af7cf");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"353af7cf");
		check(B = x"45e88f2c");
		check(C = x"63356537");
		check(D = x"3a4f735a");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"3a4f735a");
		check(B = x"3527497e");
		check(C = x"45e88f2c");
		check(D = x"63356537");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"63356537");
		check(B = x"ab92660e");
		check(C = x"3527497e");
		check(D = x"45e88f2c");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"45e88f2c");
		check(B = x"948347ae");
		check(C = x"ab92660e");
		check(D = x"3527497e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"3527497e");
		check(B = x"377c7d0a");
		check(C = x"948347ae");
		check(D = x"ab92660e");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"ab92660e");
		check(B = x"cc912f27");
		check(C = x"377c7d0a");
		check(D = x"948347ae");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"948347ae");
		check(B = x"6945a3d5");
		check(C = x"cc912f27");
		check(D = x"377c7d0a");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"377c7d0a");
		check(B = x"ae23894d");
		check(C = x"6945a3d5");
		check(D = x"cc912f27");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"cc912f27");
		check(B = x"b9ede40c");
		check(C = x"ae23894d");
		check(D = x"6945a3d5");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"6945a3d5");
		check(B = x"db4ff71c");
		check(C = x"b9ede40c");
		check(D = x"ae23894d");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"ae23894d");
		check(B = x"9b6b4960");
		check(C = x"db4ff71c");
		check(D = x"b9ede40c");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"b9ede40c");
		check(B = x"04396a39");
		check(C = x"9b6b4960");
		check(D = x"db4ff71c");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"db4ff71c");
		check(B = x"58b12eab");
		check(C = x"04396a39");
		check(D = x"9b6b4960");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"9b6b4960");
		check(B = x"52c00cae");
		check(C = x"58b12eab");
		check(D = x"04396a39");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"04396a39");
		check(B = x"aad2a216");
		check(C = x"52c00cae");
		check(D = x"58b12eab");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"58b12eab");
		check(B = x"a476af6f");
		check(C = x"aad2a216");
		check(D = x"52c00cae");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"52c00cae");
		check(B = x"50f8de8c");
		check(C = x"a476af6f");
		check(D = x"aad2a216");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"aad2a216");
		check(B = x"0d6e6d91");
		check(C = x"50f8de8c");
		check(D = x"a476af6f");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"a476af6f");
		check(B = x"17d64195");
		check(C = x"0d6e6d91");
		check(D = x"50f8de8c");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"50f8de8c");
		check(B = x"d5b7a850");
		check(C = x"17d64195");
		check(D = x"0d6e6d91");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"0d6e6d91");
		check(B = x"043cb080");
		check(C = x"d5b7a850");
		check(D = x"17d64195");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"17d64195");
		check(B = x"74f9377e");
		check(C = x"043cb080");
		check(D = x"d5b7a850");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"d5b7a850");
		check(B = x"01f2addd");
		check(C = x"74f9377e");
		check(D = x"043cb080");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"043cb080");
		check(B = x"e775c8ca");
		check(C = x"01f2addd");
		check(D = x"74f9377e");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"74f9377e");
		check(B = x"cb00b96e");
		check(C = x"e775c8ca");
		check(D = x"01f2addd");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"01f2addd");
		check(B = x"8761f38e");
		check(C = x"cb00b96e");
		check(D = x"e775c8ca");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"e775c8ca");
		check(B = x"7a516116");
		check(C = x"8761f38e");
		check(D = x"cb00b96e");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"cb00b96e");
		check(B = x"061bc867");
		check(C = x"7a516116");
		check(D = x"8761f38e");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"8761f38e");
		check(B = x"67092c33");
		check(C = x"061bc867");
		check(D = x"7a516116");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"7a516116");
		check(B = x"91044d5d");
		check(C = x"67092c33");
		check(D = x"061bc867");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"061bc867");
		check(B = x"610954eb");
		check(C = x"91044d5d");
		check(D = x"67092c33");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"67092c33");
		check(B = x"c0175fa8");
		check(C = x"610954eb");
		check(D = x"91044d5d");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"91044d5d");
		check(B = x"2ee1e3fe");
		check(C = x"c0175fa8");
		check(D = x"610954eb");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"610954eb");
		check(B = x"ae26ed7d");
		check(C = x"2ee1e3fe");
		check(D = x"c0175fa8");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"c0175fa8");
		check(B = x"71d8ecea");
		check(C = x"ae26ed7d");
		check(D = x"2ee1e3fe");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"2ee1e3fe");
		check(B = x"ff4a94dc");
		check(C = x"71d8ecea");
		check(D = x"ae26ed7d");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"ae26ed7d");
		check(B = x"dbd1bff6");
		check(C = x"ff4a94dc");
		check(D = x"71d8ecea");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"71d8ecea");
		check(B = x"9c350028");
		check(C = x"dbd1bff6");
		check(D = x"ff4a94dc");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"ff4a94dc");
		check(B = x"97e5da92");
		check(C = x"9c350028");
		check(D = x"dbd1bff6");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"dbd1bff6");
		check(B = x"facaaf06");
		check(C = x"97e5da92");
		check(D = x"9c350028");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"9c350028");
		check(B = x"56b3692f");
		check(C = x"facaaf06");
		check(D = x"97e5da92");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"97e5da92");
		check(B = x"71123afa");
		check(C = x"56b3692f");
		check(D = x"facaaf06");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"facaaf06");
		check(B = x"dc9c8ddb");
		check(C = x"71123afa");
		check(D = x"56b3692f");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"56b3692f");
		check(B = x"e6a8a386");
		check(C = x"dc9c8ddb");
		check(D = x"71123afa");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"71123afa");
		check(B = x"1df7010a");
		check(C = x"e6a8a386");
		check(D = x"dc9c8ddb");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"dc9c8ddb");
		check(B = x"d29007e7");
		check(C = x"1df7010a");
		check(D = x"e6a8a386");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"e6a8a386");
		check(B = x"7241a77e");
		check(C = x"d29007e7");
		check(D = x"1df7010a");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"1df7010a");
		check(B = x"d3248109");
		check(C = x"7241a77e");
		check(D = x"d29007e7");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"d29007e7");
		check(B = x"c8797828");
		check(C = x"d3248109");
		check(D = x"7241a77e");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"7241a77e");
		check(B = x"7a504abd");
		check(C = x"c8797828");
		check(D = x"d3248109");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"d3248109");
		check(B = x"211cc65d");
		check(C = x"7a504abd");
		check(D = x"c8797828");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"c8797828");
		check(B = x"a290d6ce");
		check(C = x"211cc65d");
		check(D = x"7a504abd");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"7a504abd");
		check(B = x"9b31b114");
		check(C = x"a290d6ce");
		check(D = x"211cc65d");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"211cc65d");
		check(B = x"723fd22d");
		check(C = x"9b31b114");
		check(D = x"a290d6ce");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"a290d6ce");
		check(B = x"d21d6a3b");
		check(C = x"723fd22d");
		check(D = x"9b31b114");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"9b31b114");
		check(B = x"3d79cf74");
		check(C = x"d21d6a3b");
		check(D = x"723fd22d");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"723fd22d");
		check(B = x"4dc4f33d");
		check(C = x"3d79cf74");
		check(D = x"d21d6a3b");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"d21d6a3b");
		check(B = x"da67616b");
		check(C = x"4dc4f33d");
		check(D = x"3d79cf74");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"3d79cf74");
		check(B = x"c9e47a04");
		check(C = x"da67616b");
		check(D = x"4dc4f33d");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"4dc4f33d");
		check(B = x"44ec5a13");
		check(C = x"c9e47a04");
		check(D = x"da67616b");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"da67616b");
		check(B = x"b12906a0");
		check(C = x"44ec5a13");
		check(D = x"c9e47a04");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"57edf4a2");
		check(B = x"2be3c955");
		check(C = x"ac49da2e");
		check(D = x"2107b67a");

		test_runner_cleanup(runner);
	end process;

end unit_md5_test_6_tb_arch;

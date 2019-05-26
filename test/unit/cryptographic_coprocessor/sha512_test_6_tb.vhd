library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")

entity sha512_test_6_tb IS
	generic(
		runner_cfg : string
	);
end sha512_test_6_tb;

architecture sha512_test_6_tb_arch OF sha512_test_6_tb IS
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

		-- Write the 512 bits message ("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl")
		write_data_in <= '1';

		data_in               <= x"61626364";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		data_in               <= x"65666768";
		data_in_word_position <= to_unsigned(1, 5);
		wait until rising_edge(clk);

		data_in               <= x"696a6b6c";
		data_in_word_position <= to_unsigned(2, 5);
		wait until rising_edge(clk);

		data_in               <= x"6d6e6f70";
		data_in_word_position <= to_unsigned(3, 5);
		wait until rising_edge(clk);

		data_in               <= x"71727374";
		data_in_word_position <= to_unsigned(4, 5);
		wait until rising_edge(clk);

		data_in               <= x"75767778";
		data_in_word_position <= to_unsigned(5, 5);
		wait until rising_edge(clk);

		data_in               <= x"797a6162";
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

		data_in               <= x"61626364";
		data_in_word_position <= to_unsigned(13, 5);
		wait until rising_edge(clk);

		data_in               <= x"65666768";
		data_in_word_position <= to_unsigned(14, 5);
		wait until rising_edge(clk);

		data_in               <= x"696a6b6c";
		data_in_word_position <= to_unsigned(15, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(512, 11);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"f6afce9d2263455d");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"58cb0218e01b86f9");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"12775dac3bb56669");
		check(B = x"f6afce9d2263455d");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"ffce2096eaa55393");
		check(F = x"58cb0218e01b86f9");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"ccdda1221b49c11f");
		check(B = x"12775dac3bb56669");
		check(C = x"f6afce9d2263455d");
		check(D = x"6a09e667f3bcc908");
		check(E = x"28492b32ba923ffe");
		check(F = x"ffce2096eaa55393");
		check(G = x"58cb0218e01b86f9");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"63dbd1b0d346be87");
		check(B = x"ccdda1221b49c11f");
		check(C = x"12775dac3bb56669");
		check(D = x"f6afce9d2263455d");
		check(E = x"806cf8338a2d8107");
		check(F = x"28492b32ba923ffe");
		check(G = x"ffce2096eaa55393");
		check(H = x"58cb0218e01b86f9");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"9aebea498d263847");
		check(B = x"63dbd1b0d346be87");
		check(C = x"ccdda1221b49c11f");
		check(D = x"12775dac3bb56669");
		check(E = x"ed9f1c9ba8b73ed3");
		check(F = x"806cf8338a2d8107");
		check(G = x"28492b32ba923ffe");
		check(H = x"ffce2096eaa55393");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"afb71ceced7b63b5");
		check(B = x"9aebea498d263847");
		check(C = x"63dbd1b0d346be87");
		check(D = x"ccdda1221b49c11f");
		check(E = x"d522535fc6b88839");
		check(F = x"ed9f1c9ba8b73ed3");
		check(G = x"806cf8338a2d8107");
		check(H = x"28492b32ba923ffe");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"85884b6ce22f18cc");
		check(B = x"afb71ceced7b63b5");
		check(C = x"9aebea498d263847");
		check(D = x"63dbd1b0d346be87");
		check(E = x"7137fe35344f3798");
		check(F = x"d522535fc6b88839");
		check(G = x"ed9f1c9ba8b73ed3");
		check(H = x"806cf8338a2d8107");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"cb216f52f43b6afe");
		check(B = x"85884b6ce22f18cc");
		check(C = x"afb71ceced7b63b5");
		check(D = x"9aebea498d263847");
		check(E = x"db93e1cbf9653c3d");
		check(F = x"7137fe35344f3798");
		check(G = x"d522535fc6b88839");
		check(H = x"ed9f1c9ba8b73ed3");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"dfd0b672c5cd1e8b");
		check(B = x"cb216f52f43b6afe");
		check(C = x"85884b6ce22f18cc");
		check(D = x"afb71ceced7b63b5");
		check(E = x"8fcb4dc8716effb1");
		check(F = x"db93e1cbf9653c3d");
		check(G = x"7137fe35344f3798");
		check(H = x"d522535fc6b88839");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"601a3293bf927720");
		check(B = x"dfd0b672c5cd1e8b");
		check(C = x"cb216f52f43b6afe");
		check(D = x"85884b6ce22f18cc");
		check(E = x"3827aaebab9dd42b");
		check(F = x"8fcb4dc8716effb1");
		check(G = x"db93e1cbf9653c3d");
		check(H = x"7137fe35344f3798");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"ae3dafac982a4e42");
		check(B = x"601a3293bf927720");
		check(C = x"dfd0b672c5cd1e8b");
		check(D = x"cb216f52f43b6afe");
		check(E = x"36f8f9a62b58566a");
		check(F = x"3827aaebab9dd42b");
		check(G = x"8fcb4dc8716effb1");
		check(H = x"db93e1cbf9653c3d");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"74a2e0caa3229324");
		check(B = x"ae3dafac982a4e42");
		check(C = x"601a3293bf927720");
		check(D = x"dfd0b672c5cd1e8b");
		check(E = x"540d76442cc9b5a3");
		check(F = x"36f8f9a62b58566a");
		check(G = x"3827aaebab9dd42b");
		check(H = x"8fcb4dc8716effb1");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"4c8afc0c3f84e472");
		check(B = x"74a2e0caa3229324");
		check(C = x"ae3dafac982a4e42");
		check(D = x"601a3293bf927720");
		check(E = x"b8793c4c2a3fba84");
		check(F = x"540d76442cc9b5a3");
		check(G = x"36f8f9a62b58566a");
		check(H = x"3827aaebab9dd42b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"4eb2877586b52f4f");
		check(B = x"4c8afc0c3f84e472");
		check(C = x"74a2e0caa3229324");
		check(D = x"ae3dafac982a4e42");
		check(E = x"5251558bcc1075d5");
		check(F = x"b8793c4c2a3fba84");
		check(G = x"540d76442cc9b5a3");
		check(H = x"36f8f9a62b58566a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"258e064bb19c6025");
		check(B = x"4eb2877586b52f4f");
		check(C = x"4c8afc0c3f84e472");
		check(D = x"74a2e0caa3229324");
		check(E = x"a535fc31fc085376");
		check(F = x"5251558bcc1075d5");
		check(G = x"b8793c4c2a3fba84");
		check(H = x"540d76442cc9b5a3");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"1f489ea312614b74");
		check(B = x"258e064bb19c6025");
		check(C = x"4eb2877586b52f4f");
		check(D = x"4c8afc0c3f84e472");
		check(E = x"e49ed684a226810c");
		check(F = x"a535fc31fc085376");
		check(G = x"5251558bcc1075d5");
		check(H = x"b8793c4c2a3fba84");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"932fcf13b4851f1d");
		check(B = x"1f489ea312614b74");
		check(C = x"258e064bb19c6025");
		check(D = x"4eb2877586b52f4f");
		check(E = x"2b881db245ef3b86");
		check(F = x"e49ed684a226810c");
		check(G = x"a535fc31fc085376");
		check(H = x"5251558bcc1075d5");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"23a6c9b3a05fe928");
		check(B = x"932fcf13b4851f1d");
		check(C = x"1f489ea312614b74");
		check(D = x"258e064bb19c6025");
		check(E = x"d9310705097e6fe1");
		check(F = x"2b881db245ef3b86");
		check(G = x"e49ed684a226810c");
		check(H = x"a535fc31fc085376");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"e7a079f6913a9e41");
		check(B = x"23a6c9b3a05fe928");
		check(C = x"932fcf13b4851f1d");
		check(D = x"1f489ea312614b74");
		check(E = x"6f55d9742fcf4e65");
		check(F = x"d9310705097e6fe1");
		check(G = x"2b881db245ef3b86");
		check(H = x"e49ed684a226810c");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"9f7fa283f2b0cde9");
		check(B = x"e7a079f6913a9e41");
		check(C = x"23a6c9b3a05fe928");
		check(D = x"932fcf13b4851f1d");
		check(E = x"c05c40c0d4d1b86d");
		check(F = x"6f55d9742fcf4e65");
		check(G = x"d9310705097e6fe1");
		check(H = x"2b881db245ef3b86");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"656b54840851eaf8");
		check(B = x"9f7fa283f2b0cde9");
		check(C = x"e7a079f6913a9e41");
		check(D = x"23a6c9b3a05fe928");
		check(E = x"80aead6bc980fcd2");
		check(F = x"c05c40c0d4d1b86d");
		check(G = x"6f55d9742fcf4e65");
		check(H = x"d9310705097e6fe1");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"3225026546be32a3");
		check(B = x"656b54840851eaf8");
		check(C = x"9f7fa283f2b0cde9");
		check(D = x"e7a079f6913a9e41");
		check(E = x"df45e4a497c8011a");
		check(F = x"80aead6bc980fcd2");
		check(G = x"c05c40c0d4d1b86d");
		check(H = x"6f55d9742fcf4e65");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"5799fec079ed8b38");
		check(B = x"3225026546be32a3");
		check(C = x"656b54840851eaf8");
		check(D = x"9f7fa283f2b0cde9");
		check(E = x"17099b331fba11c7");
		check(F = x"df45e4a497c8011a");
		check(G = x"80aead6bc980fcd2");
		check(H = x"c05c40c0d4d1b86d");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"b5bcc75199ae577f");
		check(B = x"5799fec079ed8b38");
		check(C = x"3225026546be32a3");
		check(D = x"656b54840851eaf8");
		check(E = x"ddc308b4268ada66");
		check(F = x"17099b331fba11c7");
		check(G = x"df45e4a497c8011a");
		check(H = x"80aead6bc980fcd2");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"e3107fbfacf25f9");
		check(B = x"b5bcc75199ae577f");
		check(C = x"5799fec079ed8b38");
		check(D = x"3225026546be32a3");
		check(E = x"dc20d7b45faac073");
		check(F = x"ddc308b4268ada66");
		check(G = x"17099b331fba11c7");
		check(H = x"df45e4a497c8011a");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"4a1462d36e68c05e");
		check(B = x"e3107fbfacf25f9");
		check(C = x"b5bcc75199ae577f");
		check(D = x"5799fec079ed8b38");
		check(E = x"becb94c168b78f3a");
		check(F = x"dc20d7b45faac073");
		check(G = x"ddc308b4268ada66");
		check(H = x"17099b331fba11c7");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"6c8ce3773932bcc8");
		check(B = x"4a1462d36e68c05e");
		check(C = x"e3107fbfacf25f9");
		check(D = x"b5bcc75199ae577f");
		check(E = x"1a27b5f028dae53a");
		check(F = x"becb94c168b78f3a");
		check(G = x"dc20d7b45faac073");
		check(H = x"ddc308b4268ada66");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"c53dccc995a3ba04");
		check(B = x"6c8ce3773932bcc8");
		check(C = x"4a1462d36e68c05e");
		check(D = x"e3107fbfacf25f9");
		check(E = x"79d1295a71b35643");
		check(F = x"1a27b5f028dae53a");
		check(G = x"becb94c168b78f3a");
		check(H = x"dc20d7b45faac073");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"2c196e7bd749a121");
		check(B = x"c53dccc995a3ba04");
		check(C = x"6c8ce3773932bcc8");
		check(D = x"4a1462d36e68c05e");
		check(E = x"41b589eb29dc4a9c");
		check(F = x"79d1295a71b35643");
		check(G = x"1a27b5f028dae53a");
		check(H = x"becb94c168b78f3a");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"6e97eeddfe361eea");
		check(B = x"2c196e7bd749a121");
		check(C = x"c53dccc995a3ba04");
		check(D = x"6c8ce3773932bcc8");
		check(E = x"d5a77a1d0eb29849");
		check(F = x"41b589eb29dc4a9c");
		check(G = x"79d1295a71b35643");
		check(H = x"1a27b5f028dae53a");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"6b77d1522b01b4e5");
		check(B = x"6e97eeddfe361eea");
		check(C = x"2c196e7bd749a121");
		check(D = x"c53dccc995a3ba04");
		check(E = x"44d6c0cde70a7dd8");
		check(F = x"d5a77a1d0eb29849");
		check(G = x"41b589eb29dc4a9c");
		check(H = x"79d1295a71b35643");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"456103f29276971");
		check(B = x"6b77d1522b01b4e5");
		check(C = x"6e97eeddfe361eea");
		check(D = x"2c196e7bd749a121");
		check(E = x"bceecea698535fc0");
		check(F = x"44d6c0cde70a7dd8");
		check(G = x"d5a77a1d0eb29849");
		check(H = x"41b589eb29dc4a9c");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"bb004cb390ea8019");
		check(B = x"456103f29276971");
		check(C = x"6b77d1522b01b4e5");
		check(D = x"6e97eeddfe361eea");
		check(E = x"5254e7315690b87c");
		check(F = x"bceecea698535fc0");
		check(G = x"44d6c0cde70a7dd8");
		check(H = x"d5a77a1d0eb29849");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"c503d0d82bee5035");
		check(B = x"bb004cb390ea8019");
		check(C = x"456103f29276971");
		check(D = x"6b77d1522b01b4e5");
		check(E = x"7a91fae5134df622");
		check(F = x"5254e7315690b87c");
		check(G = x"bceecea698535fc0");
		check(H = x"44d6c0cde70a7dd8");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"543cea4d2fa56cfb");
		check(B = x"c503d0d82bee5035");
		check(C = x"bb004cb390ea8019");
		check(D = x"456103f29276971");
		check(E = x"36691ef2e5c0e39a");
		check(F = x"7a91fae5134df622");
		check(G = x"5254e7315690b87c");
		check(H = x"bceecea698535fc0");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"e6ba6a68c43ed1c7");
		check(B = x"543cea4d2fa56cfb");
		check(C = x"c503d0d82bee5035");
		check(D = x"bb004cb390ea8019");
		check(E = x"ea2ed37c610e136a");
		check(F = x"36691ef2e5c0e39a");
		check(G = x"7a91fae5134df622");
		check(H = x"5254e7315690b87c");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"aa5424cbb381619c");
		check(B = x"e6ba6a68c43ed1c7");
		check(C = x"543cea4d2fa56cfb");
		check(D = x"c503d0d82bee5035");
		check(E = x"fdaeb18af6f847fc");
		check(F = x"ea2ed37c610e136a");
		check(G = x"36691ef2e5c0e39a");
		check(H = x"7a91fae5134df622");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"4067e30985f32b1");
		check(B = x"aa5424cbb381619c");
		check(C = x"e6ba6a68c43ed1c7");
		check(D = x"543cea4d2fa56cfb");
		check(E = x"9f3ca15066243347");
		check(F = x"fdaeb18af6f847fc");
		check(G = x"ea2ed37c610e136a");
		check(H = x"36691ef2e5c0e39a");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"ac639153336d88f7");
		check(B = x"4067e30985f32b1");
		check(C = x"aa5424cbb381619c");
		check(D = x"e6ba6a68c43ed1c7");
		check(E = x"97b5b35e6f8513e4");
		check(F = x"9f3ca15066243347");
		check(G = x"fdaeb18af6f847fc");
		check(H = x"ea2ed37c610e136a");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"9209eb620e7f7943");
		check(B = x"ac639153336d88f7");
		check(C = x"4067e30985f32b1");
		check(D = x"aa5424cbb381619c");
		check(E = x"7018eb205cf7f410");
		check(F = x"97b5b35e6f8513e4");
		check(G = x"9f3ca15066243347");
		check(H = x"fdaeb18af6f847fc");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"c0ec21b6edb71494");
		check(B = x"9209eb620e7f7943");
		check(C = x"ac639153336d88f7");
		check(D = x"4067e30985f32b1");
		check(E = x"46c7967543805e0f");
		check(F = x"7018eb205cf7f410");
		check(G = x"97b5b35e6f8513e4");
		check(H = x"9f3ca15066243347");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"bc598c2c8c32d921");
		check(B = x"c0ec21b6edb71494");
		check(C = x"9209eb620e7f7943");
		check(D = x"ac639153336d88f7");
		check(E = x"322e86aadd9a27bb");
		check(F = x"46c7967543805e0f");
		check(G = x"7018eb205cf7f410");
		check(H = x"97b5b35e6f8513e4");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"7bcc2378f8ef724c");
		check(B = x"bc598c2c8c32d921");
		check(C = x"c0ec21b6edb71494");
		check(D = x"9209eb620e7f7943");
		check(E = x"deacc9c3b62f8f67");
		check(F = x"322e86aadd9a27bb");
		check(G = x"46c7967543805e0f");
		check(H = x"7018eb205cf7f410");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"a7296a80ebada3ae");
		check(B = x"7bcc2378f8ef724c");
		check(C = x"bc598c2c8c32d921");
		check(D = x"c0ec21b6edb71494");
		check(E = x"ff2a0df5d2af25d6");
		check(F = x"deacc9c3b62f8f67");
		check(G = x"322e86aadd9a27bb");
		check(H = x"46c7967543805e0f");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"d9d448f5385be50f");
		check(B = x"a7296a80ebada3ae");
		check(C = x"7bcc2378f8ef724c");
		check(D = x"bc598c2c8c32d921");
		check(E = x"5991373cb75065fc");
		check(F = x"ff2a0df5d2af25d6");
		check(G = x"deacc9c3b62f8f67");
		check(H = x"322e86aadd9a27bb");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"c350385deb9887d1");
		check(B = x"d9d448f5385be50f");
		check(C = x"a7296a80ebada3ae");
		check(D = x"7bcc2378f8ef724c");
		check(E = x"62053b250a5947e5");
		check(F = x"5991373cb75065fc");
		check(G = x"ff2a0df5d2af25d6");
		check(H = x"deacc9c3b62f8f67");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"62f1554b527538e2");
		check(B = x"c350385deb9887d1");
		check(C = x"d9d448f5385be50f");
		check(D = x"a7296a80ebada3ae");
		check(E = x"a2b3a2067979d7e6");
		check(F = x"62053b250a5947e5");
		check(G = x"5991373cb75065fc");
		check(H = x"ff2a0df5d2af25d6");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"e66899f71255e6f7");
		check(B = x"62f1554b527538e2");
		check(C = x"c350385deb9887d1");
		check(D = x"d9d448f5385be50f");
		check(E = x"645781ab103d0195");
		check(F = x"a2b3a2067979d7e6");
		check(G = x"62053b250a5947e5");
		check(H = x"5991373cb75065fc");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"a0e41e8bd97e4f0b");
		check(B = x"e66899f71255e6f7");
		check(C = x"62f1554b527538e2");
		check(D = x"c350385deb9887d1");
		check(E = x"885891134ea524e8");
		check(F = x"645781ab103d0195");
		check(G = x"a2b3a2067979d7e6");
		check(H = x"62053b250a5947e5");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"e5d41dbf6e0dbe9a");
		check(B = x"a0e41e8bd97e4f0b");
		check(C = x"e66899f71255e6f7");
		check(D = x"62f1554b527538e2");
		check(E = x"503a986b15f7b066");
		check(F = x"885891134ea524e8");
		check(G = x"645781ab103d0195");
		check(H = x"a2b3a2067979d7e6");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"7be10c8ef651697b");
		check(B = x"e5d41dbf6e0dbe9a");
		check(C = x"a0e41e8bd97e4f0b");
		check(D = x"e66899f71255e6f7");
		check(E = x"b469a6a51c693f20");
		check(F = x"503a986b15f7b066");
		check(G = x"885891134ea524e8");
		check(H = x"645781ab103d0195");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"9dbd8c1cce443b2");
		check(B = x"7be10c8ef651697b");
		check(C = x"e5d41dbf6e0dbe9a");
		check(D = x"a0e41e8bd97e4f0b");
		check(E = x"48f1e6ed4abd71b9");
		check(F = x"b469a6a51c693f20");
		check(G = x"503a986b15f7b066");
		check(H = x"885891134ea524e8");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"ef8d8988e40b1341");
		check(B = x"9dbd8c1cce443b2");
		check(C = x"7be10c8ef651697b");
		check(D = x"e5d41dbf6e0dbe9a");
		check(E = x"e7bba839536b28f5");
		check(F = x"48f1e6ed4abd71b9");
		check(G = x"b469a6a51c693f20");
		check(H = x"503a986b15f7b066");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"cbfcfca1fe18eb74");
		check(B = x"ef8d8988e40b1341");
		check(C = x"9dbd8c1cce443b2");
		check(D = x"7be10c8ef651697b");
		check(E = x"dd8baaf08700849c");
		check(F = x"e7bba839536b28f5");
		check(G = x"48f1e6ed4abd71b9");
		check(H = x"b469a6a51c693f20");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"71e7fcabb8631b5c");
		check(B = x"cbfcfca1fe18eb74");
		check(C = x"ef8d8988e40b1341");
		check(D = x"9dbd8c1cce443b2");
		check(E = x"43f674715e053499");
		check(F = x"dd8baaf08700849c");
		check(G = x"e7bba839536b28f5");
		check(H = x"48f1e6ed4abd71b9");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"b494c5ab28300c7d");
		check(B = x"71e7fcabb8631b5c");
		check(C = x"cbfcfca1fe18eb74");
		check(D = x"ef8d8988e40b1341");
		check(E = x"9328ec9c3e233a73");
		check(F = x"43f674715e053499");
		check(G = x"dd8baaf08700849c");
		check(H = x"e7bba839536b28f5");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"6804bcebb29448e9");
		check(B = x"b494c5ab28300c7d");
		check(C = x"71e7fcabb8631b5c");
		check(D = x"cbfcfca1fe18eb74");
		check(E = x"4640a4ebff6f0e5b");
		check(F = x"9328ec9c3e233a73");
		check(G = x"43f674715e053499");
		check(H = x"dd8baaf08700849c");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"ab7a97742620be37");
		check(B = x"6804bcebb29448e9");
		check(C = x"b494c5ab28300c7d");
		check(D = x"71e7fcabb8631b5c");
		check(E = x"f46de32d636eb836");
		check(F = x"4640a4ebff6f0e5b");
		check(G = x"9328ec9c3e233a73");
		check(H = x"43f674715e053499");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"89c6c9a5f3edf41d");
		check(B = x"ab7a97742620be37");
		check(C = x"6804bcebb29448e9");
		check(D = x"b494c5ab28300c7d");
		check(E = x"cfcaa2db57ffdb4b");
		check(F = x"f46de32d636eb836");
		check(G = x"4640a4ebff6f0e5b");
		check(H = x"9328ec9c3e233a73");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"a44774ed9cae4c01");
		check(B = x"89c6c9a5f3edf41d");
		check(C = x"ab7a97742620be37");
		check(D = x"6804bcebb29448e9");
		check(E = x"a5d1b57b4d2ab69c");
		check(F = x"cfcaa2db57ffdb4b");
		check(G = x"f46de32d636eb836");
		check(H = x"4640a4ebff6f0e5b");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"5f34c2ac4fff1ffb");
		check(B = x"a44774ed9cae4c01");
		check(C = x"89c6c9a5f3edf41d");
		check(D = x"ab7a97742620be37");
		check(E = x"a6fc9a301db84fc4");
		check(F = x"a5d1b57b4d2ab69c");
		check(G = x"cfcaa2db57ffdb4b");
		check(H = x"f46de32d636eb836");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"6b397cdd62d352d7");
		check(B = x"5f34c2ac4fff1ffb");
		check(C = x"a44774ed9cae4c01");
		check(D = x"89c6c9a5f3edf41d");
		check(E = x"d4db8d2ed6c5410b");
		check(F = x"a6fc9a301db84fc4");
		check(G = x"a5d1b57b4d2ab69c");
		check(H = x"cfcaa2db57ffdb4b");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"63248352780e15b");
		check(B = x"6b397cdd62d352d7");
		check(C = x"5f34c2ac4fff1ffb");
		check(D = x"a44774ed9cae4c01");
		check(E = x"517f3d8704df968d");
		check(F = x"d4db8d2ed6c5410b");
		check(G = x"a6fc9a301db84fc4");
		check(H = x"a5d1b57b4d2ab69c");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"6c71a8012ae07b47");
		check(B = x"63248352780e15b");
		check(C = x"6b397cdd62d352d7");
		check(D = x"5f34c2ac4fff1ffb");
		check(E = x"65e7a80d4b16fd9e");
		check(F = x"517f3d8704df968d");
		check(G = x"d4db8d2ed6c5410b");
		check(H = x"a6fc9a301db84fc4");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"e8ee5f404df026f");
		check(B = x"6c71a8012ae07b47");
		check(C = x"63248352780e15b");
		check(D = x"6b397cdd62d352d7");
		check(E = x"18a7d6399f3fa5d1");
		check(F = x"65e7a80d4b16fd9e");
		check(G = x"517f3d8704df968d");
		check(H = x"d4db8d2ed6c5410b");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"93a8bec1e7baf485");
		check(B = x"e8ee5f404df026f");
		check(C = x"6c71a8012ae07b47");
		check(D = x"63248352780e15b");
		check(E = x"4be0fafa2e7ce817");
		check(F = x"18a7d6399f3fa5d1");
		check(G = x"65e7a80d4b16fd9e");
		check(H = x"517f3d8704df968d");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"274803e51db324bd");
		check(B = x"93a8bec1e7baf485");
		check(C = x"e8ee5f404df026f");
		check(D = x"6c71a8012ae07b47");
		check(E = x"9d431ec7c8f300fe");
		check(F = x"4be0fafa2e7ce817");
		check(G = x"18a7d6399f3fa5d1");
		check(H = x"65e7a80d4b16fd9e");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"8abfaf415fd7438c");
		check(B = x"274803e51db324bd");
		check(C = x"93a8bec1e7baf485");
		check(D = x"e8ee5f404df026f");
		check(E = x"9942caa93ddfeb77");
		check(F = x"9d431ec7c8f300fe");
		check(G = x"4be0fafa2e7ce817");
		check(H = x"18a7d6399f3fa5d1");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"a85a9377b4a99e1b");
		check(B = x"8abfaf415fd7438c");
		check(C = x"274803e51db324bd");
		check(D = x"93a8bec1e7baf485");
		check(E = x"b0282fdc994db62");
		check(F = x"9942caa93ddfeb77");
		check(G = x"9d431ec7c8f300fe");
		check(H = x"4be0fafa2e7ce817");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"874caec389c638cf");
		check(B = x"a85a9377b4a99e1b");
		check(C = x"8abfaf415fd7438c");
		check(D = x"274803e51db324bd");
		check(E = x"27c0151ffadf0037");
		check(F = x"b0282fdc994db62");
		check(G = x"9942caa93ddfeb77");
		check(H = x"9d431ec7c8f300fe");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"21182cba491ddc26");
		check(B = x"874caec389c638cf");
		check(C = x"a85a9377b4a99e1b");
		check(D = x"8abfaf415fd7438c");
		check(E = x"c4fff2a1bef2877f");
		check(F = x"27c0151ffadf0037");
		check(G = x"b0282fdc994db62");
		check(H = x"9942caa93ddfeb77");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"4024b125aa38852d");
		check(B = x"21182cba491ddc26");
		check(C = x"874caec389c638cf");
		check(D = x"a85a9377b4a99e1b");
		check(E = x"b283229faafb3bd7");
		check(F = x"c4fff2a1bef2877f");
		check(G = x"27c0151ffadf0037");
		check(H = x"b0282fdc994db62");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"8a3984fae9ec1816");
		check(B = x"4024b125aa38852d");
		check(C = x"21182cba491ddc26");
		check(D = x"874caec389c638cf");
		check(E = x"af35693a0cb6a291");
		check(F = x"b283229faafb3bd7");
		check(G = x"c4fff2a1bef2877f");
		check(H = x"27c0151ffadf0037");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"33dbe128e63c54f9");
		check(B = x"8a3984fae9ec1816");
		check(C = x"4024b125aa38852d");
		check(D = x"21182cba491ddc26");
		check(E = x"e9868bd45ac39409");
		check(F = x"af35693a0cb6a291");
		check(G = x"b283229faafb3bd7");
		check(H = x"c4fff2a1bef2877f");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"df0487a15301a1e9");
		check(B = x"33dbe128e63c54f9");
		check(C = x"8a3984fae9ec1816");
		check(D = x"4024b125aa38852d");
		check(E = x"f25cf12e2eb40ccc");
		check(F = x"e9868bd45ac39409");
		check(G = x"af35693a0cb6a291");
		check(H = x"b283229faafb3bd7");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"500336b753cf36ba");
		check(B = x"df0487a15301a1e9");
		check(C = x"33dbe128e63c54f9");
		check(D = x"8a3984fae9ec1816");
		check(E = x"ce91ec8fc6a457fc");
		check(F = x"f25cf12e2eb40ccc");
		check(G = x"e9868bd45ac39409");
		check(H = x"af35693a0cb6a291");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"bd4af8767632fc86");
		check(B = x"500336b753cf36ba");
		check(C = x"df0487a15301a1e9");
		check(D = x"33dbe128e63c54f9");
		check(E = x"6dd99d692c7e3eee");
		check(F = x"ce91ec8fc6a457fc");
		check(G = x"f25cf12e2eb40ccc");
		check(H = x"e9868bd45ac39409");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"14dcdf23590e50b3");
		check(B = x"bd4af8767632fc86");
		check(C = x"500336b753cf36ba");
		check(D = x"df0487a15301a1e9");
		check(E = x"5966f6e175bf4478");
		check(F = x"6dd99d692c7e3eee");
		check(G = x"ce91ec8fc6a457fc");
		check(H = x"f25cf12e2eb40ccc");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"e7451a374cb8b52c");
		check(B = x"14dcdf23590e50b3");
		check(C = x"bd4af8767632fc86");
		check(D = x"500336b753cf36ba");
		check(E = x"b1ea1fe45dd86620");
		check(F = x"5966f6e175bf4478");
		check(G = x"6dd99d692c7e3eee");
		check(H = x"ce91ec8fc6a457fc");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"b2d2d854d90e2437");
		check(B = x"e7451a374cb8b52c");
		check(C = x"14dcdf23590e50b3");
		check(D = x"bd4af8767632fc86");
		check(E = x"d74d25e5bc53f67e");
		check(F = x"b1ea1fe45dd86620");
		check(G = x"5966f6e175bf4478");
		check(H = x"6dd99d692c7e3eee");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"1cdcbebccccaed3f");
		check(H1_out = x"a2acc8bcd1835c67");
		check(H2_out = x"514bd29657a348de");
		check(H3_out = x"629aedb0d5503377");
		check(H4_out = x"285b78656a3a794f");
		check(H5_out = x"4cef88708916d23f");
		check(H6_out = x"78ead08d710101e3");
		check(H7_out = x"c9ba6a823ffc6067");

		test_runner_cleanup(runner);
	end process;

end sha512_test_6_tb_arch;

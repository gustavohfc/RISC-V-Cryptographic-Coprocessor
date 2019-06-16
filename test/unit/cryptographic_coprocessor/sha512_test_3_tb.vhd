library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 112 bits message ("message digest")

entity unit_sha512_test_3_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha512_test_3_tb;

architecture unit_sha512_test_3_tb_arch OF unit_sha512_test_3_tb IS
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

		-- Write the 112 bits message ("message digest")
		write_data_in <= '1';

		data_in               <= x"6d657373";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		data_in               <= x"61676520";
		data_in_word_position <= to_unsigned(1, 5);
		wait until rising_edge(clk);

		data_in               <= x"64696765";
		data_in_word_position <= to_unsigned(2, 5);
		wait until rising_edge(clk);

		data_in               <= x"73740000";
		data_in_word_position <= to_unsigned(3, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(112, 11);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"2b2deac1e644315");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"64ce1227dc1c84b1");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"d4419c54aee26843");
		check(B = x"2b2deac1e644315");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"2caab80ed506647e");
		check(F = x"64ce1227dc1c84b1");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"84a82ae87b244c6b");
		check(B = x"d4419c54aee26843");
		check(C = x"2b2deac1e644315");
		check(D = x"6a09e667f3bcc908");
		check(E = x"914a200c0a69893e");
		check(F = x"2caab80ed506647e");
		check(G = x"64ce1227dc1c84b1");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"e11f723a56062e23");
		check(B = x"84a82ae87b244c6b");
		check(C = x"d4419c54aee26843");
		check(D = x"2b2deac1e644315");
		check(E = x"4a0d1c7b8ebcba80");
		check(F = x"914a200c0a69893e");
		check(G = x"2caab80ed506647e");
		check(H = x"64ce1227dc1c84b1");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"18e79ddcdff146c");
		check(B = x"e11f723a56062e23");
		check(C = x"84a82ae87b244c6b");
		check(D = x"d4419c54aee26843");
		check(E = x"bee8b826bfca294f");
		check(F = x"4a0d1c7b8ebcba80");
		check(G = x"914a200c0a69893e");
		check(H = x"2caab80ed506647e");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"667ccc23a2af2d10");
		check(B = x"18e79ddcdff146c");
		check(C = x"e11f723a56062e23");
		check(D = x"84a82ae87b244c6b");
		check(E = x"a21a6f8c31e46990");
		check(F = x"bee8b826bfca294f");
		check(G = x"4a0d1c7b8ebcba80");
		check(H = x"914a200c0a69893e");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"6e0fea588c2c8f82");
		check(B = x"667ccc23a2af2d10");
		check(C = x"18e79ddcdff146c");
		check(D = x"e11f723a56062e23");
		check(E = x"c7d58ece202a723");
		check(F = x"a21a6f8c31e46990");
		check(G = x"bee8b826bfca294f");
		check(H = x"4a0d1c7b8ebcba80");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"a1e2c2cc575140d4");
		check(B = x"6e0fea588c2c8f82");
		check(C = x"667ccc23a2af2d10");
		check(D = x"18e79ddcdff146c");
		check(E = x"cc17c9d3a107212d");
		check(F = x"c7d58ece202a723");
		check(G = x"a21a6f8c31e46990");
		check(H = x"bee8b826bfca294f");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"c9185c9d7cd0647e");
		check(B = x"a1e2c2cc575140d4");
		check(C = x"6e0fea588c2c8f82");
		check(D = x"667ccc23a2af2d10");
		check(E = x"6bc90c34258b1167");
		check(F = x"cc17c9d3a107212d");
		check(G = x"c7d58ece202a723");
		check(H = x"a21a6f8c31e46990");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"2e809cdd55632f5a");
		check(B = x"c9185c9d7cd0647e");
		check(C = x"a1e2c2cc575140d4");
		check(D = x"6e0fea588c2c8f82");
		check(E = x"3269fe8bd70294b");
		check(F = x"6bc90c34258b1167");
		check(G = x"cc17c9d3a107212d");
		check(H = x"c7d58ece202a723");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"be22742e010df522");
		check(B = x"2e809cdd55632f5a");
		check(C = x"c9185c9d7cd0647e");
		check(D = x"a1e2c2cc575140d4");
		check(E = x"c8f0897e5ff4346b");
		check(F = x"3269fe8bd70294b");
		check(G = x"6bc90c34258b1167");
		check(H = x"cc17c9d3a107212d");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"2286920a44d98844");
		check(B = x"be22742e010df522");
		check(C = x"2e809cdd55632f5a");
		check(D = x"c9185c9d7cd0647e");
		check(E = x"49cac3b03e15c89b");
		check(F = x"c8f0897e5ff4346b");
		check(G = x"3269fe8bd70294b");
		check(H = x"6bc90c34258b1167");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"a86af03198da0518");
		check(B = x"2286920a44d98844");
		check(C = x"be22742e010df522");
		check(D = x"2e809cdd55632f5a");
		check(E = x"7ad9637d27d33352");
		check(F = x"49cac3b03e15c89b");
		check(G = x"c8f0897e5ff4346b");
		check(H = x"3269fe8bd70294b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"3ec70e5491916e35");
		check(B = x"a86af03198da0518");
		check(C = x"2286920a44d98844");
		check(D = x"be22742e010df522");
		check(E = x"3a7d56414835ad9a");
		check(F = x"7ad9637d27d33352");
		check(G = x"49cac3b03e15c89b");
		check(H = x"c8f0897e5ff4346b");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"9d6afde6d7eaa8f7");
		check(B = x"3ec70e5491916e35");
		check(C = x"a86af03198da0518");
		check(D = x"2286920a44d98844");
		check(E = x"9c7546017e62e945");
		check(F = x"3a7d56414835ad9a");
		check(G = x"7ad9637d27d33352");
		check(H = x"49cac3b03e15c89b");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"69c730e9b3262885");
		check(B = x"9d6afde6d7eaa8f7");
		check(C = x"3ec70e5491916e35");
		check(D = x"a86af03198da0518");
		check(E = x"c8e2d6698755cfa5");
		check(F = x"9c7546017e62e945");
		check(G = x"3a7d56414835ad9a");
		check(H = x"7ad9637d27d33352");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"ff42152e2c082d41");
		check(B = x"69c730e9b3262885");
		check(C = x"9d6afde6d7eaa8f7");
		check(D = x"3ec70e5491916e35");
		check(E = x"dc187a54646ebce4");
		check(F = x"c8e2d6698755cfa5");
		check(G = x"9c7546017e62e945");
		check(H = x"3a7d56414835ad9a");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"e2cbd0ab57222587");
		check(B = x"ff42152e2c082d41");
		check(C = x"69c730e9b3262885");
		check(D = x"9d6afde6d7eaa8f7");
		check(E = x"c77d9fc297a1774");
		check(F = x"dc187a54646ebce4");
		check(G = x"c8e2d6698755cfa5");
		check(H = x"9c7546017e62e945");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"91a8b24918eb4df8");
		check(B = x"e2cbd0ab57222587");
		check(C = x"ff42152e2c082d41");
		check(D = x"69c730e9b3262885");
		check(E = x"520c0a2fdde9602c");
		check(F = x"c77d9fc297a1774");
		check(G = x"dc187a54646ebce4");
		check(H = x"c8e2d6698755cfa5");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"493dcd863300775b");
		check(B = x"91a8b24918eb4df8");
		check(C = x"e2cbd0ab57222587");
		check(D = x"ff42152e2c082d41");
		check(E = x"647a93d7fa3a18b8");
		check(F = x"520c0a2fdde9602c");
		check(G = x"c77d9fc297a1774");
		check(H = x"dc187a54646ebce4");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"f216114538064d21");
		check(B = x"493dcd863300775b");
		check(C = x"91a8b24918eb4df8");
		check(D = x"e2cbd0ab57222587");
		check(E = x"7f0ced5b59ea43ee");
		check(F = x"647a93d7fa3a18b8");
		check(G = x"520c0a2fdde9602c");
		check(H = x"c77d9fc297a1774");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"3f47a4a6f2396869");
		check(B = x"f216114538064d21");
		check(C = x"493dcd863300775b");
		check(D = x"91a8b24918eb4df8");
		check(E = x"cc1963ff3588457");
		check(F = x"7f0ced5b59ea43ee");
		check(G = x"647a93d7fa3a18b8");
		check(H = x"520c0a2fdde9602c");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"896356ce7a757f08");
		check(B = x"3f47a4a6f2396869");
		check(C = x"f216114538064d21");
		check(D = x"493dcd863300775b");
		check(E = x"ccf7d537f78b3388");
		check(F = x"cc1963ff3588457");
		check(G = x"7f0ced5b59ea43ee");
		check(H = x"647a93d7fa3a18b8");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"d62f204d22138e50");
		check(B = x"896356ce7a757f08");
		check(C = x"3f47a4a6f2396869");
		check(D = x"f216114538064d21");
		check(E = x"bee79358355f1889");
		check(F = x"ccf7d537f78b3388");
		check(G = x"cc1963ff3588457");
		check(H = x"7f0ced5b59ea43ee");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"a94241fc2bc0dba4");
		check(B = x"d62f204d22138e50");
		check(C = x"896356ce7a757f08");
		check(D = x"3f47a4a6f2396869");
		check(E = x"7f90cecfac027fc");
		check(F = x"bee79358355f1889");
		check(G = x"ccf7d537f78b3388");
		check(H = x"cc1963ff3588457");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"2b2639f0da4f2117");
		check(B = x"a94241fc2bc0dba4");
		check(C = x"d62f204d22138e50");
		check(D = x"896356ce7a757f08");
		check(E = x"926090b6ab109f42");
		check(F = x"7f90cecfac027fc");
		check(G = x"bee79358355f1889");
		check(H = x"ccf7d537f78b3388");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"a2c1041c3ea7a756");
		check(B = x"2b2639f0da4f2117");
		check(C = x"a94241fc2bc0dba4");
		check(D = x"d62f204d22138e50");
		check(E = x"d28f17937dd3e48");
		check(F = x"926090b6ab109f42");
		check(G = x"7f90cecfac027fc");
		check(H = x"bee79358355f1889");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"300aff421021f7ba");
		check(B = x"a2c1041c3ea7a756");
		check(C = x"2b2639f0da4f2117");
		check(D = x"a94241fc2bc0dba4");
		check(E = x"7d4949a1cd886028");
		check(F = x"d28f17937dd3e48");
		check(G = x"926090b6ab109f42");
		check(H = x"7f90cecfac027fc");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"3b1f911cb1656403");
		check(B = x"300aff421021f7ba");
		check(C = x"a2c1041c3ea7a756");
		check(D = x"2b2639f0da4f2117");
		check(E = x"c0285025ca313a82");
		check(F = x"7d4949a1cd886028");
		check(G = x"d28f17937dd3e48");
		check(H = x"926090b6ab109f42");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"1f6d1709b3d4f618");
		check(B = x"3b1f911cb1656403");
		check(C = x"300aff421021f7ba");
		check(D = x"a2c1041c3ea7a756");
		check(E = x"1519e7e2e4b5656f");
		check(F = x"c0285025ca313a82");
		check(G = x"7d4949a1cd886028");
		check(H = x"d28f17937dd3e48");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"8eb8382be28c0aa3");
		check(B = x"1f6d1709b3d4f618");
		check(C = x"3b1f911cb1656403");
		check(D = x"300aff421021f7ba");
		check(E = x"b38baf53ae98cc68");
		check(F = x"1519e7e2e4b5656f");
		check(G = x"c0285025ca313a82");
		check(H = x"7d4949a1cd886028");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"7113eed0abf5fb5a");
		check(B = x"8eb8382be28c0aa3");
		check(C = x"1f6d1709b3d4f618");
		check(D = x"3b1f911cb1656403");
		check(E = x"fa3b2c83b922904d");
		check(F = x"b38baf53ae98cc68");
		check(G = x"1519e7e2e4b5656f");
		check(H = x"c0285025ca313a82");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"5fa9cfddaede73ed");
		check(B = x"7113eed0abf5fb5a");
		check(C = x"8eb8382be28c0aa3");
		check(D = x"1f6d1709b3d4f618");
		check(E = x"469b026982d6ac73");
		check(F = x"fa3b2c83b922904d");
		check(G = x"b38baf53ae98cc68");
		check(H = x"1519e7e2e4b5656f");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"a8e234a420f0f07d");
		check(B = x"5fa9cfddaede73ed");
		check(C = x"7113eed0abf5fb5a");
		check(D = x"8eb8382be28c0aa3");
		check(E = x"2b883e0ab21f8cf8");
		check(F = x"469b026982d6ac73");
		check(G = x"fa3b2c83b922904d");
		check(H = x"b38baf53ae98cc68");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"fb84f16e255ae9de");
		check(B = x"a8e234a420f0f07d");
		check(C = x"5fa9cfddaede73ed");
		check(D = x"7113eed0abf5fb5a");
		check(E = x"c12660a03da7fe02");
		check(F = x"2b883e0ab21f8cf8");
		check(G = x"469b026982d6ac73");
		check(H = x"fa3b2c83b922904d");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b1b130be5c963c01");
		check(B = x"fb84f16e255ae9de");
		check(C = x"a8e234a420f0f07d");
		check(D = x"5fa9cfddaede73ed");
		check(E = x"2671975728582203");
		check(F = x"c12660a03da7fe02");
		check(G = x"2b883e0ab21f8cf8");
		check(H = x"469b026982d6ac73");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"adae319d1ec294a");
		check(B = x"b1b130be5c963c01");
		check(C = x"fb84f16e255ae9de");
		check(D = x"a8e234a420f0f07d");
		check(E = x"8de51ee5e7db7f2f");
		check(F = x"2671975728582203");
		check(G = x"c12660a03da7fe02");
		check(H = x"2b883e0ab21f8cf8");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"3269f3a5c869ee94");
		check(B = x"adae319d1ec294a");
		check(C = x"b1b130be5c963c01");
		check(D = x"fb84f16e255ae9de");
		check(E = x"c6a0f06ad86f792a");
		check(F = x"8de51ee5e7db7f2f");
		check(G = x"2671975728582203");
		check(H = x"c12660a03da7fe02");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"ddb72f6349be39fc");
		check(B = x"3269f3a5c869ee94");
		check(C = x"adae319d1ec294a");
		check(D = x"b1b130be5c963c01");
		check(E = x"e72debd893cb6288");
		check(F = x"c6a0f06ad86f792a");
		check(G = x"8de51ee5e7db7f2f");
		check(H = x"2671975728582203");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"aec322680e9cfcd6");
		check(B = x"ddb72f6349be39fc");
		check(C = x"3269f3a5c869ee94");
		check(D = x"adae319d1ec294a");
		check(E = x"b65902438ba2bb49");
		check(F = x"e72debd893cb6288");
		check(G = x"c6a0f06ad86f792a");
		check(H = x"8de51ee5e7db7f2f");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"7f4aac40b44d8791");
		check(B = x"aec322680e9cfcd6");
		check(C = x"ddb72f6349be39fc");
		check(D = x"3269f3a5c869ee94");
		check(E = x"90cca052529d4ba9");
		check(F = x"b65902438ba2bb49");
		check(G = x"e72debd893cb6288");
		check(H = x"c6a0f06ad86f792a");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"cc18e24f68452e03");
		check(B = x"7f4aac40b44d8791");
		check(C = x"aec322680e9cfcd6");
		check(D = x"ddb72f6349be39fc");
		check(E = x"161c23989a8b6480");
		check(F = x"90cca052529d4ba9");
		check(G = x"b65902438ba2bb49");
		check(H = x"e72debd893cb6288");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"69406d092cbb83ea");
		check(B = x"cc18e24f68452e03");
		check(C = x"7f4aac40b44d8791");
		check(D = x"aec322680e9cfcd6");
		check(E = x"9819d844151be1b2");
		check(F = x"161c23989a8b6480");
		check(G = x"90cca052529d4ba9");
		check(H = x"b65902438ba2bb49");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"699b680de134679a");
		check(B = x"69406d092cbb83ea");
		check(C = x"cc18e24f68452e03");
		check(D = x"7f4aac40b44d8791");
		check(E = x"1845f4d0e8ff91e3");
		check(F = x"9819d844151be1b2");
		check(G = x"161c23989a8b6480");
		check(H = x"90cca052529d4ba9");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"4f14c2ac5bb05959");
		check(B = x"699b680de134679a");
		check(C = x"69406d092cbb83ea");
		check(D = x"cc18e24f68452e03");
		check(E = x"f47dfe5070c54d53");
		check(F = x"1845f4d0e8ff91e3");
		check(G = x"9819d844151be1b2");
		check(H = x"161c23989a8b6480");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"c4230ec884d86ca4");
		check(B = x"4f14c2ac5bb05959");
		check(C = x"699b680de134679a");
		check(D = x"69406d092cbb83ea");
		check(E = x"31cca59a735622e2");
		check(F = x"f47dfe5070c54d53");
		check(G = x"1845f4d0e8ff91e3");
		check(H = x"9819d844151be1b2");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"8d3f9d4096ce829f");
		check(B = x"c4230ec884d86ca4");
		check(C = x"4f14c2ac5bb05959");
		check(D = x"699b680de134679a");
		check(E = x"abb35e00c7292fca");
		check(F = x"31cca59a735622e2");
		check(G = x"f47dfe5070c54d53");
		check(H = x"1845f4d0e8ff91e3");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"609357e95984176a");
		check(B = x"8d3f9d4096ce829f");
		check(C = x"c4230ec884d86ca4");
		check(D = x"4f14c2ac5bb05959");
		check(E = x"34811cd49433ea04");
		check(F = x"abb35e00c7292fca");
		check(G = x"31cca59a735622e2");
		check(H = x"f47dfe5070c54d53");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"10c3325107c8d0b7");
		check(B = x"609357e95984176a");
		check(C = x"8d3f9d4096ce829f");
		check(D = x"c4230ec884d86ca4");
		check(E = x"7f1159e288dc95a2");
		check(F = x"34811cd49433ea04");
		check(G = x"abb35e00c7292fca");
		check(H = x"31cca59a735622e2");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"b7b98f7a223fd833");
		check(B = x"10c3325107c8d0b7");
		check(C = x"609357e95984176a");
		check(D = x"8d3f9d4096ce829f");
		check(E = x"dbd8d803e9294238");
		check(F = x"7f1159e288dc95a2");
		check(G = x"34811cd49433ea04");
		check(H = x"abb35e00c7292fca");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"927e76a181d724f1");
		check(B = x"b7b98f7a223fd833");
		check(C = x"10c3325107c8d0b7");
		check(D = x"609357e95984176a");
		check(E = x"8ff4f1e123feeffb");
		check(F = x"dbd8d803e9294238");
		check(G = x"7f1159e288dc95a2");
		check(H = x"34811cd49433ea04");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"441e486ce72ca0be");
		check(B = x"927e76a181d724f1");
		check(C = x"b7b98f7a223fd833");
		check(D = x"10c3325107c8d0b7");
		check(E = x"d3b241789c74dc18");
		check(F = x"8ff4f1e123feeffb");
		check(G = x"dbd8d803e9294238");
		check(H = x"7f1159e288dc95a2");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"366df5974cf6f06a");
		check(B = x"441e486ce72ca0be");
		check(C = x"927e76a181d724f1");
		check(D = x"b7b98f7a223fd833");
		check(E = x"1e235ef50514f829");
		check(F = x"d3b241789c74dc18");
		check(G = x"8ff4f1e123feeffb");
		check(H = x"dbd8d803e9294238");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"913012b0e8580135");
		check(B = x"366df5974cf6f06a");
		check(C = x"441e486ce72ca0be");
		check(D = x"927e76a181d724f1");
		check(E = x"ff9fd62c05783874");
		check(F = x"1e235ef50514f829");
		check(G = x"d3b241789c74dc18");
		check(H = x"8ff4f1e123feeffb");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"ba2770e58919e703");
		check(B = x"913012b0e8580135");
		check(C = x"366df5974cf6f06a");
		check(D = x"441e486ce72ca0be");
		check(E = x"5a22f3bc02051c2f");
		check(F = x"ff9fd62c05783874");
		check(G = x"1e235ef50514f829");
		check(H = x"d3b241789c74dc18");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"53cbb4bba69f8210");
		check(B = x"ba2770e58919e703");
		check(C = x"913012b0e8580135");
		check(D = x"366df5974cf6f06a");
		check(E = x"acfa523d79e8a52b");
		check(F = x"5a22f3bc02051c2f");
		check(G = x"ff9fd62c05783874");
		check(H = x"1e235ef50514f829");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"e63e92b0c9d86fd1");
		check(B = x"53cbb4bba69f8210");
		check(C = x"ba2770e58919e703");
		check(D = x"913012b0e8580135");
		check(E = x"9276591165c7ab2d");
		check(F = x"acfa523d79e8a52b");
		check(G = x"5a22f3bc02051c2f");
		check(H = x"ff9fd62c05783874");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"ad2ad37cce0a5165");
		check(B = x"e63e92b0c9d86fd1");
		check(C = x"53cbb4bba69f8210");
		check(D = x"ba2770e58919e703");
		check(E = x"7dc7df46731d7904");
		check(F = x"9276591165c7ab2d");
		check(G = x"acfa523d79e8a52b");
		check(H = x"5a22f3bc02051c2f");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"b764b53ffdfc6fdc");
		check(B = x"ad2ad37cce0a5165");
		check(C = x"e63e92b0c9d86fd1");
		check(D = x"53cbb4bba69f8210");
		check(E = x"5fa5fccb45be3cd9");
		check(F = x"7dc7df46731d7904");
		check(G = x"9276591165c7ab2d");
		check(H = x"acfa523d79e8a52b");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"1ce268f303caadc8");
		check(B = x"b764b53ffdfc6fdc");
		check(C = x"ad2ad37cce0a5165");
		check(D = x"e63e92b0c9d86fd1");
		check(E = x"6a3d6b8df9950829");
		check(F = x"5fa5fccb45be3cd9");
		check(G = x"7dc7df46731d7904");
		check(H = x"9276591165c7ab2d");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"c69750eb9160110e");
		check(B = x"1ce268f303caadc8");
		check(C = x"b764b53ffdfc6fdc");
		check(D = x"ad2ad37cce0a5165");
		check(E = x"d5130f7432464136");
		check(F = x"6a3d6b8df9950829");
		check(G = x"5fa5fccb45be3cd9");
		check(H = x"7dc7df46731d7904");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"60eb7511b35266ec");
		check(B = x"c69750eb9160110e");
		check(C = x"1ce268f303caadc8");
		check(D = x"b764b53ffdfc6fdc");
		check(E = x"51b403052a169663");
		check(F = x"d5130f7432464136");
		check(G = x"6a3d6b8df9950829");
		check(H = x"5fa5fccb45be3cd9");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"a67fcf18a77ab186");
		check(B = x"60eb7511b35266ec");
		check(C = x"c69750eb9160110e");
		check(D = x"1ce268f303caadc8");
		check(E = x"9e6cbfb443e8a0e1");
		check(F = x"51b403052a169663");
		check(G = x"d5130f7432464136");
		check(H = x"6a3d6b8df9950829");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"c3f26c65349c4609");
		check(B = x"a67fcf18a77ab186");
		check(C = x"60eb7511b35266ec");
		check(D = x"c69750eb9160110e");
		check(E = x"8a9a3ed5c1c4c471");
		check(F = x"9e6cbfb443e8a0e1");
		check(G = x"51b403052a169663");
		check(H = x"d5130f7432464136");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"93f57518c73039d8");
		check(B = x"c3f26c65349c4609");
		check(C = x"a67fcf18a77ab186");
		check(D = x"60eb7511b35266ec");
		check(E = x"a9070f6044d82ac8");
		check(F = x"8a9a3ed5c1c4c471");
		check(G = x"9e6cbfb443e8a0e1");
		check(H = x"51b403052a169663");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"bb871b6908974c32");
		check(B = x"93f57518c73039d8");
		check(C = x"c3f26c65349c4609");
		check(D = x"a67fcf18a77ab186");
		check(E = x"25392fd56a239b76");
		check(F = x"a9070f6044d82ac8");
		check(G = x"8a9a3ed5c1c4c471");
		check(H = x"9e6cbfb443e8a0e1");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"9dd0c40ffa9ab157");
		check(B = x"bb871b6908974c32");
		check(C = x"93f57518c73039d8");
		check(D = x"c3f26c65349c4609");
		check(E = x"9718d70029999849");
		check(F = x"25392fd56a239b76");
		check(G = x"a9070f6044d82ac8");
		check(H = x"8a9a3ed5c1c4c471");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"9acda2a706a7d320");
		check(B = x"9dd0c40ffa9ab157");
		check(C = x"bb871b6908974c32");
		check(D = x"93f57518c73039d8");
		check(E = x"79f22db3db6e0f63");
		check(F = x"9718d70029999849");
		check(G = x"25392fd56a239b76");
		check(H = x"a9070f6044d82ac8");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"e06c54fd2930cc9e");
		check(B = x"9acda2a706a7d320");
		check(C = x"9dd0c40ffa9ab157");
		check(D = x"bb871b6908974c32");
		check(E = x"f2c2be7f1a6c5ba8");
		check(F = x"79f22db3db6e0f63");
		check(G = x"9718d70029999849");
		check(H = x"25392fd56a239b76");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"31a6e2c569c42102");
		check(B = x"e06c54fd2930cc9e");
		check(C = x"9acda2a706a7d320");
		check(D = x"9dd0c40ffa9ab157");
		check(E = x"314e9e2ec48a19da");
		check(F = x"f2c2be7f1a6c5ba8");
		check(G = x"79f22db3db6e0f63");
		check(H = x"9718d70029999849");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"713b1e6415cf561");
		check(B = x"31a6e2c569c42102");
		check(C = x"e06c54fd2930cc9e");
		check(D = x"9acda2a706a7d320");
		check(E = x"a71702ef7fee0c94");
		check(F = x"314e9e2ec48a19da");
		check(G = x"f2c2be7f1a6c5ba8");
		check(H = x"79f22db3db6e0f63");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"701108afccd61de");
		check(B = x"713b1e6415cf561");
		check(C = x"31a6e2c569c42102");
		check(D = x"e06c54fd2930cc9e");
		check(E = x"378cefa9a72e7a7e");
		check(F = x"a71702ef7fee0c94");
		check(G = x"314e9e2ec48a19da");
		check(H = x"f2c2be7f1a6c5ba8");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"8c7bf3168dc8859e");
		check(B = x"701108afccd61de");
		check(C = x"713b1e6415cf561");
		check(D = x"31a6e2c569c42102");
		check(E = x"ffc7b7f8ff4da24e");
		check(F = x"378cefa9a72e7a7e");
		check(G = x"a71702ef7fee0c94");
		check(H = x"314e9e2ec48a19da");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"6e99a4f1b7af5a63");
		check(B = x"8c7bf3168dc8859e");
		check(C = x"701108afccd61de");
		check(D = x"713b1e6415cf561");
		check(E = x"464aecabf9ed5b3c");
		check(F = x"ffc7b7f8ff4da24e");
		check(G = x"378cefa9a72e7a7e");
		check(H = x"a71702ef7fee0c94");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"38909b5eeb9f743");
		check(B = x"6e99a4f1b7af5a63");
		check(C = x"8c7bf3168dc8859e");
		check(D = x"701108afccd61de");
		check(E = x"811dcee7d689558");
		check(F = x"464aecabf9ed5b3c");
		check(G = x"ffc7b7f8ff4da24e");
		check(H = x"378cefa9a72e7a7e");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"65ced8d1f7c3081d");
		check(B = x"38909b5eeb9f743");
		check(C = x"6e99a4f1b7af5a63");
		check(D = x"8c7bf3168dc8859e");
		check(E = x"6249cd98c670c798");
		check(F = x"811dcee7d689558");
		check(G = x"464aecabf9ed5b3c");
		check(H = x"ffc7b7f8ff4da24e");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"8f42f50b50fc6842");
		check(B = x"65ced8d1f7c3081d");
		check(C = x"38909b5eeb9f743");
		check(D = x"6e99a4f1b7af5a63");
		check(E = x"1205996ea7c3ed03");
		check(F = x"6249cd98c670c798");
		check(G = x"811dcee7d689558");
		check(H = x"464aecabf9ed5b3c");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"7fe3754fbf81de96");
		check(B = x"8f42f50b50fc6842");
		check(C = x"65ced8d1f7c3081d");
		check(D = x"38909b5eeb9f743");
		check(E = x"1959d9c6ad566899");
		check(F = x"1205996ea7c3ed03");
		check(G = x"6249cd98c670c798");
		check(H = x"811dcee7d689558");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"e841b0e68090eb16");
		check(B = x"7fe3754fbf81de96");
		check(C = x"8f42f50b50fc6842");
		check(D = x"65ced8d1f7c3081d");
		check(E = x"f38527d12a594b01");
		check(F = x"1959d9c6ad566899");
		check(G = x"1205996ea7c3ed03");
		check(H = x"6249cd98c670c798");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"a673d8d0a9e1d669");
		check(B = x"e841b0e68090eb16");
		check(C = x"7fe3754fbf81de96");
		check(D = x"8f42f50b50fc6842");
		check(E = x"b8d311d5fd381340");
		check(F = x"f38527d12a594b01");
		check(G = x"1959d9c6ad566899");
		check(H = x"1205996ea7c3ed03");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"107dbf389d9e9f71");
		check(H1_out = x"a3a95f6c055b9251");
		check(H2_out = x"bc5268c2be16d6c1");
		check(H3_out = x"3492ea45b0199f33");
		check(H4_out = x"9e16455ab1e9611");
		check(H5_out = x"8e8a905d5597b720");
		check(H6_out = x"38ddb372a8982604");
		check(H7_out = x"6de66687bb420e7c");

		test_runner_cleanup(runner);
	end process;

end unit_sha512_test_3_tb_arch;

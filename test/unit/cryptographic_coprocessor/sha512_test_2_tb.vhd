library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 24 bits message ("abc")

entity sha512_test_2_tb IS
	generic(
		runner_cfg : string
	);
end sha512_test_2_tb;

architecture sha512_test_2_tb_arch OF sha512_test_2_tb IS
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

		-- Write the 24 bits message ("abc")
		write_data_in <= '1';

		data_in               <= x"61626300";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(24, 11);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"f6afceb8bcfcddf5");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"58cb02347ab51f91");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"1320f8c9fb872cc0");
		check(B = x"f6afceb8bcfcddf5");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"c3d4ebfd48650ffa");
		check(F = x"58cb02347ab51f91");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"ebcffc07203d91f3");
		check(B = x"1320f8c9fb872cc0");
		check(C = x"f6afceb8bcfcddf5");
		check(D = x"6a09e667f3bcc908");
		check(E = x"dfa9b239f2697812");
		check(F = x"c3d4ebfd48650ffa");
		check(G = x"58cb02347ab51f91");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"5a83cb3e80050e82");
		check(B = x"ebcffc07203d91f3");
		check(C = x"1320f8c9fb872cc0");
		check(D = x"f6afceb8bcfcddf5");
		check(E = x"b47b4bb1928990e");
		check(F = x"dfa9b239f2697812");
		check(G = x"c3d4ebfd48650ffa");
		check(H = x"58cb02347ab51f91");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"b680953951604860");
		check(B = x"5a83cb3e80050e82");
		check(C = x"ebcffc07203d91f3");
		check(D = x"1320f8c9fb872cc0");
		check(E = x"745aca4a342ed2e2");
		check(F = x"b47b4bb1928990e");
		check(G = x"dfa9b239f2697812");
		check(H = x"c3d4ebfd48650ffa");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"af573b02403e89cd");
		check(B = x"b680953951604860");
		check(C = x"5a83cb3e80050e82");
		check(D = x"ebcffc07203d91f3");
		check(E = x"96f60209b6dc35ba");
		check(F = x"745aca4a342ed2e2");
		check(G = x"b47b4bb1928990e");
		check(H = x"dfa9b239f2697812");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"c4875b0c7abc076b");
		check(B = x"af573b02403e89cd");
		check(C = x"b680953951604860");
		check(D = x"5a83cb3e80050e82");
		check(E = x"5a6c781f54dcc00c");
		check(F = x"96f60209b6dc35ba");
		check(G = x"745aca4a342ed2e2");
		check(H = x"b47b4bb1928990e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"8093d195e0054fa3");
		check(B = x"c4875b0c7abc076b");
		check(C = x"af573b02403e89cd");
		check(D = x"b680953951604860");
		check(E = x"86f67263a0f0ec0a");
		check(F = x"5a6c781f54dcc00c");
		check(G = x"96f60209b6dc35ba");
		check(H = x"745aca4a342ed2e2");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"f1eca5544cb89225");
		check(B = x"8093d195e0054fa3");
		check(C = x"c4875b0c7abc076b");
		check(D = x"af573b02403e89cd");
		check(E = x"d0403c398fc40002");
		check(F = x"86f67263a0f0ec0a");
		check(G = x"5a6c781f54dcc00c");
		check(H = x"96f60209b6dc35ba");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"81782d4a5db48f03");
		check(B = x"f1eca5544cb89225");
		check(C = x"8093d195e0054fa3");
		check(D = x"c4875b0c7abc076b");
		check(E = x"91f460be46c52");
		check(F = x"d0403c398fc40002");
		check(G = x"86f67263a0f0ec0a");
		check(H = x"5a6c781f54dcc00c");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"69854c4aa0f25b59");
		check(B = x"81782d4a5db48f03");
		check(C = x"f1eca5544cb89225");
		check(D = x"8093d195e0054fa3");
		check(E = x"d375471bde1ba3f4");
		check(F = x"91f460be46c52");
		check(G = x"d0403c398fc40002");
		check(H = x"86f67263a0f0ec0a");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"db0a9963f80c2eaa");
		check(B = x"69854c4aa0f25b59");
		check(C = x"81782d4a5db48f03");
		check(D = x"f1eca5544cb89225");
		check(E = x"475975b91a7a462c");
		check(F = x"d375471bde1ba3f4");
		check(G = x"91f460be46c52");
		check(H = x"d0403c398fc40002");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"5e41214388186c14");
		check(B = x"db0a9963f80c2eaa");
		check(C = x"69854c4aa0f25b59");
		check(D = x"81782d4a5db48f03");
		check(E = x"cdf3bff2883fc9d9");
		check(F = x"475975b91a7a462c");
		check(G = x"d375471bde1ba3f4");
		check(H = x"91f460be46c52");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"44249631255d2ca0");
		check(B = x"5e41214388186c14");
		check(C = x"db0a9963f80c2eaa");
		check(D = x"69854c4aa0f25b59");
		check(E = x"860acf9effba6f61");
		check(F = x"cdf3bff2883fc9d9");
		check(G = x"475975b91a7a462c");
		check(H = x"d375471bde1ba3f4");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"fa967eed85a08028");
		check(B = x"44249631255d2ca0");
		check(C = x"5e41214388186c14");
		check(D = x"db0a9963f80c2eaa");
		check(E = x"874bfe5f6aae9f2f");
		check(F = x"860acf9effba6f61");
		check(G = x"cdf3bff2883fc9d9");
		check(H = x"475975b91a7a462c");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"ae07c86b1181c75");
		check(B = x"fa967eed85a08028");
		check(C = x"44249631255d2ca0");
		check(D = x"5e41214388186c14");
		check(E = x"a77b7c035dd4c161");
		check(F = x"874bfe5f6aae9f2f");
		check(G = x"860acf9effba6f61");
		check(H = x"cdf3bff2883fc9d9");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"caf81a425d800537");
		check(B = x"ae07c86b1181c75");
		check(C = x"fa967eed85a08028");
		check(D = x"44249631255d2ca0");
		check(E = x"2deecc6b39d64d78");
		check(F = x"a77b7c035dd4c161");
		check(G = x"874bfe5f6aae9f2f");
		check(H = x"860acf9effba6f61");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"4725be249ad19e6b");
		check(B = x"caf81a425d800537");
		check(C = x"ae07c86b1181c75");
		check(D = x"fa967eed85a08028");
		check(E = x"f47e8353f8047455");
		check(F = x"2deecc6b39d64d78");
		check(G = x"a77b7c035dd4c161");
		check(H = x"874bfe5f6aae9f2f");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"3c4b4104168e3edb");
		check(B = x"4725be249ad19e6b");
		check(C = x"caf81a425d800537");
		check(D = x"ae07c86b1181c75");
		check(E = x"29695fd88d81dbd0");
		check(F = x"f47e8353f8047455");
		check(G = x"2deecc6b39d64d78");
		check(H = x"a77b7c035dd4c161");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"9a3fb4d38ab6cf06");
		check(B = x"3c4b4104168e3edb");
		check(C = x"4725be249ad19e6b");
		check(D = x"caf81a425d800537");
		check(E = x"f14998dd5f70767e");
		check(F = x"29695fd88d81dbd0");
		check(G = x"f47e8353f8047455");
		check(H = x"2deecc6b39d64d78");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"8dc5ae65569d3855");
		check(B = x"9a3fb4d38ab6cf06");
		check(C = x"3c4b4104168e3edb");
		check(D = x"4725be249ad19e6b");
		check(E = x"4bb9e66d1145bfdc");
		check(F = x"f14998dd5f70767e");
		check(G = x"29695fd88d81dbd0");
		check(H = x"f47e8353f8047455");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"da34d6673d452dcf");
		check(B = x"8dc5ae65569d3855");
		check(C = x"9a3fb4d38ab6cf06");
		check(D = x"3c4b4104168e3edb");
		check(E = x"8e30ff09ad488753");
		check(F = x"4bb9e66d1145bfdc");
		check(G = x"f14998dd5f70767e");
		check(H = x"29695fd88d81dbd0");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"3e2644567b709a78");
		check(B = x"da34d6673d452dcf");
		check(C = x"8dc5ae65569d3855");
		check(D = x"9a3fb4d38ab6cf06");
		check(E = x"ac2b11da8f571c6");
		check(F = x"8e30ff09ad488753");
		check(G = x"4bb9e66d1145bfdc");
		check(H = x"f14998dd5f70767e");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"4f6877b58fe55484");
		check(B = x"3e2644567b709a78");
		check(C = x"da34d6673d452dcf");
		check(D = x"8dc5ae65569d3855");
		check(E = x"c66005f87db55233");
		check(F = x"ac2b11da8f571c6");
		check(G = x"8e30ff09ad488753");
		check(H = x"4bb9e66d1145bfdc");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"9aff71163fa3a940");
		check(B = x"4f6877b58fe55484");
		check(C = x"3e2644567b709a78");
		check(D = x"da34d6673d452dcf");
		check(E = x"d3ecf13769180e6f");
		check(F = x"c66005f87db55233");
		check(G = x"ac2b11da8f571c6");
		check(H = x"8e30ff09ad488753");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"bc5f791f8e6816b");
		check(B = x"9aff71163fa3a940");
		check(C = x"4f6877b58fe55484");
		check(D = x"3e2644567b709a78");
		check(E = x"6ddf1fd7edcce336");
		check(F = x"d3ecf13769180e6f");
		check(G = x"c66005f87db55233");
		check(H = x"ac2b11da8f571c6");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"884c3bc27bc4f941");
		check(B = x"bc5f791f8e6816b");
		check(C = x"9aff71163fa3a940");
		check(D = x"4f6877b58fe55484");
		check(E = x"e6e48c9a8e948365");
		check(F = x"6ddf1fd7edcce336");
		check(G = x"d3ecf13769180e6f");
		check(H = x"c66005f87db55233");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"eab4a9e5771b8d09");
		check(B = x"884c3bc27bc4f941");
		check(C = x"bc5f791f8e6816b");
		check(D = x"9aff71163fa3a940");
		check(E = x"9068a4e255a0dac");
		check(F = x"e6e48c9a8e948365");
		check(G = x"6ddf1fd7edcce336");
		check(H = x"d3ecf13769180e6f");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"e62349090f47d30a");
		check(B = x"eab4a9e5771b8d09");
		check(C = x"884c3bc27bc4f941");
		check(D = x"bc5f791f8e6816b");
		check(E = x"fcdf99710f21584");
		check(F = x"9068a4e255a0dac");
		check(G = x"e6e48c9a8e948365");
		check(H = x"6ddf1fd7edcce336");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"74bf40f869094c63");
		check(B = x"e62349090f47d30a");
		check(C = x"eab4a9e5771b8d09");
		check(D = x"884c3bc27bc4f941");
		check(E = x"f0aec2fe1437f085");
		check(F = x"fcdf99710f21584");
		check(G = x"9068a4e255a0dac");
		check(H = x"e6e48c9a8e948365");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"4c4fbbb75f1873a6");
		check(B = x"74bf40f869094c63");
		check(C = x"e62349090f47d30a");
		check(D = x"eab4a9e5771b8d09");
		check(E = x"73e025d91b9efea3");
		check(F = x"f0aec2fe1437f085");
		check(G = x"fcdf99710f21584");
		check(H = x"9068a4e255a0dac");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"ff4d3f1f0d46a736");
		check(B = x"4c4fbbb75f1873a6");
		check(C = x"74bf40f869094c63");
		check(D = x"e62349090f47d30a");
		check(E = x"3cd388e119e8162e");
		check(F = x"73e025d91b9efea3");
		check(G = x"f0aec2fe1437f085");
		check(H = x"fcdf99710f21584");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"a0509015ca08c8d4");
		check(B = x"ff4d3f1f0d46a736");
		check(C = x"4c4fbbb75f1873a6");
		check(D = x"74bf40f869094c63");
		check(E = x"e1034573654a106f");
		check(F = x"3cd388e119e8162e");
		check(G = x"73e025d91b9efea3");
		check(H = x"f0aec2fe1437f085");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"60d4e6995ed91fe6");
		check(B = x"a0509015ca08c8d4");
		check(C = x"ff4d3f1f0d46a736");
		check(D = x"4c4fbbb75f1873a6");
		check(E = x"efabbd8bf47c041a");
		check(F = x"e1034573654a106f");
		check(G = x"3cd388e119e8162e");
		check(H = x"73e025d91b9efea3");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"2c59ec7743632621");
		check(B = x"60d4e6995ed91fe6");
		check(C = x"a0509015ca08c8d4");
		check(D = x"ff4d3f1f0d46a736");
		check(E = x"fbae670fa780fd3");
		check(F = x"efabbd8bf47c041a");
		check(G = x"e1034573654a106f");
		check(H = x"3cd388e119e8162e");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"1a081afc59fdbc2c");
		check(B = x"2c59ec7743632621");
		check(C = x"60d4e6995ed91fe6");
		check(D = x"a0509015ca08c8d4");
		check(E = x"f098082f502b44cd");
		check(F = x"fbae670fa780fd3");
		check(G = x"efabbd8bf47c041a");
		check(H = x"e1034573654a106f");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"88df85b0bbe77514");
		check(B = x"1a081afc59fdbc2c");
		check(C = x"2c59ec7743632621");
		check(D = x"60d4e6995ed91fe6");
		check(E = x"8fbfd0162bbf4675");
		check(F = x"f098082f502b44cd");
		check(G = x"fbae670fa780fd3");
		check(H = x"efabbd8bf47c041a");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"2bb8e4cd989567");
		check(B = x"88df85b0bbe77514");
		check(C = x"1a081afc59fdbc2c");
		check(D = x"2c59ec7743632621");
		check(E = x"66adcfa249ac7bbd");
		check(F = x"8fbfd0162bbf4675");
		check(G = x"f098082f502b44cd");
		check(H = x"fbae670fa780fd3");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"b3bb8542b3376de5");
		check(B = x"2bb8e4cd989567");
		check(C = x"88df85b0bbe77514");
		check(D = x"1a081afc59fdbc2c");
		check(E = x"b49596c20feba7de");
		check(F = x"66adcfa249ac7bbd");
		check(G = x"8fbfd0162bbf4675");
		check(H = x"f098082f502b44cd");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"8e01e125b855d225");
		check(B = x"b3bb8542b3376de5");
		check(C = x"2bb8e4cd989567");
		check(D = x"88df85b0bbe77514");
		check(E = x"c710a47ba6a567b");
		check(F = x"b49596c20feba7de");
		check(G = x"66adcfa249ac7bbd");
		check(H = x"8fbfd0162bbf4675");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"b01521dd6a6be12c");
		check(B = x"8e01e125b855d225");
		check(C = x"b3bb8542b3376de5");
		check(D = x"2bb8e4cd989567");
		check(E = x"169008b3a4bb170b");
		check(F = x"c710a47ba6a567b");
		check(G = x"b49596c20feba7de");
		check(H = x"66adcfa249ac7bbd");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"e96f89dd48cbd851");
		check(B = x"b01521dd6a6be12c");
		check(C = x"8e01e125b855d225");
		check(D = x"b3bb8542b3376de5");
		check(E = x"f0996439e7b50cb1");
		check(F = x"169008b3a4bb170b");
		check(G = x"c710a47ba6a567b");
		check(H = x"b49596c20feba7de");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"bc05ba8de5d3c480");
		check(B = x"e96f89dd48cbd851");
		check(C = x"b01521dd6a6be12c");
		check(D = x"8e01e125b855d225");
		check(E = x"639cb938e14dc190");
		check(F = x"f0996439e7b50cb1");
		check(G = x"169008b3a4bb170b");
		check(H = x"c710a47ba6a567b");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"35d7e7f41defcbd5");
		check(B = x"bc05ba8de5d3c480");
		check(C = x"e96f89dd48cbd851");
		check(D = x"b01521dd6a6be12c");
		check(E = x"cc5100997f5710f2");
		check(F = x"639cb938e14dc190");
		check(G = x"f0996439e7b50cb1");
		check(H = x"169008b3a4bb170b");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"c47c9d5c7ea8a234");
		check(B = x"35d7e7f41defcbd5");
		check(C = x"bc05ba8de5d3c480");
		check(D = x"e96f89dd48cbd851");
		check(E = x"858d832ae0e8911c");
		check(F = x"cc5100997f5710f2");
		check(G = x"639cb938e14dc190");
		check(H = x"f0996439e7b50cb1");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"21fbadbabab5ac6");
		check(B = x"c47c9d5c7ea8a234");
		check(C = x"35d7e7f41defcbd5");
		check(D = x"bc05ba8de5d3c480");
		check(E = x"e95c2a57572d64d9");
		check(F = x"858d832ae0e8911c");
		check(G = x"cc5100997f5710f2");
		check(H = x"639cb938e14dc190");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"f61e672694de2d67");
		check(B = x"21fbadbabab5ac6");
		check(C = x"c47c9d5c7ea8a234");
		check(D = x"35d7e7f41defcbd5");
		check(E = x"c6bc35740d8daa9a");
		check(F = x"e95c2a57572d64d9");
		check(G = x"858d832ae0e8911c");
		check(H = x"cc5100997f5710f2");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"6b69fc1bb482feac");
		check(B = x"f61e672694de2d67");
		check(C = x"21fbadbabab5ac6");
		check(D = x"c47c9d5c7ea8a234");
		check(E = x"35264334c03ac8ad");
		check(F = x"c6bc35740d8daa9a");
		check(G = x"e95c2a57572d64d9");
		check(H = x"858d832ae0e8911c");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"571f323d96b3a047");
		check(B = x"6b69fc1bb482feac");
		check(C = x"f61e672694de2d67");
		check(D = x"21fbadbabab5ac6");
		check(E = x"271580ed6c3e5650");
		check(F = x"35264334c03ac8ad");
		check(G = x"c6bc35740d8daa9a");
		check(H = x"e95c2a57572d64d9");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"ca9bd862c5050918");
		check(B = x"571f323d96b3a047");
		check(C = x"6b69fc1bb482feac");
		check(D = x"f61e672694de2d67");
		check(E = x"dfe091dab182e645");
		check(F = x"271580ed6c3e5650");
		check(G = x"35264334c03ac8ad");
		check(H = x"c6bc35740d8daa9a");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"813a43dd2c502043");
		check(B = x"ca9bd862c5050918");
		check(C = x"571f323d96b3a047");
		check(D = x"6b69fc1bb482feac");
		check(E = x"7a0d8ef821c5e1a");
		check(F = x"dfe091dab182e645");
		check(G = x"271580ed6c3e5650");
		check(H = x"35264334c03ac8ad");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"d43f83727325dd77");
		check(B = x"813a43dd2c502043");
		check(C = x"ca9bd862c5050918");
		check(D = x"571f323d96b3a047");
		check(E = x"483f80a82eaee23e");
		check(F = x"7a0d8ef821c5e1a");
		check(G = x"dfe091dab182e645");
		check(H = x"271580ed6c3e5650");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"3df11b32d42e203");
		check(B = x"d43f83727325dd77");
		check(C = x"813a43dd2c502043");
		check(D = x"ca9bd862c5050918");
		check(E = x"504f94e40591cffa");
		check(F = x"483f80a82eaee23e");
		check(G = x"7a0d8ef821c5e1a");
		check(H = x"dfe091dab182e645");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"d63f68037ddf06aa");
		check(B = x"3df11b32d42e203");
		check(C = x"d43f83727325dd77");
		check(D = x"813a43dd2c502043");
		check(E = x"a6781efe1aa1ce02");
		check(F = x"504f94e40591cffa");
		check(G = x"483f80a82eaee23e");
		check(H = x"7a0d8ef821c5e1a");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"f650857b5babda4d");
		check(B = x"d63f68037ddf06aa");
		check(C = x"3df11b32d42e203");
		check(D = x"d43f83727325dd77");
		check(E = x"9ccfb31a86df0f86");
		check(F = x"a6781efe1aa1ce02");
		check(G = x"504f94e40591cffa");
		check(H = x"483f80a82eaee23e");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"63b460e42748817e");
		check(B = x"f650857b5babda4d");
		check(C = x"d63f68037ddf06aa");
		check(D = x"3df11b32d42e203");
		check(E = x"c6b4dd2a9931c509");
		check(F = x"9ccfb31a86df0f86");
		check(G = x"a6781efe1aa1ce02");
		check(H = x"504f94e40591cffa");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"7a52912943d52b05");
		check(B = x"63b460e42748817e");
		check(C = x"f650857b5babda4d");
		check(D = x"d63f68037ddf06aa");
		check(E = x"d2e89bbd91e00be0");
		check(F = x"c6b4dd2a9931c509");
		check(G = x"9ccfb31a86df0f86");
		check(H = x"a6781efe1aa1ce02");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"4b81c3aec976ea4b");
		check(B = x"7a52912943d52b05");
		check(C = x"63b460e42748817e");
		check(D = x"f650857b5babda4d");
		check(E = x"70505988124351ac");
		check(F = x"d2e89bbd91e00be0");
		check(G = x"c6b4dd2a9931c509");
		check(H = x"9ccfb31a86df0f86");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"581ecb3355dcd9b8");
		check(B = x"4b81c3aec976ea4b");
		check(C = x"7a52912943d52b05");
		check(D = x"63b460e42748817e");
		check(E = x"6a3c9b0f71c8bf36");
		check(F = x"70505988124351ac");
		check(G = x"d2e89bbd91e00be0");
		check(H = x"c6b4dd2a9931c509");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"2c074484ef1eac8c");
		check(B = x"581ecb3355dcd9b8");
		check(C = x"4b81c3aec976ea4b");
		check(D = x"7a52912943d52b05");
		check(E = x"4797cde4ed370692");
		check(F = x"6a3c9b0f71c8bf36");
		check(G = x"70505988124351ac");
		check(H = x"d2e89bbd91e00be0");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"3857dfd2fc37d3ba");
		check(B = x"2c074484ef1eac8c");
		check(C = x"581ecb3355dcd9b8");
		check(D = x"4b81c3aec976ea4b");
		check(E = x"a6af4e9c9f807e51");
		check(F = x"4797cde4ed370692");
		check(G = x"6a3c9b0f71c8bf36");
		check(H = x"70505988124351ac");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"cfcd928c5424e2b6");
		check(B = x"3857dfd2fc37d3ba");
		check(C = x"2c074484ef1eac8c");
		check(D = x"581ecb3355dcd9b8");
		check(E = x"9aee5bda1644de5");
		check(F = x"a6af4e9c9f807e51");
		check(G = x"4797cde4ed370692");
		check(H = x"6a3c9b0f71c8bf36");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"a81dedbb9f19e643");
		check(B = x"cfcd928c5424e2b6");
		check(C = x"3857dfd2fc37d3ba");
		check(D = x"2c074484ef1eac8c");
		check(E = x"84058865d60a05fa");
		check(F = x"9aee5bda1644de5");
		check(G = x"a6af4e9c9f807e51");
		check(H = x"4797cde4ed370692");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"ab44e86276478d85");
		check(B = x"a81dedbb9f19e643");
		check(C = x"cfcd928c5424e2b6");
		check(D = x"3857dfd2fc37d3ba");
		check(E = x"cd881ee59ca6bc53");
		check(F = x"84058865d60a05fa");
		check(G = x"9aee5bda1644de5");
		check(H = x"a6af4e9c9f807e51");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"5a806d7e9821a501");
		check(B = x"ab44e86276478d85");
		check(C = x"a81dedbb9f19e643");
		check(D = x"cfcd928c5424e2b6");
		check(E = x"aa84b086688a5c45");
		check(F = x"cd881ee59ca6bc53");
		check(G = x"84058865d60a05fa");
		check(H = x"9aee5bda1644de5");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"eeb9c21bb0102598");
		check(B = x"5a806d7e9821a501");
		check(C = x"ab44e86276478d85");
		check(D = x"a81dedbb9f19e643");
		check(E = x"3b5fed0d6a1f96e1");
		check(F = x"aa84b086688a5c45");
		check(G = x"cd881ee59ca6bc53");
		check(H = x"84058865d60a05fa");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"46c4210ab2cc155d");
		check(B = x"eeb9c21bb0102598");
		check(C = x"5a806d7e9821a501");
		check(D = x"ab44e86276478d85");
		check(E = x"29fab5a7bff53366");
		check(F = x"3b5fed0d6a1f96e1");
		check(G = x"aa84b086688a5c45");
		check(H = x"cd881ee59ca6bc53");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"54ba35cf56a0340e");
		check(B = x"46c4210ab2cc155d");
		check(C = x"eeb9c21bb0102598");
		check(D = x"5a806d7e9821a501");
		check(E = x"1c66f46d95690bcf");
		check(F = x"29fab5a7bff53366");
		check(G = x"3b5fed0d6a1f96e1");
		check(H = x"aa84b086688a5c45");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"181839d609c79748");
		check(B = x"54ba35cf56a0340e");
		check(C = x"46c4210ab2cc155d");
		check(D = x"eeb9c21bb0102598");
		check(E = x"ada78ba2d446140");
		check(F = x"1c66f46d95690bcf");
		check(G = x"29fab5a7bff53366");
		check(H = x"3b5fed0d6a1f96e1");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"fb6aaae5d0b6a447");
		check(B = x"181839d609c79748");
		check(C = x"54ba35cf56a0340e");
		check(D = x"46c4210ab2cc155d");
		check(E = x"e3711cb6564d112d");
		check(F = x"ada78ba2d446140");
		check(G = x"1c66f46d95690bcf");
		check(H = x"29fab5a7bff53366");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"7652c579cb60f19c");
		check(B = x"fb6aaae5d0b6a447");
		check(C = x"181839d609c79748");
		check(D = x"54ba35cf56a0340e");
		check(E = x"aff62c9665ff80fa");
		check(F = x"e3711cb6564d112d");
		check(G = x"ada78ba2d446140");
		check(H = x"1c66f46d95690bcf");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"f15e9664b2803575");
		check(B = x"7652c579cb60f19c");
		check(C = x"fb6aaae5d0b6a447");
		check(D = x"181839d609c79748");
		check(E = x"947c3dfafee570ef");
		check(F = x"aff62c9665ff80fa");
		check(G = x"e3711cb6564d112d");
		check(H = x"ada78ba2d446140");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"358406d165aee9ab");
		check(B = x"f15e9664b2803575");
		check(C = x"7652c579cb60f19c");
		check(D = x"fb6aaae5d0b6a447");
		check(E = x"8c7b5fd91a794ca0");
		check(F = x"947c3dfafee570ef");
		check(G = x"aff62c9665ff80fa");
		check(H = x"e3711cb6564d112d");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"20878dcd29cdfaf5");
		check(B = x"358406d165aee9ab");
		check(C = x"f15e9664b2803575");
		check(D = x"7652c579cb60f19c");
		check(E = x"54d3536539948d0");
		check(F = x"8c7b5fd91a794ca0");
		check(G = x"947c3dfafee570ef");
		check(H = x"aff62c9665ff80fa");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"33d48dabb5521de2");
		check(B = x"20878dcd29cdfaf5");
		check(C = x"358406d165aee9ab");
		check(D = x"f15e9664b2803575");
		check(E = x"2ba18245b50de4cf");
		check(F = x"54d3536539948d0");
		check(G = x"8c7b5fd91a794ca0");
		check(H = x"947c3dfafee570ef");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"c8960e6be864b916");
		check(B = x"33d48dabb5521de2");
		check(C = x"20878dcd29cdfaf5");
		check(D = x"358406d165aee9ab");
		check(E = x"995019a6ff3ba3de");
		check(F = x"2ba18245b50de4cf");
		check(G = x"54d3536539948d0");
		check(H = x"8c7b5fd91a794ca0");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"654ef9abec389ca9");
		check(B = x"c8960e6be864b916");
		check(C = x"33d48dabb5521de2");
		check(D = x"20878dcd29cdfaf5");
		check(E = x"ceb9fc3691ce8326");
		check(F = x"995019a6ff3ba3de");
		check(G = x"2ba18245b50de4cf");
		check(H = x"54d3536539948d0");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"d67806db8b148677");
		check(B = x"654ef9abec389ca9");
		check(C = x"c8960e6be864b916");
		check(D = x"33d48dabb5521de2");
		check(E = x"25c96a7768fb2aa3");
		check(F = x"ceb9fc3691ce8326");
		check(G = x"995019a6ff3ba3de");
		check(H = x"2ba18245b50de4cf");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"10d9c4c4295599f6");
		check(B = x"d67806db8b148677");
		check(C = x"654ef9abec389ca9");
		check(D = x"c8960e6be864b916");
		check(E = x"9bb4d39778c07f9e");
		check(F = x"25c96a7768fb2aa3");
		check(G = x"ceb9fc3691ce8326");
		check(H = x"995019a6ff3ba3de");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"73a54f399fa4b1b2");
		check(B = x"10d9c4c4295599f6");
		check(C = x"d67806db8b148677");
		check(D = x"654ef9abec389ca9");
		check(E = x"d08446aa79693ed7");
		check(F = x"9bb4d39778c07f9e");
		check(G = x"25c96a7768fb2aa3");
		check(H = x"ceb9fc3691ce8326");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"ddaf35a193617aba");
		check(H1_out = x"cc417349ae204131");
		check(H2_out = x"12e6fa4e89a97ea2");
		check(H3_out = x"a9eeee64b55d39a");
		check(H4_out = x"2192992a274fc1a8");
		check(H5_out = x"36ba3c23a3feebbd");
		check(H6_out = x"454d4423643ce80e");
		check(H7_out = x"2a9ac94fa54ca49f");

		test_runner_cleanup(runner);
	end process;

end sha512_test_2_tb_arch;

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 8 bits message ("a")

entity unit_sha512_test_1_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha512_test_1_tb;

architecture unit_sha512_test_1_tb_arch OF unit_sha512_test_1_tb IS
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

		-- Write the 8 bits message ("a")
		write_data_in <= '1';

		data_in               <= x"61000000";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(8, 11);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"f6cd6b38bcfcddf5");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"58e89eb47ab51f91");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"533dff508e3546d9");
		check(B = x"f6cd6b38bcfcddf5");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"3d3f303dd44fe38");
		check(F = x"58e89eb47ab51f91");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"bbe6eabc5173f0d5");
		check(B = x"533dff508e3546d9");
		check(C = x"f6cd6b38bcfcddf5");
		check(D = x"6a09e667f3bcc908");
		check(E = x"a37b532241cad915");
		check(F = x"3d3f303dd44fe38");
		check(G = x"58e89eb47ab51f91");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"497a0fe2d5cd19a1");
		check(B = x"bbe6eabc5173f0d5");
		check(C = x"533dff508e3546d9");
		check(D = x"f6cd6b38bcfcddf5");
		check(E = x"43d4f482b1333115");
		check(F = x"a37b532241cad915");
		check(G = x"3d3f303dd44fe38");
		check(H = x"58e89eb47ab51f91");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"6663b0927db2119b");
		check(B = x"497a0fe2d5cd19a1");
		check(C = x"bbe6eabc5173f0d5");
		check(D = x"533dff508e3546d9");
		check(E = x"d5a8e58addcd14f5");
		check(F = x"43d4f482b1333115");
		check(G = x"a37b532241cad915");
		check(H = x"3d3f303dd44fe38");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"61376581d953ef8e");
		check(B = x"6663b0927db2119b");
		check(C = x"497a0fe2d5cd19a1");
		check(D = x"bbe6eabc5173f0d5");
		check(E = x"e85bc02c88270274");
		check(F = x"d5a8e58addcd14f5");
		check(G = x"43d4f482b1333115");
		check(H = x"a37b532241cad915");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"1a9e1da7ea9392db");
		check(B = x"61376581d953ef8e");
		check(C = x"6663b0927db2119b");
		check(D = x"497a0fe2d5cd19a1");
		check(E = x"94393e06c63a7a6f");
		check(F = x"e85bc02c88270274");
		check(G = x"d5a8e58addcd14f5");
		check(H = x"43d4f482b1333115");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"a351e16378df63e0");
		check(B = x"1a9e1da7ea9392db");
		check(C = x"61376581d953ef8e");
		check(D = x"6663b0927db2119b");
		check(E = x"6e4bcd9f7ba588ba");
		check(F = x"94393e06c63a7a6f");
		check(G = x"e85bc02c88270274");
		check(H = x"d5a8e58addcd14f5");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"798c4a9db07fe8b5");
		check(B = x"a351e16378df63e0");
		check(C = x"1a9e1da7ea9392db");
		check(D = x"61376581d953ef8e");
		check(E = x"27a83d5658d148d9");
		check(F = x"6e4bcd9f7ba588ba");
		check(G = x"94393e06c63a7a6f");
		check(H = x"e85bc02c88270274");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"1794c286e8165539");
		check(B = x"798c4a9db07fe8b5");
		check(C = x"a351e16378df63e0");
		check(D = x"1a9e1da7ea9392db");
		check(E = x"ecae4fb51c35bded");
		check(F = x"27a83d5658d148d9");
		check(G = x"6e4bcd9f7ba588ba");
		check(H = x"94393e06c63a7a6f");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"8bdcd12d336529cd");
		check(B = x"1794c286e8165539");
		check(C = x"798c4a9db07fe8b5");
		check(D = x"a351e16378df63e0");
		check(E = x"3c3541d7d71329ad");
		check(F = x"ecae4fb51c35bded");
		check(G = x"27a83d5658d148d9");
		check(H = x"6e4bcd9f7ba588ba");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"b6c2decae4d063b8");
		check(B = x"8bdcd12d336529cd");
		check(C = x"1794c286e8165539");
		check(D = x"798c4a9db07fe8b5");
		check(E = x"1d8ae0a8690abea1");
		check(F = x"3c3541d7d71329ad");
		check(G = x"ecae4fb51c35bded");
		check(H = x"27a83d5658d148d9");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"9173f4a81bceb7a7");
		check(B = x"b6c2decae4d063b8");
		check(C = x"8bdcd12d336529cd");
		check(D = x"1794c286e8165539");
		check(E = x"112fe914bb096002");
		check(F = x"1d8ae0a8690abea1");
		check(G = x"3c3541d7d71329ad");
		check(H = x"ecae4fb51c35bded");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"7aff4663138b474d");
		check(B = x"9173f4a81bceb7a7");
		check(C = x"b6c2decae4d063b8");
		check(D = x"8bdcd12d336529cd");
		check(E = x"1491e9420b9c2897");
		check(F = x"112fe914bb096002");
		check(G = x"1d8ae0a8690abea1");
		check(H = x"3c3541d7d71329ad");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"e7ff16137c408739");
		check(B = x"7aff4663138b474d");
		check(C = x"9173f4a81bceb7a7");
		check(D = x"b6c2decae4d063b8");
		check(E = x"86765ccc301d0034");
		check(F = x"1491e9420b9c2897");
		check(G = x"112fe914bb096002");
		check(H = x"1d8ae0a8690abea1");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"4ce81bb4535d1e7c");
		check(B = x"e7ff16137c408739");
		check(C = x"7aff4663138b474d");
		check(D = x"9173f4a81bceb7a7");
		check(E = x"d1cad0fda6a1a068");
		check(F = x"86765ccc301d0034");
		check(G = x"1491e9420b9c2897");
		check(H = x"112fe914bb096002");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"2ba820c8bf243eed");
		check(B = x"4ce81bb4535d1e7c");
		check(C = x"e7ff16137c408739");
		check(D = x"7aff4663138b474d");
		check(E = x"47ce4d662878178");
		check(F = x"d1cad0fda6a1a068");
		check(G = x"86765ccc301d0034");
		check(H = x"1491e9420b9c2897");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"d208187536766f68");
		check(B = x"2ba820c8bf243eed");
		check(C = x"4ce81bb4535d1e7c");
		check(D = x"e7ff16137c408739");
		check(E = x"902aa333a07e4340");
		check(F = x"47ce4d662878178");
		check(G = x"d1cad0fda6a1a068");
		check(H = x"86765ccc301d0034");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"f4e8eda06397c3f5");
		check(B = x"d208187536766f68");
		check(C = x"2ba820c8bf243eed");
		check(D = x"4ce81bb4535d1e7c");
		check(E = x"d1a86935e2bc7b44");
		check(F = x"902aa333a07e4340");
		check(G = x"47ce4d662878178");
		check(H = x"d1cad0fda6a1a068");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"478e52ba0b13c952");
		check(B = x"f4e8eda06397c3f5");
		check(C = x"d208187536766f68");
		check(D = x"2ba820c8bf243eed");
		check(E = x"406f65684edd472c");
		check(F = x"d1a86935e2bc7b44");
		check(G = x"902aa333a07e4340");
		check(H = x"47ce4d662878178");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"86692511eb7355d4");
		check(B = x"478e52ba0b13c952");
		check(C = x"f4e8eda06397c3f5");
		check(D = x"d208187536766f68");
		check(E = x"939aac4839f625a6");
		check(F = x"406f65684edd472c");
		check(G = x"d1a86935e2bc7b44");
		check(H = x"902aa333a07e4340");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"c207352fc954bfe");
		check(B = x"86692511eb7355d4");
		check(C = x"478e52ba0b13c952");
		check(D = x"f4e8eda06397c3f5");
		check(E = x"2900b780d9f32f82");
		check(F = x"939aac4839f625a6");
		check(G = x"406f65684edd472c");
		check(H = x"d1a86935e2bc7b44");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"a082dfcc6a557a9f");
		check(B = x"c207352fc954bfe");
		check(C = x"86692511eb7355d4");
		check(D = x"478e52ba0b13c952");
		check(E = x"bbba92d125c28ba1");
		check(F = x"2900b780d9f32f82");
		check(G = x"939aac4839f625a6");
		check(H = x"406f65684edd472c");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"d29de38638b5f852");
		check(B = x"a082dfcc6a557a9f");
		check(C = x"c207352fc954bfe");
		check(D = x"86692511eb7355d4");
		check(E = x"6ef561467a28173c");
		check(F = x"bbba92d125c28ba1");
		check(G = x"2900b780d9f32f82");
		check(H = x"939aac4839f625a6");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"a89aa1b03f513a48");
		check(B = x"d29de38638b5f852");
		check(C = x"a082dfcc6a557a9f");
		check(D = x"c207352fc954bfe");
		check(E = x"a57f4232795299f9");
		check(F = x"6ef561467a28173c");
		check(G = x"bbba92d125c28ba1");
		check(H = x"2900b780d9f32f82");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"7330e90017063a14");
		check(B = x"a89aa1b03f513a48");
		check(C = x"d29de38638b5f852");
		check(D = x"a082dfcc6a557a9f");
		check(E = x"43fd3062a668858c");
		check(F = x"a57f4232795299f9");
		check(G = x"6ef561467a28173c");
		check(H = x"bbba92d125c28ba1");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"7704ca2c85f8dbf6");
		check(B = x"7330e90017063a14");
		check(C = x"a89aa1b03f513a48");
		check(D = x"d29de38638b5f852");
		check(E = x"af62a4c2aa1450b2");
		check(F = x"43fd3062a668858c");
		check(G = x"a57f4232795299f9");
		check(H = x"6ef561467a28173c");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"6a4b034c75ab87ba");
		check(B = x"7704ca2c85f8dbf6");
		check(C = x"7330e90017063a14");
		check(D = x"a89aa1b03f513a48");
		check(E = x"a1df858595adabe1");
		check(F = x"af62a4c2aa1450b2");
		check(G = x"43fd3062a668858c");
		check(H = x"a57f4232795299f9");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"8e69e22eeab7aeaf");
		check(B = x"6a4b034c75ab87ba");
		check(C = x"7704ca2c85f8dbf6");
		check(D = x"7330e90017063a14");
		check(E = x"e4c9eb8bc967eb2f");
		check(F = x"a1df858595adabe1");
		check(G = x"af62a4c2aa1450b2");
		check(H = x"43fd3062a668858c");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"da723d165de907d4");
		check(B = x"8e69e22eeab7aeaf");
		check(C = x"6a4b034c75ab87ba");
		check(D = x"7704ca2c85f8dbf6");
		check(E = x"9356f5db351b2889");
		check(F = x"e4c9eb8bc967eb2f");
		check(G = x"a1df858595adabe1");
		check(H = x"af62a4c2aa1450b2");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"48ea5f21e8945bf9");
		check(B = x"da723d165de907d4");
		check(C = x"8e69e22eeab7aeaf");
		check(D = x"6a4b034c75ab87ba");
		check(E = x"90321788b8d5f5d7");
		check(F = x"9356f5db351b2889");
		check(G = x"e4c9eb8bc967eb2f");
		check(H = x"a1df858595adabe1");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"43cb27552fd7daf0");
		check(B = x"48ea5f21e8945bf9");
		check(C = x"da723d165de907d4");
		check(D = x"8e69e22eeab7aeaf");
		check(E = x"32fa299d8ebfa145");
		check(F = x"90321788b8d5f5d7");
		check(G = x"9356f5db351b2889");
		check(H = x"e4c9eb8bc967eb2f");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"72fcba78d66640af");
		check(B = x"43cb27552fd7daf0");
		check(C = x"48ea5f21e8945bf9");
		check(D = x"da723d165de907d4");
		check(E = x"99a46784868168a5");
		check(F = x"32fa299d8ebfa145");
		check(G = x"90321788b8d5f5d7");
		check(H = x"9356f5db351b2889");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"e0034c48cdbf4d5e");
		check(B = x"72fcba78d66640af");
		check(C = x"43cb27552fd7daf0");
		check(D = x"48ea5f21e8945bf9");
		check(E = x"d539f38f8f4089d2");
		check(F = x"99a46784868168a5");
		check(G = x"32fa299d8ebfa145");
		check(H = x"90321788b8d5f5d7");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"9b1ceae8d4296183");
		check(B = x"e0034c48cdbf4d5e");
		check(C = x"72fcba78d66640af");
		check(D = x"43cb27552fd7daf0");
		check(E = x"83ba38ee6d26378");
		check(F = x"d539f38f8f4089d2");
		check(G = x"99a46784868168a5");
		check(H = x"32fa299d8ebfa145");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"26a22b968634b5b1");
		check(B = x"9b1ceae8d4296183");
		check(C = x"e0034c48cdbf4d5e");
		check(D = x"72fcba78d66640af");
		check(E = x"d21c55e8919da130");
		check(F = x"83ba38ee6d26378");
		check(G = x"d539f38f8f4089d2");
		check(H = x"99a46784868168a5");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"d896041c0fd131ff");
		check(B = x"26a22b968634b5b1");
		check(C = x"9b1ceae8d4296183");
		check(D = x"e0034c48cdbf4d5e");
		check(E = x"b9c634b6e0329541");
		check(F = x"d21c55e8919da130");
		check(G = x"83ba38ee6d26378");
		check(H = x"d539f38f8f4089d2");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"969f90717546a462");
		check(B = x"d896041c0fd131ff");
		check(C = x"26a22b968634b5b1");
		check(D = x"9b1ceae8d4296183");
		check(E = x"1513c03c3bdfd33e");
		check(F = x"b9c634b6e0329541");
		check(G = x"d21c55e8919da130");
		check(H = x"83ba38ee6d26378");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"a67995f07d7257c4");
		check(B = x"969f90717546a462");
		check(C = x"d896041c0fd131ff");
		check(D = x"26a22b968634b5b1");
		check(E = x"bf2f1e4c40d32729");
		check(F = x"1513c03c3bdfd33e");
		check(G = x"b9c634b6e0329541");
		check(H = x"d21c55e8919da130");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"bc052e6c3ae9f581");
		check(B = x"a67995f07d7257c4");
		check(C = x"969f90717546a462");
		check(D = x"d896041c0fd131ff");
		check(E = x"2384b87d7c80abfc");
		check(F = x"bf2f1e4c40d32729");
		check(G = x"1513c03c3bdfd33e");
		check(H = x"b9c634b6e0329541");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"10abecef26c8f8e7");
		check(B = x"bc052e6c3ae9f581");
		check(C = x"a67995f07d7257c4");
		check(D = x"969f90717546a462");
		check(E = x"bad3660a0d0b8e22");
		check(F = x"2384b87d7c80abfc");
		check(G = x"bf2f1e4c40d32729");
		check(H = x"1513c03c3bdfd33e");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"33d49ac54c1bd7d3");
		check(B = x"10abecef26c8f8e7");
		check(C = x"bc052e6c3ae9f581");
		check(D = x"a67995f07d7257c4");
		check(E = x"9ada5c9181c42460");
		check(F = x"bad3660a0d0b8e22");
		check(G = x"2384b87d7c80abfc");
		check(H = x"bf2f1e4c40d32729");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"657cbe54f6d35c9e");
		check(B = x"33d49ac54c1bd7d3");
		check(C = x"10abecef26c8f8e7");
		check(D = x"bc052e6c3ae9f581");
		check(E = x"c34ce5efeda09acf");
		check(F = x"9ada5c9181c42460");
		check(G = x"bad3660a0d0b8e22");
		check(H = x"2384b87d7c80abfc");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"38bbda404e3c11f");
		check(B = x"657cbe54f6d35c9e");
		check(C = x"33d49ac54c1bd7d3");
		check(D = x"10abecef26c8f8e7");
		check(E = x"942774d1e693a623");
		check(F = x"c34ce5efeda09acf");
		check(G = x"9ada5c9181c42460");
		check(H = x"bad3660a0d0b8e22");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"95fc3de2ca427117");
		check(B = x"38bbda404e3c11f");
		check(C = x"657cbe54f6d35c9e");
		check(D = x"33d49ac54c1bd7d3");
		check(E = x"7bbe45d7e5d9720d");
		check(F = x"942774d1e693a623");
		check(G = x"c34ce5efeda09acf");
		check(H = x"9ada5c9181c42460");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"b0fc120506684498");
		check(B = x"95fc3de2ca427117");
		check(C = x"38bbda404e3c11f");
		check(D = x"657cbe54f6d35c9e");
		check(E = x"bb0e506f629a21d");
		check(F = x"7bbe45d7e5d9720d");
		check(G = x"942774d1e693a623");
		check(H = x"c34ce5efeda09acf");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"6ebf4d1d9ed1e618");
		check(B = x"b0fc120506684498");
		check(C = x"95fc3de2ca427117");
		check(D = x"38bbda404e3c11f");
		check(E = x"152d45aa7ca324a2");
		check(F = x"bb0e506f629a21d");
		check(G = x"7bbe45d7e5d9720d");
		check(H = x"942774d1e693a623");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"850888c26d2e4137");
		check(B = x"6ebf4d1d9ed1e618");
		check(C = x"b0fc120506684498");
		check(D = x"95fc3de2ca427117");
		check(E = x"22006d94234b223a");
		check(F = x"152d45aa7ca324a2");
		check(G = x"bb0e506f629a21d");
		check(H = x"7bbe45d7e5d9720d");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"8b55c78bd35f984f");
		check(B = x"850888c26d2e4137");
		check(C = x"6ebf4d1d9ed1e618");
		check(D = x"b0fc120506684498");
		check(E = x"af201db1b0790647");
		check(F = x"22006d94234b223a");
		check(G = x"152d45aa7ca324a2");
		check(H = x"bb0e506f629a21d");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"6fe865dfd0d2459f");
		check(B = x"8b55c78bd35f984f");
		check(C = x"850888c26d2e4137");
		check(D = x"6ebf4d1d9ed1e618");
		check(E = x"bb3dcc7d2f3b2748");
		check(F = x"af201db1b0790647");
		check(G = x"22006d94234b223a");
		check(H = x"152d45aa7ca324a2");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"ec1b9f2c45f898d");
		check(B = x"6fe865dfd0d2459f");
		check(C = x"8b55c78bd35f984f");
		check(D = x"850888c26d2e4137");
		check(E = x"a786d52a762f9a45");
		check(F = x"bb3dcc7d2f3b2748");
		check(G = x"af201db1b0790647");
		check(H = x"22006d94234b223a");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"9ca38f6adda2d24c");
		check(B = x"ec1b9f2c45f898d");
		check(C = x"6fe865dfd0d2459f");
		check(D = x"8b55c78bd35f984f");
		check(E = x"826cb0c4bb17d1");
		check(F = x"a786d52a762f9a45");
		check(G = x"bb3dcc7d2f3b2748");
		check(H = x"af201db1b0790647");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"68391a248739f0b2");
		check(B = x"9ca38f6adda2d24c");
		check(C = x"ec1b9f2c45f898d");
		check(D = x"6fe865dfd0d2459f");
		check(E = x"2bae5db7119d750b");
		check(F = x"826cb0c4bb17d1");
		check(G = x"a786d52a762f9a45");
		check(H = x"bb3dcc7d2f3b2748");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"4a4c618c2a01ff18");
		check(B = x"68391a248739f0b2");
		check(C = x"9ca38f6adda2d24c");
		check(D = x"ec1b9f2c45f898d");
		check(E = x"9234271db848dd36");
		check(F = x"2bae5db7119d750b");
		check(G = x"826cb0c4bb17d1");
		check(H = x"a786d52a762f9a45");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"459078e0055d61ca");
		check(B = x"4a4c618c2a01ff18");
		check(C = x"68391a248739f0b2");
		check(D = x"9ca38f6adda2d24c");
		check(E = x"595d99e9b3d960dd");
		check(F = x"9234271db848dd36");
		check(G = x"2bae5db7119d750b");
		check(H = x"826cb0c4bb17d1");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"7ec1c7ec0edb1420");
		check(B = x"459078e0055d61ca");
		check(C = x"4a4c618c2a01ff18");
		check(D = x"68391a248739f0b2");
		check(E = x"3ec0e09d887b4409");
		check(F = x"595d99e9b3d960dd");
		check(G = x"9234271db848dd36");
		check(H = x"2bae5db7119d750b");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"1639b76b30474a40");
		check(B = x"7ec1c7ec0edb1420");
		check(C = x"459078e0055d61ca");
		check(D = x"4a4c618c2a01ff18");
		check(E = x"f9983e7bf5d63936");
		check(F = x"3ec0e09d887b4409");
		check(G = x"595d99e9b3d960dd");
		check(H = x"9234271db848dd36");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"f5a127622532f810");
		check(B = x"1639b76b30474a40");
		check(C = x"7ec1c7ec0edb1420");
		check(D = x"459078e0055d61ca");
		check(E = x"cb559900649c4ee1");
		check(F = x"f9983e7bf5d63936");
		check(G = x"3ec0e09d887b4409");
		check(H = x"595d99e9b3d960dd");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"6d180f154a4ff493");
		check(B = x"f5a127622532f810");
		check(C = x"1639b76b30474a40");
		check(D = x"7ec1c7ec0edb1420");
		check(E = x"1ddd858fe4c880a9");
		check(F = x"cb559900649c4ee1");
		check(G = x"f9983e7bf5d63936");
		check(H = x"3ec0e09d887b4409");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"739278053da02b03");
		check(B = x"6d180f154a4ff493");
		check(C = x"f5a127622532f810");
		check(D = x"1639b76b30474a40");
		check(E = x"a022ec9300168484");
		check(F = x"1ddd858fe4c880a9");
		check(G = x"cb559900649c4ee1");
		check(H = x"f9983e7bf5d63936");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"454d963b8fe1f19c");
		check(B = x"739278053da02b03");
		check(C = x"6d180f154a4ff493");
		check(D = x"f5a127622532f810");
		check(E = x"46e523ffafe20927");
		check(F = x"a022ec9300168484");
		check(G = x"1ddd858fe4c880a9");
		check(H = x"cb559900649c4ee1");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"e225c8edaf2867a7");
		check(B = x"454d963b8fe1f19c");
		check(C = x"739278053da02b03");
		check(D = x"6d180f154a4ff493");
		check(E = x"7b62bfa4778d10a");
		check(F = x"46e523ffafe20927");
		check(G = x"a022ec9300168484");
		check(H = x"1ddd858fe4c880a9");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"f0ee66e7ecf2e4c");
		check(B = x"e225c8edaf2867a7");
		check(C = x"454d963b8fe1f19c");
		check(D = x"739278053da02b03");
		check(E = x"d70ee9fd846d07e8");
		check(F = x"7b62bfa4778d10a");
		check(G = x"46e523ffafe20927");
		check(H = x"a022ec9300168484");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"2efa6d17b2989ac4");
		check(B = x"f0ee66e7ecf2e4c");
		check(C = x"e225c8edaf2867a7");
		check(D = x"454d963b8fe1f19c");
		check(E = x"abc26d9dd51b9b8b");
		check(F = x"d70ee9fd846d07e8");
		check(G = x"7b62bfa4778d10a");
		check(H = x"46e523ffafe20927");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"487a290caf33b698");
		check(B = x"2efa6d17b2989ac4");
		check(C = x"f0ee66e7ecf2e4c");
		check(D = x"e225c8edaf2867a7");
		check(E = x"754e17121447ba8c");
		check(F = x"abc26d9dd51b9b8b");
		check(G = x"d70ee9fd846d07e8");
		check(H = x"7b62bfa4778d10a");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"259b15b6c24b4908");
		check(B = x"487a290caf33b698");
		check(C = x"2efa6d17b2989ac4");
		check(D = x"f0ee66e7ecf2e4c");
		check(E = x"379c8e460dab0308");
		check(F = x"754e17121447ba8c");
		check(G = x"abc26d9dd51b9b8b");
		check(H = x"d70ee9fd846d07e8");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"2bcf550bd7c1685");
		check(B = x"259b15b6c24b4908");
		check(C = x"487a290caf33b698");
		check(D = x"2efa6d17b2989ac4");
		check(E = x"eb2eda565993021f");
		check(F = x"379c8e460dab0308");
		check(G = x"754e17121447ba8c");
		check(H = x"abc26d9dd51b9b8b");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"a5335b8ba7fe9cbf");
		check(B = x"2bcf550bd7c1685");
		check(C = x"259b15b6c24b4908");
		check(D = x"487a290caf33b698");
		check(E = x"798efdb249b70f46");
		check(F = x"eb2eda565993021f");
		check(G = x"379c8e460dab0308");
		check(H = x"754e17121447ba8c");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"588e0ef6a917af62");
		check(B = x"a5335b8ba7fe9cbf");
		check(C = x"2bcf550bd7c1685");
		check(D = x"259b15b6c24b4908");
		check(E = x"f9f35083eb9a407e");
		check(F = x"798efdb249b70f46");
		check(G = x"eb2eda565993021f");
		check(H = x"379c8e460dab0308");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"3638e36dfefe6215");
		check(B = x"588e0ef6a917af62");
		check(C = x"a5335b8ba7fe9cbf");
		check(D = x"2bcf550bd7c1685");
		check(E = x"84a866ae39589bac");
		check(F = x"f9f35083eb9a407e");
		check(G = x"798efdb249b70f46");
		check(H = x"eb2eda565993021f");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"a3065070f177fd07");
		check(B = x"3638e36dfefe6215");
		check(C = x"588e0ef6a917af62");
		check(D = x"a5335b8ba7fe9cbf");
		check(E = x"25e4b4bffa88e593");
		check(F = x"84a866ae39589bac");
		check(G = x"f9f35083eb9a407e");
		check(H = x"798efdb249b70f46");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"cf17125a0cf22824");
		check(B = x"a3065070f177fd07");
		check(C = x"3638e36dfefe6215");
		check(D = x"588e0ef6a917af62");
		check(E = x"777b6aaee3963629");
		check(F = x"25e4b4bffa88e593");
		check(G = x"84a866ae39589bac");
		check(H = x"f9f35083eb9a407e");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"2b4c8bf6961cb71e");
		check(B = x"cf17125a0cf22824");
		check(C = x"a3065070f177fd07");
		check(D = x"3638e36dfefe6215");
		check(E = x"e4bc5c5eb7132f69");
		check(F = x"777b6aaee3963629");
		check(G = x"25e4b4bffa88e593");
		check(H = x"84a866ae39589bac");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"293df36db3913e16");
		check(B = x"2b4c8bf6961cb71e");
		check(C = x"cf17125a0cf22824");
		check(D = x"a3065070f177fd07");
		check(E = x"8b105f1e1bcbdea2");
		check(F = x"e4bc5c5eb7132f69");
		check(G = x"777b6aaee3963629");
		check(H = x"25e4b4bffa88e593");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"b4c754feb89131ab");
		check(B = x"293df36db3913e16");
		check(C = x"2b4c8bf6961cb71e");
		check(D = x"cf17125a0cf22824");
		check(E = x"9e1f8555ddb6beb6");
		check(F = x"8b105f1e1bcbdea2");
		check(G = x"e4bc5c5eb7132f69");
		check(H = x"777b6aaee3963629");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"1f20daf5ab651e72");
		check(B = x"b4c754feb89131ab");
		check(C = x"293df36db3913e16");
		check(D = x"2b4c8bf6961cb71e");
		check(E = x"eaa3a49e0f98fafb");
		check(F = x"9e1f8555ddb6beb6");
		check(G = x"8b105f1e1bcbdea2");
		check(H = x"e4bc5c5eb7132f69");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"b56c5f95f6f0d862");
		check(B = x"1f20daf5ab651e72");
		check(C = x"b4c754feb89131ab");
		check(D = x"293df36db3913e16");
		check(E = x"6bb4ae0d3f8078fc");
		check(F = x"eaa3a49e0f98fafb");
		check(G = x"9e1f8555ddb6beb6");
		check(H = x"8b105f1e1bcbdea2");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"9968df1b199e65b5");
		check(B = x"b56c5f95f6f0d862");
		check(C = x"1f20daf5ab651e72");
		check(D = x"b4c754feb89131ab");
		check(E = x"d3e6220fd34a5564");
		check(F = x"6bb4ae0d3f8078fc");
		check(G = x"eaa3a49e0f98fafb");
		check(H = x"9e1f8555ddb6beb6");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"b9a1cb68e82adbb7");
		check(B = x"9968df1b199e65b5");
		check(C = x"b56c5f95f6f0d862");
		check(D = x"1f20daf5ab651e72");
		check(E = x"674d41d248e29927");
		check(F = x"d3e6220fd34a5564");
		check(G = x"6bb4ae0d3f8078fc");
		check(H = x"eaa3a49e0f98fafb");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"b537162ae6674d8c");
		check(B = x"b9a1cb68e82adbb7");
		check(C = x"9968df1b199e65b5");
		check(D = x"b56c5f95f6f0d862");
		check(E = x"b177b9e57e0a0a85");
		check(F = x"674d41d248e29927");
		check(G = x"d3e6220fd34a5564");
		check(H = x"6bb4ae0d3f8078fc");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"1f40fc92da241694");
		check(H1_out = x"750979ee6cf582f2");
		check(H2_out = x"d5d7d28e18335de0");
		check(H3_out = x"5abc54d0560e0f53");
		check(H4_out = x"2860c652bf08d56");
		check(H5_out = x"252aa5e74210546");
		check(H6_out = x"f369fbbbce8c12cf");
		check(H7_out = x"c7957b2652fe9a75");

		test_runner_cleanup(runner);
	end process;

end unit_sha512_test_1_tb_arch;

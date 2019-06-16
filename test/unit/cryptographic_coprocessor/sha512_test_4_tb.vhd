library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

-- 208 bits message ("abcdefghijklmnopqrstuvwxyz")

entity unit_sha512_test_4_tb IS
	generic(
		runner_cfg : string
	);
end unit_sha512_test_4_tb;

architecture unit_sha512_test_4_tb_arch OF unit_sha512_test_4_tb IS
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

		-- Write the 208 bits message ("abcdefghijklmnopqrstuvwxyz")
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

		data_in               <= x"797a0000";
		data_in_word_position <= to_unsigned(6, 5);
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(208, 11);
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
		check(A = x"63dbf04e6fe25921");
		check(B = x"ccdda1221b49c11f");
		check(C = x"12775dac3bb56669");
		check(D = x"f6afce9d2263455d");
		check(E = x"806d16d126c91ba1");
		check(F = x"28492b32ba923ffe");
		check(G = x"ffce2096eaa55393");
		check(H = x"58cb0218e01b86f9");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"8ecc9dc8efa90c3e");
		check(B = x"63dbf04e6fe25921");
		check(C = x"ccdda1221b49c11f");
		check(D = x"12775dac3bb56669");
		check(E = x"4999ba4bae9cc15d");
		check(F = x"806d16d126c91ba1");
		check(G = x"28492b32ba923ffe");
		check(H = x"ffce2096eaa55393");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"aa8104a3a29eac5e");
		check(B = x"8ecc9dc8efa90c3e");
		check(C = x"63dbf04e6fe25921");
		check(D = x"ccdda1221b49c11f");
		check(E = x"9d74de063c0366c1");
		check(F = x"4999ba4bae9cc15d");
		check(G = x"806d16d126c91ba1");
		check(H = x"28492b32ba923ffe");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"361c4458775ac3b5");
		check(B = x"aa8104a3a29eac5e");
		check(C = x"8ecc9dc8efa90c3e");
		check(D = x"63dbf04e6fe25921");
		check(E = x"d227fd09e3156f7b");
		check(F = x"9d74de063c0366c1");
		check(G = x"4999ba4bae9cc15d");
		check(H = x"806d16d126c91ba1");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"af26cd8d121762c3");
		check(B = x"361c4458775ac3b5");
		check(C = x"aa8104a3a29eac5e");
		check(D = x"8ecc9dc8efa90c3e");
		check(E = x"8be27ad9542fc38d");
		check(F = x"d227fd09e3156f7b");
		check(G = x"9d74de063c0366c1");
		check(H = x"4999ba4bae9cc15d");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"7833da5d3dd62871");
		check(B = x"af26cd8d121762c3");
		check(C = x"361c4458775ac3b5");
		check(D = x"aa8104a3a29eac5e");
		check(E = x"d924594d5c652baf");
		check(F = x"8be27ad9542fc38d");
		check(G = x"d227fd09e3156f7b");
		check(H = x"9d74de063c0366c1");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"e4ba4357944b6ade");
		check(B = x"7833da5d3dd62871");
		check(C = x"af26cd8d121762c3");
		check(D = x"361c4458775ac3b5");
		check(E = x"2897da42bfd27f5b");
		check(F = x"d924594d5c652baf");
		check(G = x"8be27ad9542fc38d");
		check(H = x"d227fd09e3156f7b");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"c06329d0241124e3");
		check(B = x"e4ba4357944b6ade");
		check(C = x"7833da5d3dd62871");
		check(D = x"af26cd8d121762c3");
		check(E = x"fbbfc13f37d0ac9b");
		check(F = x"2897da42bfd27f5b");
		check(G = x"d924594d5c652baf");
		check(H = x"8be27ad9542fc38d");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"d8eb39c8c9712f1c");
		check(B = x"c06329d0241124e3");
		check(C = x"e4ba4357944b6ade");
		check(D = x"7833da5d3dd62871");
		check(E = x"bf8096b3758ad7c7");
		check(F = x"fbbfc13f37d0ac9b");
		check(G = x"2897da42bfd27f5b");
		check(H = x"d924594d5c652baf");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"b097d5e4b0f9e026");
		check(B = x"d8eb39c8c9712f1c");
		check(C = x"c06329d0241124e3");
		check(D = x"e4ba4357944b6ade");
		check(E = x"33042e1ce946552c");
		check(F = x"bf8096b3758ad7c7");
		check(G = x"fbbfc13f37d0ac9b");
		check(H = x"2897da42bfd27f5b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"30667ad32113d9c1");
		check(B = x"b097d5e4b0f9e026");
		check(C = x"d8eb39c8c9712f1c");
		check(D = x"c06329d0241124e3");
		check(E = x"597bfac72cb49be0");
		check(F = x"33042e1ce946552c");
		check(G = x"bf8096b3758ad7c7");
		check(H = x"fbbfc13f37d0ac9b");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"aa2de7a925b8c070");
		check(B = x"30667ad32113d9c1");
		check(C = x"b097d5e4b0f9e026");
		check(D = x"d8eb39c8c9712f1c");
		check(E = x"3a6e49e7e038fcdc");
		check(F = x"597bfac72cb49be0");
		check(G = x"33042e1ce946552c");
		check(H = x"bf8096b3758ad7c7");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"cb1030dbd52101eb");
		check(B = x"aa2de7a925b8c070");
		check(C = x"30667ad32113d9c1");
		check(D = x"b097d5e4b0f9e026");
		check(E = x"b32a2c2d13d717f0");
		check(F = x"3a6e49e7e038fcdc");
		check(G = x"597bfac72cb49be0");
		check(H = x"33042e1ce946552c");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"7f59fcc01938abc9");
		check(B = x"cb1030dbd52101eb");
		check(C = x"aa2de7a925b8c070");
		check(D = x"30667ad32113d9c1");
		check(E = x"74db430410afa824");
		check(F = x"b32a2c2d13d717f0");
		check(G = x"3a6e49e7e038fcdc");
		check(H = x"597bfac72cb49be0");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"f6b8db5c8608dbb8");
		check(B = x"7f59fcc01938abc9");
		check(C = x"cb1030dbd52101eb");
		check(D = x"aa2de7a925b8c070");
		check(E = x"260e7a34592d32c8");
		check(F = x"74db430410afa824");
		check(G = x"b32a2c2d13d717f0");
		check(H = x"3a6e49e7e038fcdc");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"367a91ea5ce9685d");
		check(B = x"f6b8db5c8608dbb8");
		check(C = x"7f59fcc01938abc9");
		check(D = x"cb1030dbd52101eb");
		check(E = x"e98be3e4c5aaaa3b");
		check(F = x"260e7a34592d32c8");
		check(G = x"74db430410afa824");
		check(H = x"b32a2c2d13d717f0");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"a5da9dd203596b52");
		check(B = x"367a91ea5ce9685d");
		check(C = x"f6b8db5c8608dbb8");
		check(D = x"7f59fcc01938abc9");
		check(E = x"6d5ce7d12bf63168");
		check(F = x"e98be3e4c5aaaa3b");
		check(G = x"260e7a34592d32c8");
		check(H = x"74db430410afa824");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"36acf153e02589cd");
		check(B = x"a5da9dd203596b52");
		check(C = x"367a91ea5ce9685d");
		check(D = x"f6b8db5c8608dbb8");
		check(E = x"edc5f711a17ffacf");
		check(F = x"6d5ce7d12bf63168");
		check(G = x"e98be3e4c5aaaa3b");
		check(H = x"260e7a34592d32c8");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"a9b368ce71537479");
		check(B = x"36acf153e02589cd");
		check(C = x"a5da9dd203596b52");
		check(D = x"367a91ea5ce9685d");
		check(E = x"bdffca4f9e9764c");
		check(F = x"edc5f711a17ffacf");
		check(G = x"6d5ce7d12bf63168");
		check(H = x"e98be3e4c5aaaa3b");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"e35f1773958cd2ad");
		check(B = x"a9b368ce71537479");
		check(C = x"36acf153e02589cd");
		check(D = x"a5da9dd203596b52");
		check(E = x"5e9d731f8f1ba1ac");
		check(F = x"bdffca4f9e9764c");
		check(G = x"edc5f711a17ffacf");
		check(H = x"6d5ce7d12bf63168");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"9ad2b12e228ff7f3");
		check(B = x"e35f1773958cd2ad");
		check(C = x"a9b368ce71537479");
		check(D = x"36acf153e02589cd");
		check(E = x"4268d5dc1e03858d");
		check(F = x"5e9d731f8f1ba1ac");
		check(G = x"bdffca4f9e9764c");
		check(H = x"edc5f711a17ffacf");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"71e06aa6c230ce40");
		check(B = x"9ad2b12e228ff7f3");
		check(C = x"e35f1773958cd2ad");
		check(D = x"a9b368ce71537479");
		check(E = x"a08d61c41c4549");
		check(F = x"4268d5dc1e03858d");
		check(G = x"5e9d731f8f1ba1ac");
		check(H = x"bdffca4f9e9764c");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"c3456799fc791b16");
		check(B = x"71e06aa6c230ce40");
		check(C = x"9ad2b12e228ff7f3");
		check(D = x"e35f1773958cd2ad");
		check(E = x"9b21e73668a2489e");
		check(F = x"a08d61c41c4549");
		check(G = x"4268d5dc1e03858d");
		check(H = x"5e9d731f8f1ba1ac");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"c147bda8ac721d35");
		check(B = x"c3456799fc791b16");
		check(C = x"71e06aa6c230ce40");
		check(D = x"9ad2b12e228ff7f3");
		check(E = x"456f6bcdb6c365da");
		check(F = x"9b21e73668a2489e");
		check(G = x"a08d61c41c4549");
		check(H = x"4268d5dc1e03858d");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"886693a30d72662d");
		check(B = x"c147bda8ac721d35");
		check(C = x"c3456799fc791b16");
		check(D = x"71e06aa6c230ce40");
		check(E = x"a48e24fd33e98471");
		check(F = x"456f6bcdb6c365da");
		check(G = x"9b21e73668a2489e");
		check(H = x"a08d61c41c4549");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"55c2755b8ada568d");
		check(B = x"886693a30d72662d");
		check(C = x"c147bda8ac721d35");
		check(D = x"c3456799fc791b16");
		check(E = x"b3fb08b8e138b199");
		check(F = x"a48e24fd33e98471");
		check(G = x"456f6bcdb6c365da");
		check(H = x"9b21e73668a2489e");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"3d7f2da035f2f3f9");
		check(B = x"55c2755b8ada568d");
		check(C = x"886693a30d72662d");
		check(D = x"c147bda8ac721d35");
		check(E = x"477795b391fd6cde");
		check(F = x"b3fb08b8e138b199");
		check(G = x"a48e24fd33e98471");
		check(H = x"456f6bcdb6c365da");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"243e4f9bbdf68030");
		check(B = x"3d7f2da035f2f3f9");
		check(C = x"55c2755b8ada568d");
		check(D = x"886693a30d72662d");
		check(E = x"b5e77116f19e3788");
		check(F = x"477795b391fd6cde");
		check(G = x"b3fb08b8e138b199");
		check(H = x"a48e24fd33e98471");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"804a372453cec965");
		check(B = x"243e4f9bbdf68030");
		check(C = x"3d7f2da035f2f3f9");
		check(D = x"55c2755b8ada568d");
		check(E = x"cbc40f1d78ab4617");
		check(F = x"b5e77116f19e3788");
		check(G = x"477795b391fd6cde");
		check(H = x"b3fb08b8e138b199");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"46bb28ab678dfd01");
		check(B = x"804a372453cec965");
		check(C = x"243e4f9bbdf68030");
		check(D = x"3d7f2da035f2f3f9");
		check(E = x"1746b4d30cc0263b");
		check(F = x"cbc40f1d78ab4617");
		check(G = x"b5e77116f19e3788");
		check(H = x"477795b391fd6cde");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"5ea20ebab59573df");
		check(B = x"46bb28ab678dfd01");
		check(C = x"804a372453cec965");
		check(D = x"243e4f9bbdf68030");
		check(E = x"9ff358013b2867ea");
		check(F = x"1746b4d30cc0263b");
		check(G = x"cbc40f1d78ab4617");
		check(H = x"b5e77116f19e3788");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"528e5df1833306f7");
		check(B = x"5ea20ebab59573df");
		check(C = x"46bb28ab678dfd01");
		check(D = x"804a372453cec965");
		check(E = x"aec932fd466661ca");
		check(F = x"9ff358013b2867ea");
		check(G = x"1746b4d30cc0263b");
		check(H = x"cbc40f1d78ab4617");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"494121a420e265a0");
		check(B = x"528e5df1833306f7");
		check(C = x"5ea20ebab59573df");
		check(D = x"46bb28ab678dfd01");
		check(E = x"c1e68347ba38624f");
		check(F = x"aec932fd466661ca");
		check(G = x"9ff358013b2867ea");
		check(H = x"1746b4d30cc0263b");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"ff7f6e2e24bb3d15");
		check(B = x"494121a420e265a0");
		check(C = x"528e5df1833306f7");
		check(D = x"5ea20ebab59573df");
		check(E = x"9d59818123c501b7");
		check(F = x"c1e68347ba38624f");
		check(G = x"aec932fd466661ca");
		check(H = x"9ff358013b2867ea");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"8a6d2911e945f31f");
		check(B = x"ff7f6e2e24bb3d15");
		check(C = x"494121a420e265a0");
		check(D = x"528e5df1833306f7");
		check(E = x"eeeb61c7da507994");
		check(F = x"9d59818123c501b7");
		check(G = x"c1e68347ba38624f");
		check(H = x"aec932fd466661ca");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"122b001e9a54f76a");
		check(B = x"8a6d2911e945f31f");
		check(C = x"ff7f6e2e24bb3d15");
		check(D = x"494121a420e265a0");
		check(E = x"cb6f6e1281478844");
		check(F = x"eeeb61c7da507994");
		check(G = x"9d59818123c501b7");
		check(H = x"c1e68347ba38624f");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"993161a0252f184c");
		check(B = x"122b001e9a54f76a");
		check(C = x"8a6d2911e945f31f");
		check(D = x"ff7f6e2e24bb3d15");
		check(E = x"91478902b9ceedf");
		check(F = x"cb6f6e1281478844");
		check(G = x"eeeb61c7da507994");
		check(H = x"9d59818123c501b7");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"2b173fff8da4d8d");
		check(B = x"993161a0252f184c");
		check(C = x"122b001e9a54f76a");
		check(D = x"8a6d2911e945f31f");
		check(E = x"4c17a43347e776ab");
		check(F = x"91478902b9ceedf");
		check(G = x"cb6f6e1281478844");
		check(H = x"eeeb61c7da507994");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"55da8edee27c5ebc");
		check(B = x"2b173fff8da4d8d");
		check(C = x"993161a0252f184c");
		check(D = x"122b001e9a54f76a");
		check(E = x"41b25709a1a5f2a8");
		check(F = x"4c17a43347e776ab");
		check(G = x"91478902b9ceedf");
		check(H = x"cb6f6e1281478844");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"3afdf17e85205e11");
		check(B = x"55da8edee27c5ebc");
		check(C = x"2b173fff8da4d8d");
		check(D = x"993161a0252f184c");
		check(E = x"18d988c70e80fdab");
		check(F = x"41b25709a1a5f2a8");
		check(G = x"4c17a43347e776ab");
		check(H = x"91478902b9ceedf");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"f07e5eb39ab13257");
		check(B = x"3afdf17e85205e11");
		check(C = x"55da8edee27c5ebc");
		check(D = x"2b173fff8da4d8d");
		check(E = x"686e16291c525bb1");
		check(F = x"18d988c70e80fdab");
		check(G = x"41b25709a1a5f2a8");
		check(H = x"4c17a43347e776ab");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"b9a906c0c641d1e4");
		check(B = x"f07e5eb39ab13257");
		check(C = x"3afdf17e85205e11");
		check(D = x"55da8edee27c5ebc");
		check(E = x"20d19033e8d14134");
		check(F = x"686e16291c525bb1");
		check(G = x"18d988c70e80fdab");
		check(H = x"41b25709a1a5f2a8");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"ba80039747fb2cec");
		check(B = x"b9a906c0c641d1e4");
		check(C = x"f07e5eb39ab13257");
		check(D = x"3afdf17e85205e11");
		check(E = x"835b51f226ccb9a2");
		check(F = x"20d19033e8d14134");
		check(G = x"686e16291c525bb1");
		check(H = x"18d988c70e80fdab");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"de956882df1b9492");
		check(B = x"ba80039747fb2cec");
		check(C = x"b9a906c0c641d1e4");
		check(D = x"f07e5eb39ab13257");
		check(E = x"e0275fc43d758829");
		check(F = x"835b51f226ccb9a2");
		check(G = x"20d19033e8d14134");
		check(H = x"686e16291c525bb1");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"63a72a53f2c84890");
		check(B = x"de956882df1b9492");
		check(C = x"ba80039747fb2cec");
		check(D = x"b9a906c0c641d1e4");
		check(E = x"55e2eb644aceed27");
		check(F = x"e0275fc43d758829");
		check(G = x"835b51f226ccb9a2");
		check(H = x"20d19033e8d14134");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"20a6a3f960360733");
		check(B = x"63a72a53f2c84890");
		check(C = x"de956882df1b9492");
		check(D = x"ba80039747fb2cec");
		check(E = x"67f774734c40aa88");
		check(F = x"55e2eb644aceed27");
		check(G = x"e0275fc43d758829");
		check(H = x"835b51f226ccb9a2");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"85bec73d0138a8a4");
		check(B = x"20a6a3f960360733");
		check(C = x"63a72a53f2c84890");
		check(D = x"de956882df1b9492");
		check(E = x"33ea010fb316f6cf");
		check(F = x"67f774734c40aa88");
		check(G = x"55e2eb644aceed27");
		check(H = x"e0275fc43d758829");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"b7a7499217206482");
		check(B = x"85bec73d0138a8a4");
		check(C = x"20a6a3f960360733");
		check(D = x"63a72a53f2c84890");
		check(E = x"4acf3d6b627b30d3");
		check(F = x"33ea010fb316f6cf");
		check(G = x"67f774734c40aa88");
		check(H = x"55e2eb644aceed27");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"86cf656a6488ecd5");
		check(B = x"b7a7499217206482");
		check(C = x"85bec73d0138a8a4");
		check(D = x"20a6a3f960360733");
		check(E = x"70efba42832f0aed");
		check(F = x"4acf3d6b627b30d3");
		check(G = x"33ea010fb316f6cf");
		check(H = x"67f774734c40aa88");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"42d5fd7d8f9128a9");
		check(B = x"86cf656a6488ecd5");
		check(C = x"b7a7499217206482");
		check(D = x"85bec73d0138a8a4");
		check(E = x"d667748844563222");
		check(F = x"70efba42832f0aed");
		check(G = x"4acf3d6b627b30d3");
		check(H = x"33ea010fb316f6cf");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"b8473fd5a3020947");
		check(B = x"42d5fd7d8f9128a9");
		check(C = x"86cf656a6488ecd5");
		check(D = x"b7a7499217206482");
		check(E = x"5554b6a96d4b41ed");
		check(F = x"d667748844563222");
		check(G = x"70efba42832f0aed");
		check(H = x"4acf3d6b627b30d3");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"9474924d3beaf1bb");
		check(B = x"b8473fd5a3020947");
		check(C = x"42d5fd7d8f9128a9");
		check(D = x"86cf656a6488ecd5");
		check(E = x"d5ae4c28c67870a8");
		check(F = x"5554b6a96d4b41ed");
		check(G = x"d667748844563222");
		check(H = x"70efba42832f0aed");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"941f0eba186c57bc");
		check(B = x"9474924d3beaf1bb");
		check(C = x"b8473fd5a3020947");
		check(D = x"42d5fd7d8f9128a9");
		check(E = x"20764291fbf63182");
		check(F = x"d5ae4c28c67870a8");
		check(G = x"5554b6a96d4b41ed");
		check(H = x"d667748844563222");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"7a66f24be9bba4d0");
		check(B = x"941f0eba186c57bc");
		check(C = x"9474924d3beaf1bb");
		check(D = x"b8473fd5a3020947");
		check(E = x"b3f71a63200365a8");
		check(F = x"20764291fbf63182");
		check(G = x"d5ae4c28c67870a8");
		check(H = x"5554b6a96d4b41ed");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"8a54b1b5456b7038");
		check(B = x"7a66f24be9bba4d0");
		check(C = x"941f0eba186c57bc");
		check(D = x"9474924d3beaf1bb");
		check(E = x"b81d8bc596802dff");
		check(F = x"b3f71a63200365a8");
		check(G = x"20764291fbf63182");
		check(H = x"d5ae4c28c67870a8");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"6799ccc865d481db");
		check(B = x"8a54b1b5456b7038");
		check(C = x"7a66f24be9bba4d0");
		check(D = x"941f0eba186c57bc");
		check(E = x"f450a2f361896084");
		check(F = x"b81d8bc596802dff");
		check(G = x"b3f71a63200365a8");
		check(H = x"20764291fbf63182");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"beef5297560acfde");
		check(B = x"6799ccc865d481db");
		check(C = x"8a54b1b5456b7038");
		check(D = x"7a66f24be9bba4d0");
		check(E = x"13c2dbc4f1c5fa95");
		check(F = x"f450a2f361896084");
		check(G = x"b81d8bc596802dff");
		check(H = x"b3f71a63200365a8");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"83b9f0bcae50c69a");
		check(B = x"beef5297560acfde");
		check(C = x"6799ccc865d481db");
		check(D = x"8a54b1b5456b7038");
		check(E = x"b3c0b6ef568e861b");
		check(F = x"13c2dbc4f1c5fa95");
		check(G = x"f450a2f361896084");
		check(H = x"b81d8bc596802dff");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"f3a1ffde4583746c");
		check(B = x"83b9f0bcae50c69a");
		check(C = x"beef5297560acfde");
		check(D = x"6799ccc865d481db");
		check(E = x"1e77e773762818c6");
		check(F = x"b3c0b6ef568e861b");
		check(G = x"13c2dbc4f1c5fa95");
		check(H = x"f450a2f361896084");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"2a7f359b1448c7eb");
		check(B = x"f3a1ffde4583746c");
		check(C = x"83b9f0bcae50c69a");
		check(D = x"beef5297560acfde");
		check(E = x"689272885509c0fc");
		check(F = x"1e77e773762818c6");
		check(G = x"b3c0b6ef568e861b");
		check(H = x"13c2dbc4f1c5fa95");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"15152a49f0e657cd");
		check(B = x"2a7f359b1448c7eb");
		check(C = x"f3a1ffde4583746c");
		check(D = x"83b9f0bcae50c69a");
		check(E = x"7893a87b8777f605");
		check(F = x"689272885509c0fc");
		check(G = x"1e77e773762818c6");
		check(H = x"b3c0b6ef568e861b");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"a999c3775d33e414");
		check(B = x"15152a49f0e657cd");
		check(C = x"2a7f359b1448c7eb");
		check(D = x"f3a1ffde4583746c");
		check(E = x"18614ecb28848e68");
		check(F = x"7893a87b8777f605");
		check(G = x"689272885509c0fc");
		check(H = x"1e77e773762818c6");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"995c6990f135f8c4");
		check(B = x"a999c3775d33e414");
		check(C = x"15152a49f0e657cd");
		check(D = x"2a7f359b1448c7eb");
		check(E = x"7918668c47ad3135");
		check(F = x"18614ecb28848e68");
		check(G = x"7893a87b8777f605");
		check(H = x"689272885509c0fc");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"86de03a56f04404");
		check(B = x"995c6990f135f8c4");
		check(C = x"a999c3775d33e414");
		check(D = x"15152a49f0e657cd");
		check(E = x"8adf10fa3f5ddb73");
		check(F = x"7918668c47ad3135");
		check(G = x"18614ecb28848e68");
		check(H = x"7893a87b8777f605");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"7073804f2cbb8c96");
		check(B = x"86de03a56f04404");
		check(C = x"995c6990f135f8c4");
		check(D = x"a999c3775d33e414");
		check(E = x"6e15179d3b9a5ff4");
		check(F = x"8adf10fa3f5ddb73");
		check(G = x"7918668c47ad3135");
		check(H = x"18614ecb28848e68");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"14b7e4e2ea6a1c6");
		check(B = x"7073804f2cbb8c96");
		check(C = x"86de03a56f04404");
		check(D = x"995c6990f135f8c4");
		check(E = x"f398044f5f64b575");
		check(F = x"6e15179d3b9a5ff4");
		check(G = x"8adf10fa3f5ddb73");
		check(H = x"7918668c47ad3135");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"846b1a0a5e6020db");
		check(B = x"14b7e4e2ea6a1c6");
		check(C = x"7073804f2cbb8c96");
		check(D = x"86de03a56f04404");
		check(E = x"1fbca9fb07fbe78c");
		check(F = x"f398044f5f64b575");
		check(G = x"6e15179d3b9a5ff4");
		check(H = x"8adf10fa3f5ddb73");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"8bfcf2428e43a5");
		check(B = x"846b1a0a5e6020db");
		check(C = x"14b7e4e2ea6a1c6");
		check(D = x"7073804f2cbb8c96");
		check(E = x"a367fd0f5a3836c0");
		check(F = x"1fbca9fb07fbe78c");
		check(G = x"f398044f5f64b575");
		check(H = x"6e15179d3b9a5ff4");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"71e24054b1f5f290");
		check(B = x"8bfcf2428e43a5");
		check(C = x"846b1a0a5e6020db");
		check(D = x"14b7e4e2ea6a1c6");
		check(E = x"85478c1b8d6f357e");
		check(F = x"a367fd0f5a3836c0");
		check(G = x"1fbca9fb07fbe78c");
		check(H = x"f398044f5f64b575");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"8e2bd49c4349037a");
		check(B = x"71e24054b1f5f290");
		check(C = x"8bfcf2428e43a5");
		check(D = x"846b1a0a5e6020db");
		check(E = x"f44a3c51fc4bf0d1");
		check(F = x"85478c1b8d6f357e");
		check(G = x"a367fd0f5a3836c0");
		check(H = x"1fbca9fb07fbe78c");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"7577c47ae1ba8d45");
		check(B = x"8e2bd49c4349037a");
		check(C = x"71e24054b1f5f290");
		check(D = x"8bfcf2428e43a5");
		check(E = x"dc72244048217f26");
		check(F = x"f44a3c51fc4bf0d1");
		check(G = x"85478c1b8d6f357e");
		check(H = x"a367fd0f5a3836c0");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"bb6d0847ce4ce120");
		check(B = x"7577c47ae1ba8d45");
		check(C = x"8e2bd49c4349037a");
		check(D = x"71e24054b1f5f290");
		check(E = x"f0903ec0ae16483d");
		check(F = x"dc72244048217f26");
		check(G = x"f44a3c51fc4bf0d1");
		check(H = x"85478c1b8d6f357e");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"291b7bae68eaccda");
		check(B = x"bb6d0847ce4ce120");
		check(C = x"7577c47ae1ba8d45");
		check(D = x"8e2bd49c4349037a");
		check(E = x"42cc44227e1b218d");
		check(F = x"f0903ec0ae16483d");
		check(G = x"dc72244048217f26");
		check(H = x"f44a3c51fc4bf0d1");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"8f399a6fbb8ead38");
		check(B = x"291b7bae68eaccda");
		check(C = x"bb6d0847ce4ce120");
		check(D = x"7577c47ae1ba8d45");
		check(E = x"9b9e7b8f66499078");
		check(F = x"42cc44227e1b218d");
		check(G = x"f0903ec0ae16483d");
		check(H = x"dc72244048217f26");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"8d1023e0be4e6965");
		check(B = x"8f399a6fbb8ead38");
		check(C = x"291b7bae68eaccda");
		check(D = x"bb6d0847ce4ce120");
		check(E = x"cdd0684f13f0561e");
		check(F = x"9b9e7b8f66499078");
		check(G = x"42cc44227e1b218d");
		check(H = x"f0903ec0ae16483d");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"62ae98048100f146");
		check(B = x"8d1023e0be4e6965");
		check(C = x"8f399a6fbb8ead38");
		check(D = x"291b7bae68eaccda");
		check(E = x"86f8d38a1b22ce3a");
		check(F = x"cdd0684f13f0561e");
		check(G = x"9b9e7b8f66499078");
		check(H = x"42cc44227e1b218d");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"e3b61204cf0d52a6");
		check(B = x"62ae98048100f146");
		check(C = x"8d1023e0be4e6965");
		check(D = x"8f399a6fbb8ead38");
		check(E = x"444bc9793e61baa3");
		check(F = x"86f8d38a1b22ce3a");
		check(G = x"cdd0684f13f0561e");
		check(H = x"9b9e7b8f66499078");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"4dbff86cc2ca1bae");
		check(H1_out = x"1e16468a05cb9881");
		check(H2_out = x"c97f1753bce36190");
		check(H3_out = x"34898faa1aabe429");
		check(H4_out = x"955a1bf8ec483d74");
		check(H5_out = x"21fe3c1646613a59");
		check(H6_out = x"ed5441fb0f321389");
		check(H7_out = x"f77f48a879c7b1f1");

		test_runner_cleanup(runner);
	end process;

end unit_sha512_test_4_tb_arch;

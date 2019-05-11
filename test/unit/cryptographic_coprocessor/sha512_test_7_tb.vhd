library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 640 bits message ("12345678901234567890123456789012345678901234567890123456789012345678901234567890")

entity sha512_test_7_tb IS
	generic(
		runner_cfg : string
	);
end sha512_test_7_tb;

architecture sha512_test_7_tb_arch OF sha512_test_7_tb IS
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

		-- Write the first 512 bits
		write_data_in <= '1';

		data_in               <= x"31323334";
		data_in_word_position <= to_unsigned(0, 5);
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= to_unsigned(1, 5);
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= to_unsigned(2, 5);
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= to_unsigned(3, 5);
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= to_unsigned(4, 5);
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= to_unsigned(5, 5);
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= to_unsigned(6, 5);
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= to_unsigned(7, 5);
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= to_unsigned(8, 5);
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= to_unsigned(9, 5);
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= to_unsigned(10, 5);
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= to_unsigned(11, 5);
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= to_unsigned(12, 5);
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= to_unsigned(13, 5);
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= to_unsigned(14, 5);
		wait until rising_edge(clk);

		data_in               <= x"31323334";
		data_in_word_position <= to_unsigned(15, 5);
		wait until rising_edge(clk);

		data_in               <= x"35363738";
		data_in_word_position <= to_unsigned(16, 5);
		wait until rising_edge(clk);

		data_in               <= x"39303132";
		data_in_word_position <= to_unsigned(17, 5);
		wait until rising_edge(clk);

		data_in               <= x"33343536";
		data_in_word_position <= to_unsigned(18, 5);
		wait until rising_edge(clk);

		data_in               <= x"37383930";
		data_in_word_position <= to_unsigned(19, 5);
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
		check(A = x"c67f9e6cf233152d");
		check(B = x"6a09e667f3bcc908");
		check(C = x"bb67ae8584caa73b");
		check(D = x"3c6ef372fe94f82b");
		check(E = x"289ad1e8afeb56c9");
		check(F = x"510e527fade682d1");
		check(G = x"9b05688c2b3e6c1f");
		check(H = x"1f83d9abfb41bd6b");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"888585e5d84de015");
		check(B = x"c67f9e6cf233152d");
		check(C = x"6a09e667f3bcc908");
		check(D = x"bb67ae8584caa73b");
		check(E = x"142ad935963d54af");
		check(F = x"289ad1e8afeb56c9");
		check(G = x"510e527fade682d1");
		check(H = x"9b05688c2b3e6c1f");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"69f565063160cead");
		check(B = x"888585e5d84de015");
		check(C = x"c67f9e6cf233152d");
		check(D = x"6a09e667f3bcc908");
		check(E = x"21d1aa88028580ac");
		check(F = x"142ad935963d54af");
		check(G = x"289ad1e8afeb56c9");
		check(H = x"510e527fade682d1");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"fdcbaaf63efd7123");
		check(B = x"69f565063160cead");
		check(C = x"888585e5d84de015");
		check(D = x"c67f9e6cf233152d");
		check(E = x"8a9f318a25f9216");
		check(F = x"21d1aa88028580ac");
		check(G = x"142ad935963d54af");
		check(H = x"289ad1e8afeb56c9");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"40115d6848d4b19e");
		check(B = x"fdcbaaf63efd7123");
		check(C = x"69f565063160cead");
		check(D = x"888585e5d84de015");
		check(E = x"90b5a1599e66141b");
		check(F = x"8a9f318a25f9216");
		check(G = x"21d1aa88028580ac");
		check(H = x"142ad935963d54af");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"f4986a2ccbbfc69a");
		check(B = x"40115d6848d4b19e");
		check(C = x"fdcbaaf63efd7123");
		check(D = x"69f565063160cead");
		check(E = x"c35ce5cbbd87119c");
		check(F = x"90b5a1599e66141b");
		check(G = x"8a9f318a25f9216");
		check(H = x"21d1aa88028580ac");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"a2e061d5efb6c8d3");
		check(B = x"f4986a2ccbbfc69a");
		check(C = x"40115d6848d4b19e");
		check(D = x"fdcbaaf63efd7123");
		check(E = x"47b774eb14d01d53");
		check(F = x"c35ce5cbbd87119c");
		check(G = x"90b5a1599e66141b");
		check(H = x"8a9f318a25f9216");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"d195d445218d2bca");
		check(B = x"a2e061d5efb6c8d3");
		check(C = x"f4986a2ccbbfc69a");
		check(D = x"40115d6848d4b19e");
		check(E = x"c372c32f32d8166b");
		check(F = x"47b774eb14d01d53");
		check(G = x"c35ce5cbbd87119c");
		check(H = x"90b5a1599e66141b");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"7861c580c66201e2");
		check(B = x"d195d445218d2bca");
		check(C = x"a2e061d5efb6c8d3");
		check(D = x"f4986a2ccbbfc69a");
		check(E = x"ecefd69aeadbcdbb");
		check(F = x"c372c32f32d8166b");
		check(G = x"47b774eb14d01d53");
		check(H = x"c35ce5cbbd87119c");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"9c919df3a7de29d0");
		check(B = x"7861c580c66201e2");
		check(C = x"d195d445218d2bca");
		check(D = x"a2e061d5efb6c8d3");
		check(E = x"4a13e7fdaf02fbc1");
		check(F = x"ecefd69aeadbcdbb");
		check(G = x"c372c32f32d8166b");
		check(H = x"47b774eb14d01d53");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"b05c3dea9c0f4101");
		check(B = x"9c919df3a7de29d0");
		check(C = x"7861c580c66201e2");
		check(D = x"d195d445218d2bca");
		check(E = x"7501ed094f34495");
		check(F = x"4a13e7fdaf02fbc1");
		check(G = x"ecefd69aeadbcdbb");
		check(H = x"c372c32f32d8166b");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"199ba9c01e5adf5e");
		check(B = x"b05c3dea9c0f4101");
		check(C = x"9c919df3a7de29d0");
		check(D = x"7861c580c66201e2");
		check(E = x"801001494ee59fc0");
		check(F = x"7501ed094f34495");
		check(G = x"4a13e7fdaf02fbc1");
		check(H = x"ecefd69aeadbcdbb");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"60b922fbaabfa64c");
		check(B = x"199ba9c01e5adf5e");
		check(C = x"b05c3dea9c0f4101");
		check(D = x"9c919df3a7de29d0");
		check(E = x"de7933112ed41dbc");
		check(F = x"801001494ee59fc0");
		check(G = x"7501ed094f34495");
		check(H = x"4a13e7fdaf02fbc1");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"2ba7e836118d98fc");
		check(B = x"60b922fbaabfa64c");
		check(C = x"199ba9c01e5adf5e");
		check(D = x"b05c3dea9c0f4101");
		check(E = x"e19f6a258fcee63f");
		check(F = x"de7933112ed41dbc");
		check(G = x"801001494ee59fc0");
		check(H = x"7501ed094f34495");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"b1527de8daeedd5b");
		check(B = x"2ba7e836118d98fc");
		check(C = x"60b922fbaabfa64c");
		check(D = x"199ba9c01e5adf5e");
		check(E = x"47592015139e4944");
		check(F = x"e19f6a258fcee63f");
		check(G = x"de7933112ed41dbc");
		check(H = x"801001494ee59fc0");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"444611aba1514506");
		check(B = x"b1527de8daeedd5b");
		check(C = x"2ba7e836118d98fc");
		check(D = x"60b922fbaabfa64c");
		check(E = x"f24a9319d6eaa2fc");
		check(F = x"47592015139e4944");
		check(G = x"e19f6a258fcee63f");
		check(H = x"de7933112ed41dbc");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"111c5480a82f5fab");
		check(B = x"444611aba1514506");
		check(C = x"b1527de8daeedd5b");
		check(D = x"2ba7e836118d98fc");
		check(E = x"a68c5a21e72915a6");
		check(F = x"f24a9319d6eaa2fc");
		check(G = x"47592015139e4944");
		check(H = x"e19f6a258fcee63f");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"5c01da6cf44753e6");
		check(B = x"111c5480a82f5fab");
		check(C = x"444611aba1514506");
		check(D = x"b1527de8daeedd5b");
		check(E = x"cca4f915d9c52a54");
		check(F = x"a68c5a21e72915a6");
		check(G = x"f24a9319d6eaa2fc");
		check(H = x"47592015139e4944");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"98b629751df96281");
		check(B = x"5c01da6cf44753e6");
		check(C = x"111c5480a82f5fab");
		check(D = x"444611aba1514506");
		check(E = x"5577f279bcfb1456");
		check(F = x"cca4f915d9c52a54");
		check(G = x"a68c5a21e72915a6");
		check(H = x"f24a9319d6eaa2fc");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"2a2d1df9e96950ea");
		check(B = x"98b629751df96281");
		check(C = x"5c01da6cf44753e6");
		check(D = x"111c5480a82f5fab");
		check(E = x"e38b54c3dfccd0ef");
		check(F = x"5577f279bcfb1456");
		check(G = x"cca4f915d9c52a54");
		check(H = x"a68c5a21e72915a6");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"60262e7e169065e");
		check(B = x"2a2d1df9e96950ea");
		check(C = x"98b629751df96281");
		check(D = x"5c01da6cf44753e6");
		check(E = x"dfdc15b09020504c");
		check(F = x"e38b54c3dfccd0ef");
		check(G = x"5577f279bcfb1456");
		check(H = x"cca4f915d9c52a54");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"da5bb897819f01f8");
		check(B = x"60262e7e169065e");
		check(C = x"2a2d1df9e96950ea");
		check(D = x"98b629751df96281");
		check(E = x"b2e72932ed26112");
		check(F = x"dfdc15b09020504c");
		check(G = x"e38b54c3dfccd0ef");
		check(H = x"5577f279bcfb1456");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"5adea6748593d1dd");
		check(B = x"da5bb897819f01f8");
		check(C = x"60262e7e169065e");
		check(D = x"2a2d1df9e96950ea");
		check(E = x"12f4b5015f8a6338");
		check(F = x"b2e72932ed26112");
		check(G = x"dfdc15b09020504c");
		check(H = x"e38b54c3dfccd0ef");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"e195a62f446f657");
		check(B = x"5adea6748593d1dd");
		check(C = x"da5bb897819f01f8");
		check(D = x"60262e7e169065e");
		check(E = x"4c9907641a2cd1cc");
		check(F = x"12f4b5015f8a6338");
		check(G = x"b2e72932ed26112");
		check(H = x"dfdc15b09020504c");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"2fe5e4c51960ffb0");
		check(B = x"e195a62f446f657");
		check(C = x"5adea6748593d1dd");
		check(D = x"da5bb897819f01f8");
		check(E = x"9ef6382ce922722e");
		check(F = x"4c9907641a2cd1cc");
		check(G = x"12f4b5015f8a6338");
		check(H = x"b2e72932ed26112");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"ffeff1c4eda069ae");
		check(B = x"2fe5e4c51960ffb0");
		check(C = x"e195a62f446f657");
		check(D = x"5adea6748593d1dd");
		check(E = x"7108bee644037528");
		check(F = x"9ef6382ce922722e");
		check(G = x"4c9907641a2cd1cc");
		check(H = x"12f4b5015f8a6338");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"3596c25cac43f0ef");
		check(B = x"ffeff1c4eda069ae");
		check(C = x"2fe5e4c51960ffb0");
		check(D = x"e195a62f446f657");
		check(E = x"f7d1b7b5177b833a");
		check(F = x"7108bee644037528");
		check(G = x"9ef6382ce922722e");
		check(H = x"4c9907641a2cd1cc");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"fda2eade89ab6dc3");
		check(B = x"3596c25cac43f0ef");
		check(C = x"ffeff1c4eda069ae");
		check(D = x"2fe5e4c51960ffb0");
		check(E = x"755cef53862eb193");
		check(F = x"f7d1b7b5177b833a");
		check(G = x"7108bee644037528");
		check(H = x"9ef6382ce922722e");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"dc649e1def0520d8");
		check(B = x"fda2eade89ab6dc3");
		check(C = x"3596c25cac43f0ef");
		check(D = x"ffeff1c4eda069ae");
		check(E = x"88d44e71b805640f");
		check(F = x"755cef53862eb193");
		check(G = x"f7d1b7b5177b833a");
		check(H = x"7108bee644037528");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"db4167479c15915b");
		check(B = x"dc649e1def0520d8");
		check(C = x"fda2eade89ab6dc3");
		check(D = x"3596c25cac43f0ef");
		check(E = x"2d3d3eb59bca8ad9");
		check(F = x"88d44e71b805640f");
		check(G = x"755cef53862eb193");
		check(H = x"f7d1b7b5177b833a");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"f9bf9034a0287e17");
		check(B = x"db4167479c15915b");
		check(C = x"dc649e1def0520d8");
		check(D = x"fda2eade89ab6dc3");
		check(E = x"a8910967c9f69dc5");
		check(F = x"2d3d3eb59bca8ad9");
		check(G = x"88d44e71b805640f");
		check(H = x"755cef53862eb193");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"1de685f94d98bc8f");
		check(B = x"f9bf9034a0287e17");
		check(C = x"db4167479c15915b");
		check(D = x"dc649e1def0520d8");
		check(E = x"fe562cbbe0d96190");
		check(F = x"a8910967c9f69dc5");
		check(G = x"2d3d3eb59bca8ad9");
		check(H = x"88d44e71b805640f");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"cbeeffde2b96572b");
		check(B = x"1de685f94d98bc8f");
		check(C = x"f9bf9034a0287e17");
		check(D = x"db4167479c15915b");
		check(E = x"55f541db87588803");
		check(F = x"fe562cbbe0d96190");
		check(G = x"a8910967c9f69dc5");
		check(H = x"2d3d3eb59bca8ad9");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"99da22224f1a9e3c");
		check(B = x"cbeeffde2b96572b");
		check(C = x"1de685f94d98bc8f");
		check(D = x"f9bf9034a0287e17");
		check(E = x"b552795a614119e");
		check(F = x"55f541db87588803");
		check(G = x"fe562cbbe0d96190");
		check(H = x"a8910967c9f69dc5");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"2555b7ff5045fac9");
		check(B = x"99da22224f1a9e3c");
		check(C = x"cbeeffde2b96572b");
		check(D = x"1de685f94d98bc8f");
		check(E = x"5e352ebeddecbbc9");
		check(F = x"b552795a614119e");
		check(G = x"55f541db87588803");
		check(H = x"fe562cbbe0d96190");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"dabd739fb41a333c");
		check(B = x"2555b7ff5045fac9");
		check(C = x"99da22224f1a9e3c");
		check(D = x"cbeeffde2b96572b");
		check(E = x"3fd6e7c52857583d");
		check(F = x"5e352ebeddecbbc9");
		check(G = x"b552795a614119e");
		check(H = x"55f541db87588803");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"77567691798743c5");
		check(B = x"dabd739fb41a333c");
		check(C = x"2555b7ff5045fac9");
		check(D = x"99da22224f1a9e3c");
		check(E = x"159ab74b6c35c0b9");
		check(F = x"3fd6e7c52857583d");
		check(G = x"5e352ebeddecbbc9");
		check(H = x"b552795a614119e");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"2160a7478e159647");
		check(B = x"77567691798743c5");
		check(C = x"dabd739fb41a333c");
		check(D = x"2555b7ff5045fac9");
		check(E = x"5efe6fa8cacc6858");
		check(F = x"159ab74b6c35c0b9");
		check(G = x"3fd6e7c52857583d");
		check(H = x"5e352ebeddecbbc9");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"b1026655a9c95e06");
		check(B = x"2160a7478e159647");
		check(C = x"77567691798743c5");
		check(D = x"dabd739fb41a333c");
		check(E = x"d5237bedede7a8a3");
		check(F = x"5efe6fa8cacc6858");
		check(G = x"159ab74b6c35c0b9");
		check(H = x"3fd6e7c52857583d");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"db3f9bb19e9ab89e");
		check(B = x"b1026655a9c95e06");
		check(C = x"2160a7478e159647");
		check(D = x"77567691798743c5");
		check(E = x"270683a4f82a9d90");
		check(F = x"d5237bedede7a8a3");
		check(G = x"5efe6fa8cacc6858");
		check(H = x"159ab74b6c35c0b9");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"43586dfca0bd2d9f");
		check(B = x"db3f9bb19e9ab89e");
		check(C = x"b1026655a9c95e06");
		check(D = x"2160a7478e159647");
		check(E = x"1c5c2a7d532ab09c");
		check(F = x"270683a4f82a9d90");
		check(G = x"d5237bedede7a8a3");
		check(H = x"5efe6fa8cacc6858");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"8ea516edc5bfc222");
		check(B = x"43586dfca0bd2d9f");
		check(C = x"db3f9bb19e9ab89e");
		check(D = x"b1026655a9c95e06");
		check(E = x"22e6576cf65a75d");
		check(F = x"1c5c2a7d532ab09c");
		check(G = x"270683a4f82a9d90");
		check(H = x"d5237bedede7a8a3");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"a6f80157561bd9c7");
		check(B = x"8ea516edc5bfc222");
		check(C = x"43586dfca0bd2d9f");
		check(D = x"db3f9bb19e9ab89e");
		check(E = x"9ba49a8b6e402de5");
		check(F = x"22e6576cf65a75d");
		check(G = x"1c5c2a7d532ab09c");
		check(H = x"270683a4f82a9d90");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"33e6fb478c98c62d");
		check(B = x"a6f80157561bd9c7");
		check(C = x"8ea516edc5bfc222");
		check(D = x"43586dfca0bd2d9f");
		check(E = x"6d9733435cffd022");
		check(F = x"9ba49a8b6e402de5");
		check(G = x"22e6576cf65a75d");
		check(H = x"1c5c2a7d532ab09c");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"df6dbb22e7d0eb82");
		check(B = x"33e6fb478c98c62d");
		check(C = x"a6f80157561bd9c7");
		check(D = x"8ea516edc5bfc222");
		check(E = x"d62eb3039b008f9b");
		check(F = x"6d9733435cffd022");
		check(G = x"9ba49a8b6e402de5");
		check(H = x"22e6576cf65a75d");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"4c9102ad74f7f188");
		check(B = x"df6dbb22e7d0eb82");
		check(C = x"33e6fb478c98c62d");
		check(D = x"a6f80157561bd9c7");
		check(E = x"a2143b392f60e093");
		check(F = x"d62eb3039b008f9b");
		check(G = x"6d9733435cffd022");
		check(H = x"9ba49a8b6e402de5");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"2280798327bb6ed0");
		check(B = x"4c9102ad74f7f188");
		check(C = x"df6dbb22e7d0eb82");
		check(D = x"33e6fb478c98c62d");
		check(E = x"20e7b4acce591c96");
		check(F = x"a2143b392f60e093");
		check(G = x"d62eb3039b008f9b");
		check(H = x"6d9733435cffd022");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"246d368233300272");
		check(B = x"2280798327bb6ed0");
		check(C = x"4c9102ad74f7f188");
		check(D = x"df6dbb22e7d0eb82");
		check(E = x"55bbb5bad6f2567e");
		check(F = x"20e7b4acce591c96");
		check(G = x"a2143b392f60e093");
		check(H = x"d62eb3039b008f9b");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"8f35ba1a36dc4612");
		check(B = x"246d368233300272");
		check(C = x"2280798327bb6ed0");
		check(D = x"4c9102ad74f7f188");
		check(E = x"8e77faffbb78ced6");
		check(F = x"55bbb5bad6f2567e");
		check(G = x"20e7b4acce591c96");
		check(H = x"a2143b392f60e093");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"a9441c1f30c56471");
		check(B = x"8f35ba1a36dc4612");
		check(C = x"246d368233300272");
		check(D = x"2280798327bb6ed0");
		check(E = x"fb911c29f87c6b56");
		check(F = x"8e77faffbb78ced6");
		check(G = x"55bbb5bad6f2567e");
		check(H = x"20e7b4acce591c96");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"4ee81487ffa1265a");
		check(B = x"a9441c1f30c56471");
		check(C = x"8f35ba1a36dc4612");
		check(D = x"246d368233300272");
		check(E = x"c5fcbb22d745ffec");
		check(F = x"fb911c29f87c6b56");
		check(G = x"8e77faffbb78ced6");
		check(H = x"55bbb5bad6f2567e");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"f088df6d3a9c6c24");
		check(B = x"4ee81487ffa1265a");
		check(C = x"a9441c1f30c56471");
		check(D = x"8f35ba1a36dc4612");
		check(E = x"7b8c8b516d606acd");
		check(F = x"c5fcbb22d745ffec");
		check(G = x"fb911c29f87c6b56");
		check(H = x"8e77faffbb78ced6");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"c57910f0e929411c");
		check(B = x"f088df6d3a9c6c24");
		check(C = x"4ee81487ffa1265a");
		check(D = x"a9441c1f30c56471");
		check(E = x"2ed1cd5d68315208");
		check(F = x"7b8c8b516d606acd");
		check(G = x"c5fcbb22d745ffec");
		check(H = x"fb911c29f87c6b56");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"77abd3902d1ce330");
		check(B = x"c57910f0e929411c");
		check(C = x"f088df6d3a9c6c24");
		check(D = x"4ee81487ffa1265a");
		check(E = x"12fbc7c002f32a72");
		check(F = x"2ed1cd5d68315208");
		check(G = x"7b8c8b516d606acd");
		check(H = x"c5fcbb22d745ffec");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"74da48832864fa84");
		check(B = x"77abd3902d1ce330");
		check(C = x"c57910f0e929411c");
		check(D = x"f088df6d3a9c6c24");
		check(E = x"d345570df7312569");
		check(F = x"12fbc7c002f32a72");
		check(G = x"2ed1cd5d68315208");
		check(H = x"7b8c8b516d606acd");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"2c26b29019b4b04e");
		check(B = x"74da48832864fa84");
		check(C = x"77abd3902d1ce330");
		check(D = x"c57910f0e929411c");
		check(E = x"5cade259d2a88adb");
		check(F = x"d345570df7312569");
		check(G = x"12fbc7c002f32a72");
		check(H = x"2ed1cd5d68315208");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"91b3cdddb9eb41bb");
		check(B = x"2c26b29019b4b04e");
		check(C = x"74da48832864fa84");
		check(D = x"77abd3902d1ce330");
		check(E = x"256ccaaca4a4c813");
		check(F = x"5cade259d2a88adb");
		check(G = x"d345570df7312569");
		check(H = x"12fbc7c002f32a72");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"3f725e11320e0fcb");
		check(B = x"91b3cdddb9eb41bb");
		check(C = x"2c26b29019b4b04e");
		check(D = x"74da48832864fa84");
		check(E = x"36ae4bbb9cd2b936");
		check(F = x"256ccaaca4a4c813");
		check(G = x"5cade259d2a88adb");
		check(H = x"d345570df7312569");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"655a627734a3e5d0");
		check(B = x"3f725e11320e0fcb");
		check(C = x"91b3cdddb9eb41bb");
		check(D = x"2c26b29019b4b04e");
		check(E = x"4efa690a74d34c5e");
		check(F = x"36ae4bbb9cd2b936");
		check(G = x"256ccaaca4a4c813");
		check(H = x"5cade259d2a88adb");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"faf37eae3751ccbc");
		check(B = x"655a627734a3e5d0");
		check(C = x"3f725e11320e0fcb");
		check(D = x"91b3cdddb9eb41bb");
		check(E = x"8827ff2f34212c05");
		check(F = x"4efa690a74d34c5e");
		check(G = x"36ae4bbb9cd2b936");
		check(H = x"256ccaaca4a4c813");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"2a9c34df07d0d08a");
		check(B = x"faf37eae3751ccbc");
		check(C = x"655a627734a3e5d0");
		check(D = x"3f725e11320e0fcb");
		check(E = x"9837690ba33970b8");
		check(F = x"8827ff2f34212c05");
		check(G = x"4efa690a74d34c5e");
		check(H = x"36ae4bbb9cd2b936");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"b7db3caa8fb69592");
		check(B = x"2a9c34df07d0d08a");
		check(C = x"faf37eae3751ccbc");
		check(D = x"655a627734a3e5d0");
		check(E = x"897c869b52c16817");
		check(F = x"9837690ba33970b8");
		check(G = x"8827ff2f34212c05");
		check(H = x"4efa690a74d34c5e");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"639f38ef874d61cf");
		check(B = x"b7db3caa8fb69592");
		check(C = x"2a9c34df07d0d08a");
		check(D = x"faf37eae3751ccbc");
		check(E = x"82cd53bef5bf0a");
		check(F = x"897c869b52c16817");
		check(G = x"9837690ba33970b8");
		check(H = x"8827ff2f34212c05");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"b08ca2f56257cbc4");
		check(B = x"639f38ef874d61cf");
		check(C = x"b7db3caa8fb69592");
		check(D = x"2a9c34df07d0d08a");
		check(E = x"3dd5066d92014844");
		check(F = x"82cd53bef5bf0a");
		check(G = x"897c869b52c16817");
		check(H = x"9837690ba33970b8");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"2ca5ff0103fbbf9d");
		check(B = x"b08ca2f56257cbc4");
		check(C = x"639f38ef874d61cf");
		check(D = x"b7db3caa8fb69592");
		check(E = x"c7519c2d6ecafb3");
		check(F = x"3dd5066d92014844");
		check(G = x"82cd53bef5bf0a");
		check(H = x"897c869b52c16817");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"f0baf629e039bbe7");
		check(B = x"2ca5ff0103fbbf9d");
		check(C = x"b08ca2f56257cbc4");
		check(D = x"639f38ef874d61cf");
		check(E = x"ac596a4b160a17e");
		check(F = x"c7519c2d6ecafb3");
		check(G = x"3dd5066d92014844");
		check(H = x"82cd53bef5bf0a");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"6b1f270a8de41735");
		check(B = x"f0baf629e039bbe7");
		check(C = x"2ca5ff0103fbbf9d");
		check(D = x"b08ca2f56257cbc4");
		check(E = x"f5bbc5e77a551247");
		check(F = x"ac596a4b160a17e");
		check(G = x"c7519c2d6ecafb3");
		check(H = x"3dd5066d92014844");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"652eb5ba58cad9b");
		check(B = x"6b1f270a8de41735");
		check(C = x"f0baf629e039bbe7");
		check(D = x"2ca5ff0103fbbf9d");
		check(E = x"e5fbd89204073286");
		check(F = x"f5bbc5e77a551247");
		check(G = x"ac596a4b160a17e");
		check(H = x"c7519c2d6ecafb3");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"9b1877e895b33f5d");
		check(B = x"652eb5ba58cad9b");
		check(C = x"6b1f270a8de41735");
		check(D = x"f0baf629e039bbe7");
		check(E = x"5ec0a450614b9489");
		check(F = x"e5fbd89204073286");
		check(G = x"f5bbc5e77a551247");
		check(H = x"ac596a4b160a17e");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"f92bd4de8c8e82a0");
		check(B = x"9b1877e895b33f5d");
		check(C = x"652eb5ba58cad9b");
		check(D = x"6b1f270a8de41735");
		check(E = x"2f58074d7aacabce");
		check(F = x"5ec0a450614b9489");
		check(G = x"e5fbd89204073286");
		check(H = x"f5bbc5e77a551247");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"3fe7be9815a8ad26");
		check(B = x"f92bd4de8c8e82a0");
		check(C = x"9b1877e895b33f5d");
		check(D = x"652eb5ba58cad9b");
		check(E = x"3919562530f8254c");
		check(F = x"2f58074d7aacabce");
		check(G = x"5ec0a450614b9489");
		check(H = x"e5fbd89204073286");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"db4b90a52ae394ae");
		check(B = x"3fe7be9815a8ad26");
		check(C = x"f92bd4de8c8e82a0");
		check(D = x"9b1877e895b33f5d");
		check(E = x"b6a6dcb7fcc7c9cb");
		check(F = x"3919562530f8254c");
		check(G = x"2f58074d7aacabce");
		check(H = x"5ec0a450614b9489");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"1b1072fb89885bc0");
		check(B = x"db4b90a52ae394ae");
		check(C = x"3fe7be9815a8ad26");
		check(D = x"f92bd4de8c8e82a0");
		check(E = x"be8ed58b2b39d1d");
		check(F = x"b6a6dcb7fcc7c9cb");
		check(G = x"3919562530f8254c");
		check(H = x"2f58074d7aacabce");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"56c235ad55131716");
		check(B = x"1b1072fb89885bc0");
		check(C = x"db4b90a52ae394ae");
		check(D = x"3fe7be9815a8ad26");
		check(E = x"a6b59d8ca003e82d");
		check(F = x"be8ed58b2b39d1d");
		check(G = x"b6a6dcb7fcc7c9cb");
		check(H = x"3919562530f8254c");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"26665b358011e721");
		check(B = x"56c235ad55131716");
		check(C = x"1b1072fb89885bc0");
		check(D = x"db4b90a52ae394ae");
		check(E = x"ac2c5691b6f928ec");
		check(F = x"a6b59d8ca003e82d");
		check(G = x"be8ed58b2b39d1d");
		check(H = x"b6a6dcb7fcc7c9cb");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"42a2ca40b10efd78");
		check(B = x"26665b358011e721");
		check(C = x"56c235ad55131716");
		check(D = x"1b1072fb89885bc0");
		check(E = x"fd91bf13ed305203");
		check(F = x"ac2c5691b6f928ec");
		check(G = x"a6b59d8ca003e82d");
		check(H = x"be8ed58b2b39d1d");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"ebf04cea0eedb549");
		check(B = x"42a2ca40b10efd78");
		check(C = x"26665b358011e721");
		check(D = x"56c235ad55131716");
		check(E = x"24fef9f3d60c6ca");
		check(F = x"fd91bf13ed305203");
		check(G = x"ac2c5691b6f928ec");
		check(H = x"a6b59d8ca003e82d");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"d6ecc2aae3b9c8a6");
		check(B = x"ebf04cea0eedb549");
		check(C = x"42a2ca40b10efd78");
		check(D = x"26665b358011e721");
		check(E = x"114ecb51628fad50");
		check(F = x"24fef9f3d60c6ca");
		check(G = x"fd91bf13ed305203");
		check(H = x"ac2c5691b6f928ec");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"8c810941d5c87a5a");
		check(B = x"d6ecc2aae3b9c8a6");
		check(C = x"ebf04cea0eedb549");
		check(D = x"42a2ca40b10efd78");
		check(E = x"19510db71b51a092");
		check(F = x"114ecb51628fad50");
		check(G = x"24fef9f3d60c6ca");
		check(H = x"fd91bf13ed305203");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"8e238891e8d7ca8");
		check(B = x"8c810941d5c87a5a");
		check(C = x"d6ecc2aae3b9c8a6");
		check(D = x"ebf04cea0eedb549");
		check(E = x"d2468e142988ad77");
		check(F = x"19510db71b51a092");
		check(G = x"114ecb51628fad50");
		check(H = x"24fef9f3d60c6ca");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"72ec1ef1124a45b0");
		check(H1_out = x"47e8b7c75a932195");
		check(H2_out = x"135bb61de24ec0d1");
		check(H3_out = x"914042246e0aec3a");
		check(H4_out = x"2354e093d76f3048");
		check(H5_out = x"b456764346900cb1");
		check(H6_out = x"30d2a4fd5dd16abb");
		check(H7_out = x"5e30bcb850dee843");

		test_runner_cleanup(runner);
	end process;

end sha512_test_7_tb_arch;

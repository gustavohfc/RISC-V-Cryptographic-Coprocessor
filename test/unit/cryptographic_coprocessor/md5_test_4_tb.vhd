library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 112 bits message ("message digest")

entity md5_test_4_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_4_tb;

architecture md5_test_4_tb_arch OF md5_test_4_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal calculate_next_block  : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_idle               : std_logic             := '0';
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
			is_idle               => is_idle,
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

		-- Write the 112 bits message ("message digest")
		write_data_in <= '1';

		data_in               <= x"6d657373";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"61676520";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"64696765";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"73740000";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(112, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"5ed29dae");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"e2a2fc32");
		check(C = x"5ed29dae");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"9073e056");
		check(C = x"e2a2fc32");
		check(D = x"5ed29dae");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"5ed29dae");
		check(B = x"b9940c11");
		check(C = x"9073e056");
		check(D = x"e2a2fc32");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"e2a2fc32");
		check(B = x"fa62d3a4");
		check(C = x"b9940c11");
		check(D = x"9073e056");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"9073e056");
		check(B = x"b88dc1c7");
		check(C = x"fa62d3a4");
		check(D = x"b9940c11");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"b9940c11");
		check(B = x"a089a530");
		check(C = x"b88dc1c7");
		check(D = x"fa62d3a4");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"fa62d3a4");
		check(B = x"c63616cd");
		check(C = x"a089a530");
		check(D = x"b88dc1c7");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"b88dc1c7");
		check(B = x"fcced5db");
		check(C = x"c63616cd");
		check(D = x"a089a530");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"a089a530");
		check(B = x"9bb4c658");
		check(C = x"fcced5db");
		check(D = x"c63616cd");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"c63616cd");
		check(B = x"4731c077");
		check(C = x"9bb4c658");
		check(D = x"fcced5db");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"fcced5db");
		check(B = x"5ff4a4e8");
		check(C = x"4731c077");
		check(D = x"9bb4c658");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"9bb4c658");
		check(B = x"27c95b7f");
		check(C = x"5ff4a4e8");
		check(D = x"4731c077");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"4731c077");
		check(B = x"034e9992");
		check(C = x"27c95b7f");
		check(D = x"5ff4a4e8");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"5ff4a4e8");
		check(B = x"872d34d8");
		check(C = x"034e9992");
		check(D = x"27c95b7f");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"27c95b7f");
		check(B = x"b760921a");
		check(C = x"872d34d8");
		check(D = x"034e9992");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"034e9992");
		check(B = x"6d3425b2");
		check(C = x"b760921a");
		check(D = x"872d34d8");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"872d34d8");
		check(B = x"551aefa3");
		check(C = x"6d3425b2");
		check(D = x"b760921a");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"b760921a");
		check(B = x"62cdb24b");
		check(C = x"551aefa3");
		check(D = x"6d3425b2");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"6d3425b2");
		check(B = x"f615fbe5");
		check(C = x"62cdb24b");
		check(D = x"551aefa3");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"551aefa3");
		check(B = x"3d3c3afc");
		check(C = x"f615fbe5");
		check(D = x"62cdb24b");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"62cdb24b");
		check(B = x"343bff12");
		check(C = x"3d3c3afc");
		check(D = x"f615fbe5");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"f615fbe5");
		check(B = x"99351d3c");
		check(C = x"343bff12");
		check(D = x"3d3c3afc");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"3d3c3afc");
		check(B = x"e7f48f59");
		check(C = x"99351d3c");
		check(D = x"343bff12");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"343bff12");
		check(B = x"7247931a");
		check(C = x"e7f48f59");
		check(D = x"99351d3c");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"99351d3c");
		check(B = x"e37cf5f6");
		check(C = x"7247931a");
		check(D = x"e7f48f59");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"e7f48f59");
		check(B = x"709f1676");
		check(C = x"e37cf5f6");
		check(D = x"7247931a");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"7247931a");
		check(B = x"2460ff57");
		check(C = x"709f1676");
		check(D = x"e37cf5f6");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"e37cf5f6");
		check(B = x"c64f6e00");
		check(C = x"2460ff57");
		check(D = x"709f1676");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"709f1676");
		check(B = x"4e341514");
		check(C = x"c64f6e00");
		check(D = x"2460ff57");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"2460ff57");
		check(B = x"99ccfca3");
		check(C = x"4e341514");
		check(D = x"c64f6e00");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"c64f6e00");
		check(B = x"29209d1f");
		check(C = x"99ccfca3");
		check(D = x"4e341514");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"4e341514");
		check(B = x"7b425bcb");
		check(C = x"29209d1f");
		check(D = x"99ccfca3");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"99ccfca3");
		check(B = x"1d72c0d5");
		check(C = x"7b425bcb");
		check(D = x"29209d1f");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"29209d1f");
		check(B = x"8139174f");
		check(C = x"1d72c0d5");
		check(D = x"7b425bcb");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"7b425bcb");
		check(B = x"77401eff");
		check(C = x"8139174f");
		check(D = x"1d72c0d5");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"1d72c0d5");
		check(B = x"2e678c51");
		check(C = x"77401eff");
		check(D = x"8139174f");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"8139174f");
		check(B = x"af1a865c");
		check(C = x"2e678c51");
		check(D = x"77401eff");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"77401eff");
		check(B = x"26bbf48d");
		check(C = x"af1a865c");
		check(D = x"2e678c51");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"2e678c51");
		check(B = x"1eaad7f9");
		check(C = x"26bbf48d");
		check(D = x"af1a865c");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"af1a865c");
		check(B = x"ff95dbf7");
		check(C = x"1eaad7f9");
		check(D = x"26bbf48d");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"26bbf48d");
		check(B = x"9ff8129c");
		check(C = x"ff95dbf7");
		check(D = x"1eaad7f9");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"1eaad7f9");
		check(B = x"580f8d8e");
		check(C = x"9ff8129c");
		check(D = x"ff95dbf7");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"ff95dbf7");
		check(B = x"49bd582a");
		check(C = x"580f8d8e");
		check(D = x"9ff8129c");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"9ff8129c");
		check(B = x"c5148eb0");
		check(C = x"49bd582a");
		check(D = x"580f8d8e");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"580f8d8e");
		check(B = x"9551398b");
		check(C = x"c5148eb0");
		check(D = x"49bd582a");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"49bd582a");
		check(B = x"8ee8cb35");
		check(C = x"9551398b");
		check(D = x"c5148eb0");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"c5148eb0");
		check(B = x"8f920a7f");
		check(C = x"8ee8cb35");
		check(D = x"9551398b");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"9551398b");
		check(B = x"1158f562");
		check(C = x"8f920a7f");
		check(D = x"8ee8cb35");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"8ee8cb35");
		check(B = x"3a3bd4bf");
		check(C = x"1158f562");
		check(D = x"8f920a7f");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"8f920a7f");
		check(B = x"3250a790");
		check(C = x"3a3bd4bf");
		check(D = x"1158f562");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"1158f562");
		check(B = x"ed9ac5d4");
		check(C = x"3250a790");
		check(D = x"3a3bd4bf");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"3a3bd4bf");
		check(B = x"7e40a029");
		check(C = x"ed9ac5d4");
		check(D = x"3250a790");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"3250a790");
		check(B = x"778e9f99");
		check(C = x"7e40a029");
		check(D = x"ed9ac5d4");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"ed9ac5d4");
		check(B = x"555e3d90");
		check(C = x"778e9f99");
		check(D = x"7e40a029");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"7e40a029");
		check(B = x"c004fc5d");
		check(C = x"555e3d90");
		check(D = x"778e9f99");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"778e9f99");
		check(B = x"853d163f");
		check(C = x"c004fc5d");
		check(D = x"555e3d90");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"555e3d90");
		check(B = x"57ff85d4");
		check(C = x"853d163f");
		check(D = x"c004fc5d");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"c004fc5d");
		check(B = x"61367f65");
		check(C = x"57ff85d4");
		check(D = x"853d163f");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"853d163f");
		check(B = x"671dc236");
		check(C = x"61367f65");
		check(D = x"57ff85d4");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"57ff85d4");
		check(B = x"162448f8");
		check(C = x"671dc236");
		check(D = x"61367f65");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"61367f65");
		check(B = x"c02f9d34");
		check(C = x"162448f8");
		check(D = x"671dc236");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"671dc236");
		check(B = x"98747d54");
		check(C = x"c02f9d34");
		check(D = x"162448f8");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"162448f8");
		check(B = x"9dc60bf3");
		check(C = x"98747d54");
		check(D = x"c02f9d34");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"f96b697d");
		check(B = x"7cb7938d");
		check(C = x"525a2f31");
		check(D = x"aaf161d0");

		test_runner_cleanup(runner);
	end process;

end md5_test_4_tb_arch;

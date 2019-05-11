library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 24 bits message ("abc")

entity md5_test_3_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_3_tb;

architecture md5_test_3_tb_arch OF md5_test_3_tb IS
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

		-- Write the 24 bits message ("abc")
		write_data_in <= '1';

		data_in               <= x"61626300";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(24, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"d6d117b4");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"344a8432");
		check(C = x"d6d117b4");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"2f6fbd72");
		check(C = x"344a8432");
		check(D = x"d6d117b4");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"d6d117b4");
		check(B = x"7ad956f2");
		check(C = x"2f6fbd72");
		check(D = x"344a8432");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"344a8432");
		check(B = x"c73741ef");
		check(C = x"7ad956f2");
		check(D = x"2f6fbd72");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"2f6fbd72");
		check(B = x"8bac3051");
		check(C = x"c73741ef");
		check(D = x"7ad956f2");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"7ad956f2");
		check(B = x"207dc67b");
		check(C = x"8bac3051");
		check(D = x"c73741ef");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"c73741ef");
		check(B = x"928d99f6");
		check(C = x"207dc67b");
		check(D = x"8bac3051");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"8bac3051");
		check(B = x"854b3712");
		check(C = x"928d99f6");
		check(D = x"207dc67b");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"207dc67b");
		check(B = x"74e2f284");
		check(C = x"854b3712");
		check(D = x"928d99f6");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"928d99f6");
		check(B = x"3020401c");
		check(C = x"74e2f284");
		check(D = x"854b3712");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"854b3712");
		check(B = x"5ed49596");
		check(C = x"3020401c");
		check(D = x"74e2f284");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"74e2f284");
		check(B = x"dda9b9a6");
		check(C = x"5ed49596");
		check(D = x"3020401c");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"3020401c");
		check(B = x"a1051895");
		check(C = x"dda9b9a6");
		check(D = x"5ed49596");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"5ed49596");
		check(B = x"e396856b");
		check(C = x"a1051895");
		check(D = x"dda9b9a6");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"dda9b9a6");
		check(B = x"72aff2e0");
		check(C = x"e396856b");
		check(D = x"a1051895");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"a1051895");
		check(B = x"3e9e9126");
		check(C = x"72aff2e0");
		check(D = x"e396856b");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"e396856b");
		check(B = x"4a1d804e");
		check(C = x"3e9e9126");
		check(D = x"72aff2e0");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"72aff2e0");
		check(B = x"e25e1652");
		check(C = x"4a1d804e");
		check(D = x"3e9e9126");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"3e9e9126");
		check(B = x"b5b204e4");
		check(C = x"e25e1652");
		check(D = x"4a1d804e");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"4a1d804e");
		check(B = x"59a8ffda");
		check(C = x"b5b204e4");
		check(D = x"e25e1652");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"e25e1652");
		check(B = x"6d002f1e");
		check(C = x"59a8ffda");
		check(D = x"b5b204e4");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"b5b204e4");
		check(B = x"abfc7920");
		check(C = x"6d002f1e");
		check(D = x"59a8ffda");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"59a8ffda");
		check(B = x"47092c07");
		check(C = x"abfc7920");
		check(D = x"6d002f1e");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"6d002f1e");
		check(B = x"b7f268cf");
		check(C = x"47092c07");
		check(D = x"abfc7920");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"abfc7920");
		check(B = x"09388eff");
		check(C = x"b7f268cf");
		check(D = x"47092c07");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"47092c07");
		check(B = x"fe1623b1");
		check(C = x"09388eff");
		check(D = x"b7f268cf");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"b7f268cf");
		check(B = x"786acb8f");
		check(C = x"fe1623b1");
		check(D = x"09388eff");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"09388eff");
		check(B = x"790a77fb");
		check(C = x"786acb8f");
		check(D = x"fe1623b1");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"fe1623b1");
		check(B = x"9f47e4f8");
		check(C = x"790a77fb");
		check(D = x"786acb8f");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"786acb8f");
		check(B = x"a62884aa");
		check(C = x"9f47e4f8");
		check(D = x"790a77fb");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"790a77fb");
		check(B = x"726342d3");
		check(C = x"a62884aa");
		check(D = x"9f47e4f8");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"9f47e4f8");
		check(B = x"b3707ebf");
		check(C = x"726342d3");
		check(D = x"a62884aa");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"a62884aa");
		check(B = x"60127b2e");
		check(C = x"b3707ebf");
		check(D = x"726342d3");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"726342d3");
		check(B = x"8d212ff5");
		check(C = x"60127b2e");
		check(D = x"b3707ebf");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"b3707ebf");
		check(B = x"3b0875c7");
		check(C = x"8d212ff5");
		check(D = x"60127b2e");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"60127b2e");
		check(B = x"21b117b9");
		check(C = x"3b0875c7");
		check(D = x"8d212ff5");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"8d212ff5");
		check(B = x"6e7429d5");
		check(C = x"21b117b9");
		check(D = x"3b0875c7");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"3b0875c7");
		check(B = x"3575227e");
		check(C = x"6e7429d5");
		check(D = x"21b117b9");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"21b117b9");
		check(B = x"5a2f5ea5");
		check(C = x"3575227e");
		check(D = x"6e7429d5");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"6e7429d5");
		check(B = x"11de1779");
		check(C = x"5a2f5ea5");
		check(D = x"3575227e");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"3575227e");
		check(B = x"fadcaa38");
		check(C = x"11de1779");
		check(D = x"5a2f5ea5");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"5a2f5ea5");
		check(B = x"31c465ca");
		check(C = x"fadcaa38");
		check(D = x"11de1779");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"11de1779");
		check(B = x"4c6124f4");
		check(C = x"31c465ca");
		check(D = x"fadcaa38");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"fadcaa38");
		check(B = x"7f2e507b");
		check(C = x"4c6124f4");
		check(D = x"31c465ca");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"31c465ca");
		check(B = x"99d9679d");
		check(C = x"7f2e507b");
		check(D = x"4c6124f4");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"4c6124f4");
		check(B = x"8fae6399");
		check(C = x"99d9679d");
		check(D = x"7f2e507b");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"7f2e507b");
		check(B = x"7beb9700");
		check(C = x"8fae6399");
		check(D = x"99d9679d");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"99d9679d");
		check(B = x"7b201df8");
		check(C = x"7beb9700");
		check(D = x"8fae6399");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"8fae6399");
		check(B = x"f4e8e96e");
		check(C = x"7b201df8");
		check(D = x"7beb9700");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"7beb9700");
		check(B = x"b298cefd");
		check(C = x"f4e8e96e");
		check(D = x"7b201df8");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"7b201df8");
		check(B = x"8bf025c4");
		check(C = x"b298cefd");
		check(D = x"f4e8e96e");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"f4e8e96e");
		check(B = x"06cc5e8a");
		check(C = x"8bf025c4");
		check(D = x"b298cefd");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"b298cefd");
		check(B = x"5b0d97aa");
		check(C = x"06cc5e8a");
		check(D = x"8bf025c4");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"8bf025c4");
		check(B = x"7d632dd0");
		check(C = x"5b0d97aa");
		check(D = x"06cc5e8a");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"06cc5e8a");
		check(B = x"3bfa2c27");
		check(C = x"7d632dd0");
		check(D = x"5b0d97aa");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"5b0d97aa");
		check(B = x"7f81cc35");
		check(C = x"3bfa2c27");
		check(D = x"7d632dd0");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"7d632dd0");
		check(B = x"094454ab");
		check(C = x"7f81cc35");
		check(D = x"3bfa2c27");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"3bfa2c27");
		check(B = x"4f9dbe3f");
		check(C = x"094454ab");
		check(D = x"7f81cc35");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"7f81cc35");
		check(B = x"7327d604");
		check(C = x"4f9dbe3f");
		check(D = x"094454ab");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"094454ab");
		check(B = x"310ade8f");
		check(C = x"7327d604");
		check(D = x"4f9dbe3f");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"4f9dbe3f");
		check(B = x"624d8cb2");
		check(C = x"310ade8f");
		check(D = x"7327d604");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"7327d604");
		check(B = x"e484b9d8");
		check(C = x"624d8cb2");
		check(D = x"310ade8f");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"310ade8f");
		check(B = x"c08226b3");
		check(C = x"e484b9d8");
		check(D = x"624d8cb2");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"90015098");
		check(B = x"3cd24fb0");
		check(C = x"d6963f7d");
		check(D = x"28e17f72");

		test_runner_cleanup(runner);
	end process;

end md5_test_3_tb_arch;

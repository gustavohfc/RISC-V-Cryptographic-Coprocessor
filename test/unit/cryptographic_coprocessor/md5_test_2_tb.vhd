library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 8 bits message ("a")

entity md5_test_2_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_2_tb;

architecture md5_test_2_tb_arch OF md5_test_2_tb IS
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

		-- Write the 8 bits message ("a")
		write_data_in <= '1';

		data_in               <= x"61000000";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_block <= '1';
		is_last_block        <= '1';
		last_block_size      <= to_unsigned(8, 10);
		wait until rising_edge(clk);
		calculate_next_block <= '0';
		is_last_block        <= '0';

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"a56017f4");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"f2d58361");
		check(C = x"a56017f4");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"e65857a7");
		check(C = x"f2d58361");
		check(D = x"a56017f4");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"a56017f4");
		check(B = x"607d9686");
		check(C = x"e65857a7");
		check(D = x"f2d58361");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"f2d58361");
		check(B = x"3a9d5bcc");
		check(C = x"607d9686");
		check(D = x"e65857a7");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"e65857a7");
		check(B = x"e0a07db7");
		check(C = x"3a9d5bcc");
		check(D = x"607d9686");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"607d9686");
		check(B = x"d31ddc83");
		check(C = x"e0a07db7");
		check(D = x"3a9d5bcc");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"3a9d5bcc");
		check(B = x"a8af6da5");
		check(C = x"d31ddc83");
		check(D = x"e0a07db7");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"e0a07db7");
		check(B = x"be580957");
		check(C = x"a8af6da5");
		check(D = x"d31ddc83");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"d31ddc83");
		check(B = x"f386bea6");
		check(C = x"be580957");
		check(D = x"a8af6da5");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"a8af6da5");
		check(B = x"f5fdd933");
		check(C = x"f386bea6");
		check(D = x"be580957");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"be580957");
		check(B = x"68493d6a");
		check(C = x"f5fdd933");
		check(D = x"f386bea6");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"f386bea6");
		check(B = x"44244cf8");
		check(C = x"68493d6a");
		check(D = x"f5fdd933");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"f5fdd933");
		check(B = x"d0fe9b27");
		check(C = x"44244cf8");
		check(D = x"68493d6a");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"68493d6a");
		check(B = x"6360a45f");
		check(C = x"d0fe9b27");
		check(D = x"44244cf8");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"44244cf8");
		check(B = x"f01e3ce2");
		check(C = x"6360a45f");
		check(D = x"d0fe9b27");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"d0fe9b27");
		check(B = x"9c341767");
		check(C = x"f01e3ce2");
		check(D = x"6360a45f");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"6360a45f");
		check(B = x"970ab3a9");
		check(C = x"9c341767");
		check(D = x"f01e3ce2");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"f01e3ce2");
		check(B = x"e39ffd23");
		check(C = x"970ab3a9");
		check(D = x"9c341767");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"9c341767");
		check(B = x"8d25cc66");
		check(C = x"e39ffd23");
		check(D = x"970ab3a9");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"970ab3a9");
		check(B = x"8c444930");
		check(C = x"8d25cc66");
		check(D = x"e39ffd23");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"e39ffd23");
		check(B = x"7267097a");
		check(C = x"8c444930");
		check(D = x"8d25cc66");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"8d25cc66");
		check(B = x"2dacb8a3");
		check(C = x"7267097a");
		check(D = x"8c444930");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"8c444930");
		check(B = x"373beab0");
		check(C = x"2dacb8a3");
		check(D = x"7267097a");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"7267097a");
		check(B = x"f175e3ad");
		check(C = x"373beab0");
		check(D = x"2dacb8a3");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"2dacb8a3");
		check(B = x"9d5df67e");
		check(C = x"f175e3ad");
		check(D = x"373beab0");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"373beab0");
		check(B = x"87b7f475");
		check(C = x"9d5df67e");
		check(D = x"f175e3ad");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"f175e3ad");
		check(B = x"c8f891b4");
		check(C = x"87b7f475");
		check(D = x"9d5df67e");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"9d5df67e");
		check(B = x"93842e98");
		check(C = x"c8f891b4");
		check(D = x"87b7f475");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"87b7f475");
		check(B = x"c7043b64");
		check(C = x"93842e98");
		check(D = x"c8f891b4");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"c8f891b4");
		check(B = x"94a2ebee");
		check(C = x"c7043b64");
		check(D = x"93842e98");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"93842e98");
		check(B = x"3745961f");
		check(C = x"94a2ebee");
		check(D = x"c7043b64");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"c7043b64");
		check(B = x"bd607d1e");
		check(C = x"3745961f");
		check(D = x"94a2ebee");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"94a2ebee");
		check(B = x"a6f72085");
		check(C = x"bd607d1e");
		check(D = x"3745961f");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"3745961f");
		check(B = x"bf8b4f98");
		check(C = x"a6f72085");
		check(D = x"bd607d1e");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"bd607d1e");
		check(B = x"daf7f308");
		check(C = x"bf8b4f98");
		check(D = x"a6f72085");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"a6f72085");
		check(B = x"35a82a7a");
		check(C = x"daf7f308");
		check(D = x"bf8b4f98");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"bf8b4f98");
		check(B = x"89e0ec97");
		check(C = x"35a82a7a");
		check(D = x"daf7f308");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"daf7f308");
		check(B = x"5abe099c");
		check(C = x"89e0ec97");
		check(D = x"35a82a7a");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"35a82a7a");
		check(B = x"cf7e60db");
		check(C = x"5abe099c");
		check(D = x"89e0ec97");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"89e0ec97");
		check(B = x"75c151e2");
		check(C = x"cf7e60db");
		check(D = x"5abe099c");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"5abe099c");
		check(B = x"942e0c86");
		check(C = x"75c151e2");
		check(D = x"cf7e60db");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"cf7e60db");
		check(B = x"0c0e6ac4");
		check(C = x"942e0c86");
		check(D = x"75c151e2");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"75c151e2");
		check(B = x"cc6f5e9e");
		check(C = x"0c0e6ac4");
		check(D = x"942e0c86");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"942e0c86");
		check(B = x"0ac50e18");
		check(C = x"cc6f5e9e");
		check(D = x"0c0e6ac4");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"0c0e6ac4");
		check(B = x"79ca7845");
		check(C = x"0ac50e18");
		check(D = x"cc6f5e9e");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"cc6f5e9e");
		check(B = x"8a4a6356");
		check(C = x"79ca7845");
		check(D = x"0ac50e18");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"0ac50e18");
		check(B = x"918f93bb");
		check(C = x"8a4a6356");
		check(D = x"79ca7845");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"79ca7845");
		check(B = x"cab8fe42");
		check(C = x"918f93bb");
		check(D = x"8a4a6356");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"8a4a6356");
		check(B = x"6a4daeee");
		check(C = x"cab8fe42");
		check(D = x"918f93bb");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"918f93bb");
		check(B = x"36269c3f");
		check(C = x"6a4daeee");
		check(D = x"cab8fe42");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"cab8fe42");
		check(B = x"1ee405eb");
		check(C = x"36269c3f");
		check(D = x"6a4daeee");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"6a4daeee");
		check(B = x"982c7861");
		check(C = x"1ee405eb");
		check(D = x"36269c3f");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"36269c3f");
		check(B = x"6812a362");
		check(C = x"982c7861");
		check(D = x"1ee405eb");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"1ee405eb");
		check(B = x"71fc7709");
		check(C = x"6812a362");
		check(D = x"982c7861");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"982c7861");
		check(B = x"893501c0");
		check(C = x"71fc7709");
		check(D = x"6812a362");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"6812a362");
		check(B = x"febd62fd");
		check(C = x"893501c0");
		check(D = x"71fc7709");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"71fc7709");
		check(B = x"28936a74");
		check(C = x"febd62fd");
		check(D = x"893501c0");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"893501c0");
		check(B = x"53e33526");
		check(C = x"28936a74");
		check(D = x"febd62fd");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"febd62fd");
		check(B = x"aa4d8ae3");
		check(C = x"53e33526");
		check(D = x"28936a74");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"28936a74");
		check(B = x"52309e0b");
		check(C = x"aa4d8ae3");
		check(D = x"53e33526");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"53e33526");
		check(B = x"50f422f3");
		check(C = x"52309e0b");
		check(D = x"aa4d8ae3");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"aa4d8ae3");
		check(B = x"49dee633");
		check(C = x"50f422f3");
		check(D = x"52309e0b");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"52309e0b");
		check(B = x"b8e94637");
		check(C = x"49dee633");
		check(D = x"50f422f3");

		-- Check final result
		wait until is_complete = '1';
		wait until rising_edge(clk);
		check(A = x"0cc175b9");
		check(B = x"c0f1b6a8");
		check(C = x"31c399e2");
		check(D = x"69772661");

		test_runner_cleanup(runner);
	end process;

end md5_test_2_tb_arch;

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

entity md5_test_complete_tb IS
	generic(
		runner_cfg : string
	);
end md5_test_complete_tb;

architecture md5_test_complete_tb_arch OF md5_test_complete_tb IS
	signal clk                   : std_logic                     := '0';
	signal start_new_hash        : std_logic                     := '0';
	signal calculate_next_chunk  : std_logic                     := '0';
	signal write_data_in         : std_logic                     := '0';
	signal data_in               : std_logic_vector(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0);
	signal is_last_chunk         : std_logic                     := '0';
	signal is_idle               : std_logic                     := '0';
	signal is_waiting_next_chunk : std_logic                     := '0';
	signal is_busy               : std_logic                     := '0';
	signal is_complete           : std_logic                     := '0';
	signal error                 : md5_error_type;
	signal A                     : std_logic_vector(31 downto 0) := (others => '0');
	signal B                     : std_logic_vector(31 downto 0) := (others => '0');
	signal C                     : std_logic_vector(31 downto 0) := (others => '0');
	signal D                     : std_logic_vector(31 downto 0) := (others => '0');

begin
	md5 : entity work.md5
		port map(
			clk                   => clk,
			start_new_hash        => start_new_hash,
			write_data_in         => write_data_in,
			data_in               => data_in,
			data_in_word_position => data_in_word_position,
			calculate_next_chunk  => calculate_next_chunk,
			is_last_chunk         => is_last_chunk,
			is_idle               => is_idle,
			is_waiting_next_chunk => is_waiting_next_chunk,
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

		-- Write the 496 bits message ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
		write_data_in <= '1';

		data_in               <= x"41424344";
		data_in_word_position <= x"0";
		wait until rising_edge(clk);

		data_in               <= x"45464748";
		data_in_word_position <= x"1";
		wait until rising_edge(clk);

		data_in               <= x"494a4b4c";
		data_in_word_position <= x"2";
		wait until rising_edge(clk);

		data_in               <= x"4d4e4f50";
		data_in_word_position <= x"3";
		wait until rising_edge(clk);

		data_in               <= x"51525354";
		data_in_word_position <= x"4";
		wait until rising_edge(clk);

		data_in               <= x"55565758";
		data_in_word_position <= x"5";
		wait until rising_edge(clk);

		data_in               <= x"595a6162";
		data_in_word_position <= x"6";
		wait until rising_edge(clk);

		data_in               <= x"63646566";
		data_in_word_position <= x"7";
		wait until rising_edge(clk);

		data_in               <= x"6768696a";
		data_in_word_position <= x"8";
		wait until rising_edge(clk);

		data_in               <= x"6b6c6d6e";
		data_in_word_position <= x"9";
		wait until rising_edge(clk);

		data_in               <= x"6f707172";
		data_in_word_position <= x"a";
		wait until rising_edge(clk);

		data_in               <= x"73747576";
		data_in_word_position <= x"b";
		wait until rising_edge(clk);

		data_in               <= x"7778797a";
		data_in_word_position <= x"c";
		wait until rising_edge(clk);

		data_in               <= x"30313233";
		data_in_word_position <= x"d";
		wait until rising_edge(clk);

		data_in               <= x"34353637";
		data_in_word_position <= x"e";
		wait until rising_edge(clk);

		data_in               <= x"38390000";
		data_in_word_position <= x"f";
		wait until rising_edge(clk);

		write_data_in <= '0';

		-- Start calculation
		calculate_next_chunk <= '1';
		wait until rising_edge(clk);
		calculate_next_chunk <= '0';

		--wait until rising_edge(clk); -- Wait padding step
		
		wait until rising_edge(clk);

		-------------------------------------------- Round 1 --------------------------------------------
		
		-- Step 0
		wait until rising_edge(clk);
		check(A = x"10325476");
		check(B = x"c6c10796");
		check(C = x"efcdab89");
		check(D = x"98badcfe");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"98badcfe");
		check(B = x"99a09999");
		check(C = x"c6c10796");
		check(D = x"efcdab89");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"efcdab89");
		check(B = x"11067980");
		check(C = x"99a09999");
		check(D = x"c6c10796");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"c6c10796");
		check(B = x"27bce07a");
		check(C = x"11067980");
		check(D = x"99a09999");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"99a09999");
		check(B = x"f22e6c4e");
		check(C = x"27bce07a");
		check(D = x"11067980");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"11067980");
		check(B = x"b4ac9218");
		check(C = x"f22e6c4e");
		check(D = x"27bce07a");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"27bce07a");
		check(B = x"a95a2fc0");
		check(C = x"b4ac9218");
		check(D = x"f22e6c4e");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"f22e6c4e");
		check(B = x"a4799506");
		check(C = x"a95a2fc0");
		check(D = x"b4ac9218");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"b4ac9218");
		check(B = x"1eb3e7c1");
		check(C = x"a4799506");
		check(D = x"a95a2fc0");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"a95a2fc0");
		check(B = x"a6e70cfe");
		check(C = x"1eb3e7c1");
		check(D = x"a4799506");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"a4799506");
		check(B = x"ca27520b");
		check(C = x"a6e70cfe");
		check(D = x"1eb3e7c1");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"1eb3e7c1");
		check(B = x"8a7612ec");
		check(C = x"ca27520b");
		check(D = x"a6e70cfe");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"a6e70cfe");
		check(B = x"3cbdcd45");
		check(C = x"8a7612ec");
		check(D = x"ca27520b");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"ca27520b");
		check(B = x"b8dec763");
		check(C = x"3cbdcd45");
		check(D = x"8a7612ec");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"8a7612ec");
		check(B = x"fa148c8a");
		check(C = x"b8dec763");
		check(D = x"3cbdcd45");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"3cbdcd45");
		check(B = x"5d38e690");
		check(C = x"fa148c8a");
		check(D = x"b8dec763");
		
		wait for 1000 ps;

		test_runner_cleanup(runner);
		--wait;
	end process;

end md5_test_complete_tb_arch;

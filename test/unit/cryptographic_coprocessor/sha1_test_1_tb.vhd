library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 8 bits message ("a")

entity sha1_test_1_tb IS
	generic(
		runner_cfg : string
	);
end sha1_test_1_tb;

architecture sha1_test_1_tb_arch OF sha1_test_1_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal calculate_next_block  : std_logic             := '0';
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_idle               : std_logic             := '0';
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : md5_error_type;
	signal H0_out                : unsigned(31 downto 0) := (others => '0');
	signal H1_out                : unsigned(31 downto 0) := (others => '0');
	signal H2_out                : unsigned(31 downto 0) := (others => '0');
	signal H3_out                : unsigned(31 downto 0) := (others => '0');
	signal H4_out                : unsigned(31 downto 0) := (others => '0');

begin
	sha1 : entity work.sha1
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
			H0_out                => H0_out,
			H1_out                => H1_out,
			H2_out                => H2_out,
			H3_out                => H3_out,
			H4_out                => H4_out
		);

	clk <= not clk after 10 ps;

	main : process
		alias A is <<signal sha1.A : unsigned(31 downto 0)>>;
		alias B is <<signal sha1.B : unsigned(31 downto 0)>>;
		alias C is <<signal sha1.C : unsigned(31 downto 0)>>;
		alias D is <<signal sha1.D : unsigned(31 downto 0)>>;
		alias E is <<signal sha1.E : unsigned(31 downto 0)>>;
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

		-------------------------------------------- Round 0 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"013498b3");
		check(B = x"67452301");
		check(C = x"7bf36ae2");
		check(D = x"98badcfe");
		check(E = x"10325476");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"8d43e36d");
		check(B = x"013498b3");
		check(C = x"59d148c0");
		check(D = x"7bf36ae2");
		check(E = x"98badcfe");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"178d2f08");
		check(B = x"8d43e36d");
		check(C = x"c04d262c");
		check(D = x"59d148c0");
		check(E = x"7bf36ae2");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"98ecf029");
		check(B = x"178d2f08");
		check(C = x"6350f8db");
		check(D = x"c04d262c");
		check(E = x"59d148c0");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"9531efb8");
		check(B = x"98ecf029");
		check(C = x"05e34bc2");
		check(D = x"6350f8db");
		check(E = x"c04d262c");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"24fddfa9");
		check(B = x"9531efb8");
		check(C = x"663b3c0a");
		check(D = x"05e34bc2");
		check(E = x"6350f8db");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"628293e2");
		check(B = x"24fddfa9");
		check(C = x"254c7bee");
		check(D = x"663b3c0a");
		check(E = x"05e34bc2");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"1706bd51");
		check(B = x"628293e2");
		check(C = x"493f77ea");
		check(D = x"254c7bee");
		check(E = x"663b3c0a");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"e6e3dbb3");
		check(B = x"1706bd51");
		check(C = x"98a0a4f8");
		check(D = x"493f77ea");
		check(E = x"254c7bee");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"b48452fd");
		check(B = x"e6e3dbb3");
		check(C = x"45c1af54");
		check(D = x"98a0a4f8");
		check(E = x"493f77ea");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"910e0091");
		check(B = x"b48452fd");
		check(C = x"f9b8f6ec");
		check(D = x"45c1af54");
		check(E = x"98a0a4f8");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"06a530af");
		check(B = x"910e0091");
		check(C = x"6d2114bf");
		check(D = x"f9b8f6ec");
		check(E = x"45c1af54");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"de9b35ca");
		check(B = x"06a530af");
		check(C = x"64438024");
		check(D = x"6d2114bf");
		check(E = x"f9b8f6ec");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"94a32e14");
		check(B = x"de9b35ca");
		check(C = x"c1a94c2b");
		check(D = x"64438024");
		check(E = x"6d2114bf");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"3cd2d518");
		check(B = x"94a32e14");
		check(C = x"b7a6cd72");
		check(D = x"c1a94c2b");
		check(E = x"64438024");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"2ecae907");
		check(B = x"3cd2d518");
		check(C = x"2528cb85");
		check(D = x"b7a6cd72");
		check(E = x"c1a94c2b");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"5fadb00b");
		check(B = x"2ecae907");
		check(C = x"0f34b546");
		check(D = x"2528cb85");
		check(E = x"b7a6cd72");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"16ffebfc");
		check(B = x"5fadb00b");
		check(C = x"cbb2ba41");
		check(D = x"0f34b546");
		check(E = x"2528cb85");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"ab5979f5");
		check(B = x"16ffebfc");
		check(C = x"d7eb6c02");
		check(D = x"cbb2ba41");
		check(E = x"0f34b546");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"3ad1e596");
		check(B = x"ab5979f5");
		check(C = x"05bffaff");
		check(D = x"d7eb6c02");
		check(E = x"cbb2ba41");

		test_runner_cleanup(runner);
	end process;

end sha1_test_1_tb_arch;

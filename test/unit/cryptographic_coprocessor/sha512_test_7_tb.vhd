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


		test_runner_cleanup(runner);
	end process;

end sha512_test_7_tb_arch;

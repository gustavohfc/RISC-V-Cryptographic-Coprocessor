library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

-- 112 bits message ("message digest")

entity sha256_test_3_tb IS
	generic(
		runner_cfg : string
	);
end sha256_test_3_tb;

architecture sha256_test_3_tb_arch OF sha256_test_3_tb IS
	signal clk                   : std_logic             := '0';
	signal start_new_hash        : std_logic             := '0';
	signal write_data_in         : std_logic             := '0';
	signal data_in               : unsigned(31 downto 0) := (others => '0');
	signal data_in_word_position : unsigned(3 downto 0)  := (others => '0');
	signal calculate_next_block  : std_logic             := '0';
	signal is_last_block         : std_logic             := '0';
	signal last_block_size       : unsigned(9 downto 0)  := (others => '0');
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : sha256_error_type;
	signal H0_out                : unsigned(31 downto 0) := (others => '0');
	signal H1_out                : unsigned(31 downto 0) := (others => '0');
	signal H2_out                : unsigned(31 downto 0) := (others => '0');
	signal H3_out                : unsigned(31 downto 0) := (others => '0');
	signal H4_out                : unsigned(31 downto 0) := (others => '0');
	signal H5_out                : unsigned(31 downto 0) := (others => '0');
	signal H6_out                : unsigned(31 downto 0) := (others => '0');
	signal H7_out                : unsigned(31 downto 0) := (others => '0');

begin
	sha256 : entity work.sha256
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
		alias A is <<signal sha256.A : unsigned(31 downto 0)>>;
		alias B is <<signal sha256.B : unsigned(31 downto 0)>>;
		alias C is <<signal sha256.C : unsigned(31 downto 0)>>;
		alias D is <<signal sha256.D : unsigned(31 downto 0)>>;
		alias E is <<signal sha256.E : unsigned(31 downto 0)>>;
		alias F is <<signal sha256.F : unsigned(31 downto 0)>>;
		alias G is <<signal sha256.G : unsigned(31 downto 0)>>;
		alias H is <<signal sha256.H : unsigned(31 downto 0)>>;
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

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step

		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

		-- Step 0
		wait until rising_edge(clk);
		check(A = x"696dfbc0");
		check(B = x"6a09e667");
		check(C = x"bb67ae85");
		check(D = x"3c6ef372");
		check(E = x"062d5615");
		check(F = x"510e527f");
		check(G = x"9b05688c");
		check(H = x"1f83d9ab");

		-- Step 1
		wait until rising_edge(clk);
		check(A = x"ea679b69");
		check(B = x"696dfbc0");
		check(C = x"6a09e667");
		check(D = x"bb67ae85");
		check(E = x"47b16bdc");
		check(F = x"062d5615");
		check(G = x"510e527f");
		check(H = x"9b05688c");

		-- Step 2
		wait until rising_edge(clk);
		check(A = x"47ac0948");
		check(B = x"ea679b69");
		check(C = x"696dfbc0");
		check(D = x"6a09e667");
		check(E = x"58eaaa1d");
		check(F = x"47b16bdc");
		check(G = x"062d5615");
		check(H = x"510e527f");

		-- Step 3
		wait until rising_edge(clk);
		check(A = x"8f759f05");
		check(B = x"47ac0948");
		check(C = x"ea679b69");
		check(D = x"696dfbc0");
		check(E = x"a285cbf8");
		check(F = x"58eaaa1d");
		check(G = x"47b16bdc");
		check(H = x"062d5615");

		-- Step 4
		wait until rising_edge(clk);
		check(A = x"81a323ec");
		check(B = x"8f759f05");
		check(C = x"47ac0948");
		check(D = x"ea679b69");
		check(E = x"ce1e7a13");
		check(F = x"a285cbf8");
		check(G = x"58eaaa1d");
		check(H = x"47b16bdc");

		-- Step 5
		wait until rising_edge(clk);
		check(A = x"722c7ed9");
		check(B = x"81a323ec");
		check(C = x"8f759f05");
		check(D = x"47ac0948");
		check(E = x"216b9712");
		check(F = x"ce1e7a13");
		check(G = x"a285cbf8");
		check(H = x"58eaaa1d");

		-- Step 6
		wait until rising_edge(clk);
		check(A = x"2ba3bce3");
		check(B = x"722c7ed9");
		check(C = x"81a323ec");
		check(D = x"8f759f05");
		check(E = x"d46e9b41");
		check(F = x"216b9712");
		check(G = x"ce1e7a13");
		check(H = x"a285cbf8");

		-- Step 7
		wait until rising_edge(clk);
		check(A = x"76e932a7");
		check(B = x"2ba3bce3");
		check(C = x"722c7ed9");
		check(D = x"81a323ec");
		check(E = x"3fb95438");
		check(F = x"d46e9b41");
		check(G = x"216b9712");
		check(H = x"ce1e7a13");

		-- Step 8
		wait until rising_edge(clk);
		check(A = x"d4d86b30");
		check(B = x"76e932a7");
		check(C = x"2ba3bce3");
		check(D = x"722c7ed9");
		check(E = x"f786e9fe");
		check(F = x"3fb95438");
		check(G = x"d46e9b41");
		check(H = x"216b9712");

		-- Step 9
		wait until rising_edge(clk);
		check(A = x"f751124c");
		check(B = x"d4d86b30");
		check(C = x"76e932a7");
		check(D = x"2ba3bce3");
		check(E = x"e577d726");
		check(F = x"f786e9fe");
		check(G = x"3fb95438");
		check(H = x"d46e9b41");

		-- Step 10
		wait until rising_edge(clk);
		check(A = x"9fa5c4fb");
		check(B = x"f751124c");
		check(C = x"d4d86b30");
		check(D = x"76e932a7");
		check(E = x"e87581f4");
		check(F = x"e577d726");
		check(G = x"f786e9fe");
		check(H = x"3fb95438");

		-- Step 11
		wait until rising_edge(clk);
		check(A = x"93b182d2");
		check(B = x"9fa5c4fb");
		check(C = x"f751124c");
		check(D = x"d4d86b30");
		check(E = x"dba31093");
		check(F = x"e87581f4");
		check(G = x"e577d726");
		check(H = x"f786e9fe");

		-- Step 12
		wait until rising_edge(clk);
		check(A = x"ef7dfb43");
		check(B = x"93b182d2");
		check(C = x"9fa5c4fb");
		check(D = x"f751124c");
		check(E = x"b8312c23");
		check(F = x"dba31093");
		check(G = x"e87581f4");
		check(H = x"e577d726");

		-- Step 13
		wait until rising_edge(clk);
		check(A = x"c6a0ab99");
		check(B = x"ef7dfb43");
		check(C = x"93b182d2");
		check(D = x"9fa5c4fb");
		check(E = x"480ef090");
		check(F = x"b8312c23");
		check(G = x"dba31093");
		check(H = x"e87581f4");

		-- Step 14
		wait until rising_edge(clk);
		check(A = x"ebbe3fa2");
		check(B = x"c6a0ab99");
		check(C = x"ef7dfb43");
		check(D = x"93b182d2");
		check(E = x"13e9dfd1");
		check(F = x"480ef090");
		check(G = x"b8312c23");
		check(H = x"dba31093");

		-- Step 15
		wait until rising_edge(clk);
		check(A = x"3e9d3b30");
		check(B = x"ebbe3fa2");
		check(C = x"c6a0ab99");
		check(D = x"ef7dfb43");
		check(E = x"238ba8c8");
		check(F = x"13e9dfd1");
		check(G = x"480ef090");
		check(H = x"b8312c23");

		-- Step 16
		wait until rising_edge(clk);
		check(A = x"794b0eb4");
		check(B = x"3e9d3b30");
		check(C = x"ebbe3fa2");
		check(D = x"c6a0ab99");
		check(E = x"d7425368");
		check(F = x"238ba8c8");
		check(G = x"13e9dfd1");
		check(H = x"480ef090");

		-- Step 17
		wait until rising_edge(clk);
		check(A = x"6f8c3e73");
		check(B = x"794b0eb4");
		check(C = x"3e9d3b30");
		check(D = x"ebbe3fa2");
		check(E = x"72c1d24c");
		check(F = x"d7425368");
		check(G = x"238ba8c8");
		check(H = x"13e9dfd1");

		-- Step 18
		wait until rising_edge(clk);
		check(A = x"5e03be6d");
		check(B = x"6f8c3e73");
		check(C = x"794b0eb4");
		check(D = x"3e9d3b30");
		check(E = x"b1b3019c");
		check(F = x"72c1d24c");
		check(G = x"d7425368");
		check(H = x"238ba8c8");

		-- Step 19
		wait until rising_edge(clk);
		check(A = x"3b6488ea");
		check(B = x"5e03be6d");
		check(C = x"6f8c3e73");
		check(D = x"794b0eb4");
		check(E = x"50e2daa7");
		check(F = x"b1b3019c");
		check(G = x"72c1d24c");
		check(H = x"d7425368");

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"2d727f11");
		check(B = x"3b6488ea");
		check(C = x"5e03be6d");
		check(D = x"6f8c3e73");
		check(E = x"cc0d7d67");
		check(F = x"50e2daa7");
		check(G = x"b1b3019c");
		check(H = x"72c1d24c");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"bce152d9");
		check(B = x"2d727f11");
		check(C = x"3b6488ea");
		check(D = x"5e03be6d");
		check(E = x"72e12201");
		check(F = x"cc0d7d67");
		check(G = x"50e2daa7");
		check(H = x"b1b3019c");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"af898364");
		check(B = x"bce152d9");
		check(C = x"2d727f11");
		check(D = x"3b6488ea");
		check(E = x"536e11a9");
		check(F = x"72e12201");
		check(G = x"cc0d7d67");
		check(H = x"50e2daa7");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"c90f220a");
		check(B = x"af898364");
		check(C = x"bce152d9");
		check(D = x"2d727f11");
		check(E = x"3fc7c978");
		check(F = x"536e11a9");
		check(G = x"72e12201");
		check(H = x"cc0d7d67");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"82a85da6");
		check(B = x"c90f220a");
		check(C = x"af898364");
		check(D = x"bce152d9");
		check(E = x"63f42e90");
		check(F = x"3fc7c978");
		check(G = x"536e11a9");
		check(H = x"72e12201");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"616be363");
		check(B = x"82a85da6");
		check(C = x"c90f220a");
		check(D = x"af898364");
		check(E = x"a5db9af5");
		check(F = x"63f42e90");
		check(G = x"3fc7c978");
		check(H = x"536e11a9");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"6b0ab407");
		check(B = x"616be363");
		check(C = x"82a85da6");
		check(D = x"c90f220a");
		check(E = x"ec9c5647");
		check(F = x"a5db9af5");
		check(G = x"63f42e90");
		check(H = x"3fc7c978");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"1235ac19");
		check(B = x"6b0ab407");
		check(C = x"616be363");
		check(D = x"82a85da6");
		check(E = x"27eff004");
		check(F = x"ec9c5647");
		check(G = x"a5db9af5");
		check(H = x"63f42e90");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"4959f35b");
		check(B = x"1235ac19");
		check(C = x"6b0ab407");
		check(D = x"616be363");
		check(E = x"75e10e1b");
		check(F = x"27eff004");
		check(G = x"ec9c5647");
		check(H = x"a5db9af5");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"8926cce1");
		check(B = x"4959f35b");
		check(C = x"1235ac19");
		check(D = x"6b0ab407");
		check(E = x"7037a0ed");
		check(F = x"75e10e1b");
		check(G = x"27eff004");
		check(H = x"ec9c5647");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"d3ca7452");
		check(B = x"8926cce1");
		check(C = x"4959f35b");
		check(D = x"1235ac19");
		check(E = x"9728bfd6");
		check(F = x"7037a0ed");
		check(G = x"75e10e1b");
		check(H = x"27eff004");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"218cd7d1");
		check(B = x"d3ca7452");
		check(C = x"8926cce1");
		check(D = x"4959f35b");
		check(E = x"2ac2478f");
		check(F = x"9728bfd6");
		check(G = x"7037a0ed");
		check(H = x"75e10e1b");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"8e0a120e");
		check(B = x"218cd7d1");
		check(C = x"d3ca7452");
		check(D = x"8926cce1");
		check(E = x"901fb384");
		check(F = x"2ac2478f");
		check(G = x"9728bfd6");
		check(H = x"7037a0ed");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"98685203");
		check(B = x"8e0a120e");
		check(C = x"218cd7d1");
		check(D = x"d3ca7452");
		check(E = x"8245f9a7");
		check(F = x"901fb384");
		check(G = x"2ac2478f");
		check(H = x"9728bfd6");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"d9d079d9");
		check(B = x"98685203");
		check(C = x"8e0a120e");
		check(D = x"218cd7d1");
		check(E = x"4e43c285");
		check(F = x"8245f9a7");
		check(G = x"901fb384");
		check(H = x"2ac2478f");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"c54c0ad3");
		check(B = x"d9d079d9");
		check(C = x"98685203");
		check(D = x"8e0a120e");
		check(E = x"5532d907");
		check(F = x"4e43c285");
		check(G = x"8245f9a7");
		check(H = x"901fb384");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"d41491b8");
		check(B = x"c54c0ad3");
		check(C = x"d9d079d9");
		check(D = x"98685203");
		check(E = x"f0efe132");
		check(F = x"5532d907");
		check(G = x"4e43c285");
		check(H = x"8245f9a7");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"644480bc");
		check(B = x"d41491b8");
		check(C = x"c54c0ad3");
		check(D = x"d9d079d9");
		check(E = x"3cd3514c");
		check(F = x"f0efe132");
		check(G = x"5532d907");
		check(H = x"4e43c285");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"55541b8f");
		check(B = x"644480bc");
		check(C = x"d41491b8");
		check(D = x"c54c0ad3");
		check(E = x"5bef2116");
		check(F = x"3cd3514c");
		check(G = x"f0efe132");
		check(H = x"5532d907");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"438a2feb");
		check(B = x"55541b8f");
		check(C = x"644480bc");
		check(D = x"d41491b8");
		check(E = x"5b4017ec");
		check(F = x"5bef2116");
		check(G = x"3cd3514c");
		check(H = x"f0efe132");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"e328a176");
		check(B = x"438a2feb");
		check(C = x"55541b8f");
		check(D = x"644480bc");
		check(E = x"eaf1ecda");
		check(F = x"5b4017ec");
		check(G = x"5bef2116");
		check(H = x"3cd3514c");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"e9413ccc");
		check(B = x"e328a176");
		check(C = x"438a2feb");
		check(D = x"55541b8f");
		check(E = x"f884a705");
		check(F = x"eaf1ecda");
		check(G = x"5b4017ec");
		check(H = x"5bef2116");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"c42560a1");
		check(B = x"e9413ccc");
		check(C = x"e328a176");
		check(D = x"438a2feb");
		check(E = x"5dad17a3");
		check(F = x"f884a705");
		check(G = x"eaf1ecda");
		check(H = x"5b4017ec");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"1a3da577");
		check(B = x"c42560a1");
		check(C = x"e9413ccc");
		check(D = x"e328a176");
		check(E = x"9b20b66b");
		check(F = x"5dad17a3");
		check(G = x"f884a705");
		check(H = x"eaf1ecda");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"0978b90a");
		check(B = x"1a3da577");
		check(C = x"c42560a1");
		check(D = x"e9413ccc");
		check(E = x"08d9d0c3");
		check(F = x"9b20b66b");
		check(G = x"5dad17a3");
		check(H = x"f884a705");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"fd0e8180");
		check(B = x"0978b90a");
		check(C = x"1a3da577");
		check(D = x"c42560a1");
		check(E = x"3527cf87");
		check(F = x"08d9d0c3");
		check(G = x"9b20b66b");
		check(H = x"5dad17a3");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"082d8f8c");
		check(B = x"fd0e8180");
		check(C = x"0978b90a");
		check(D = x"1a3da577");
		check(E = x"a9d4034b");
		check(F = x"3527cf87");
		check(G = x"08d9d0c3");
		check(H = x"9b20b66b");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"458ea901");
		check(B = x"082d8f8c");
		check(C = x"fd0e8180");
		check(D = x"0978b90a");
		check(E = x"8e4ab241");
		check(F = x"a9d4034b");
		check(G = x"3527cf87");
		check(H = x"08d9d0c3");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"182038f5");
		check(B = x"458ea901");
		check(C = x"082d8f8c");
		check(D = x"fd0e8180");
		check(E = x"b0bce55c");
		check(F = x"8e4ab241");
		check(G = x"a9d4034b");
		check(H = x"3527cf87");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"6a783d4b");
		check(B = x"182038f5");
		check(C = x"458ea901");
		check(D = x"082d8f8c");
		check(E = x"5e16f9ea");
		check(F = x"b0bce55c");
		check(G = x"8e4ab241");
		check(H = x"a9d4034b");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"0c7dbf16");
		check(B = x"6a783d4b");
		check(C = x"182038f5");
		check(D = x"458ea901");
		check(E = x"fc52a427");
		check(F = x"5e16f9ea");
		check(G = x"b0bce55c");
		check(H = x"8e4ab241");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"172c846b");
		check(B = x"0c7dbf16");
		check(C = x"6a783d4b");
		check(D = x"182038f5");
		check(E = x"c6ef9bfc");
		check(F = x"fc52a427");
		check(G = x"5e16f9ea");
		check(H = x"b0bce55c");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"e269c27a");
		check(B = x"172c846b");
		check(C = x"0c7dbf16");
		check(D = x"6a783d4b");
		check(E = x"978b0a02");
		check(F = x"c6ef9bfc");
		check(G = x"fc52a427");
		check(H = x"5e16f9ea");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"a5b8e643");
		check(B = x"e269c27a");
		check(C = x"172c846b");
		check(D = x"0c7dbf16");
		check(E = x"fd7f14bb");
		check(F = x"978b0a02");
		check(G = x"c6ef9bfc");
		check(H = x"fc52a427");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"26dddb2b");
		check(B = x"a5b8e643");
		check(C = x"e269c27a");
		check(D = x"172c846b");
		check(E = x"5348b915");
		check(F = x"fd7f14bb");
		check(G = x"978b0a02");
		check(H = x"c6ef9bfc");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"2ad09003");
		check(B = x"26dddb2b");
		check(C = x"a5b8e643");
		check(D = x"e269c27a");
		check(E = x"33806544");
		check(F = x"5348b915");
		check(G = x"fd7f14bb");
		check(H = x"978b0a02");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"c144e9ef");
		check(B = x"2ad09003");
		check(C = x"26dddb2b");
		check(D = x"a5b8e643");
		check(E = x"73e85c37");
		check(F = x"33806544");
		check(G = x"5348b915");
		check(H = x"fd7f14bb");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"f3cc1dbb");
		check(B = x"c144e9ef");
		check(C = x"2ad09003");
		check(D = x"26dddb2b");
		check(E = x"ca279b7a");
		check(F = x"73e85c37");
		check(G = x"33806544");
		check(H = x"5348b915");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"af6e2def");
		check(B = x"f3cc1dbb");
		check(C = x"c144e9ef");
		check(D = x"2ad09003");
		check(E = x"d12cf8ae");
		check(F = x"ca279b7a");
		check(G = x"73e85c37");
		check(H = x"33806544");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"de718a26");
		check(B = x"af6e2def");
		check(C = x"f3cc1dbb");
		check(D = x"c144e9ef");
		check(E = x"e9e49d83");
		check(F = x"d12cf8ae");
		check(G = x"ca279b7a");
		check(H = x"73e85c37");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"3c051773");
		check(B = x"de718a26");
		check(C = x"af6e2def");
		check(D = x"f3cc1dbb");
		check(E = x"dd5be937");
		check(F = x"e9e49d83");
		check(G = x"d12cf8ae");
		check(H = x"ca279b7a");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"af7bc242");
		check(B = x"3c051773");
		check(C = x"de718a26");
		check(D = x"af6e2def");
		check(E = x"841d6792");
		check(F = x"dd5be937");
		check(G = x"e9e49d83");
		check(H = x"d12cf8ae");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"13bc32c9");
		check(B = x"af7bc242");
		check(C = x"3c051773");
		check(D = x"de718a26");
		check(E = x"adf65c63");
		check(F = x"841d6792");
		check(G = x"dd5be937");
		check(H = x"e9e49d83");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"8d7a88ee");
		check(B = x"13bc32c9");
		check(C = x"af7bc242");
		check(D = x"3c051773");
		check(E = x"0a424bb4");
		check(F = x"adf65c63");
		check(G = x"841d6792");
		check(H = x"dd5be937");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"f7846f55");
		check(H1_out = x"cf23e14e");
		check(H2_out = x"ebeab5b4");
		check(H3_out = x"e1550cad");
		check(H4_out = x"5b509e33");
		check(H5_out = x"48fbc4ef");
		check(H6_out = x"a3a1413d");
		check(H7_out = x"393cb650");

		test_runner_cleanup(runner);
	end process;

end sha256_test_3_tb_arch;

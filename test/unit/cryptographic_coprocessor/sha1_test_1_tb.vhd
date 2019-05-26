library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	signal is_waiting_next_block : std_logic             := '0';
	signal is_busy               : std_logic             := '0';
	signal is_complete           : std_logic             := '0';
	signal error                 : sha1_error_type;
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

		wait until rising_edge(clk);

		wait until rising_edge(clk);    -- Wait padding step
		
		wait until rising_edge(clk);    -- Wait the pre calculation step

		-------------------------------------------- Round 1 --------------------------------------------

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

		-- Step 20
		wait until rising_edge(clk);
		check(A = x"0dd747b1");
		check(B = x"3ad1e596");
		check(C = x"6ad65e7d");
		check(D = x"05bffaff");
		check(E = x"d7eb6c02");

		-- Step 21
		wait until rising_edge(clk);
		check(A = x"57668ef8");
		check(B = x"0dd747b1");
		check(C = x"8eb47965");
		check(D = x"6ad65e7d");
		check(E = x"05bffaff");

		-- Step 22
		wait until rising_edge(clk);
		check(A = x"57212656");
		check(B = x"57668ef8");
		check(C = x"4375d1ec");
		check(D = x"8eb47965");
		check(E = x"6ad65e7d");

		-- Step 23
		wait until rising_edge(clk);
		check(A = x"587c3b69");
		check(B = x"57212656");
		check(C = x"15d9a3be");
		check(D = x"4375d1ec");
		check(E = x"8eb47965");

		-- Step 24
		wait until rising_edge(clk);
		check(A = x"94a32676");
		check(B = x"587c3b69");
		check(C = x"95c84995");
		check(D = x"15d9a3be");
		check(E = x"4375d1ec");

		-- Step 25
		wait until rising_edge(clk);
		check(A = x"37225da7");
		check(B = x"94a32676");
		check(C = x"561f0eda");
		check(D = x"95c84995");
		check(E = x"15d9a3be");

		-- Step 26
		wait until rising_edge(clk);
		check(A = x"c073a57e");
		check(B = x"37225da7");
		check(C = x"a528c99d");
		check(D = x"561f0eda");
		check(E = x"95c84995");

		-- Step 27
		wait until rising_edge(clk);
		check(A = x"d72c806e");
		check(B = x"c073a57e");
		check(C = x"cdc89769");
		check(D = x"a528c99d");
		check(E = x"561f0eda");

		-- Step 28
		wait until rising_edge(clk);
		check(A = x"831d03eb");
		check(B = x"d72c806e");
		check(C = x"b01ce95f");
		check(D = x"cdc89769");
		check(E = x"a528c99d");

		-- Step 29
		wait until rising_edge(clk);
		check(A = x"229c3156");
		check(B = x"831d03eb");
		check(C = x"b5cb201b");
		check(D = x"b01ce95f");
		check(E = x"cdc89769");

		-- Step 30
		wait until rising_edge(clk);
		check(A = x"b4f37984");
		check(B = x"229c3156");
		check(C = x"e0c740fa");
		check(D = x"b5cb201b");
		check(E = x"b01ce95f");

		-- Step 31
		wait until rising_edge(clk);
		check(A = x"94f65775");
		check(B = x"b4f37984");
		check(C = x"88a70c55");
		check(D = x"e0c740fa");
		check(E = x"b5cb201b");

		-- Step 32
		wait until rising_edge(clk);
		check(A = x"2a032f9b");
		check(B = x"94f65775");
		check(C = x"2d3cde61");
		check(D = x"88a70c55");
		check(E = x"e0c740fa");

		-- Step 33
		wait until rising_edge(clk);
		check(A = x"c174a741");
		check(B = x"2a032f9b");
		check(C = x"653d95dd");
		check(D = x"2d3cde61");
		check(E = x"88a70c55");

		-- Step 34
		wait until rising_edge(clk);
		check(A = x"481844c5");
		check(B = x"c174a741");
		check(C = x"ca80cbe6");
		check(D = x"653d95dd");
		check(E = x"2d3cde61");

		-- Step 35
		wait until rising_edge(clk);
		check(A = x"25e95d6b");
		check(B = x"481844c5");
		check(C = x"705d29d0");
		check(D = x"ca80cbe6");
		check(E = x"653d95dd");

		-- Step 36
		wait until rising_edge(clk);
		check(A = x"fc08d9f3");
		check(B = x"25e95d6b");
		check(C = x"52061131");
		check(D = x"705d29d0");
		check(E = x"ca80cbe6");

		-- Step 37
		wait until rising_edge(clk);
		check(A = x"42285bb1");
		check(B = x"fc08d9f3");
		check(C = x"c97a575a");
		check(D = x"52061131");
		check(E = x"705d29d0");

		-- Step 38
		wait until rising_edge(clk);
		check(A = x"a3b72b37");
		check(B = x"42285bb1");
		check(C = x"ff02367c");
		check(D = x"c97a575a");
		check(E = x"52061131");

		-- Step 39
		wait until rising_edge(clk);
		check(A = x"ac15a69d");
		check(B = x"a3b72b37");
		check(C = x"508a16ec");
		check(D = x"ff02367c");
		check(E = x"c97a575a");

		-- Step 40
		wait until rising_edge(clk);
		check(A = x"e6cd1f2c");
		check(B = x"ac15a69d");
		check(C = x"e8edcacd");
		check(D = x"508a16ec");
		check(E = x"ff02367c");

		-- Step 41
		wait until rising_edge(clk);
		check(A = x"504f64c1");
		check(B = x"e6cd1f2c");
		check(C = x"6b0569a7");
		check(D = x"e8edcacd");
		check(E = x"508a16ec");

		-- Step 42
		wait until rising_edge(clk);
		check(A = x"b45fc818");
		check(B = x"504f64c1");
		check(C = x"39b347cb");
		check(D = x"6b0569a7");
		check(E = x"e8edcacd");

		-- Step 43
		wait until rising_edge(clk);
		check(A = x"7d09f328");
		check(B = x"b45fc818");
		check(C = x"5413d930");
		check(D = x"39b347cb");
		check(E = x"6b0569a7");

		-- Step 44
		wait until rising_edge(clk);
		check(A = x"7b7354d5");
		check(B = x"7d09f328");
		check(C = x"2d17f206");
		check(D = x"5413d930");
		check(E = x"39b347cb");

		-- Step 45
		wait until rising_edge(clk);
		check(A = x"b44db2b6");
		check(B = x"7b7354d5");
		check(C = x"1f427cca");
		check(D = x"2d17f206");
		check(E = x"5413d930");

		-- Step 46
		wait until rising_edge(clk);
		check(A = x"c43968f2");
		check(B = x"b44db2b6");
		check(C = x"5edcd535");
		check(D = x"1f427cca");
		check(E = x"2d17f206");

		-- Step 47
		wait until rising_edge(clk);
		check(A = x"f9add677");
		check(B = x"c43968f2");
		check(C = x"ad136cad");
		check(D = x"5edcd535");
		check(E = x"1f427cca");

		-- Step 48
		wait until rising_edge(clk);
		check(A = x"5432b748");
		check(B = x"f9add677");
		check(C = x"b10e5a3c");
		check(D = x"ad136cad");
		check(E = x"5edcd535");

		-- Step 49
		wait until rising_edge(clk);
		check(A = x"2d5edb70");
		check(B = x"5432b748");
		check(C = x"fe6b759d");
		check(D = x"b10e5a3c");
		check(E = x"ad136cad");

		-- Step 50
		wait until rising_edge(clk);
		check(A = x"5c350fcb");
		check(B = x"2d5edb70");
		check(C = x"150cadd2");
		check(D = x"fe6b759d");
		check(E = x"b10e5a3c");

		-- Step 51
		wait until rising_edge(clk);
		check(A = x"7c1b92b1");
		check(B = x"5c350fcb");
		check(C = x"0b57b6dc");
		check(D = x"150cadd2");
		check(E = x"fe6b759d");

		-- Step 52
		wait until rising_edge(clk);
		check(A = x"c60f44d9");
		check(B = x"7c1b92b1");
		check(C = x"d70d43f2");
		check(D = x"0b57b6dc");
		check(E = x"150cadd2");

		-- Step 53
		wait until rising_edge(clk);
		check(A = x"c530ead6");
		check(B = x"c60f44d9");
		check(C = x"5f06e4ac");
		check(D = x"d70d43f2");
		check(E = x"0b57b6dc");

		-- Step 54
		wait until rising_edge(clk);
		check(A = x"d7a11b36");
		check(B = x"c530ead6");
		check(C = x"7183d136");
		check(D = x"5f06e4ac");
		check(E = x"d70d43f2");

		-- Step 55
		wait until rising_edge(clk);
		check(A = x"af4f737e");
		check(B = x"d7a11b36");
		check(C = x"b14c3ab5");
		check(D = x"7183d136");
		check(E = x"5f06e4ac");

		-- Step 56
		wait until rising_edge(clk);
		check(A = x"81923337");
		check(B = x"af4f737e");
		check(C = x"b5e846cd");
		check(D = x"b14c3ab5");
		check(E = x"7183d136");

		-- Step 57
		wait until rising_edge(clk);
		check(A = x"68346c20");
		check(B = x"81923337");
		check(C = x"abd3dcdf");
		check(D = x"b5e846cd");
		check(E = x"b14c3ab5");

		-- Step 58
		wait until rising_edge(clk);
		check(A = x"80c84724");
		check(B = x"68346c20");
		check(C = x"e0648ccd");
		check(D = x"abd3dcdf");
		check(E = x"b5e846cd");

		-- Step 59
		wait until rising_edge(clk);
		check(A = x"c682f53f");
		check(B = x"80c84724");
		check(C = x"1a0d1b08");
		check(D = x"e0648ccd");
		check(E = x"abd3dcdf");

		-- Step 60
		wait until rising_edge(clk);
		check(A = x"193b35bd");
		check(B = x"c682f53f");
		check(C = x"203211c9");
		check(D = x"1a0d1b08");
		check(E = x"e0648ccd");

		-- Step 61
		wait until rising_edge(clk);
		check(A = x"ceec2b04");
		check(B = x"193b35bd");
		check(C = x"f1a0bd4f");
		check(D = x"203211c9");
		check(E = x"1a0d1b08");

		-- Step 62
		wait until rising_edge(clk);
		check(A = x"829ed919");
		check(B = x"ceec2b04");
		check(C = x"464ecd6f");
		check(D = x"f1a0bd4f");
		check(E = x"203211c9");

		-- Step 63
		wait until rising_edge(clk);
		check(A = x"377a9914");
		check(B = x"829ed919");
		check(C = x"33bb0ac1");
		check(D = x"464ecd6f");
		check(E = x"f1a0bd4f");

		-- Step 64
		wait until rising_edge(clk);
		check(A = x"dac285b9");
		check(B = x"377a9914");
		check(C = x"60a7b646");
		check(D = x"33bb0ac1");
		check(E = x"464ecd6f");

		-- Step 65
		wait until rising_edge(clk);
		check(A = x"cd6d6c13");
		check(B = x"dac285b9");
		check(C = x"0ddea645");
		check(D = x"60a7b646");
		check(E = x"33bb0ac1");

		-- Step 66
		wait until rising_edge(clk);
		check(A = x"639762aa");
		check(B = x"cd6d6c13");
		check(C = x"76b0a16e");
		check(D = x"0ddea645");
		check(E = x"60a7b646");

		-- Step 67
		wait until rising_edge(clk);
		check(A = x"d3fcdf01");
		check(B = x"639762aa");
		check(C = x"f35b5b04");
		check(D = x"76b0a16e");
		check(E = x"0ddea645");

		-- Step 68
		wait until rising_edge(clk);
		check(A = x"3e5a0cc1");
		check(B = x"d3fcdf01");
		check(C = x"98e5d8aa");
		check(D = x"f35b5b04");
		check(E = x"76b0a16e");

		-- Step 69
		wait until rising_edge(clk);
		check(A = x"c4b7981a");
		check(B = x"3e5a0cc1");
		check(C = x"74ff37c0");
		check(D = x"98e5d8aa");
		check(E = x"f35b5b04");

		-- Step 70
		wait until rising_edge(clk);
		check(A = x"26f94df5");
		check(B = x"c4b7981a");
		check(C = x"4f968330");
		check(D = x"74ff37c0");
		check(E = x"98e5d8aa");

		-- Step 71
		wait until rising_edge(clk);
		check(A = x"42650d26");
		check(B = x"26f94df5");
		check(C = x"b12de606");
		check(D = x"4f968330");
		check(E = x"74ff37c0");

		-- Step 72
		wait until rising_edge(clk);
		check(A = x"9487b5c9");
		check(B = x"42650d26");
		check(C = x"49be537d");
		check(D = x"b12de606");
		check(E = x"4f968330");

		-- Step 73
		wait until rising_edge(clk);
		check(A = x"65e8d295");
		check(B = x"9487b5c9");
		check(C = x"90994349");
		check(D = x"49be537d");
		check(E = x"b12de606");

		-- Step 74
		wait until rising_edge(clk);
		check(A = x"064cc166");
		check(B = x"65e8d295");
		check(C = x"6521ed72");
		check(D = x"90994349");
		check(E = x"49be537d");

		-- Step 75
		wait until rising_edge(clk);
		check(A = x"ce8e1721");
		check(B = x"064cc166");
		check(C = x"597a34a5");
		check(D = x"6521ed72");
		check(E = x"90994349");

		-- Step 76
		wait until rising_edge(clk);
		check(A = x"a6e259d2");
		check(B = x"ce8e1721");
		check(C = x"81933059");
		check(D = x"597a34a5");
		check(E = x"6521ed72");

		-- Step 77
		wait until rising_edge(clk);
		check(A = x"22890379");
		check(B = x"a6e259d2");
		check(C = x"73a385c8");
		check(D = x"81933059");
		check(E = x"597a34a5");

		-- Step 78
		wait until rising_edge(clk);
		check(A = x"0ad7fc73");
		check(B = x"22890379");
		check(C = x"a9b89674");
		check(D = x"73a385c8");
		check(E = x"81933059");

		-- Step 79
		wait until rising_edge(clk);
		check(A = x"1fb2c136");
		check(B = x"0ad7fc73");
		check(C = x"48a240de");
		check(D = x"a9b89674");
		check(E = x"73a385c8");

		-- Check final result
		wait until is_complete = '1';
		check(H0_out = x"86f7e437");
		check(H1_out = x"faa5a7fc");
		check(H2_out = x"e15d1ddc");
		check(H3_out = x"b9eaeaea");
		check(H4_out = x"377667b8");

		test_runner_cleanup(runner);
	end process;

end sha1_test_1_tb_arch;

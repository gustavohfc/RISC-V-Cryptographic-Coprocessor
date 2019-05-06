library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.coprocessor_constants.all;

entity md5 is
	port(
		-- Inputs
		clk                        : in  std_logic;
		start_new_hash             : in  std_logic; -- Reset the state machine to calculate a new hash
		write_data_in              : in  std_logic;
		data_in                    : in  std_logic_vector(31 downto 0);
		data_in_word_position      : in  unsigned(3 downto 0); -- A number between 0 and 15
		calculate_next_chunk       : in  std_logic;
		is_last_chunk              : in  std_logic;
		last_chunk_size            : in  unsigned(9 downto 0); -- A number between 1 and 512
		-- Outputs
		is_idle                    : out std_logic; -- Waiting for a new message
		is_waiting_next_chunk      : out std_logic; -- Waiting for next data of a message which it already started the message digest calculation
		is_busy                    : out std_logic; -- Is busy calculating the padding os message digest of the last chunk
		is_complete                : out std_logic; -- The message digest was calculated successfully
		error                      : out md5_error_type;
		A_out, B_out, C_out, D_out : out std_logic_vector(31 downto 0)
	);
end entity md5;

architecture md5_arch of md5 is

	type state_type is (
		idle,                           -- Waiting the first chunk of data
		waiting_next_chunk,
		padding_last_chunk,
		calculating,
		hash_complete,
		error_occurred
	);
	signal state : state_type := idle;

	constant A0 : word32 := X"67452301";
	constant B0 : word32 := X"efcdab89";
	constant C0 : word32 := X"98badcfe";
	constant D0 : word32 := X"10325476";

	type s_const is array (0 to 63) of unsigned; -- TODO: range 7 downto 0
	constant S : s_const := (
		-- Round 1
		X"07",
		X"0C",
		X"11",
		X"16",
		X"07",
		X"0C",
		X"11",
		X"16",
		X"07",
		X"0C",
		X"11",
		X"16",
		X"07",
		X"0C",
		X"11",
		X"16",
		-- Round 2
		X"05",
		X"09",
		X"0E",
		X"14",
		X"05",
		X"09",
		X"0E",
		X"14",
		X"05",
		X"09",
		X"0E",
		X"14",
		X"05",
		X"09",
		X"0E",
		X"14",
		-- Round 3
		X"04",
		X"0B",
		X"10",
		X"17",
		X"04",
		X"0B",
		X"10",
		X"17",
		X"04",
		X"0B",
		X"10",
		X"17",
		X"04",
		X"0B",
		X"10",
		X"17",
		-- Round 4
		X"06",
		X"0A",
		X"0F",
		X"15",
		X"06",
		X"0A",
		X"0F",
		X"15",
		X"06",
		X"0A",
		X"0F",
		X"15",
		X"06",
		X"0A",
		X"0F",
		X"15"
	);

	type t_const is array (0 to 63) of unsigned; -- TODO: range 31 downto 0
	constant T : t_const := (
		-- Round 1
		X"d76aa478",
		X"e8c7b756",
		X"242070db",
		X"c1bdceee",
		X"f57c0faf",
		X"4787c62a",
		X"a8304613",
		X"fd469501",
		X"698098d8",
		X"8b44f7af",
		X"ffff5bb1",
		X"895cd7be",
		X"6b901122",
		X"fd987193",
		X"a679438e",
		X"49b40821",
		-- Round 2
		X"f61e2562",
		X"c040b340",
		X"265e5a51",
		X"e9b6c7aa",
		X"d62f105d",
		X"02441453",
		X"d8a1e681",
		X"e7d3fbc8",
		X"21e1cde6",
		X"c33707d6",
		X"f4d50d87",
		X"455a14ed",
		X"a9e3e905",
		X"fcefa3f8",
		X"676f02d9",
		X"8d2a4c8a",
		-- Round 3
		X"fffa3942",
		X"8771f681",
		X"6d9d6122",
		X"fde5380c",
		X"a4beea44",
		X"4bdecfa9",
		X"f6bb4b60",
		X"bebfbc70",
		X"289b7ec6",
		X"eaa127fa",
		X"d4ef3085",
		X"04881d05",
		X"d9d4d039",
		X"e6db99e5",
		X"1fa27cf8",
		X"c4ac5665",
		-- Round 4
		X"f4292244",
		X"432aff97",
		X"ab9423a7",
		X"fc93a039",
		X"655b59c3",
		X"8f0ccc92",
		X"ffeff47d",
		X"85845dd1",
		X"6fa87e4f",
		X"fe2ce6e0",
		X"a3014314",
		X"4e0811a1",
		X"f7537e82",
		X"bd3af235",
		X"2ad7d2bb",
		X"eb86d391"
	);

	type k_const is array (0 to 63) of natural; -- TODO: range 4 downto 0
	constant K : k_const := (
		-- Round 1
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		-- Round 2
		1,
		6,
		11,
		0,
		5,
		10,
		15,
		4,
		9,
		14,
		3,
		8,
		13,
		2,
		7,
		12,
		-- Round 3
		5,
		8,
		11,
		14,
		1,
		4,
		7,
		10,
		13,
		0,
		3,
		6,
		9,
		12,
		15,
		2,
		-- Round 4
		0,
		7,
		14,
		5,
		12,
		3,
		10,
		1,
		8,
		15,
		6,
		13,
		4,
		11,
		2,
		9
	);

	-- Functions
	function left_circular_shift(x : in word32; s : in unsigned) return word32 is
	begin
		-- TODO: Change shift_left to sll
		return std_logic_vector(shift_left(unsigned(x), to_integer(unsigned(s)))) or std_logic_vector(shift_right(unsigned(x), to_integer(32 - unsigned(s))));
	end function left_circular_shift;

	function swap_byte_endianness(x : in word32) return word32 is
	begin
		return x(7 downto 0) & x(15 downto 8) & x(23 downto 16) & x(31 downto 24);
	end function swap_byte_endianness;

	-- Step of the calculation, TODO: 0 to 63
	signal current_step : natural := 0;

	-- Message digest buffer
	signal A : word32 := A0;
	signal B : word32 := B0;
	signal C : word32 := C0;
	signal D : word32 := D0;

	-- Buffer for the 512 bit input
	signal input_buffer : std_logic_vector(0 to 511) := (others => '0');

	signal message_size : unsigned(64 downto 0) := (others => '0');
	
	signal last_chunk_size_internal : unsigned(9 downto 0); -- A number between 1 and 512

begin

	-- Outputs
	A_out <= A;
	B_out <= B;
	C_out <= C;
	D_out <= D;

	is_idle               <= '1' when state = idle else '0';
	is_waiting_next_chunk <= '1' when state = waiting_next_chunk else '0';
	is_busy               <= '1' when state = padding_last_chunk or state = calculating else '0';
	is_complete           <= '1' when state = hash_complete else '0';

	fsm : process(clk, start_new_hash)
		variable input_first_bit : natural; -- TODO: range 0 to 480
		variable X_k, f_result   : unsigned(31 downto 0);
		variable X_k_first_bit   : natural; -- TODO: range 31 downto 0
	begin
		if start_new_hash = '1' then
			state        <= idle;
			current_step <= 0;
			error        <= MD5_ERROR_NONE;

			-- Set default messsage digest buffer
			A <= A0;
			B <= B0;
			C <= C0;
			D <= D0;

			-- Reset the iput buffer
			input_buffer <= (others => '0');

		elsif rising_edge(clk) then

			-- Validate inputs
			if write_data_in = '1' and not (state = waiting_next_chunk or state = idle) then
				state <= error_occurred;
				error <= MD5_ERROR_UNEXPECTED_NEW_DATA;
			end if;

			case state is
				when idle | waiting_next_chunk => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if write_data_in = '1' then
						-- Write new data
						input_first_bit                                       := to_integer(data_in_word_position & "00000"); -- 5 left shifts = *32
						input_buffer(input_first_bit to input_first_bit + 31) <= data_in;
					end if;

					-- Calculate next state
					if calculate_next_chunk = '1' then
						if is_last_chunk = '0' then
							state <= calculating;
						else
							state <= padding_last_chunk;
							last_chunk_size_internal <= last_chunk_size;
						end if;
					end if;

				when padding_last_chunk => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					input_buffer(to_integer(last_chunk_size_internal)) <= '1';
					input_buffer(to_integer(last_chunk_size_internal + 1) to 511) <= (others => '0');
					
					state <= calculating;

				when calculating => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					X_k_first_bit := K(current_step) * 32; -- TODO: change to shift
					X_k           := unsigned(swap_byte_endianness(input_buffer(X_k_first_bit to X_k_first_bit + 31)));

					if current_step < 16 then
						f_result := unsigned((B and C) or (not B and D));
					elsif current_step < 32 then
						f_result := unsigned((B and D) or (B and not D));
					elsif current_step < 48 then
						f_result := unsigned(B xor C xor D);
					else
						f_result := unsigned(C xor (B or not D));
					end if;

					A    <= D;
					B    <= std_logic_vector(unsigned(B) + unsigned(left_circular_shift(std_logic_vector(unsigned(a) + f_result + X_k + T(current_step)), s(current_step))));
					C    <= B;
					D    <= C;
					current_step <= current_step + 1;
					
					if current_step = 63 then
						state <= hash_complete;
					else
						state <= calculating;
					end if;

				when hash_complete => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					state <= hash_complete;

				when error_occurred => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					state <= error_occurred;

				when others =>
					null;

			end case;

		end if;
	end process;

end architecture md5_arch;

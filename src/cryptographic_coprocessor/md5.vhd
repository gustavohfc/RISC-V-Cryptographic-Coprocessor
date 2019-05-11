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
		write_data_in              : in  std_logic; -- Write the data_in to the buffer position indicated by data_in_word_position
		data_in                    : in  unsigned(31 downto 0); -- Data to be written to the input buffer
		data_in_word_position      : in  unsigned(3 downto 0); -- A number between 0 and 15 corresponding to the word position of data_in
		calculate_next_block       : in  std_logic; -- Start the calculation of the next block
		is_last_block              : in  std_logic; -- Indicates whether this block is the last
		last_block_size            : in  unsigned(9 downto 0); -- The size of the last block, should be between 1 and 512
		-- Outputs
		is_waiting_next_block      : out std_logic;
		is_busy                    : out std_logic; -- Is busy calculating the hash
		is_complete                : out std_logic; -- The message digest was calculated successfully
		error                      : out md5_error_type; -- Indicates if a error has occurred
		A_out, B_out, C_out, D_out : out unsigned(31 downto 0) -- The message digest result
	);
end entity md5;

architecture md5_arch of md5 is

	type state_type is (
		waiting_next_block,
		padding_last_block,
		preparing_additional_block,     -- When the padding doesn't fit on the last block it's needed to add a additional block
		pre_calculation,
		calculating,
		post_calculation,
		hash_complete,                  -- The message digest was calculated successfully
		error_occurred
	);
	signal state : state_type := waiting_next_block;

	constant A0 : unsigned(31 downto 0) := X"67452301";
	constant B0 : unsigned(31 downto 0) := X"efcdab89";
	constant C0 : unsigned(31 downto 0) := X"98badcfe";
	constant D0 : unsigned(31 downto 0) := X"10325476";

	type s_const is array (0 to 63) of unsigned(7 downto 0);
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

	type t_const is array (0 to 63) of unsigned(31 downto 0);
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

	type k_const is array (0 to 63) of unsigned;
	constant K : k_const := (
		-- Round 1
		X"0",
		X"1",
		X"2",
		X"3",
		X"4",
		X"5",
		X"6",
		X"7",
		X"8",
		X"9",
		X"a",
		X"b",
		X"c",
		X"d",
		X"e",
		X"f",
		-- Round 2
		X"1",
		X"6",
		X"b",
		X"0",
		X"5",
		X"a",
		X"f",
		X"4",
		X"9",
		X"e",
		X"3",
		X"8",
		X"d",
		X"2",
		X"7",
		X"c",
		-- Round 3
		X"5",
		X"8",
		X"b",
		X"e",
		X"1",
		X"4",
		X"7",
		X"a",
		X"d",
		X"0",
		X"3",
		X"6",
		X"9",
		X"c",
		X"f",
		X"2",
		-- Round 4
		X"0",
		X"7",
		X"e",
		X"5",
		X"c",
		X"3",
		X"a",
		X"1",
		X"8",
		X"f",
		X"6",
		X"d",
		X"4",
		X"b",
		X"2",
		X"9"
	);

	-- Functions
	function left_circular_shift(x : in unsigned(31 downto 0); s : in unsigned(7 downto 0)) return unsigned is
	begin
		return shift_left(x, to_integer(s)) or shift_right(x, to_integer(32 - s));
	end function left_circular_shift;

	function swap_byte_endianness(x : in unsigned(31 downto 0)) return unsigned is
	begin
		return x(7 downto 0) & x(15 downto 8) & x(23 downto 16) & x(31 downto 24);
	end function swap_byte_endianness;

	signal current_step : natural range 0 to 63 := 0;

	-- Message digest buffer
	signal A              : unsigned(31 downto 0) := A0;
	signal B              : unsigned(31 downto 0) := B0;
	signal C              : unsigned(31 downto 0) := C0;
	signal D              : unsigned(31 downto 0) := D0;
	signal AA, BB, CC, DD : unsigned(31 downto 0) := (others => '0');

	-- Buffer for the 512 bit input
	signal input_buffer : unsigned(0 to 511) := (others => '0');

	signal message_size : unsigned(63 downto 0) := (others => '0');

	signal last_block_size_internal : unsigned(9 downto 0) := (others => '0');

	signal is_last_block_internal : std_logic := '0';

	signal additional_block_needed : std_logic := '0';

	signal padding_bit_1_on_additional_block : std_logic := '0';

begin

	-- Outputs
	A_out <= A;
	B_out <= B;
	C_out <= C;
	D_out <= D;

	is_waiting_next_block <= '1' when state = waiting_next_block else '0';
	is_busy               <= '1' when state = preparing_additional_block or state = padding_last_block or state = pre_calculation or state = calculating or state = post_calculation else '0';
	is_complete           <= '1' when state = hash_complete else '0';

	fsm : process(clk, start_new_hash)
		variable input_first_bit, X_k_first_bit : natural range 0 to 480;
		variable X_k, f_result                  : unsigned(31 downto 0);
		variable temp_A, temp_B, temp_C, temp_D : unsigned(31 downto 0);
	begin
		if start_new_hash = '1' then
			state        <= waiting_next_block;
			current_step <= 0;
			error        <= MD5_ERROR_NONE;

			-- Set default messsage digest buffer
			A <= A0;
			B <= B0;
			C <= C0;
			D <= D0;

			-- Reset the iput buffer
			input_buffer <= (others => '0');

			is_last_block_internal            <= '0';
			additional_block_needed           <= '0';
			padding_bit_1_on_additional_block <= '0';
			message_size                      <= (others => '0');

		elsif rising_edge(clk) then

			-- Validate inputs
			if write_data_in = '1' and not (state = waiting_next_block) then
				state <= error_occurred;
				error <= MD5_ERROR_UNEXPECTED_NEW_DATA;
			end if;

			case state is
				when waiting_next_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if write_data_in = '1' then
						-- Write new data
						input_first_bit                                       := to_integer(data_in_word_position & "00000"); -- * 32
						input_buffer(input_first_bit to input_first_bit + 31) <= data_in;
					end if;

					-- Calculate next state
					if calculate_next_block = '1' then
						if is_last_block = '0' then
							message_size <= message_size + 512;
							state        <= pre_calculation;
						else
							message_size             <= message_size + last_block_size;
							last_block_size_internal <= last_block_size;
							is_last_block_internal   <= '1';
							state                    <= padding_last_block;
						end if;
					end if;

				when padding_last_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if last_block_size_internal < 447 then
						input_buffer(to_integer(last_block_size_internal))            <= '1';
						input_buffer(to_integer(last_block_size_internal + 1) to 447) <= (others => '0');
						input_buffer(448 to 479)                                      <= swap_byte_endianness(message_size(31 downto 0));
						input_buffer(480 to 511)                                      <= swap_byte_endianness(message_size(63 downto 32));
						additional_block_needed                                       <= '0';
						padding_bit_1_on_additional_block                             <= '0';
						state                                                         <= pre_calculation;
					elsif last_block_size_internal < 511 then
						input_buffer(to_integer(last_block_size_internal))            <= '1';
						input_buffer(to_integer(last_block_size_internal + 1) to 511) <= (others => '0');
						additional_block_needed                                       <= '1';
						padding_bit_1_on_additional_block                             <= '0';
						state                                                         <= pre_calculation;
					elsif last_block_size_internal = 511 then
						input_buffer(511)                 <= '1';
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '0';
						state                             <= pre_calculation;
					elsif last_block_size_internal = 512 then
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '1';
						state                             <= pre_calculation;
					else
						state <= error_occurred;
						error <= MD5_ERROR_INVALID_LAST_BLOCK_SIZE;
					end if;

				when preparing_additional_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					input_buffer(0)          <= padding_bit_1_on_additional_block;
					input_buffer(1 to 447)   <= (others => '0');
					input_buffer(448 to 479) <= swap_byte_endianness(message_size(31 downto 0));
					input_buffer(480 to 511) <= swap_byte_endianness(message_size(63 downto 32));

					additional_block_needed <= '0';

					state <= pre_calculation;

				when pre_calculation => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					AA <= A;
					BB <= B;
					CC <= C;
					DD <= D;
					
					state <= calculating;

				when calculating =>     ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					X_k_first_bit := to_integer(K(current_step) & "00000"); -- * 32
					X_k           := swap_byte_endianness(input_buffer(X_k_first_bit to X_k_first_bit + 31));

					if current_step < 16 then
						f_result := (B and C) or (not B and D);
					elsif current_step < 32 then
						f_result := (B and D) or (C and not D);
					elsif current_step < 48 then
						f_result := B xor C xor D;
					else
						f_result := C xor (B or not D);
					end if;

					A <= D;
					B <= B + left_circular_shift(a + f_result + X_k + T(current_step), s(current_step));
					C <= B;
					D <= C;

					if current_step = 63 then
						current_step <= 0;
						state        <= post_calculation;
					else
						current_step <= current_step + 1;
						state        <= calculating;
					end if;

				when post_calculation => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					temp_A := A + AA;
					temp_B := B + BB;
					temp_C := C + CC;
					temp_D := D + DD;

					if is_last_block_internal = '1' then
						if additional_block_needed = '1' then
							A     <= temp_A;
							B     <= temp_B;
							C     <= temp_C;
							D     <= temp_D;
							state <= preparing_additional_block;
						else
							A     <= swap_byte_endianness(temp_A);
							B     <= swap_byte_endianness(temp_B);
							C     <= swap_byte_endianness(temp_C);
							D     <= swap_byte_endianness(temp_D);
							state <= hash_complete;
						end if;
					else
						A     <= temp_A;
						B     <= temp_B;
						C     <= temp_C;
						D     <= temp_D;
						state <= waiting_next_block;
					end if;

				when hash_complete =>   ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					state <= hash_complete;

				when error_occurred =>  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					state <= error_occurred;

				when others =>
					null;

			end case;

		end if;
	end process;

end architecture md5_arch;

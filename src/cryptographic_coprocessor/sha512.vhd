library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

entity sha512 is
	port(
		-- Inputs
		clk                            : in  std_logic;
		start_new_hash                 : in  std_logic; -- Reset the state machine to calculate a new hash
		write_data_in                  : in  std_logic; -- Write the data_in to the buffer position indicated by data_in_word_position
		data_in                        : in  unsigned(31 downto 0); -- Data to be written to the input buffer
		data_in_word_position          : in  unsigned(4 downto 0); -- A number between 0 and 31 corresponding to the word position of data_in
		calculate_next_block           : in  std_logic; -- Start the calculation of the next block
		is_last_block                  : in  std_logic; -- Indicates whether this block is the last
		last_block_size                : in  unsigned(10 downto 0); -- The size of the last block, should be between 1 and 1024
		-- Outputs
		is_waiting_next_block          : out std_logic;
		is_busy                        : out std_logic; -- Is busy calculating the hash
		is_complete                    : out std_logic; -- The message digest was calculated successfully
		error                          : out sha512_error_type; -- Indicates if a error has occurred
		H0_out, H1_out, H2_out, H3_out : out unsigned(63 downto 0); -- The message digest result
		H4_out, H5_out, H6_out, H7_out : out unsigned(63 downto 0) -- The message digest result
	);
end entity sha512;

architecture sha512_arch of sha512 is

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

	constant H0_initial : unsigned(63 downto 0) := X"6a09e667f3bcc908";
	constant H1_initial : unsigned(63 downto 0) := X"bb67ae8584caa73b";
	constant H2_initial : unsigned(63 downto 0) := X"3c6ef372fe94f82b";
	constant H3_initial : unsigned(63 downto 0) := X"a54ff53a5f1d36f1";
	constant H4_initial : unsigned(63 downto 0) := X"510e527fade682d1";
	constant H5_initial : unsigned(63 downto 0) := X"9b05688c2b3e6c1f";
	constant H6_initial : unsigned(63 downto 0) := X"1f83d9abfb41bd6b";
	constant H7_initial : unsigned(63 downto 0) := X"5be0cd19137e2179";

	-- Functions
	function right_circular_shift(x : in unsigned(63 downto 0); s : in unsigned(7 downto 0)) return unsigned is
	begin
		return shift_right(x, to_integer(s)) or shift_left(x, to_integer(64 - s));
	end function right_circular_shift;

	function CH(x : in unsigned(63 downto 0); y : in unsigned(63 downto 0); z : in unsigned(63 downto 0)) return unsigned is
	begin
		return (x and y) xor (not x and z);
	end function CH;

	function MAJ(x : in unsigned(63 downto 0); y : in unsigned(63 downto 0); z : in unsigned(63 downto 0)) return unsigned is
	begin
		return (x and y) xor (x and z) xor (y and z);
	end function MAJ;

	function BSIG0(x : in unsigned(63 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"1C") xor right_circular_shift(x, x"22") xor right_circular_shift(x, x"27");
	end function BSIG0;

	function BSIG1(x : in unsigned(63 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"0E") xor right_circular_shift(x, x"12") xor right_circular_shift(x, x"29");
	end function BSIG1;

	function SSIG0(x : in unsigned(63 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"01") xor right_circular_shift(x, x"08") xor shift_right(x, 7);
	end function SSIG0;

	function SSIG1(x : in unsigned(63 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"13") xor right_circular_shift(x, x"3D") xor shift_right(x, 6);
	end function SSIG1;

	signal current_step : natural range 0 to 79 := 0;

	type k_const is array (0 to 79) of unsigned;
	constant K : k_const := (
		X"428a2f98d728ae22",
		X"7137449123ef65cd",
		X"b5c0fbcfec4d3b2f",
		X"e9b5dba58189dbbc",
		X"3956c25bf348b538",
		X"59f111f1b605d019",
		X"923f82a4af194f9b",
		X"ab1c5ed5da6d8118",
		X"d807aa98a3030242",
		X"12835b0145706fbe",
		X"243185be4ee4b28c",
		X"550c7dc3d5ffb4e2",
		X"72be5d74f27b896f",
		X"80deb1fe3b1696b1",
		X"9bdc06a725c71235",
		X"c19bf174cf692694",
		X"e49b69c19ef14ad2",
		X"efbe4786384f25e3",
		X"0fc19dc68b8cd5b5",
		X"240ca1cc77ac9c65",
		X"2de92c6f592b0275",
		X"4a7484aa6ea6e483",
		X"5cb0a9dcbd41fbd4",
		X"76f988da831153b5",
		X"983e5152ee66dfab",
		X"a831c66d2db43210",
		X"b00327c898fb213f",
		X"bf597fc7beef0ee4",
		X"c6e00bf33da88fc2",
		X"d5a79147930aa725",
		X"06ca6351e003826f",
		X"142929670a0e6e70",
		X"27b70a8546d22ffc",
		X"2e1b21385c26c926",
		X"4d2c6dfc5ac42aed",
		X"53380d139d95b3df",
		X"650a73548baf63de",
		X"766a0abb3c77b2a8",
		X"81c2c92e47edaee6",
		X"92722c851482353b",
		X"a2bfe8a14cf10364",
		X"a81a664bbc423001",
		X"c24b8b70d0f89791",
		X"c76c51a30654be30",
		X"d192e819d6ef5218",
		X"d69906245565a910",
		X"f40e35855771202a",
		X"106aa07032bbd1b8",
		X"19a4c116b8d2d0c8",
		X"1e376c085141ab53",
		X"2748774cdf8eeb99",
		X"34b0bcb5e19b48a8",
		X"391c0cb3c5c95a63",
		X"4ed8aa4ae3418acb",
		X"5b9cca4f7763e373",
		X"682e6ff3d6b2b8a3",
		X"748f82ee5defb2fc",
		X"78a5636f43172f60",
		X"84c87814a1f0ab72",
		X"8cc702081a6439ec",
		X"90befffa23631e28",
		X"a4506cebde82bde9",
		X"bef9a3f7b2c67915",
		X"c67178f2e372532b",
		X"ca273eceea26619c",
		X"d186b8c721c0c207",
		X"eada7dd6cde0eb1e",
		X"f57d4f7fee6ed178",
		X"06f067aa72176fba",
		X"0a637dc5a2c898a6",
		X"113f9804bef90dae",
		X"1b710b35131c471b",
		X"28db77f523047d84",
		X"32caab7b40c72493",
		X"3c9ebe0a15c9bebc",
		X"431d67c49c100d4c",
		X"4cc5d4becb3e42b6",
		X"597f299cfc657e2a",
		X"5fcb6fab3ad6faec",
		X"6c44198c4a475817"
	);

	-- Message digest buffer
	signal H0                     : unsigned(63 downto 0) := H0_initial;
	signal H1                     : unsigned(63 downto 0) := H1_initial;
	signal H2                     : unsigned(63 downto 0) := H2_initial;
	signal H3                     : unsigned(63 downto 0) := H3_initial;
	signal H4                     : unsigned(63 downto 0) := H4_initial;
	signal H5                     : unsigned(63 downto 0) := H5_initial;
	signal H6                     : unsigned(63 downto 0) := H6_initial;
	signal H7                     : unsigned(63 downto 0) := H7_initial;
	signal A, B, C, D, E, F, G, H : unsigned(63 downto 0) := (others => '0');

	-- Message buffer, the first 1024 bits are from the original message and the others 4096 are used to store
	-- data during the calculation
	signal message_buffer : unsigned(0 to 5119) := (others => '0');

	signal message_size : unsigned(127 downto 0) := (others => '0');

	signal last_block_size_internal : unsigned(10 downto 0) := (others => '0');

	signal is_last_block_internal : std_logic := '0';

	signal additional_block_needed : std_logic := '0';

	signal padding_bit_1_on_additional_block : std_logic := '0';

begin

	-- Outputs
	H0_out <= H0;
	H1_out <= H1;
	H2_out <= H2;
	H3_out <= H3;
	H4_out <= H4;
	H5_out <= H5;
	H6_out <= H6;
	H7_out <= H7;

	is_waiting_next_block <= '1' when state = waiting_next_block else '0';
	is_busy               <= '1' when state = preparing_additional_block or state = padding_last_block or state = pre_calculation or state = calculating or state = post_calculation else '0';
	is_complete           <= '1' when state = hash_complete else '0';

	fsm : process(clk, start_new_hash)
		variable input_first_bit : natural range 0 to 960;
		variable W_t_first_bit   : natural range 0 to 5056;
		variable W_t, T1         : unsigned(63 downto 0);
	begin
		if start_new_hash = '1' then
			state        <= waiting_next_block;
			current_step <= 0;
			error        <= SHA512_ERROR_NONE;

			-- Set default messsage digest buffer
			H0 <= H0_initial;
			H1 <= H1_initial;
			H2 <= H2_initial;
			H3 <= H3_initial;
			H4 <= H4_initial;
			H5 <= H5_initial;
			H6 <= H6_initial;
			H7 <= H7_initial;

			-- Reset the iput buffer
			message_buffer <= (others => '0');

			is_last_block_internal            <= '0';
			additional_block_needed           <= '0';
			padding_bit_1_on_additional_block <= '0';
			message_size                      <= (others => '0');

		elsif rising_edge(clk) then

			-- Validate inputs
			if write_data_in = '1' and not (state = waiting_next_block) then
				state <= error_occurred;
				error <= SHA512_ERROR_UNEXPECTED_NEW_DATA;
			end if;

			case state is
				when waiting_next_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if write_data_in = '1' then
						-- Write new data
						input_first_bit                                         := to_integer(data_in_word_position & "00000"); -- * 31
						message_buffer(input_first_bit to input_first_bit + 31) <= data_in;
					end if;

					if calculate_next_block = '1' then
						if is_last_block = '0' then
							message_size <= message_size + 1024;
							state        <= pre_calculation;
						else
							message_size             <= message_size + last_block_size;
							last_block_size_internal <= last_block_size;
							is_last_block_internal   <= '1';
							state                    <= padding_last_block;
						end if;
					end if;

				when padding_last_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if last_block_size_internal < 895 then
						message_buffer(to_integer(last_block_size_internal))            <= '1';
						message_buffer(to_integer(last_block_size_internal + 1) to 895) <= (others => '0');
						message_buffer(896 to 1023)                                     <= message_size;
						additional_block_needed                                         <= '0';
						padding_bit_1_on_additional_block                               <= '0';
						state                                                           <= pre_calculation;
					elsif last_block_size_internal < 1023 then
						message_buffer(to_integer(last_block_size_internal))             <= '1';
						message_buffer(to_integer(last_block_size_internal + 1) to 1023) <= (others => '0');
						additional_block_needed                                          <= '1';
						padding_bit_1_on_additional_block                                <= '0';
						state                                                            <= pre_calculation;
					elsif last_block_size_internal = 1023 then
						message_buffer(1023)              <= '1';
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '0';
						state                             <= pre_calculation;
					elsif last_block_size_internal = 1024 then
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '1';
						state                             <= pre_calculation;
					else
						state <= error_occurred;
						error <= SHA512_ERROR_INVALID_LAST_BLOCK_SIZE;
					end if;

				when preparing_additional_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					message_buffer(0)           <= padding_bit_1_on_additional_block;
					message_buffer(1 to 895)    <= (others => '0');
					message_buffer(896 to 1023) <= message_size;

					additional_block_needed <= '0';

					state <= pre_calculation;

				when pre_calculation => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					A <= H0;
					B <= H1;
					C <= H2;
					D <= H3;
					E <= H4;
					F <= H5;
					G <= H6;
					H <= H7;

					state <= calculating;

				when calculating =>     ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					W_t_first_bit := current_step * 64;

					if current_step < 16 then
						W_t := message_buffer(W_t_first_bit to W_t_first_bit + 63);
					else
						W_t                                                 := SSIG1(message_buffer(W_t_first_bit - 128 to W_t_first_bit - 65)) + message_buffer(W_t_first_bit - 448 to W_t_first_bit - 385) + SSIG0(message_buffer(W_t_first_bit - 960 to W_t_first_bit - 897)) + message_buffer(W_t_first_bit - 1024 to W_t_first_bit - 961);
						message_buffer(W_t_first_bit to W_t_first_bit + 63) <= W_t;
					end if;

					T1 := H + BSIG1(E) + CH(E, F, G) + K(current_step) + W_t;

					A <= T1 + BSIG0(A) + MAJ(A, B, C);
					B <= A;
					C <= B;
					D <= C;
					E <= D + T1;
					F <= E;
					G <= F;
					H <= G;

					if current_step = 79 then
						current_step <= 0;
						state        <= post_calculation;
					else
						current_step <= current_step + 1;
						state        <= calculating;
					end if;

				when post_calculation => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					H0 <= H0 + A;
					H1 <= H1 + B;
					H2 <= H2 + C;
					H3 <= H3 + D;
					H4 <= H4 + E;
					H5 <= H5 + F;
					H6 <= H6 + G;
					H7 <= H7 + H;

					if is_last_block_internal = '1' then
						if additional_block_needed = '1' then
							state <= preparing_additional_block;
						else
							state <= hash_complete;
						end if;
					else
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

end architecture sha512_arch;

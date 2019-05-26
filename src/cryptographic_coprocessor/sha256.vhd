library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

entity sha256 is
	port(
		-- Inputs
		clk                            : in  std_logic;
		start_new_hash                 : in  std_logic; -- Reset the state machine to calculate a new hash
		write_data_in                  : in  std_logic; -- Write the data_in to the buffer position indicated by data_in_word_position
		data_in                        : in  unsigned(31 downto 0); -- Data to be written to the input buffer
		data_in_word_position          : in  unsigned(3 downto 0); -- A number between 0 and 15 corresponding to the word position of data_in
		calculate_next_block           : in  std_logic; -- Start the calculation of the next block
		is_last_block                  : in  std_logic; -- Indicates whether this block is the last
		last_block_size                : in  unsigned(9 downto 0); -- The size of the last block, should be between 1 and 512
		-- Outputs
		is_waiting_next_block          : out std_logic;
		is_busy                        : out std_logic; -- Is busy calculating the hash
		is_complete                    : out std_logic; -- The message digest was calculated successfully
		error                          : out sha256_error_type; -- Indicates if a error has occurred
		H0_out, H1_out, H2_out, H3_out : out unsigned(31 downto 0); -- The message digest result
		H4_out, H5_out, H6_out, H7_out : out unsigned(31 downto 0) -- The message digest result
	);
end entity sha256;

architecture sha256_arch of sha256 is

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

	constant H0_initial : unsigned(31 downto 0) := X"6a09e667";
	constant H1_initial : unsigned(31 downto 0) := X"bb67ae85";
	constant H2_initial : unsigned(31 downto 0) := X"3c6ef372";
	constant H3_initial : unsigned(31 downto 0) := X"a54ff53a";
	constant H4_initial : unsigned(31 downto 0) := X"510e527f";
	constant H5_initial : unsigned(31 downto 0) := X"9b05688c";
	constant H6_initial : unsigned(31 downto 0) := X"1f83d9ab";
	constant H7_initial : unsigned(31 downto 0) := X"5be0cd19";

	-- Functions
	function right_circular_shift(x : in unsigned(31 downto 0); s : in unsigned(7 downto 0)) return unsigned is
	begin
		return shift_right(x, to_integer(s)) or shift_left(x, to_integer(32 - s));
	end function right_circular_shift;

	function CH(x : in unsigned(31 downto 0); y : in unsigned(31 downto 0); z : in unsigned(31 downto 0)) return unsigned is
	begin
		return (x and y) xor (not x and z);
	end function CH;

	function MAJ(x : in unsigned(31 downto 0); y : in unsigned(31 downto 0); z : in unsigned(31 downto 0)) return unsigned is
	begin
		return (x and y) xor (x and z) xor (y and z);
	end function MAJ;

	function BSIG0(x : in unsigned(31 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"02") xor right_circular_shift(x, x"0D") xor right_circular_shift(x, x"16");
	end function BSIG0;

	function BSIG1(x : in unsigned(31 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"06") xor right_circular_shift(x, x"0B") xor right_circular_shift(x, x"19");
	end function BSIG1;

	function SSIG0(x : in unsigned(31 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"07") xor right_circular_shift(x, x"12") xor shift_right(x, 3);
	end function SSIG0;

	function SSIG1(x : in unsigned(31 downto 0)) return unsigned is
	begin
		return right_circular_shift(x, x"11") xor right_circular_shift(x, x"13") xor shift_right(x, 10);
	end function SSIG1;

	signal current_step : natural range 0 to 63 := 0;

	type k_const is array (0 to 63) of unsigned;
	constant K : k_const := (
		X"428a2f98",
		X"71374491",
		X"b5c0fbcf",
		X"e9b5dba5",
		X"3956c25b",
		X"59f111f1",
		X"923f82a4",
		X"ab1c5ed5",
		X"d807aa98",
		X"12835b01",
		X"243185be",
		X"550c7dc3",
		X"72be5d74",
		X"80deb1fe",
		X"9bdc06a7",
		X"c19bf174",
		X"e49b69c1",
		X"efbe4786",
		X"0fc19dc6",
		X"240ca1cc",
		X"2de92c6f",
		X"4a7484aa",
		X"5cb0a9dc",
		X"76f988da",
		X"983e5152",
		X"a831c66d",
		X"b00327c8",
		X"bf597fc7",
		X"c6e00bf3",
		X"d5a79147",
		X"06ca6351",
		X"14292967",
		X"27b70a85",
		X"2e1b2138",
		X"4d2c6dfc",
		X"53380d13",
		X"650a7354",
		X"766a0abb",
		X"81c2c92e",
		X"92722c85",
		X"a2bfe8a1",
		X"a81a664b",
		X"c24b8b70",
		X"c76c51a3",
		X"d192e819",
		X"d6990624",
		X"f40e3585",
		X"106aa070",
		X"19a4c116",
		X"1e376c08",
		X"2748774c",
		X"34b0bcb5",
		X"391c0cb3",
		X"4ed8aa4a",
		X"5b9cca4f",
		X"682e6ff3",
		X"748f82ee",
		X"78a5636f",
		X"84c87814",
		X"8cc70208",
		X"90befffa",
		X"a4506ceb",
		X"bef9a3f7",
		X"c67178f2"
	);

	-- Message digest buffer
	signal H0                     : unsigned(31 downto 0) := H0_initial;
	signal H1                     : unsigned(31 downto 0) := H1_initial;
	signal H2                     : unsigned(31 downto 0) := H2_initial;
	signal H3                     : unsigned(31 downto 0) := H3_initial;
	signal H4                     : unsigned(31 downto 0) := H4_initial;
	signal H5                     : unsigned(31 downto 0) := H5_initial;
	signal H6                     : unsigned(31 downto 0) := H6_initial;
	signal H7                     : unsigned(31 downto 0) := H7_initial;
	signal A, B, C, D, E, F, G, H : unsigned(31 downto 0) := (others => '0');

	-- Message buffer, the first 512 bits are from the original message and the others 1536 are used to store
	-- data during the calculation
	signal message_buffer : unsigned(0 to 2048) := (others => '0');

	signal message_size : unsigned(63 downto 0) := (others => '0');

	signal last_block_size_internal : unsigned(9 downto 0) := (others => '0');

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
		variable input_first_bit    : natural range 0 to 480;
		variable W_t_first_bit      : natural range 0 to 2528; -- TODO: to 2016?
		variable W_t, K_t, T1 : unsigned(31 downto 0);
	begin
		if start_new_hash = '1' then
			state        <= waiting_next_block;
			current_step <= 0;
			error        <= SHA256_ERROR_NONE;

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
				error <= SHA256_ERROR_UNEXPECTED_NEW_DATA;
			end if;

			case state is
				when waiting_next_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if write_data_in = '1' then
						-- Write new data
						input_first_bit                                         := to_integer(data_in_word_position & "00000"); -- * 32
						message_buffer(input_first_bit to input_first_bit + 31) <= data_in;
					end if;

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
						message_buffer(to_integer(last_block_size_internal))            <= '1';
						message_buffer(to_integer(last_block_size_internal + 1) to 447) <= (others => '0');
						message_buffer(448 to 511)                                      <= message_size;
						additional_block_needed                                         <= '0';
						padding_bit_1_on_additional_block                               <= '0';
						state                                                           <= pre_calculation;
					elsif last_block_size_internal < 511 then
						message_buffer(to_integer(last_block_size_internal))            <= '1';
						message_buffer(to_integer(last_block_size_internal + 1) to 511) <= (others => '0');
						additional_block_needed                                         <= '1';
						padding_bit_1_on_additional_block                               <= '0';
						state                                                           <= pre_calculation;
					elsif last_block_size_internal = 511 then
						message_buffer(511)               <= '1';
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '0';
						state                             <= pre_calculation;
					elsif last_block_size_internal = 512 then
						additional_block_needed           <= '1';
						padding_bit_1_on_additional_block <= '1';
						state                             <= pre_calculation;
					else
						state <= error_occurred;
						error <= SHA256_ERROR_INVALID_LAST_BLOCK_SIZE;
					end if;

				when preparing_additional_block => ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					message_buffer(0)          <= padding_bit_1_on_additional_block;
					message_buffer(1 to 447)   <= (others => '0');
					message_buffer(448 to 511) <= message_size;

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
					W_t_first_bit := current_step * 32;

					if current_step < 16 then
						W_t := message_buffer(W_t_first_bit to W_t_first_bit + 31);
					else
						W_t := SSIG1(message_buffer(W_t_first_bit - 64 to W_t_first_bit - 33)) + message_buffer(W_t_first_bit - 224 to W_t_first_bit - 193) + SSIG0(message_buffer(W_t_first_bit - 480 to W_t_first_bit - 449)) + message_buffer(W_t_first_bit - 512 to W_t_first_bit - 481);
						message_buffer(W_t_first_bit to W_t_first_bit + 31) <= W_t;
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

					if current_step = 63 then
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

end architecture sha256_arch;

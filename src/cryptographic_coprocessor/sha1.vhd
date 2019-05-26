library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.coprocessor_constants.all;

entity sha1 is
	port(
		-- Inputs
		clk                                    : in  std_logic;
		start_new_hash                         : in  std_logic; -- Reset the state machine to calculate a new hash
		write_data_in                          : in  std_logic; -- Write the data_in to the buffer position indicated by data_in_word_position
		data_in                                : in  unsigned(31 downto 0); -- Data to be written to the input buffer
		data_in_word_position                  : in  unsigned(3 downto 0); -- A number between 0 and 15 corresponding to the word position of data_in
		calculate_next_block                   : in  std_logic; -- Start the calculation of the next block
		is_last_block                          : in  std_logic; -- Indicates whether this block is the last
		last_block_size                        : in  unsigned(9 downto 0); -- The size of the last block, should be between 1 and 512
		-- Outputs
		is_waiting_next_block                  : out std_logic;
		is_busy                                : out std_logic; -- Is busy calculating the hash
		is_complete                            : out std_logic; -- The message digest was calculated successfully
		error                                  : out sha1_error_type; -- Indicates if a error has occurred
		H0_out, H1_out, H2_out, H3_out, H4_out : out unsigned(31 downto 0) -- The message digest result
	);
end entity sha1;

architecture sha1_arch of sha1 is

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

	constant H0_initial : unsigned(31 downto 0) := X"67452301";
	constant H1_initial : unsigned(31 downto 0) := X"EFCDAB89";
	constant H2_initial : unsigned(31 downto 0) := X"98BADCFE";
	constant H3_initial : unsigned(31 downto 0) := X"10325476";
	constant H4_initial : unsigned(31 downto 0) := X"C3D2E1F0";

	-- Functions
	function left_circular_shift(x : in unsigned(31 downto 0); s : in unsigned(7 downto 0)) return unsigned is
	begin
		return shift_left(x, to_integer(s)) or shift_right(x, to_integer(32 - s));
	end function left_circular_shift;

	signal current_step : natural range 0 to 79 := 0;

	-- Message digest buffer
	signal H0            : unsigned(31 downto 0) := H0_initial;
	signal H1            : unsigned(31 downto 0) := H1_initial;
	signal H2            : unsigned(31 downto 0) := H2_initial;
	signal H3            : unsigned(31 downto 0) := H3_initial;
	signal H4            : unsigned(31 downto 0) := H4_initial;
	signal A, B, C, D, E : unsigned(31 downto 0) := (others => '0');

	-- Message buffer, the first 512 bits are from the original message and the others 2048 are used to store
	-- data during the calculation
	signal message_buffer : unsigned(0 to 2559) := (others => '0');

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

	is_waiting_next_block <= '1' when state = waiting_next_block else '0';
	is_busy               <= '1' when state = preparing_additional_block or state = padding_last_block or state = pre_calculation or state = calculating or state = post_calculation else '0';
	is_complete           <= '1' when state = hash_complete else '0';

	fsm : process(clk, start_new_hash)
		variable input_first_bit    : natural range 0 to 480;
		variable W_t_first_bit      : natural range 0 to 2528;
		variable W_t, K_t, f_result : unsigned(31 downto 0);
	begin
		if start_new_hash = '1' then
			state        <= waiting_next_block;
			current_step <= 0;
			error        <= SHA1_ERROR_NONE;

			-- Set default messsage digest buffer
			H0 <= H0_initial;
			H1 <= H1_initial;
			H2 <= H2_initial;
			H3 <= H3_initial;
			H4 <= H4_initial;

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
				error <= SHA1_ERROR_UNEXPECTED_NEW_DATA;
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
						error <= SHA1_ERROR_INVALID_LAST_BLOCK_SIZE;
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

					state <= calculating;

				when calculating =>     ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					W_t_first_bit := current_step * 32;

					if current_step < 16 then
						W_t := message_buffer(W_t_first_bit to W_t_first_bit + 31);
					else
						W_t                                                 := left_circular_shift(message_buffer(W_t_first_bit - 96 to W_t_first_bit - 65) xor message_buffer(W_t_first_bit - 256 to W_t_first_bit - 225) xor message_buffer(W_t_first_bit - 448 to W_t_first_bit - 417) xor message_buffer(W_t_first_bit - 512 to W_t_first_bit - 481), x"01");
						message_buffer(W_t_first_bit to W_t_first_bit + 31) <= W_t;
					end if;

					if current_step < 20 then
						f_result := (B and C) or (not B and D);
						K_t      := x"5A827999";
					elsif current_step < 40 then
						f_result := B xor C xor D;
						K_t      := x"6ED9EBA1";
					elsif current_step < 60 then
						f_result := (B and C) or (B and D) or (C and D);
						K_t      := x"8F1BBCDC";
					else
						f_result := B xor C xor D;
						K_t      := x"CA62C1D6";
					end if;

					A <= left_circular_shift(A, x"05") + f_result + E + W_t + K_t;
					B <= A;
					C <= left_circular_shift(B, x"1E");
					D <= C;
					E <= D;

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

end architecture sha1_arch;

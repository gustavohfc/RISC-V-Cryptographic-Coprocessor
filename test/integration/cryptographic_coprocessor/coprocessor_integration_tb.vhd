LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE STD.textio.all;
USE ieee.std_logic_textio.all;

use work.constants.all;
use work.riscv_core_constants.all;

ENTITY coprocessor_integration_tb IS
	generic(
		runner_cfg : string;
		test_name  : string
	);
END coprocessor_integration_tb;

ARCHITECTURE coprocessor_integration_tb_arch OF coprocessor_integration_tb IS
	constant clk_half_period : time      := 10 ps;
	signal clk               : std_logic := '1';
	signal stop              : std_logic := '0';

	signal memory_word_addr : std_logic_vector(7 DOWNTO 0)  := (others => '0');
	signal memory_data_in   : std_logic_vector(31 DOWNTO 0) := (others => '0');
	signal memory_wren      : std_logic                     := '0';
	signal memory_output    : std_logic_vector(31 DOWNTO 0) := (others => '0');

BEGIN
	riscv : entity work.riscv_coprocessor_top
		generic map(
			WSIZE                  => WORD_SIZE,
			instructions_init_file => "cryptographic_coprocessor_instructions.hex",
			data_init_file         => "cryptographic_coprocessor_data.hex"
		)
		port map(
			clk              => clk,
			memory_word_addr => memory_word_addr,
			memory_data_in   => memory_data_in,
			memory_wren      => memory_wren,
			memory_output    => memory_output
		);

	clk <= not clk after clk_half_period when stop = '0' else '0';

	main : PROCESS
		-- The memory mapping is as follows:
		-- 0x0 - Used for communication between the testbench or the UART module with the RISC-V program
		-- 0x4 to 0x16 - MD5 resul
		-- 0x14 to 0x24 - SHA1 resul
		-- 0x28 to 0x44 - SHA256 resul
		-- 0x48 to 0x84 - SHA512 resul
		-- 0x88 - Message length
		-- 0x8C to memory end - Message
		variable next_addr : unsigned(WORD_SIZE - 1 downto 0) := (others => '0');

		variable md5result, md5expected       : unsigned(127 downto 0) := (others => '0');
		variable sha1result, sha1expected     : unsigned(159 downto 0) := (others => '0');
		variable sha256result, sha256expected : unsigned(255 downto 0) := (others => '0');
		variable sha512result, sha512expected : unsigned(511 downto 0) := (others => '0');

		variable message_len : integer;

		variable byte1, byte2, byte3, byte4 : integer;

		file input_file : text open read_mode is test_name & "_in.hex";
		variable line   : line;
	BEGIN
		test_runner_setup(runner, runner_cfg);

		----------- Load the MD5 expected result -----------
		readline(input_file, line);
		for i in 0 to 3 loop
			read(line, byte1);
			read(line, byte2);
			read(line, byte3);
			read(line, byte4);
			md5expected(127 - (i * 32) downto 96 - (i * 32)) := to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8);
		end loop;

		----------- Load the SHA1 expected result -----------
		readline(input_file, line);
		for i in 0 to 4 loop
			read(line, byte1);
			read(line, byte2);
			read(line, byte3);
			read(line, byte4);
			sha1expected(159 - (i * 32) downto 128 - (i * 32)) := to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8);
		end loop;

		----------- Load the SHA256 expected result -----------
		readline(input_file, line);
		for i in 0 to 7 loop
			read(line, byte1);
			read(line, byte2);
			read(line, byte3);
			read(line, byte4);
			sha256expected(255 - (i * 32) downto 224 - (i * 32)) := to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8);
		end loop;

		----------- Load the SHA512 expected result -----------
		readline(input_file, line);
		for i in 0 to 15 loop
			read(line, byte1);
			read(line, byte2);
			read(line, byte3);
			read(line, byte4);
			sha512expected(511 - (i * 32) downto 480 - (i * 32)) := to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8);
		end loop;

		----------- Write the message length to the memory -----------
		next_addr        := to_unsigned(34, WORD_SIZE); -- Addr 0x88
		readline(input_file, line);
		read(line, message_len);
		memory_wren      <= '1';
		memory_word_addr <= std_logic_vector(next_addr(7 downto 0));
		memory_data_in   <= std_logic_vector(to_unsigned(message_len, WORD_SIZE));
		wait until rising_edge(clk);
		next_addr        := next_addr + 1;

		----------- Write the message to the memory -----------
		readline(input_file, line);
		next_addr := to_unsigned(35, WORD_SIZE); -- Addr 0x8C
		while line'length > 0 loop
			read(line, byte1);

			if line'length > 0 then
				read(line, byte2);
			end if;

			if line'length > 0 then
				read(line, byte3);
			end if;

			if line'length > 0 then
				read(line, byte4);
			end if;

			memory_wren      <= '1';
			memory_word_addr <= std_logic_vector(next_addr(7 downto 0));
			memory_data_in   <= std_logic_vector(to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8));

			wait until rising_edge(clk);

			next_addr := next_addr + 1;
		end loop;

		----------- Make the RISC-V start calculating the hash -----------
		memory_wren      <= '1';
		memory_word_addr <= (others => '0');
		memory_data_in   <= std_logic_vector(to_unsigned(1, WORD_SIZE));
		wait until rising_edge(clk);

		----------- Wait the RISC-V complete the calculation -----------
		memory_wren      <= '0';
		memory_word_addr <= (others => '0');
		wait until memory_output = std_logic_vector(to_unsigned(3, WORD_SIZE));
		wait until rising_edge(clk);

		----------- Check the md5 results -----------
		next_addr := to_unsigned(1, WORD_SIZE);
		for i in 0 to 3 loop
			memory_word_addr <= std_logic_vector(next_addr(7 downto 0));

			wait until rising_edge(clk);

			md5result(127 - (i * 32) downto 96 - (i * 32)) := unsigned(memory_output);

			next_addr := next_addr + 1;
		end loop;

		check_equal(md5result, md5expected, "MD5 fail");

		----------- Check the sha1 results -----------
		for i in 0 to 4 loop
			memory_word_addr <= std_logic_vector(next_addr(7 downto 0));

			wait until rising_edge(clk);

			sha1result(159 - (i * 32) downto 128 - (i * 32)) := unsigned(memory_output);

			next_addr := next_addr + 1;
		end loop;

		check_equal(sha1result, sha1expected, "SHA1 fail");

		----------- Check the sha256 results -----------
		for i in 0 to 7 loop
			memory_word_addr <= std_logic_vector(next_addr(7 downto 0));

			wait until rising_edge(clk);

			sha256result(255 - (i * 32) downto 224 - (i * 32)) := unsigned(memory_output);

			next_addr := next_addr + 1;
		end loop;

		check_equal(sha256result, sha256expected, "SHA256 fail");

		----------- Check the sha512 results -----------
		for i in 0 to 15 loop
			memory_word_addr <= std_logic_vector(next_addr(7 downto 0));

			wait until rising_edge(clk);

			sha512result(511 - (i * 32) downto 480 - (i * 32)) := unsigned(memory_output);

			next_addr := next_addr + 1;
		end loop;

		check_equal(sha512result, sha512expected, "SHA512 fail");

		test_runner_cleanup(runner);
		wait;
	END PROCESS;

END coprocessor_integration_tb_arch;

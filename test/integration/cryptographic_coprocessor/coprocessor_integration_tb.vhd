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

	signal stall_external : std_logic                     := '0';
	signal address_b      : std_logic_vector(7 DOWNTO 0)  := (others => '0');
	signal data_b         : std_logic_vector(31 DOWNTO 0) := (others => '0');
	signal wren_b         : std_logic                     := '0';
	signal q_b            : std_logic_vector(31 DOWNTO 0) := (others => '0');

BEGIN
	riscv : entity work.riscv_core
		generic map(
			WSIZE                  => WORD_SIZE,
			instructions_init_file => "cryptographic_coprocessor_instructions.hex",
			data_init_file         => "cryptographic_coprocessor_data.hex"
		)

		port map(
			clk            => clk,
			stall_external => stall_external,
			address_b      => address_b,
			data_b         => data_b,
			wren_b         => wren_b,
			q_b            => q_b
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

		variable md5result, md5expected : unsigned(127 downto 0) := (others => '0');

		variable message_len : integer;

		variable byte1, byte2, byte3, byte4 : integer;

		file input_file : text open read_mode is "cryptographic_coprocessor_" & test_name & "_in.hex";
		variable line   : line;
	BEGIN
		test_runner_setup(runner, runner_cfg);

		wait until falling_edge(clk);

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

		----------- Load the SHA256 expected result -----------
		readline(input_file, line);

		----------- Load the SHA512 expected result -----------
		readline(input_file, line);

		----------- Write the message length to the memory -----------
		next_addr := to_unsigned(34, WORD_SIZE); -- Addr 0x88
		readline(input_file, line);
		read(line, message_len);
		wren_b    <= '1';
		address_b <= std_logic_vector(next_addr(7 downto 0));
		data_b    <= std_logic_vector(to_unsigned(message_len, WORD_SIZE));
		wait until falling_edge(clk);
		next_addr := next_addr + 1;

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

			wren_b    <= '1';
			address_b <= std_logic_vector(next_addr(7 downto 0));
			data_b    <= std_logic_vector(to_unsigned(byte1, 8) & to_unsigned(byte2, 8) & to_unsigned(byte3, 8) & to_unsigned(byte4, 8));

			wait until falling_edge(clk);

			next_addr := next_addr + 1;
		end loop;

		----------- Make the RISC-V start calculating the hash -----------
		wren_b    <= '1';
		address_b <= (others => '0');
		data_b    <= std_logic_vector(to_unsigned(1, WORD_SIZE));
		wait until falling_edge(clk);

		----------- Wait the RISC-V complete the calculation -----------
		wren_b    <= '0';
		address_b <= (others => '0');
		wait until q_b = std_logic_vector(to_unsigned(3, WORD_SIZE));

		----------- Check the md5 results -----------
		next_addr := to_unsigned(1, WORD_SIZE);
		for i in 0 to 3 loop
			address_b <= (others => '0');

			wait until falling_edge(clk);

			md5result(127 - (i * 32) downto 96 - (i * 32)) := unsigned(q_b);

			next_addr := next_addr + 1;
		end loop;

		check_equal(md5result, md5expected, "MD5 fail");

		----------- Write the message to the memory -----------

		--		----------- Write the message size to the memory -----------
		--		next_addr := to_unsigned(22, WSIZE); -- Address 0x88
		--		wren_b    <= '1';
		--		address_b <= std_logic_vector(next_addr(7 downto 0));
		--		data_b    <= std_logic_vector(to_unsigned(message_len, WSIZE));
		--		wait until falling_edge(clk);
		--		next_addr := next_addr + 1;
		--
		--		----------- Write the message to the memory -----------
		--		for i in 0 to message_decoded'length - 1 loop
		--			wren_b    <= '1';
		--			address_b <= std_logic_vector(next_addr(7 downto 0));
		--			data_b    <= std_logic_vector(to_unsigned(message_decoded(i), WSIZE));
		--			wait until falling_edge(clk);
		--			next_addr := next_addr + 1;
		--		end loop;
		--
		--		----------- Make the RISC-V start calculating the hash -----------
		--		wren_b    <= '1';
		--		address_b <= (others => '0');
		--		data_b    <= std_logic_vector(to_unsigned(1, WSIZE));
		--		wait until falling_edge(clk);
		--
		--		----------- Wait the RISC-V complete the calculation -----------
		--		wren_b    <= '0';
		--		address_b <= (others => '0');
		--		wait until q_b = std_logic_vector(to_unsigned(3, WSIZE));
		--
		--		----------- Check the md5 results -----------
		--		next_addr := to_unsigned(1, WSIZE);
		--
		--		for i in 0 to 3 loop
		--			address_b <= (others => '0');
		--
		--			wait until falling_edge(clk);
		--
		--			md5result(127 - (i * 32) downto 96 - (i * 32)) := unsigned(q_b);
		--
		--			next_addr := next_addr + 1;
		--		end loop;

		-- Check the sha1 results

		-- Check the sha256 results

		-- Check the sha512 results

		test_runner_cleanup(runner);
		wait;
	END PROCESS;

	--	watch_changes : PROCESS(clk)
	--		alias register_write_enable is <<signal riscv.stage_ID_inst.registers.write_enable : std_logic>>;
	--		alias register_rd is <<signal riscv.stage_ID_inst.registers.rd : std_logic_vector(4 downto 0)>>;
	--		alias register_write_data is <<signal riscv.stage_ID_inst.registers.write_data : std_logic_vector(WSIZE - 1 downto 0)>>;
	--
	--		alias memory_write_enable is <<signal riscv.stage_MEM_inst.wren_memory_in : std_logic>>;
	--		alias memory_address is <<signal riscv.stage_MEM_inst.ALU_Z : std_logic_vector(WSIZE - 1 downto 0)>>;
	--		alias r2_in is <<signal riscv.stage_MEM_inst.r2_in : std_logic_vector(WSIZE - 1 downto 0)>>;
	--		
	--	BEGIN
	--		-- Watch changes in the registers
	--		if falling_edge(clk) and register_write_enable = '1' and unsigned(register_rd) /= 0 then
	--			write(row, to_string(register_rd), right);
	--			write(row, " " & to_string(register_write_data));
	--			writeline(register_changes, row);
	--		end if;
	--
	--		-- Watch changes in the memory
	--		if falling_edge(clk) and memory_write_enable = '1' then
	--			report (to_string(memory_address));
	--			write(row, to_string(memory_address), right);
	--			write(row, " " & to_string(r2_in));
	--			writeline(memory_changes, row);
	--		end if;
	--	END PROCESS;

END coprocessor_integration_tb_arch;

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
		runner_cfg  : string;
		WSIZE       : natural;
		message     : string;
		message_len : natural;
		md5         : string;
		sha1        : string;
		sha256      : string;
		sha512      : string
	);
END coprocessor_integration_tb;

ARCHITECTURE coprocessor_integration_tb_arch OF coprocessor_integration_tb IS
	constant clk_half_period : time      := 10 ps;
	signal clk               : std_logic := '1';
	signal stop              : std_logic := '0';

	impure function decode_string(encoded_integer_vector : string) return integer_vector is
		variable parts        : lines_t := split(encoded_integer_vector, ", ");
		variable return_value : integer_vector(parts'range);
	begin
		for i in parts'range loop
			return_value(i) := integer'value(parts(i).all);
		end loop;

		return return_value;
	end;

	constant message_decoded : integer_vector := decode_string(message);
	constant md5_decoded     : integer_vector := decode_string(md5);
	constant sha1_decoded    : integer_vector := decode_string(sha1);
	constant sha256_decoded  : integer_vector := decode_string(sha256);
	constant sha512_decoded  : integer_vector := decode_string(sha512);

	signal stall_external : std_logic                     := '0';
	signal address_b      : std_logic_vector(7 DOWNTO 0)  := (others => '0');
	signal data_b         : std_logic_vector(31 DOWNTO 0) := (others => '0');
	signal wren_b         : std_logic                     := '0';
	signal q_b            : std_logic_vector(31 DOWNTO 0) := (others => '0');

BEGIN
	riscv : entity work.riscv_core
		generic map(
			WSIZE                  => WSIZE,
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
		alias PC is <<signal riscv.PC_IF_ID : std_logic_vector(WORD_SIZE - 1 downto 0)>>;

		variable next_addr : unsigned(WORD_SIZE - 1 downto 0) := to_unsigned(1, WSIZE); -- The first addr is used for communication
	BEGIN
		test_runner_setup(runner, runner_cfg);

		wait until falling_edge(clk);

		----------- Write the message size to the memory -----------
		wren_b    <= '1';
		address_b <= std_logic_vector(next_addr(7 downto 0));
		data_b    <= std_logic_vector(to_unsigned(message_len, WSIZE));
		wait until falling_edge(clk);
		next_addr := next_addr + 1;

		----------- Write the message to the memory -----------
		for i in 0 to message_decoded'length - 1 loop
			wren_b    <= '1';
			address_b <= std_logic_vector(next_addr(7 downto 0));
			data_b    <= std_logic_vector(to_unsigned(message_decoded(i), WSIZE));
			wait until falling_edge(clk);
			next_addr := next_addr + 1;
		end loop;

		-- Make the RISC-V start calculating the hash
		wren_b    <= '1';
		address_b <= (others => '0');
		data_b    <= std_logic_vector(to_unsigned(1, WSIZE));
		wait until falling_edge(clk);
		
		-- Wait the RISC-V complete the calculation
		wren_b    <= '0';
		address_b <= (others => '0');
		wait until q_b = std_logic_vector(to_unsigned(3, WSIZE));


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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.riscv_core_constants.all;

entity riscv_core is
	generic(
		WSIZE                  : natural := WORD_SIZE;
		instructions_init_file : string  := DEFAULT_INSTRUCTIONS_INIT_FILE;
		data_init_file         : string  := DEFAULT_DATA_INIT_FILE
	);

	port(
		clk                     : in  std_logic;
		-- Coprocessor communication
		coprocessor_instruction : out std_logic_vector(31 downto 0);
		coprocessor_data        : out std_logic_vector(31 downto 0);
		coprocessor_r2          : out std_logic_vector(31 downto 0);
		coprocessor_output      : in  std_logic_vector(31 downto 0);
		-- Direct memory access
		memory_word_addr        : in  std_logic_vector(7 downto 0);
		memory_data_in          : in  std_logic_vector(31 downto 0);
		memory_wren             : in  std_logic;
		memory_output           : out std_logic_vector(31 downto 0)
		--		instruction     : out std_logic_vector(WSIZE - 1 downto 0);
		--		registers_array : out ARRAY_32X32
		--*--*--*--*--*--*--*--*--*--*--*--*--*--*--* Signals necessary to FPGA, comment when simulating in modelsim and uncomment above --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
		--		clk50, clk_key                                 : in  std_logic;
		--		MUX_FPGA_select                                : in  std_logic_vector(1 downto 0);
		--		reg_number                                     : in  std_logic_vector(4 downto 0);
		--		hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0 : out std_logic_vector(7 downto 0)
		--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
	);
end riscv_core;

architecture riscv_core_arch of riscv_core is
	--*--*--*--*--*--*--*--*--*--*--*--*--*--*--* Signals necessary to FPGA, comment when simulating in modelsim --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
	--	signal clk, clk_out                                                           : std_logic;
	--	signal registers_array                                                        : ARRAY_32X32;
	--	signal MUX_FPGA_out, reg_display                                              : std_logic_vector(31 downto 0);
	--	signal hex0aux, hex1aux, hex2aux, hex3aux, hex4aux, hex5aux, hex6aux, hex7aux : std_logic_vector(7 downto 0);
	--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

	signal instruction_IF_ID, instruction_ID_EX, instruction_EX_MEM, instruction_MEM_WB_CO : std_logic_vector((WSIZE - 1) downto 0);
	signal ALU_A, ALU_B, ALU_Z, r2_ID_EX, r2_EX_MEM, r2_MEM_CO                             : std_logic_vector((WSIZE - 1) downto 0);
	signal data_register_write, WB_data, data_MEM_WB_CO, immediate, rs1                    : std_logic_vector((WSIZE - 1) downto 0);
	signal PC_IF_ID                                                                        : std_logic_vector((WSIZE - 1) downto 0);

	signal WB_address     : std_logic_vector(4 downto 0);
	signal next_pc_select : std_logic_vector(1 downto 0);

	signal wren_register_ID_EX, wren_register_EX_MEM, wren_register_MEM_WB, wren_register_WB : std_logic;
	signal wren_memory_ID_EX, wren_memory_EX_MEM                                             : std_logic;
	signal stage_MEM_output_select_ID_EX, stage_MEM_output_select_EX_MEM, stall              : std_logic;

begin

	--	instruction <= instruction_IF_ID;
	--*--*--*--*--*--*--*--*--*--*--*--*--*--*--* Signals necessary to FPGA, comment when simulating in modelsim and uncomment above --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
	--	reg_display <= registers_array(to_integer(unsigned(reg_number)));
	--
	--	hex7 <= hex7aux;
	--	hex6 <= hex6aux;
	--	hex5 <= hex5aux;
	--	hex4 <= hex4aux;
	--	hex3 <= hex3aux;
	--	hex2 <= hex2aux;
	--	hex1 <= hex1aux;
	--	hex0 <= hex0aux;
	--
	--	mux4_FPGA : entity work.mux4
	--		generic map(WSIZE => WSIZE)
	--		port map(MUX_FPGA_select, PC_IF_ID, instruction_IF_ID, BUBBLE, reg_display, MUX_FPGA_out);
	--	-- cada portmap ira gerar os sinais que serao enviados para o FPGA
	--	HEX_0 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(31 downto 28), hex7aux);
	--	HEX_1 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(27 downto 24), hex6aux);
	--	HEX_2 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(23 downto 20), hex5aux);
	--	HEX_3 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(19 downto 16), hex4aux);
	--	HEX_4 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(15 downto 12), hex3aux);
	--	HEX_5 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(11 downto 8), hex2aux);
	--	HEX_6 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(7 downto 4), hex1aux);
	--	HEX_7 : entity work.display7seg_decoder
	--		port map(MUX_FPGA_out(3 downto 0), hex0aux);
	--
	--	debounce_inst : entity work.debounce
	--		generic map(
	--			counter_size => 19
	--		)
	--		port map(
	--			clk    => clk50,
	--			button => clk_key,
	--			result => clk_out
	--		);
	--	clk <= not clk_out;
	--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

	stage_IF_inst : entity work.stage_IF
		generic map(
			WSIZE                  => WSIZE,
			instructions_init_file => instructions_init_file
		)
		port map(
			clk             => clk,
			immediate       => immediate,
			rs1             => rs1,
			next_pc_select  => next_pc_select,
			stall           => stall,
			instruction_out => instruction_IF_ID,
			PC_IF_ID_out    => PC_IF_ID
		);

	stage_ID_inst : entity work.stage_ID
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk                         => clk,
			instruction_in              => instruction_IF_ID,
			instruction_out             => instruction_ID_EX,
			WB_data                     => data_register_write,
			WB_address                  => WB_address,
			wren_register_in            => wren_register_WB,
			wren_memory_out             => wren_memory_ID_EX,
			wren_register_out           => wren_register_ID_EX,
			stage_MEM_output_select_out => stage_MEM_output_select_ID_EX,
			stall                       => stall,
			r2_out                      => r2_ID_EX,
			ALU_A_out                   => ALU_A,
			ALU_B_out                   => ALU_B,
			immediate_out               => immediate,
			rs1_out                     => rs1,
			PC_IF_ID                    => PC_IF_ID,
			next_pc_select              => next_pc_select
		);

	stage_EX_inst : entity work.stage_EX
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk                         => clk,
			instruction_in              => instruction_ID_EX,
			instruction_out             => instruction_EX_MEM,
			r2_in                       => r2_ID_EX,
			r2_out                      => r2_EX_MEM,
			ALU_A                       => ALU_A,
			ALU_B                       => ALU_B,
			ALU_Z                       => ALU_Z,
			wren_memory_in              => wren_memory_ID_EX,
			wren_register_in            => wren_register_ID_EX,
			stage_MEM_output_select_in  => stage_MEM_output_select_ID_EX,
			wren_memory_out             => wren_memory_EX_MEM,
			wren_register_out           => wren_register_EX_MEM,
			stage_MEM_output_select_out => stage_MEM_output_select_EX_MEM
		);

	stage_MEM_inst : entity work.stage_MEM
		generic map(
			WSIZE          => WSIZE,
			data_init_file => data_init_file
		)
		port map(
			clk               => clk,
			instruction_in    => instruction_EX_MEM,
			instruction_out   => instruction_MEM_WB_CO,
			r2_in             => r2_EX_MEM,
			r2_out            => r2_MEM_CO,
			ALU_Z             => ALU_Z,
			data_out          => data_MEM_WB_CO,
			wren_memory_in    => wren_memory_EX_MEM,
			wren_register_in  => wren_register_EX_MEM,
			output_select     => stage_MEM_output_select_EX_MEM,
			wren_register_out => wren_register_MEM_WB,
			address_b         => memory_word_addr,
			data_b            => memory_data_in,
			wren_b            => memory_wren,
			q_b               => memory_output
		);

	stage_WB_inst : entity work.stage_WB
		generic map(
			WSIZE => WSIZE
		)
		port map(
			instruction_in    => instruction_MEM_WB_CO,
			data_in           => data_MEM_WB_CO,
			wren_register_in  => wren_register_MEM_WB,
			wren_register_out => wren_register_WB,
			WB_address        => WB_address,
			WB_data_out       => WB_data
		);

	coprocessor_instruction <= instruction_MEM_WB_CO;
	coprocessor_data        <= data_MEM_WB_CO;
	coprocessor_r2          <= r2_MEM_CO;

	data_register_write <= std_logic_vector(coprocessor_output) when instruction_MEM_WB_CO(6 downto 0) = CRYPTOGRAPHIC_COPROCESSOR_OPCODE else WB_data;

end riscv_core_arch;

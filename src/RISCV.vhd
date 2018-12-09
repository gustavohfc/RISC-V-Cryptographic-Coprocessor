library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity RISCV is
	generic(WSIZE : natural := WORD_SIZE);

	port(
		clk             : in    std_logic;
		instruction     : out   std_logic_vector(WSIZE - 1 downto 0);
		registers_array : out   ARRAY_32X32
	);
end RISCV;

architecture RISCV_arch of RISCV is
	signal instruction_IF_ID, instruction_ID_EX, instruction_EX_MEM, instruction_MEM_WB : std_logic_vector((WSIZE - 1) downto 0);
	signal ALU_A, ALU_B, ALU_Z, wdata_ID_EX, wdata_EX_MEM                               : std_logic_vector((WSIZE - 1) downto 0);
	signal WB_data, data_MEM_WB, immediate, rs1                                         : std_logic_vector((WSIZE - 1) downto 0);
	signal PC_IF_ID                                                                     : std_logic_vector((WSIZE - 1) downto 0);

	signal WB_address     : std_logic_vector(4 downto 0);
	signal next_pc_select : std_logic_vector(1 downto 0);

	signal wren_register_ID_EX, wren_register_EX_MEM, wren_register_MEM_WB, wren_register_WB : std_logic;
	signal wren_memory_ID_EX, wren_memory_EX_MEM                                             : std_logic;
	signal WB_select_ID_EX, WB_select_EX_MEM                                                 : std_logic;
begin

	stage_IF_inst : entity work.stage_IF
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk            => clk,
			immediate      => immediate,
			rs1            => rs1,
			next_pc_select => next_pc_select,
			instruction_out => instruction_IF_ID,
			PC_IF_ID_out   => PC_IF_ID
		);

	stage_ID_inst : entity work.stage_ID
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk               => clk,
			instruction_in    => instruction_IF_ID,
			instruction_out   => instruction_ID_EX,
			WB_data           => WB_data,
			WB_address        => WB_address,
			wren_register_in  => wren_register_WB,
			wren_memory_out   => wren_memory_ID_EX,
			wren_register_out => wren_register_ID_EX,
			WB_select_out     => WB_select_ID_EX,
			wdata_out         => wdata_ID_EX,
			ALU_A_out         => ALU_A,
			ALU_B_out         => ALU_B,
			immediate_out     => immediate,
			rs1_out           => rs1,
			PC_IF_ID          => PC_IF_ID,
			next_pc_select    => next_pc_select,
			registers_array   => registers_array
		);

	stage_EX_inst : entity work.stage_EX
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk               => clk,
			instruction_in    => instruction_ID_EX,
			instruction_out   => instruction_EX_MEM,
			wdata_in          => wdata_ID_EX,
			wdata_out         => wdata_EX_MEM,
			ALU_A             => ALU_A,
			ALU_B             => ALU_B,
			ALU_Z             => ALU_Z,
			wren_memory_in    => wren_memory_ID_EX,
			wren_register_in  => wren_register_ID_EX,
			WB_select_in      => WB_select_ID_EX,
			wren_memory_out   => wren_memory_EX_MEM,
			wren_register_out => wren_register_EX_MEM,
			WB_select_out     => WB_select_EX_MEM
		);

	stage_MEM_inst : entity work.stage_MEM
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk               => clk,
			instruction_in    => instruction_EX_MEM,
			instruction_out   => instruction_MEM_WB,
			wdata_in          => wdata_EX_MEM,
			ALU_Z_in          => ALU_Z,
			data_out          => data_MEM_WB,
			wren_memory_in    => wren_memory_EX_MEM,
			wren_register_in  => wren_register_EX_MEM,
			WB_select_in      => WB_select_EX_MEM,
			wren_register_out => wren_register_MEM_WB
		);

	stage_WB_inst : entity work.stage_WB
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk               => clk,
			instruction_in    => instruction_MEM_WB,
			data_in           => data_MEM_WB,
			wren_register_in  => wren_register_MEM_WB,
			wren_register_out => wren_register_WB,
			WB_address        => WB_address,
			WB_data_out       => WB_data
		);
		
	instruction <= instruction_IF_ID;

end RISCV_arch;

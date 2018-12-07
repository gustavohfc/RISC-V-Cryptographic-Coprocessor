library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity stage_ID is
	generic(WSIZE : natural);

	port(
		clk                                : in  std_logic;
		instruction_in                     : in  std_logic_vector((WSIZE - 1) downto 0);
		instruction_out                    : out std_logic_vector((WSIZE - 1) downto 0);
		write_back_data                    : in  std_logic_vector((WSIZE - 1) downto 0);
		wren_register_in   : in  std_logic;
		wren_memory_out, wren_register_out : out std_logic;
		wdata_out                          : out std_logic_vector((WSIZE - 1) downto 0);
		ALU_A_out, ALU_B_out               : out std_logic_vector((WSIZE - 1) downto 0)
	);
end entity stage_ID;

architecture stage_ID_arch of stage_ID is
	signal rs1, rs2, rd                           : std_logic_vector(4 downto 0) := (others => '0');
	signal r2, immediate                          : std_logic_vector((WSIZE - 1) downto 0);
	signal ALU_select, wren_memory, wren_register : std_logic;
	signal instruction_type                       : instruction_type;
	signal ALU_A, ALU_B                           : std_logic_vector((WSIZE - 1) downto 0);

begin

	control : entity work.control
		generic map(
			WSIZE => WSIZE
		)
		port map(
			instruction      => instruction_in,
			instruction_type => instruction_type,
			ALU_select       => ALU_select,
			wren_memory      => wren_memory,
			wren_register    => wren_register
		);

	registers : entity work.register_file
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk          => clk,
			write_enable => wren_register_in,
			rs1          => rs1,
			rs2          => rs2,
			rd           => rd,
			write_data   => write_back_data,
			r1           => ALU_A,
			r2           => r2
		);

	imm_decoder : entity work.immediate_decoder
		generic map(
			WSIZE => WSIZE
		)
		port map(
			instruction      => instruction_in,
			instruction_type => instruction_type,
			immediate        => immediate
		);

	mux_ALU : entity work.mux2
		generic map(
			WSIZE => WSIZE
		)
		port map(
			S  => ALU_select,
			I0 => immediate,
			I1 => r2,
			O  => ALU_B
		);

	process(clk) is
	begin
		if rising_edge(clk) then
			instruction_out   <= instruction_in;
			ALU_A_out         <= ALU_A;
			ALU_B_out         <= ALU_B;
			wdata_out         <= r2;
			wren_memory_out   <= wren_memory;
			wren_register_out <= wren_register;
		end if;
	end process;

end architecture stage_ID_arch;

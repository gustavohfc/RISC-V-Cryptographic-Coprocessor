library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;

entity RISCV is
	generic(WSIZE : natural := WORD_SIZE);

	port(
		clk : in std_logic
	);
end RISCV;

architecture RISCV_arch of RISCV is
	signal instruction_IF_ID, instruction_ID_EX : std_logic_vector((WSIZE - 1) downto 0);
	signal ALU_A, ALU_B                         : std_logic_vector((WSIZE - 1) downto 0);

begin

	stage_IF : entity work.stage_IF
		generic map(WSIZE => WSIZE)
		port map(
			clk         => clk,
			instruction => instruction_IF_ID
		);

	stage_ID : entity work.stage_ID
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk             => clk,
			write_enable_in => '0',     --TODO
			write_data      => (others => '0'), --TODO
			instruction_in  => instruction_IF_ID,
			instruction_out => instruction_ID_EX,
			ALU_A_out       => ALU_A,
			ALU_B_out       => ALU_B
		);

	stage_EX : entity work.stage_EX
		generic map(
			WSIZE => WSIZE
		)
		port map(
			clk            => clk,
			ALU_A          => ALU_A,
			ALU_B          => ALU_B,
			instruction_in => instruction_ID_EX
		);

end RISCV_arch;

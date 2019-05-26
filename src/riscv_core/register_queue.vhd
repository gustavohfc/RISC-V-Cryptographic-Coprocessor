library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_core_constants.all;

entity register_queue is
	port(
		clk              : in  std_logic;
		rs1, rs2, rd     : in  std_logic_vector(4 downto 0);
		instruction_type : in  instruction_types;
		stall            : out std_logic
	);
end entity register_queue;

architecture RTL of register_queue is
	signal rq1, rq2, rq3 : std_logic_vector(4 downto 0) := (others => '0');
	signal ZERO          : std_logic_vector(4 downto 0) := (others => '0');
	signal stall_aux     : std_logic;

begin
	stall <= stall_aux;
	stall_aux <= '1' when ((instruction_type = R_type or instruction_type = S_type or instruction_type = B_type) and (rs2 = rq1 or rs2 = rq2) and (rs2 /= ZERO)) or ((instruction_type = R_type or instruction_type = S_type or instruction_type = B_type or instruction_type = I_type) and (rs1 = rq1 or rs1 = rq2) and (rs1 /= ZERO)) else '0';

	process(clk) is
	begin
		if rising_edge(clk) then
--			if (instruction_type = R_type or instruction_type = S_type or instruction_type = B_type) and (rs2 = rq1 or rs2 = rq2) and (rs2 /= ZERO) then
--				stall_aux <= '1';
--			elsif (instruction_type = R_type or instruction_type = S_type or instruction_type = B_type or instruction_type = I_type) and (rs1 = rq1 or rs1 = rq2) and (rs1 /= ZERO) then
--				stall_aux <= '1';
--			else
--				stall_aux <= '0';
--			end if;

			if instruction_type = S_type or instruction_type = B_type or stall_aux = '1' then
				rq3 <= rq2;
				rq2 <= rq1;
				rq1 <= (others => '0');
			else
				rq3 <= rq2;
				rq2 <= rq1;
				rq1 <= rd;
			end if;
		end if;
	end process;

end architecture RTL;

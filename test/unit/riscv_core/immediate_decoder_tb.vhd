LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

use work.constants.all;
use work.riscv_core_constants.all;

ENTITY unit_immediate_decoder_tb IS
	generic(
		runner_cfg : string
	);
END unit_immediate_decoder_tb;

ARCHITECTURE unit_immediate_decoder_tb_arch OF unit_immediate_decoder_tb IS
	signal instruction : std_logic_vector(WORD_SIZE - 1 downto 0);
	signal instruction_type : instruction_types;
	signal immediate : std_logic_vector(WORD_SIZE - 1 downto 0);
BEGIN
	
	decoder: entity work.immediate_decoder
		generic map(
			WSIZE => WORD_SIZE
		)
		port map(
			instruction      => instruction(31 downto 7),
			instruction_type => instruction_type,
			immediate        => immediate
		);
		
	main : PROCESS
	BEGIN
		test_runner_setup(runner, runner_cfg);
		
		----------------------- TYPE I -----------------------
		-- lw t0, 16(zero)
		instruction <= x"01002283";
		instruction_type <= I_type;
		wait for 1 ns;
		check_equal(signed(immediate), 16, result("lw t0, 16(zero)"));
		
		-- addi t1, zero, -100
		instruction <= x"f9c00313";
		instruction_type <= I_type;
		wait for 1 ns;
		check_equal(signed(immediate), -100, result("addi t1, zero, -100"));
		
		-- xori t0, t0, -1
		instruction <= x"fff2c293";
		instruction_type <= I_type;
		wait for 1 ns;
		check_equal(signed(immediate), -1, result("xori t0, t0, -1"));
		
		-- addi t1, zero, 354
		instruction <= x"16200313";
		instruction_type <= I_type;
		wait for 1 ns;
		check_equal(signed(immediate), 354, result("addi t1, zero, 354"));
		
		-- jalr zero, zero, 0x18
		instruction <= x"01800067";
		instruction_type <= I_type;
		wait for 1 ns;
		check_equal(signed(immediate), 24, result("jalr zero, zero, 0x18"));
		
		
		----------------------- TYPE S -----------------------
		-- sw t0, 60(s0)
		instruction <= x"02542e23";
		instruction_type <= S_type;
		wait for 1 ns;
		check_equal(signed(immediate), 60, result("sw t0, 60(s0)"));
		
		
		----------------------- TYPE B -----------------------
		-- bne t0, t0, main
		instruction <= x"fe5290e3";
		instruction_type <= B_type;
		wait for 1 ns;
		check_equal(signed(immediate), -32, result("bne t0, t0, main"));
		
		
		----------------------- TYPE U -----------------------
		-- jalr zero, zero, 0x18
		instruction <= x"00002437";
		instruction_type <= U_type;
		wait for 1 ns;
		check_equal(signed(immediate), 8192, result("lui s0, 2"));
		
		
		----------------------- TYPE J -----------------------
		-- jal rot
		instruction <= x"00c000ef";
		instruction_type <= J_type;
		wait for 1 ns;
		check_equal(signed(immediate), 12, result("jal rot"));
		

		test_runner_cleanup(runner);
		wait;
	END PROCESS;
		
END unit_immediate_decoder_tb_arch;
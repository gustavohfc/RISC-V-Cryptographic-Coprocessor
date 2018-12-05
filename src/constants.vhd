library ieee;
use ieee.std_logic_1164.all;

package constants is
	-- Configuration
	constant WORD_SIZE : integer := 32;

	-- Opcodes
	constant OPCODE_LOAD       : std_logic_vector(6 downto 0) := "0000011"; -- TODO: Not implemented
	constant OPCODE_LOAD_FP    : std_logic_vector(6 downto 0) := "0000111"; -- TODO: Not implemented
	constant OPCODE_CUSTOM_0   : std_logic_vector(6 downto 0) := "0001011"; -- TODO: Not implemented
	constant OPCODE_MISC_MEM   : std_logic_vector(6 downto 0) := "0001111"; -- TODO: Not implemented
	constant OPCODE_OP_IMM     : std_logic_vector(6 downto 0) := "0010011"; -- TODO: Not implemented
	constant OPCODE_AUIPC      : std_logic_vector(6 downto 0) := "0010111"; -- TODO: Not implemented
	constant OPCODE_OP_IMM_32  : std_logic_vector(6 downto 0) := "0011011"; -- TODO: Not implemented
	--	constant OPCODE_           : std_logic_vector(6 downto 0) := "0011111";
	constant OPCODE_STORE      : std_logic_vector(6 downto 0) := "0100011"; -- TODO: Not implemented
	constant OPCODE_STORE_FP   : std_logic_vector(6 downto 0) := "0100111"; -- TODO: Not implemented
	constant OPCODE_CUSTOM_1   : std_logic_vector(6 downto 0) := "0101011"; -- TODO: Not implemented
	constant OPCODE_AMO        : std_logic_vector(6 downto 0) := "0101111"; -- TODO: Not implemented
	constant OPCODE_OP         : std_logic_vector(6 downto 0) := "0110011"; -- TODO: Not implemented
	constant OPCODE_LUI        : std_logic_vector(6 downto 0) := "0110111"; -- TODO: Not implemented
	constant OPCODE_OP_32      : std_logic_vector(6 downto 0) := "0111011"; -- TODO: Not implemented
	--	constant OPCODE_           : std_logic_vector(6 downto 0) := "0111111";
	constant OPCODE_MADD       : std_logic_vector(6 downto 0) := "1000011"; -- TODO: Not implemented
	constant OPCODE_MSUB       : std_logic_vector(6 downto 0) := "1000111"; -- TODO: Not implemented
	constant OPCODE_NMSUB      : std_logic_vector(6 downto 0) := "1001011"; -- TODO: Not implemented
	constant OPCODE_NMADD      : std_logic_vector(6 downto 0) := "1001111"; -- TODO: Not implemented
	constant OPCODE_OP_FP      : std_logic_vector(6 downto 0) := "1010011"; -- TODO: Not implemented
	constant OPCODE_RESERVED_1 : std_logic_vector(6 downto 0) := "1010111"; -- TODO: Not implemented
	constant OPCODE_CUSTOM_2   : std_logic_vector(6 downto 0) := "1011011"; -- TODO: Not implemented
	--	constant OPCODE_           : std_logic_vector(6 downto 0) := "1011111";
	constant OPCODE_BRANCH     : std_logic_vector(6 downto 0) := "1100011"; -- TODO: Not implemented
	constant OPCODE_JALR       : std_logic_vector(6 downto 0) := "1100111"; -- TODO: Not implemented
	constant OPCODE_RESERVED_2 : std_logic_vector(6 downto 0) := "1101011"; -- TODO: Not implemented
	constant OPCODE_JAL        : std_logic_vector(6 downto 0) := "1101111"; -- TODO: Not implemented
	constant OPCODE_SYSTEM     : std_logic_vector(6 downto 0) := "1110011"; -- TODO: Not implemented
	constant OPCODE_RESERVED_3 : std_logic_vector(6 downto 0) := "1110111"; -- TODO: Not implemented
	constant OPCODE_CUSTOM_3   : std_logic_vector(6 downto 0) := "1111011"; -- TODO: Not implemented
	--	constant OPCODE_           : std_logic_vector(6 downto 0) := "1111111";

end package constants;

package body constants is
end package body constants;

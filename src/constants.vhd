library ieee;
use ieee.std_logic_1164.all;

package constants is
	-- Configuration
	constant WORD_SIZE : natural := 32;

	-- Opcode and functs
	constant CRYPTOGRAPHIC_COPROCESSOR_OPCODE : std_logic_vector(6 downto 0) := "0001011";

	-- FUNCT2, identifies the target module
	constant FUNCT2_MD5    : std_logic_vector(1 downto 0) := "00";
	constant FUNCT2_SHA1   : std_logic_vector(1 downto 0) := "01";
	constant FUNCT2_SHA256 : std_logic_vector(1 downto 0) := "10";
	constant FUNCT2_SHA512 : std_logic_vector(1 downto 0) := "11";

	-- FUNCT3, identifies the operation
	constant FUNCT3_LW     : std_logic_vector(2 downto 0) := "000";
	constant FUNCT3_NEXT   : std_logic_vector(2 downto 0) := "001";
	constant FUNCT3_LAST   : std_logic_vector(2 downto 0) := "010";
	constant FUNCT3_BUSY   : std_logic_vector(2 downto 0) := "011";
	constant FUNCT3_DIGEST : std_logic_vector(2 downto 0) := "100";
	constant FUNCT3_RESET  : std_logic_vector(2 downto 0) := "101";

	constant BUBBLE : std_logic_vector((WORD_SIZE - 1) downto 0) := (others => '0');

end package constants;

package body constants is
end package body constants;

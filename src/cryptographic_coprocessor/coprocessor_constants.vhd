library ieee;
use ieee.std_logic_1164.all;

package coprocessor_constants is

	type md5_error_type is (
		-- MD5
		MD5_ERROR_NONE,
		MD5_ERROR_UNEXPECTED_NEW_DATA,
		MD5_ERROR_INVALID_LAST_BLOCK_SIZE,
		
		-- SHA 1
		SHA1_ERROR_NONE,
		SHA1_ERROR_UNEXPECTED_NEW_DATA,
		SHA1_ERROR_INVALID_LAST_BLOCK_SIZE
	);

end package coprocessor_constants;

package body coprocessor_constants is
end package body coprocessor_constants;

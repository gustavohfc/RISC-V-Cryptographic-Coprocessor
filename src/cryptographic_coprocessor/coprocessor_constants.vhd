library ieee;
use ieee.std_logic_1164.all;

package coprocessor_constants is

	type md5_error_type is (
		MD5_ERROR_NONE,
		MD5_ERROR_UNEXPECTED_NEW_DATA,
		MD5_ERROR_INVALID_LAST_BLOCK_SIZE
	);

	type sha1_error_type is (
		SHA1_ERROR_NONE,
		SHA1_ERROR_UNEXPECTED_NEW_DATA,
		SHA1_ERROR_INVALID_LAST_BLOCK_SIZE
	);

	type sha256_error_type is (
		SHA256_ERROR_NONE,
		SHA256_ERROR_UNEXPECTED_NEW_DATA,
		SHA256_ERROR_INVALID_LAST_BLOCK_SIZE
	);

	type sha512_error_type is (
		SHA512_ERROR_NONE,
		SHA512_ERROR_UNEXPECTED_NEW_DATA,
		SHA512_ERROR_INVALID_LAST_BLOCK_SIZE
	);

end package coprocessor_constants;

package body coprocessor_constants is
end package body coprocessor_constants;

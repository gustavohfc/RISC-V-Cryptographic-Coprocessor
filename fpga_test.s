.data
	COMM_ADDR: 	.word 0
	MD5_RESULT: 	.space 16
	SHA1_RESULT: 	.space 20
	SHA256_RESULT: 	.space 32
	SHA512_RESULT: 	.space 64
	MESSAGE_LEN: 	.word 48
	MESSAGE:	.byte 67 83 73 82 00 00 86 45 # RISC-V

.text
nop

################################################################## MD5
	la t0, MESSAGE_LEN
	lw s0, 0(t0) # s0 is the remaining bits of the message
	la s1, MESSAGE # s1 is the address of the next word to be loaded
	li s3, 16 # Number of words per block (512/32)
	
MD5_NEXT_BLOCK:
	li s2, 0 # s2 is current number of words loaded to the coprocessor
	
MD5_NEXT_WORD:
	lw t0, 0(s1)
	crypto.md5.lw s1, s2
	addi s0, s0, -32
	addi s1, s1, 4
	blez s0, MD5_LAST
	addi s2, s2, 1
	bne s2, s3, MD5_NEXT_WORD
	
	crypto.md5.next
	
MD5_WAIT_BLOCK_PROC:
	crypto.md5.busy t0
	bnez t0, MD5_WAIT_BLOCK_PROC
	j MD5_NEXT_BLOCK

MD5_LAST:
	# Calculate the numer of bits in the last block
	addi t0, s0, 32
	slli t1, s2, 5 # s2*32
	add t0, t0, t1
	
	crypto.md5.last t0

MD5_WAIT_LAST:
	crypto.md5.busy t0
	bnez t0, MD5_WAIT_LAST

# Get the message digest
	li s0, 0 # Next word from the message digest to read
	li s1, 4 # Number of 32 bits words in the MD5 message digest
	la s2, MD5_RESULT
	
MD5_DIGEST_LOOP:
	crypto.md5.digest t0, s0
	addi s0, s0, 1
	sw t0, 0(s2)
	addi s2, s2, 4
	bne s0, s1, MD5_DIGEST_LOOP



################################################################## SHA1
	la t0, MESSAGE_LEN
	lw s0, 0(t0) # s0 is the remaining bits of the message
	la s1, MESSAGE # s1 is the address of the next word to be loaded
	li s3, 16 # Number of words per block (512/32)
	
SHA1_NEXT_BLOCK:
	li s2, 0 # s2 is current number of words loaded to the coprocessor
	
SHA1_NEXT_WORD:
	lw t0, 0(s1)
	crypto.sha1.lw s1, s2
	addi s0, s0, -32
	addi s1, s1, 4
	blez s0, SHA1_LAST
	addi s2, s2, 1
	bne s2, s3, SHA1_NEXT_WORD
	
	crypto.sha1.next
	
SHA1_WAIT_BLOCK_PROC:
	crypto.sha1.busy t0
	bnez t0, SHA1_WAIT_BLOCK_PROC
	j SHA1_NEXT_BLOCK

SHA1_LAST:
	# Calculate the numer of bits in the last block
	addi t0, s0, 32
	slli t1, s2, 5 # s2*32
	add t0, t0, t1
	
	crypto.sha1.last t0

SHA1_WAIT_LAST:
	crypto.sha1.busy t0
	bnez t0, SHA1_WAIT_LAST

# Get the message digest
	li s0, 0 # Next word from the message digest to read
	li s1, 5 # Number of 32 bits words in the message digest
	la s2, SHA1_RESULT
	
SHA1_DIGEST_LOOP:
	crypto.sha1.digest t0, s0
	addi s0, s0, 1
	sw t0, 0(s2)
	addi s2, s2, 4
	bne s0, s1, SHA1_DIGEST_LOOP



################################################################## SHA256
	la t0, MESSAGE_LEN
	lw s0, 0(t0) # s0 is the remaining bits of the message
	la s1, MESSAGE # s1 is the address of the next word to be loaded
	li s3, 16 # Number of words per block (512/32)
	
SHA256_NEXT_BLOCK:
	li s2, 0 # s2 is current number of words loaded to the coprocessor
	
SHA256_NEXT_WORD:
	lw t0, 0(s1)
	crypto.sha256.lw s1, s2
	addi s0, s0, -32
	addi s1, s1, 4
	blez s0, SHA256_LAST
	addi s2, s2, 1
	bne s2, s3, SHA256_NEXT_WORD
	
	crypto.sha256.next
	
SHA256_WAIT_BLOCK_PROC:
	crypto.sha256.busy t0
	bnez t0, SHA256_WAIT_BLOCK_PROC
	j SHA256_NEXT_BLOCK

SHA256_LAST:
	# Calculate the numer of bits in the last block
	addi t0, s0, 32
	slli t1, s2, 5 # s2*32
	add t0, t0, t1
	
	crypto.sha256.last t0

SHA256_WAIT_LAST:
	crypto.sha256.busy t0
	bnez t0, SHA256_WAIT_LAST

# Get the message digest
	li s0, 0 # Next word from the message digest to read
	li s1, 8 # Number of 32 bits words in the message digest
	la s2, SHA256_RESULT

SHA256_DIGEST_LOOP:
	crypto.sha256.digest t0, s0
	addi s0, s0, 1
	sw t0, 0(s2)
	addi s2, s2, 4
	bne s0, s1, SHA256_DIGEST_LOOP




################################################################## SHA512
	la t0, MESSAGE_LEN
	lw s0, 0(t0) # s0 is the remaining bits of the message
	la s1, MESSAGE # s1 is the address of the next word to be loaded
	li s3, 32 # Number of words per block (1024/32)
	
SHA512_NEXT_BLOCK:
	li s2, 0 # s2 is current number of words loaded to the coprocessor
	
SHA512_NEXT_WORD:
	lw t0, 0(s1)
	crypto.sha512.lw s1, s2
	addi s0, s0, -32
	addi s1, s1, 4
	blez s0, SHA512_LAST
	addi s2, s2, 1
	bne s2, s3, SHA512_NEXT_WORD
	
	crypto.sha512.next
	
SHA512_WAIT_BLOCK_PROC:
	crypto.sha512.busy t0
	bnez t0, SHA512_WAIT_BLOCK_PROC
	j SHA512_NEXT_BLOCK

SHA512_LAST:
	# Calculate the numer of bits in the last block
	addi t0, s0, 32
	slli t1, s2, 5 # s2*32
	add t0, t0, t1
	
	crypto.sha512.last t0

SHA512_WAIT_LAST:
	crypto.sha512.busy t0
	bnez t0, SHA512_WAIT_LAST

# Get the message digest
	li s0, 0 # Next word from the message digest to read
	li s1, 16 # Number of 32 bits words in the message digest
	la s2, SHA512_RESULT
	
SHA512_DIGEST_LOOP:
	crypto.sha512.digest t0, s0
	addi s0, s0, 1
	sw t0, 0(s2)
	addi s2, s2, 4
	bne s0, s1, SHA512_DIGEST_LOOP




##################################################################
FINISH:
	li t0, 3
	sw t0, 0(zero)
	
END: j END

.data
	SHA256_RESULT: 	.space 16
	MESSAGE_LEN: 	.word 24
	MESSAGE:	.byte 0 99 98 97 # abc

.text
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
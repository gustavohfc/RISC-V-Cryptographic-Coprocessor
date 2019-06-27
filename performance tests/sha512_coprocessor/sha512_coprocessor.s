.data
	SHA512_RESULT: 	.space 16
	MESSAGE_LEN: 	.word 24
	MESSAGE:	.byte 0 99 98 97 # abc
	
.text
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

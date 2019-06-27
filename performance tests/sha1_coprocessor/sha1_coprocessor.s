.data
	SHA1_RESULT: 	.space 16
	MESSAGE_LEN: 	.word 24
	MESSAGE:	.byte 0 99 98 97 # abc

.text
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
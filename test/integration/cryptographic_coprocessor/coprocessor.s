.data
	COMM_ADDR: 	.word 0
	MD5_RESULT: 	.space 16
	SHA1_RESULT: 	.space 20
	SHA256_RESULT: 	.space 32
	SHA512_RESULT: 	.space 64
	MESSAGE_LEN: 	.space 4
	MESSAGE:

.text
# Wait for the value of the first memory address change to 1,meaning that the data was loaded
START:
	li s0, 1
	la s1, COMM_ADDR
	
WAIT_DATA_READY:
	lw t0, 0(s1)
	bne s0, t0, WAIT_DATA_READY


################################################################## MD5
	la t0, MESSAGE_LEN
	lw s0, 0(t0) # s0 is the remaining bits of the message
	la s1, MESSAGE # s1 is the address of the next word to be loaded
	li s3, 16 # Number of words per block (512/32)
	
MD5_NEXT_BLOCK:
	li s2, 0 # s2 is current number of blocks loaded to the coprocessor
	
MD5_NEXT_WORD:
	lw t0, 0(s1)
	crypto.md5.lw s1, s2
	addi s0, s0, -32
	addi s1, s1, 4
	addi s2, s2, 1
	blez s0, MD5_LAST
	bne s2, s3, MD5_NEXT_WORD
	
	crypto.md5.next
	
MD5_WAIT_BLOCK_PROC:
	crypto.md5.completed t0
	beqz  t0, MD5_WAIT_BLOCK_PROC
	j MD5_NEXT_BLOCK

MD5_LAST:
	slli t0, s2, 5 # s2*32 is the number of bits in the last block
	crypto.md5.last t0

MD5_WAIT_LAST:
	crypto.md5.completed t0
	beqz t0, MD5_WAIT_LAST

# Get the message digest
	li t0, 0
	li t1, 1
	li t2, 2
	li t3, 3
	
	crypto.md5.digest t0, t0
	crypto.md5.digest t1, t1
	crypto.md5.digest t2, t2
	crypto.md5.digest t3, t3
	
	la s0, MD5_RESULT
	sw t0, 0(s0)
	sw t1, 4(s0)
	sw t2, 8(s0)
	sw t3, 12(s0)
	

##################################################################
FINISH:
	li t0, 3
	sw t0, 0(zero)

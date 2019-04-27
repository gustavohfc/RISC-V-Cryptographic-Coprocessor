.text

# BEQ test
	add t1, zero, zero
	addi t2, zero, 1
beq_add:
	addi t1, t1, 1
	beq t1, t2, beq_add

# BNE test
	add t1, zero, zero
	addi t2, zero, 2
bne_add:
	addi t1, t1, 1
	bne t1, t2, bne_add

# BLT test
	add t1, zero, zero
	addi t2, zero, 2
blt_add:
	addi t1, t1, 1
	blt t1, t2, blt_add

# BGE test
	add t1, zero, zero
	addi t2, zero, 2
bge_add:
	addi t1, t1, 1
	bge t2, t1, bge_add
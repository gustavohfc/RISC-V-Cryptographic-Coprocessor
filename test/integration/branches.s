.data
data: .word 1 3

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
	
# Branch afeter memory stall
	addi t0, zero, 2
	la t1, data
load:	lw t2, 0(t1)
	blt t0, t2, end
	addi t1, t1, 4
	j load
	
end:
	addi s0, zero, -1

.data
N_fib:	.word 20
F1:	.word 0
F2:	.word 1

.text
	li s0, 0x2000 # TODO: It can be replaced with 'la s0, mem' when the instruction auipc is implemented
	lw s1, 0(s0)	# s1 = N_fib
	lw s2, 4(s0)	# s2 = F1
	lw s3, 8(s0)	# s3 = F2
	addi s4, s0, 12
loop:
	beq s1, zero, end

	add t0, s2, s3
	addi s2, s3, 0
	addi s3, t0, 0
	  
	sw t0, 0(s4)
	addi s4, s4, 4
    
	addi s1, s1, -1 #dec counter
	j loop

end: 

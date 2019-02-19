.data
	# Memoria
	mem: .word 0, 1, 2, 3, -1
.text	
	li s0, 0x2000 # TODO: It can be replaced with 'la s0, mem' when the instruction auipc is implemented
	lw s1, 4(s0)	# s1 = 1
	lw s2, 8(s0)	# s2 = 2
	lw s3, 12(s0)	# s3 = 3
	lw s4, 16(s0)	# s4 = -1
	addi s5, s1, 30	# s5 = 31
	sw s1, 32(s0)
	lw s1, 32(s0)
	slti s6, s4, 1	# s6 = 1
	sltiu s6, s4, 1	# s6 = 0
	xori s6, s5, 63	# s6 = 32
	ori s6, s5, 60	# s6 = 63
	andi s6, s5, 60	# s6 = 28
	slli s6, s1, 5	# s6 = 32
	srli s6, s4, 15	# s6 = 131071 (1FFFF)
	srai s6, s4, 15	# s6 = -1
	add s6, s1, s4	# s6 = 0
	add s6, s2, s3	# s6 = 5
	sub s6, s5, s4	# s6 = 32
	sll s6, s2, s3	# s6 = 16
	slt s6, s1, s4	# s6 = 0
	sltu s6, s1, s4	# s6 = 1
	xor s6, s4, s3	# s6 = -4 (FFFFFFFC)
	srl s6, s4, s3	# s6 = 536870911 (1FFFFFFF)
	sra s6, s4, s3	# s6 = -1
	or s6, s1, s2	# s6 = 3
	and s6, s1, s2	# s6 = 0
	jal s7, pulo1	# s7 = 108 (6C), pc = 124 (7C) 31
	lw s1, 36(s0)	# s1 = -1
	lw s2, 40(s0)	# s2 = 31
	lw s3, 44(s0)	# s3 = 0
	jalr s7, s8, 0	# s8 = 124 (7C), pc = 140 (8C) 35
pulo1:	
	sw s4, 36(s0)
	sw s5, 40(s0)
	sw s6, 44(s0)
	jalr s8, s7, 0	# s8 = 140 (8C), pc = 108 (6C) 27
	nop 		# data hazard tests:
	lw s1, 4(s0)	# s1 = 1
	lw s2, 8(s0)	# s2 = 2
	lw s3, 12(s0)	# s3 = 3
	add s1, s3, s2	# s1 = 5
	add s1, s1, s4	# s1 = 4
	lw s1, 0(s0)	# s1 = 1
	add s1, s1, s1	# s1 = 2
	nop		# branch tests:
	add s1, zero, zero	# s1 = 0
	addi s2, zero, 5	# s2 = 5
	
loop1:	addi s1, s1, 1	# s1++ (inside loop)
	bne s1, s2, loop1	# PC = 188 (BC) 47
	addi s1, s1, 5	# s1 = 10

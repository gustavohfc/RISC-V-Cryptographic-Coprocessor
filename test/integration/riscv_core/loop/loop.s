.data
	MEM_START:


.text
la s0, MEM_START
addi s1, s0, 64

LOOP:
sw s0, 0(s0)
addi s0, s0, 4
bne s0, s1, LOOP
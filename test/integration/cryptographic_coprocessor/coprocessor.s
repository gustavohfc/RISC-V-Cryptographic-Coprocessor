.data
	MEM_START:

.text
# Wait for the value of the first memory address change to 1,meaning that the data was loaded
START:
	li s0, 1
	la s1, MEM_START
	
WAIT_DATA_READY:
	lw t0, 0(s1)
	bne s0, t0, WAIT_DATA_READY

lw x1, 4(s1)
lw x2, 8(s1)
lw x3, 12(s1)
lw x4, 16(s1)
lw x5, 20(s1)
lw x6, 24(s1)
lw x7, 28(s1)
lw x8, 32(s1)
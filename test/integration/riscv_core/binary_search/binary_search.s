# This is a simple binary search algorithm developed with RISC-V Assembly code for RV32I
# Code created by FabioTS - https://github.com/FabioTS

### INPUT:
# First set target value at .data section to be found
# Set the array size desired, remember that the index begin at [0]
# Insert the elements of array in ascending order

### OUTPUT:
# Register x20 = Index of target located inside array
# Register x21 = Absolute address of located target
# Register x22 = Data value at located address
# Register x23 = Number of iterations taken to find target

.data
target:		.word 144
arr_size:	.word 30	# First index is 0 arr_size would be n_elements - 1
arr:		.word 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040, 1346269, 2178309

.text
	la s0, target # Load memory address offset
	
	# Load target value
	la t0, target
	lw s1, 0(t0)
		
	# Array size at t0
	la t0, arr_size
	lw t1, 0(t0)
	slli t1, t1, 2

	# Array initial address at s2 and final address at s3
	la s2, arr
	sub s2, s2, s0
	add s3, s2, t1
	
loop:
	# Assert array has minimum elements required
	blt s3, s2, fail
	addi s7, s7, 1
	
	# Find the middle element of sub array
	add t0, s2, s3
	srli t1, t0, 1
	
	# Load value to compare
	add t2, t1, s0
	jal ra, align
	lw t2, 0(t2)

	blt t2, s1, if_less
	bgt t2, s1, if_greater
	beq t2, s1, if_equal
	
	j end

if_less:
	addi s2, t1, 4
	j loop
if_greater:
	addi s3, t1, -4
	j loop
if_equal:
	la t3, arr
	sub t3, t3, s0
	sub t3, t1, t3
	srli s4, t3, 2	# Index of target located inside array
	add s5, t1, s0	# Absolute address of located target
	lw s6, 0(s5)	# Target value found
	j end
align:			# Must be optimized, maybe with "div/mod"...
	add t4, t1, zero
align2:	addi t4, t4, -4
	blt zero, t4, align2
	add t1, t1, t4 
	add t2, t2, t4 
	jr ra, 0
fail:
	li s4, -1
	j end
end:

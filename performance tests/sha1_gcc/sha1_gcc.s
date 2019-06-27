.data

addTemp: .word 0

.LC0:
	.string	"abc"
	
masks.1619:
	.byte	0
	.byte	-128
	.byte	-64
	.byte	-32
	.byte	-16
	.byte	-8
	.byte	-4
	.byte	-2
	.align	2
#	.type	markbit.1620, @object
	.size	markbit.1620, 8
markbit.1620:
	.byte	-128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.section	.rodata
	.align	2
#	.type	K.1632, @object
	.size	K.1632, 16
K.1632:
	.word	1518500249
	.word	1859775393
	.word	-1894007588
	.word	-899497514
	.ident	"GCC: (GNU) 8.3.0"
		
	.file	"sha1_gcc.c"
	.option nopic
	.text
	.local	addTemp
	.comm	addTemp,4,4
#	.align	2
	.globl	SHA1Reset
#	.type	SHA1Reset, @function


	j main
	

SHA1Reset:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	bnez	a5,.L2
	li	a5,1
	j	.L3
.L2:
	lw	a5,-20(s0)
	sw	zero,24(a5)
	lw	a5,-20(s0)
	lw	a4,24(a5)
	lw	a5,-20(s0)
	sw	a4,20(a5)
	lw	a5,-20(s0)
	sh	zero,28(a5)
	lw	a5,-20(s0)
	li	a4,1732583424
	addi	a4,a4,769
	sw	a4,0(a5)
	lw	a5,-20(s0)
	li	a4,-271732736
	addi	a4,a4,-1143
	sw	a4,4(a5)
	lw	a5,-20(s0)
	li	a4,-1732583424
	addi	a4,a4,-770
	sw	a4,8(a5)
	lw	a5,-20(s0)
	li	a4,271732736
	addi	a4,a4,1142
	sw	a4,12(a5)
	lw	a5,-20(s0)
	li	a4,-1009590272
	addi	a4,a4,496
	sw	a4,16(a5)
	lw	a5,-20(s0)
	sw	zero,96(a5)
	lw	a5,-20(s0)
	sw	zero,100(a5)
	li	a5,0
.L3:
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA1Reset, .-SHA1Reset
#	.align	2
	.globl	SHA1Input
#	.type	SHA1Input, @function
SHA1Input:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	lw	a5,-20(s0)
	bnez	a5,.L5
	li	a5,1
	j	.L6
.L5:
	lw	a5,-28(s0)
	bnez	a5,.L7
	li	a5,0
	j	.L6
.L7:
	lw	a5,-24(s0)
	bnez	a5,.L8
	li	a5,1
	j	.L6
.L8:
	lw	a5,-20(s0)
	lw	a5,96(a5)
	beqz	a5,.L9
	lw	a5,-20(s0)
	li	a4,3
	sw	a4,100(a5)
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L6
.L9:
	lw	a5,-20(s0)
	lw	a5,100(a5)
	beqz	a5,.L11
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L6
.L16:
	lw	a5,-20(s0)
	lh	a3,28(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,28(a5)
	lw	a5,-24(s0)
	lbu	a4,0(a5)
	lw	a5,-20(s0)
	add	a5,a5,a3
	sb	a4,30(a5)
	lw	a5,-20(s0)
	lw	a4,24(a5)
#	lui	a5,%hi(addTemp)
#	sw	a4,%lo(addTemp)(a5)

	la a5, addTemp
	sw a4, 0(a5)

	lw	a5,-20(s0)
	lw	a5,24(a5)
	addi	a4,a5,8
	lw	a5,-20(s0)
	sw	a4,24(a5)
	lw	a5,-20(s0)
	lw	a4,24(a5)
#	lui	a5,%hi(addTemp)
#	lw	a5,%lo(addTemp)(a5)

	la a5, addTemp
	lw a5, 0(a5)

	bgeu	a4,a5,.L12
	lw	a5,-20(s0)
	lw	a5,20(a5)
	addi	a4,a5,1
	lw	a5,-20(s0)
	sw	a4,20(a5)
	lw	a5,-20(s0)
	lw	a5,20(a5)
	beqz	a5,.L13
.L12:
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L14
.L13:
	li	a5,2
.L14:
	lw	a4,-20(s0)
	sw	a5,100(a4)
	lw	a5,-20(s0)
	lw	a5,100(a5)
	bnez	a5,.L15
	lw	a5,-20(s0)
	lh	a4,28(a5)
	li	a5,64
	bne	a4,a5,.L15
	lw	a0,-20(s0)
	call	SHA1ProcessMessageBlock
.L15:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L11:
	lw	a5,-28(s0)
	addi	a4,a5,-1
	sw	a4,-28(s0)
	bnez	a5,.L16
	lw	a5,-20(s0)
	lw	a5,100(a5)
.L6:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA1Input, .-SHA1Input
#	.align	2
	.globl	SHA1FinalBits
#	.type	SHA1FinalBits, @function
SHA1FinalBits:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	mv	a5,a1
	sw	a2,-28(s0)
	sb	a5,-21(s0)
	lw	a5,-20(s0)
	bnez	a5,.L18
	li	a5,1
	j	.L19
.L18:
	lw	a5,-28(s0)
	bnez	a5,.L20
	li	a5,0
	j	.L19
.L20:
	lw	a5,-20(s0)
	lw	a5,100(a5)
	beqz	a5,.L21
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L19
.L21:
	lw	a5,-20(s0)
	lw	a5,96(a5)
	beqz	a5,.L22
	lw	a5,-20(s0)
	li	a4,3
	sw	a4,100(a5)
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L19
.L22:
	lw	a4,-28(s0)
	li	a5,7
	bleu	a4,a5,.L23
	lw	a5,-20(s0)
	li	a4,4
	sw	a4,100(a5)
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L19
.L23:
	lw	a5,-20(s0)
	lw	a4,24(a5)
#	lui	a5,%hi(addTemp)
#	sw	a4,%lo(addTemp)(a5)
	
	la a5, addTemp
	sw a4, 0(a5)
	
	lw	a5,-20(s0)
	lw	a4,24(a5)
	lw	a5,-28(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	sw	a4,24(a5)
	lw	a5,-20(s0)
	lw	a4,24(a5)
#	lui	a5,%hi(addTemp)
#	lw	a5,%lo(addTemp)(a5)
	
	la a5, addTemp
	lw a5, 0(a5)
	
	bgeu	a4,a5,.L24
	lw	a5,-20(s0)
	lw	a5,20(a5)
	addi	a4,a5,1
	lw	a5,-20(s0)
	sw	a4,20(a5)
	lw	a5,-20(s0)
	lw	a5,20(a5)
	beqz	a5,.L25
.L24:
	lw	a5,-20(s0)
	lw	a5,100(a5)
	j	.L26
.L25:
	li	a5,2
.L26:
	lw	a4,-20(s0)
	sw	a5,100(a4)
#	lui	a5,%hi(masks.1619)
#	addi	a4,a5,%lo(masks.1619)
	
	la a4, masks.1619
	
	lw	a5,-28(s0)
	add	a5,a4,a5
	lbu	a4,0(a5)
	lbu	a5,-21(s0)
	and	a5,a4,a5
	andi	a4,a5,0xff
#	lui	a5,%hi(markbit.1620)
#	addi	a3,a5,%lo(markbit.1620)
	
	la a3, markbit.1620
	
	lw	a5,-28(s0)
	add	a5,a3,a5
	lbu	a5,0(a5)
	or	a5,a4,a5
	andi	a5,a5,0xff
	mv	a1,a5
	lw	a0,-20(s0)
	call	SHA1Finalize
	lw	a5,-20(s0)
	lw	a5,100(a5)
.L19:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA1FinalBits, .-SHA1FinalBits
#	.align	2
	.globl	SHA1Result
#	.type	SHA1Result, @function
SHA1Result:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	bnez	a5,.L28
	li	a5,1
	j	.L29
.L28:
	lw	a5,-40(s0)
	bnez	a5,.L30
	li	a5,1
	j	.L29
.L30:
	lw	a5,-36(s0)
	lw	a5,100(a5)
	beqz	a5,.L31
	lw	a5,-36(s0)
	lw	a5,100(a5)
	j	.L29
.L31:
	lw	a5,-36(s0)
	lw	a5,96(a5)
	bnez	a5,.L32
	li	a1,128
	lw	a0,-36(s0)
	call	SHA1Finalize
.L32:
	sw	zero,-20(s0)
	j	.L33
.L34:
	lw	a5,-20(s0)
	srai	a5,a5,2
	lw	a4,-36(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-20(s0)
	not	a5,a5
	andi	a5,a5,3
	slli	a5,a5,3
	srl	a3,a4,a5
	lw	a5,-20(s0)
	lw	a4,-40(s0)
	add	a5,a4,a5
	andi	a4,a3,0xff
	sb	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L33:
	lw	a4,-20(s0)
	li	a5,19
	ble	a4,a5,.L34
	li	a5,0
.L29:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra, 0
	.size	SHA1Result, .-SHA1Result
#	.align	2
#	.type	SHA1ProcessMessageBlock, @function
SHA1ProcessMessageBlock:
	addi	sp,sp,-384
	sw	s0,380(sp)
	addi	s0,sp,384
	sw	a0,-372(s0)
	sw	zero,-20(s0)
	j	.L36
.L37:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-372(s0)
	add	a5,a4,a5
	lbu	a5,30(a5)
	slli	a4,a5,24
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-348(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-348(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a5,a5,1
	lw	a3,-372(s0)
	add	a5,a3,a5
	lbu	a5,30(a5)
	slli	a5,a5,16
	or	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-348(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-348(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a5,a5,2
	lw	a3,-372(s0)
	add	a5,a3,a5
	lbu	a5,30(a5)
	slli	a5,a5,8
	or	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-348(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-348(a5)
	lw	a4,-20(s0)
	slli	a4,a4,2
	addi	a4,a4,3
	lw	a3,-372(s0)
	add	a4,a3,a4
	lbu	a4,30(a4)
	or	a4,a5,a4
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-348(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L36:
	lw	a4,-20(s0)
	li	a5,15
	ble	a4,a5,.L37
	li	a5,16
	sw	a5,-20(s0)
	j	.L38
.L39:
	lw	a5,-20(s0)
	addi	a5,a5,-3
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-348(a5)
	lw	a5,-20(s0)
	addi	a5,a5,-8
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	xor	a4,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-14
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	xor	a4,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-16
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	xor	a5,a4,a5
	slli	a3,a5,1
	srli	a4,a5,31
	or	a4,a4,a3
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-348(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L38:
	lw	a4,-20(s0)
	li	a5,79
	ble	a4,a5,.L39
	lw	a5,-372(s0)
	lw	a5,0(a5)
	sw	a5,-24(s0)
	lw	a5,-372(s0)
	lw	a5,4(a5)
	sw	a5,-28(s0)
	lw	a5,-372(s0)
	lw	a5,8(a5)
	sw	a5,-32(s0)
	lw	a5,-372(s0)
	lw	a5,12(a5)
	sw	a5,-36(s0)
	lw	a5,-372(s0)
	lw	a5,16(a5)
	sw	a5,-40(s0)
	sw	zero,-20(s0)
	j	.L40
.L41:
	lw	a5,-24(s0)
	slli	a4,a5,5
	srli	a5,a5,27
	or	a5,a5,a4
	lw	a3,-28(s0)
	lw	a4,-32(s0)
	and	a3,a3,a4
	lw	a4,-28(s0)
	not	a2,a4
	lw	a4,-36(s0)
	and	a4,a2,a4
	xor	a4,a3,a4
	add	a4,a5,a4
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	add	a4,a4,a5
#	lui	a5,%hi(K.1632)
#	lw	a5,%lo(K.1632)(a5)

	la a5, K.1632
	lw a5, 0(a5)
	
	
	add	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-40(s0)
	lw	a5,-32(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	srli	a4,a5,2
	slli	a5,a5,30
	or	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-28(s0)
	lw	a5,-44(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L40:
	lw	a4,-20(s0)
	li	a5,19
	ble	a4,a5,.L41
	li	a5,20
	sw	a5,-20(s0)
	j	.L42
.L43:
	lw	a5,-24(s0)
	slli	a4,a5,5
	srli	a5,a5,27
	or	a5,a5,a4
	lw	a3,-28(s0)
	lw	a4,-32(s0)
	xor	a3,a3,a4
	lw	a4,-36(s0)
	xor	a4,a3,a4
	add	a4,a5,a4
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	add	a4,a4,a5
#	lui	a5,%hi(K.1632)
#	addi	a5,a5,%lo(K.1632)
	
	la a5, K.1632
	
	lw	a5,4(a5)
	add	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-40(s0)
	lw	a5,-32(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	srli	a4,a5,2
	slli	a5,a5,30
	or	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-28(s0)
	lw	a5,-44(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L42:
	lw	a4,-20(s0)
	li	a5,39
	ble	a4,a5,.L43
	li	a5,40
	sw	a5,-20(s0)
	j	.L44
.L45:
	lw	a5,-24(s0)
	slli	a4,a5,5
	srli	a5,a5,27
	or	a5,a5,a4
	lw	a3,-32(s0)
	lw	a4,-36(s0)
	xor	a3,a3,a4
	lw	a4,-28(s0)
	and	a3,a3,a4
	lw	a2,-32(s0)
	lw	a4,-36(s0)
	and	a4,a2,a4
	xor	a4,a3,a4
	add	a4,a5,a4
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	add	a4,a4,a5
#	lui	a5,%hi(K.1632)
#	addi	a5,a5,%lo(K.1632)
	
	la a5, K.1632
	
	lw	a5,8(a5)
	add	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-40(s0)
	lw	a5,-32(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	srli	a4,a5,2
	slli	a5,a5,30
	or	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-28(s0)
	lw	a5,-44(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L44:
	lw	a4,-20(s0)
	li	a5,59
	ble	a4,a5,.L45
	li	a5,60
	sw	a5,-20(s0)
	j	.L46
.L47:
	lw	a5,-24(s0)
	slli	a4,a5,5
	srli	a5,a5,27
	or	a5,a5,a4
	lw	a3,-28(s0)
	lw	a4,-32(s0)
	xor	a3,a3,a4
	lw	a4,-36(s0)
	xor	a4,a3,a4
	add	a4,a5,a4
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-348(a5)
	add	a4,a4,a5
#	lui	a5,%hi(K.1632)
#	addi	a5,a5,%lo(K.1632)
	
	la a5, K.1632
	
	lw	a5,12(a5)
	add	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-40(s0)
	lw	a5,-32(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	srli	a4,a5,2
	slli	a5,a5,30
	or	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-28(s0)
	lw	a5,-44(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L46:
	lw	a4,-20(s0)
	li	a5,79
	ble	a4,a5,.L47
	lw	a5,-372(s0)
	lw	a4,0(a5)
	lw	a5,-24(s0)
	add	a4,a4,a5
	lw	a5,-372(s0)
	sw	a4,0(a5)
	lw	a5,-372(s0)
	lw	a4,4(a5)
	lw	a5,-28(s0)
	add	a4,a4,a5
	lw	a5,-372(s0)
	sw	a4,4(a5)
	lw	a5,-372(s0)
	lw	a4,8(a5)
	lw	a5,-32(s0)
	add	a4,a4,a5
	lw	a5,-372(s0)
	sw	a4,8(a5)
	lw	a5,-372(s0)
	lw	a4,12(a5)
	lw	a5,-36(s0)
	add	a4,a4,a5
	lw	a5,-372(s0)
	sw	a4,12(a5)
	lw	a5,-372(s0)
	lw	a4,16(a5)
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-372(s0)
	sw	a4,16(a5)
	lw	a5,-372(s0)
	sh	zero,28(a5)
	nop
	lw	s0,380(sp)
	addi	sp,sp,384
	jr	ra, 0
	.size	SHA1ProcessMessageBlock, .-SHA1ProcessMessageBlock
#	.align	2
#	.type	SHA1Finalize, @function
SHA1Finalize:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	mv	a5,a1
	sb	a5,-37(s0)
	lbu	a5,-37(s0)
	mv	a1,a5
	lw	a0,-36(s0)
	call	SHA1PadMessage
	sw	zero,-20(s0)
	j	.L49
.L50:
	lw	a4,-36(s0)
	lw	a5,-20(s0)
	add	a5,a4,a5
	sb	zero,30(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L49:
	lw	a4,-20(s0)
	li	a5,63
	ble	a4,a5,.L50
	lw	a5,-36(s0)
	sw	zero,20(a5)
	lw	a5,-36(s0)
	sw	zero,24(a5)
	lw	a5,-36(s0)
	li	a4,1
	sw	a4,96(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra, 0
	.size	SHA1Finalize, .-SHA1Finalize
#	.align	2
#	.type	SHA1PadMessage, @function
SHA1PadMessage:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	mv	a5,a1
	sb	a5,-21(s0)
	lw	a5,-20(s0)
	lh	a4,28(a5)
	li	a5,55
	ble	a4,a5,.L52
	lw	a5,-20(s0)
	lh	a3,28(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,28(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	lbu	a4,-21(s0)
	sb	a4,30(a5)
	j	.L53
.L54:
	lw	a5,-20(s0)
	lh	a3,28(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,28(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	sb	zero,30(a5)
.L53:
	lw	a5,-20(s0)
	lh	a4,28(a5)
	li	a5,63
	ble	a4,a5,.L54
	lw	a0,-20(s0)
	call	SHA1ProcessMessageBlock
	j	.L56
.L52:
	lw	a5,-20(s0)
	lh	a3,28(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,28(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	lbu	a4,-21(s0)
	sb	a4,30(a5)
	j	.L56
.L57:
	lw	a5,-20(s0)
	lh	a3,28(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,28(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	sb	zero,30(a5)
.L56:
	lw	a5,-20(s0)
	lh	a4,28(a5)
	li	a5,55
	ble	a4,a5,.L57
	lw	a5,-20(s0)
	lw	a5,20(a5)
	srli	a5,a5,24
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,86(a5)
	lw	a5,-20(s0)
	lw	a5,20(a5)
	srli	a5,a5,16
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,87(a5)
	lw	a5,-20(s0)
	lw	a5,20(a5)
	srli	a5,a5,8
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,88(a5)
	lw	a5,-20(s0)
	lw	a5,20(a5)
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,89(a5)
	lw	a5,-20(s0)
	lw	a5,24(a5)
	srli	a5,a5,24
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,90(a5)
	lw	a5,-20(s0)
	lw	a5,24(a5)
	srli	a5,a5,16
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,91(a5)
	lw	a5,-20(s0)
	lw	a5,24(a5)
	srli	a5,a5,8
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,92(a5)
	lw	a5,-20(s0)
	lw	a5,24(a5)
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,93(a5)
	lw	a0,-20(s0)
	call	SHA1ProcessMessageBlock
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA1PadMessage, .-SHA1PadMessage
	.section	.rodata
#	.align	2

#	.align	2
	.globl	main
#	.type	main, @function
main:
	addi	sp,sp,-176
	sw	ra,172(sp)
	sw	s0,168(sp)
	addi	s0,sp,176
	sw	a0,-164(s0)
	sw	a1,-168(s0)
#	lui	a5,%hi(.LC0)
#	addi	a5,a5,%lo(.LC0)
	
	la a5, .LC0
	
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L59
.L60:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L59:
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	bnez	a5,.L60
	addi	a5,s0,-128
	mv	a0,a5
	call	SHA1Reset
	addi	a5,s0,-128
	lw	a2,-20(s0)
	lw	a1,-24(s0)
	mv	a0,a5
	call	SHA1Input
	addi	a4,s0,-148
	addi	a5,s0,-128
	mv	a1,a4
	mv	a0,a5
	call	SHA1Result
	li	a5,0
	mv	a0,a5
	lw	ra,172(sp)
	lw	s0,168(sp)
	addi	sp,sp,176
#	jr	ra, 0
	.size	main, .-main
	.section	.sdata,"aw"
#	.align	2
#	.type	masks.1619, @object
	.size	masks.1619, 8

.data

addTemp: .word 0

.LC0:
	.string	"abc"
	
	
masks.1628:
	.byte	0
	.byte	-128
	.byte	-64
	.byte	-32
	.byte	-16
	.byte	-8
	.byte	-4
	.byte	-2
	.align	2
#	.type	markbit.1629, @object
	.size	markbit.1629, 8
markbit.1629:
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
#	.type	K.1641, @object
	.size	K.1641, 256
K.1641:
	.word	1116352408
	.word	1899447441
	.word	-1245643825
	.word	-373957723
	.word	961987163
	.word	1508970993
	.word	-1841331548
	.word	-1424204075
	.word	-670586216
	.word	310598401
	.word	607225278
	.word	1426881987
	.word	1925078388
	.word	-2132889090
	.word	-1680079193
	.word	-1046744716
	.word	-459576895
	.word	-272742522
	.word	264347078
	.word	604807628
	.word	770255983
	.word	1249150122
	.word	1555081692
	.word	1996064986
	.word	-1740746414
	.word	-1473132947
	.word	-1341970488
	.word	-1084653625
	.word	-958395405
	.word	-710438585
	.word	113926993
	.word	338241895
	.word	666307205
	.word	773529912
	.word	1294757372
	.word	1396182291
	.word	1695183700
	.word	1986661051
	.word	-2117940946
	.word	-1838011259
	.word	-1564481375
	.word	-1474664885
	.word	-1035236496
	.word	-949202525
	.word	-778901479
	.word	-694614492
	.word	-200395387
	.word	275423344
	.word	430227734
	.word	506948616
	.word	659060556
	.word	883997877
	.word	958139571
	.word	1322822218
	.word	1537002063
	.word	1747873779
	.word	1955562222
	.word	2024104815
	.word	-2067236844
	.word	-1933114872
	.word	-1866530822
	.word	-1538233109
	.word	-1090935817
	.word	-965641998
	.ident	"GCC: (GNU) 8.3.0"
	
	

	
	.file	"sha256_gcc.c"
	.option nopic
	.text
	.local	addTemp
	.comm	addTemp,4,4
	.data
	.align	2
#	.type	SHA224_H0, @object
	.size	SHA224_H0, 32
	
SHA224_H0:
	.word	-1056596264
	.word	914150663
	.word	812702999
	.word	-150054599
	.word	-4191439
	.word	1750603025
	.word	1694076839
	.word	-1090891868
#	.align	2
#	.type	SHA256_H0, @object
	.size	SHA256_H0, 32
SHA256_H0:
	.word	1779033703
	.word	-1150833019
	.word	1013904242
	.word	-1521486534
	.word	1359893119
	.word	-1694144372
	.word	528734635
	.word	1541459225
	.text
#	.align	2
	.globl	SHA256Reset
#	.type	SHA256Reset, @function



	j main


SHA256Reset:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
#	lui	a5,%hi(SHA256_H0)
#	addi	a1,a5,%lo(SHA256_H0)
	
	la a1, SHA256_H0
	
	lw	a0,-20(s0)
	call	SHA224_256Reset
	mv	a5,a0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA256Reset, .-SHA256Reset
#	.align	2
	.globl	SHA256Input
#	.type	SHA256Input, @function
SHA256Input:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	lw	a5,-20(s0)
	bnez	a5,.L4
	li	a5,1
	j	.L5
.L4:
	lw	a5,-28(s0)
	bnez	a5,.L6
	li	a5,0
	j	.L5
.L6:
	lw	a5,-24(s0)
	bnez	a5,.L7
	li	a5,1
	j	.L5
.L7:
	lw	a5,-20(s0)
	lw	a5,108(a5)
	beqz	a5,.L8
	lw	a5,-20(s0)
	li	a4,3
	sw	a4,112(a5)
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L5
.L8:
	lw	a5,-20(s0)
	lw	a5,112(a5)
	beqz	a5,.L10
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L5
.L15:
	lw	a5,-20(s0)
	lh	a3,40(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,40(a5)
	lw	a5,-24(s0)
	lbu	a4,0(a5)
	lw	a5,-20(s0)
	add	a5,a5,a3
	sb	a4,42(a5)
	lw	a5,-20(s0)
	lw	a4,36(a5)
#	lui	a5,%hi(addTemp)
#	sw	a4,%lo(addTemp)(a5)

	la a5, addTemp
	sw a4, 0(a5)
	
	lw	a5,-20(s0)
	lw	a5,36(a5)
	addi	a4,a5,8
	lw	a5,-20(s0)
	sw	a4,36(a5)
	lw	a5,-20(s0)
	lw	a4,36(a5)
#	lui	a5,%hi(addTemp)
#	lw	a5,%lo(addTemp)(a5)
	
	la a5, addTemp
	lw a5, 0(a5)
	
	bgeu	a4,a5,.L11
	lw	a5,-20(s0)
	lw	a5,32(a5)
	addi	a4,a5,1
	lw	a5,-20(s0)
	sw	a4,32(a5)
	lw	a5,-20(s0)
	lw	a5,32(a5)
	beqz	a5,.L12
.L11:
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L13
.L12:
	li	a5,2
.L13:
	lw	a4,-20(s0)
	sw	a5,112(a4)
	lw	a5,-20(s0)
	lw	a5,112(a5)
	bnez	a5,.L14
	lw	a5,-20(s0)
	lh	a4,40(a5)
	li	a5,64
	bne	a4,a5,.L14
	lw	a0,-20(s0)
	call	SHA224_256ProcessMessageBlock
.L14:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L10:
	lw	a5,-28(s0)
	addi	a4,a5,-1
	sw	a4,-28(s0)
	bnez	a5,.L15
	lw	a5,-20(s0)
	lw	a5,112(a5)
.L5:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA256Input, .-SHA256Input
#	.align	2
	.globl	SHA256FinalBits
#	.type	SHA256FinalBits, @function
SHA256FinalBits:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	mv	a5,a1
	sw	a2,-28(s0)
	sb	a5,-21(s0)
	lw	a5,-20(s0)
	bnez	a5,.L17
	li	a5,1
	j	.L18
.L17:
	lw	a5,-28(s0)
	bnez	a5,.L19
	li	a5,0
	j	.L18
.L19:
	lw	a5,-20(s0)
	lw	a5,112(a5)
	beqz	a5,.L20
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L18
.L20:
	lw	a5,-20(s0)
	lw	a5,108(a5)
	beqz	a5,.L21
	lw	a5,-20(s0)
	li	a4,3
	sw	a4,112(a5)
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L18
.L21:
	lw	a4,-28(s0)
	li	a5,7
	bleu	a4,a5,.L22
	lw	a5,-20(s0)
	li	a4,4
	sw	a4,112(a5)
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L18
.L22:
	lw	a5,-20(s0)
	lw	a4,36(a5)
#	lui	a5,%hi(addTemp)
#	sw	a4,%lo(addTemp)(a5)
	
	la a5, addTemp
	sw a4, 0(a5)
	
	lw	a5,-20(s0)
	lw	a4,36(a5)
	lw	a5,-28(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	sw	a4,36(a5)
	lw	a5,-20(s0)
	lw	a4,36(a5)
#	lui	a5,%hi(addTemp)
#	lw	a5,%lo(addTemp)(a5)
	
	la a5, addTemp
	lw a5, 0(a5)
	
	bgeu	a4,a5,.L23
	lw	a5,-20(s0)
	lw	a5,32(a5)
	addi	a4,a5,1
	lw	a5,-20(s0)
	sw	a4,32(a5)
	lw	a5,-20(s0)
	lw	a5,32(a5)
	beqz	a5,.L24
.L23:
	lw	a5,-20(s0)
	lw	a5,112(a5)
	j	.L25
.L24:
	li	a5,2
.L25:
	lw	a4,-20(s0)
	sw	a5,112(a4)
#	lui	a5,%hi(masks.1628)
#	addi	a4,a5,%lo(masks.1628)
	
	la a4, masks.1628
	
	lw	a5,-28(s0)
	add	a5,a4,a5
	lbu	a4,0(a5)
	lbu	a5,-21(s0)
	and	a5,a4,a5
	andi	a4,a5,0xff
#	lui	a5,%hi(markbit.1629)
#	addi	a3,a5,%lo(markbit.1629)
	
	la a3, markbit.1629
	
	lw	a5,-28(s0)
	add	a5,a3,a5
	lbu	a5,0(a5)
	or	a5,a4,a5
	andi	a5,a5,0xff
	mv	a1,a5
	lw	a0,-20(s0)
	call	SHA224_256Finalize
	lw	a5,-20(s0)
	lw	a5,112(a5)
.L18:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA256FinalBits, .-SHA256FinalBits
#	.align	2
	.globl	SHA256Result
#	.type	SHA256Result, @function
SHA256Result:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	li	a2,32
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	SHA224_256ResultN
	mv	a5,a0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA256Result, .-SHA256Result
#	.align	2
#	.type	SHA224_256Reset, @function
SHA224_256Reset:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-20(s0)
	bnez	a5,.L29
	li	a5,1
	j	.L30
.L29:
	lw	a5,-20(s0)
	sw	zero,36(a5)
	lw	a5,-20(s0)
	lw	a4,36(a5)
	lw	a5,-20(s0)
	sw	a4,32(a5)
	lw	a5,-20(s0)
	sh	zero,40(a5)
	lw	a5,-24(s0)
	lw	a4,0(a5)
	lw	a5,-20(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	lw	a4,4(a5)
	lw	a5,-20(s0)
	sw	a4,4(a5)
	lw	a5,-24(s0)
	lw	a4,8(a5)
	lw	a5,-20(s0)
	sw	a4,8(a5)
	lw	a5,-24(s0)
	lw	a4,12(a5)
	lw	a5,-20(s0)
	sw	a4,12(a5)
	lw	a5,-24(s0)
	lw	a4,16(a5)
	lw	a5,-20(s0)
	sw	a4,16(a5)
	lw	a5,-24(s0)
	lw	a4,20(a5)
	lw	a5,-20(s0)
	sw	a4,20(a5)
	lw	a5,-24(s0)
	lw	a4,24(a5)
	lw	a5,-20(s0)
	sw	a4,24(a5)
	lw	a5,-24(s0)
	lw	a4,28(a5)
	lw	a5,-20(s0)
	sw	a4,28(a5)
	lw	a5,-20(s0)
	sw	zero,108(a5)
	lw	a5,-20(s0)
	sw	zero,112(a5)
	li	a5,0
.L30:
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA224_256Reset, .-SHA224_256Reset
#	.align	2
#	.type	SHA224_256ProcessMessageBlock, @function
SHA224_256ProcessMessageBlock:
	addi	sp,sp,-336
	sw	s0,332(sp)
	addi	s0,sp,336
	sw	a0,-324(s0)
	sw	zero,-24(s0)
	lw	a5,-24(s0)
	sw	a5,-20(s0)
	j	.L32
.L33:
	lw	a4,-324(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	lbu	a5,42(a5)
	slli	a4,a5,24
	lw	a5,-24(s0)
	addi	a5,a5,1
	lw	a3,-324(s0)
	add	a5,a3,a5
	lbu	a5,42(a5)
	slli	a5,a5,16
	or	a4,a4,a5
	lw	a5,-24(s0)
	addi	a5,a5,2
	lw	a3,-324(s0)
	add	a5,a3,a5
	lbu	a5,42(a5)
	slli	a5,a5,8
	or	a5,a4,a5
	lw	a4,-24(s0)
	addi	a4,a4,3
	lw	a3,-324(s0)
	add	a4,a3,a4
	lbu	a4,42(a4)
	or	a4,a5,a4
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-304(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,4
	sw	a5,-24(s0)
.L32:
	lw	a4,-20(s0)
	li	a5,15
	ble	a4,a5,.L33
	li	a5,16
	sw	a5,-20(s0)
	j	.L34
.L35:
	lw	a5,-20(s0)
	addi	a5,a5,-2
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-304(a5)
	slli	a3,a5,15
	srli	a4,a5,17
	or	a4,a4,a3
	lw	a5,-20(s0)
	addi	a5,a5,-2
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-304(a5)
	slli	a3,a5,13
	srli	a5,a5,19
	or	a5,a5,a3
	xor	a4,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-2
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-304(a5)
	srli	a5,a5,10
	xor	a4,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-7
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-304(a5)
	add	a3,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-15
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-304(a5)
	srli	a2,a5,7
	slli	a4,a5,25
	or	a4,a4,a2
	lw	a5,-20(s0)
	addi	a5,a5,-15
	slli	a5,a5,2
	addi	a2,s0,-16
	add	a5,a2,a5
	lw	a5,-304(a5)
	slli	a2,a5,14
	srli	a5,a5,18
	or	a5,a5,a2
	xor	a4,a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-15
	slli	a5,a5,2
	addi	a2,s0,-16
	add	a5,a2,a5
	lw	a5,-304(a5)
	srli	a5,a5,3
	xor	a5,a4,a5
	add	a4,a3,a5
	lw	a5,-20(s0)
	addi	a5,a5,-16
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-304(a5)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-304(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L34:
	lw	a4,-20(s0)
	li	a5,63
	ble	a4,a5,.L35
	lw	a5,-324(s0)
	lw	a5,0(a5)
	sw	a5,-28(s0)
	lw	a5,-324(s0)
	lw	a5,4(a5)
	sw	a5,-32(s0)
	lw	a5,-324(s0)
	lw	a5,8(a5)
	sw	a5,-36(s0)
	lw	a5,-324(s0)
	lw	a5,12(a5)
	sw	a5,-40(s0)
	lw	a5,-324(s0)
	lw	a5,16(a5)
	sw	a5,-44(s0)
	lw	a5,-324(s0)
	lw	a5,20(a5)
	sw	a5,-48(s0)
	lw	a5,-324(s0)
	lw	a5,24(a5)
	sw	a5,-52(s0)
	lw	a5,-324(s0)
	lw	a5,28(a5)
	sw	a5,-56(s0)
	sw	zero,-20(s0)
	j	.L36
.L37:
	lw	a5,-44(s0)
	srli	a3,a5,6
	slli	a4,a5,26
	or	a4,a4,a3
	lw	a5,-44(s0)
	srli	a3,a5,11
	slli	a5,a5,21
	or	a5,a5,a3
	xor	a4,a4,a5
	lw	a5,-44(s0)
	slli	a3,a5,7
	srli	a5,a5,25
	or	a5,a5,a3
	xor	a4,a4,a5
	lw	a5,-56(s0)
	add	a4,a4,a5
	lw	a3,-44(s0)
	lw	a5,-48(s0)
	and	a3,a3,a5
	lw	a5,-44(s0)
	not	a2,a5
	lw	a5,-52(s0)
	and	a5,a2,a5
	xor	a5,a3,a5
	add	a4,a4,a5
#	lui	a5,%hi(K.1641)
	lw	a3,-20(s0)
	slli	a3,a3,2
#	addi	a5,a5,%lo(K.1641)
	
	la a5, K.1641
	
	add	a5,a3,a5
	lw	a5,0(a5)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-304(a5)
	add	a5,a4,a5
	sw	a5,-60(s0)
	lw	a5,-28(s0)
	srli	a3,a5,2
	slli	a4,a5,30
	or	a4,a4,a3
	lw	a5,-28(s0)
	srli	a3,a5,13
	slli	a5,a5,19
	or	a5,a5,a3
	xor	a4,a4,a5
	lw	a5,-28(s0)
	slli	a3,a5,10
	srli	a5,a5,22
	or	a5,a5,a3
	xor	a4,a4,a5
	lw	a3,-32(s0)
	lw	a5,-36(s0)
	xor	a3,a3,a5
	lw	a5,-28(s0)
	and	a3,a3,a5
	lw	a2,-32(s0)
	lw	a5,-36(s0)
	and	a5,a2,a5
	xor	a5,a3,a5
	add	a5,a4,a5
	sw	a5,-64(s0)
	lw	a5,-52(s0)
	sw	a5,-56(s0)
	lw	a5,-48(s0)
	sw	a5,-52(s0)
	lw	a5,-44(s0)
	sw	a5,-48(s0)
	lw	a4,-40(s0)
	lw	a5,-60(s0)
	add	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-36(s0)
	sw	a5,-40(s0)
	lw	a5,-32(s0)
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	sw	a5,-32(s0)
	lw	a4,-60(s0)
	lw	a5,-64(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L36:
	lw	a4,-20(s0)
	li	a5,63
	ble	a4,a5,.L37
	lw	a5,-324(s0)
	lw	a4,0(a5)
	lw	a5,-28(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,0(a5)
	lw	a5,-324(s0)
	lw	a4,4(a5)
	lw	a5,-32(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,4(a5)
	lw	a5,-324(s0)
	lw	a4,8(a5)
	lw	a5,-36(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,8(a5)
	lw	a5,-324(s0)
	lw	a4,12(a5)
	lw	a5,-40(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,12(a5)
	lw	a5,-324(s0)
	lw	a4,16(a5)
	lw	a5,-44(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,16(a5)
	lw	a5,-324(s0)
	lw	a4,20(a5)
	lw	a5,-48(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,20(a5)
	lw	a5,-324(s0)
	lw	a4,24(a5)
	lw	a5,-52(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,24(a5)
	lw	a5,-324(s0)
	lw	a4,28(a5)
	lw	a5,-56(s0)
	add	a4,a4,a5
	lw	a5,-324(s0)
	sw	a4,28(a5)
	lw	a5,-324(s0)
	sh	zero,40(a5)
	nop
	lw	s0,332(sp)
	addi	sp,sp,336
	jr	ra, 0
	.size	SHA224_256ProcessMessageBlock, .-SHA224_256ProcessMessageBlock
#	.align	2
#	.type	SHA224_256Finalize, @function
SHA224_256Finalize:
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
	call	SHA224_256PadMessage
	sw	zero,-20(s0)
	j	.L39
.L40:
	lw	a4,-36(s0)
	lw	a5,-20(s0)
	add	a5,a4,a5
	sb	zero,42(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L39:
	lw	a4,-20(s0)
	li	a5,63
	ble	a4,a5,.L40
	lw	a5,-36(s0)
	sw	zero,32(a5)
	lw	a5,-36(s0)
	sw	zero,36(a5)
	lw	a5,-36(s0)
	li	a4,1
	sw	a4,108(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra, 0
	.size	SHA224_256Finalize, .-SHA224_256Finalize
#	.align	2
#	.type	SHA224_256PadMessage, @function
SHA224_256PadMessage:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	mv	a5,a1
	sb	a5,-21(s0)
	lw	a5,-20(s0)
	lh	a4,40(a5)
	li	a5,55
	ble	a4,a5,.L42
	lw	a5,-20(s0)
	lh	a3,40(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,40(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	lbu	a4,-21(s0)
	sb	a4,42(a5)
	j	.L43
.L44:
	lw	a5,-20(s0)
	lh	a3,40(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,40(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	sb	zero,42(a5)
.L43:
	lw	a5,-20(s0)
	lh	a4,40(a5)
	li	a5,63
	ble	a4,a5,.L44
	lw	a0,-20(s0)
	call	SHA224_256ProcessMessageBlock
	j	.L46
.L42:
	lw	a5,-20(s0)
	lh	a3,40(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,40(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	lbu	a4,-21(s0)
	sb	a4,42(a5)
	j	.L46
.L47:
	lw	a5,-20(s0)
	lh	a3,40(a5)
	slli	a5,a3,16
	srli	a5,a5,16
	addi	a5,a5,1
	slli	a5,a5,16
	srli	a5,a5,16
	slli	a4,a5,16
	srai	a4,a4,16
	lw	a5,-20(s0)
	sh	a4,40(a5)
	mv	a4,a3
	lw	a5,-20(s0)
	add	a5,a5,a4
	sb	zero,42(a5)
.L46:
	lw	a5,-20(s0)
	lh	a4,40(a5)
	li	a5,55
	ble	a4,a5,.L47
	lw	a5,-20(s0)
	lw	a5,32(a5)
	srli	a5,a5,24
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,98(a5)
	lw	a5,-20(s0)
	lw	a5,32(a5)
	srli	a5,a5,16
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,99(a5)
	lw	a5,-20(s0)
	lw	a5,32(a5)
	srli	a5,a5,8
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,100(a5)
	lw	a5,-20(s0)
	lw	a5,32(a5)
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,101(a5)
	lw	a5,-20(s0)
	lw	a5,36(a5)
	srli	a5,a5,24
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,102(a5)
	lw	a5,-20(s0)
	lw	a5,36(a5)
	srli	a5,a5,16
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,103(a5)
	lw	a5,-20(s0)
	lw	a5,36(a5)
	srli	a5,a5,8
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,104(a5)
	lw	a5,-20(s0)
	lw	a5,36(a5)
	andi	a4,a5,0xff
	lw	a5,-20(s0)
	sb	a4,105(a5)
	lw	a0,-20(s0)
	call	SHA224_256ProcessMessageBlock
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra, 0
	.size	SHA224_256PadMessage, .-SHA224_256PadMessage
#	.align	2
#	.type	SHA224_256ResultN, @function
SHA224_256ResultN:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	bnez	a5,.L49
	li	a5,1
	j	.L50
.L49:
	lw	a5,-40(s0)
	bnez	a5,.L51
	li	a5,1
	j	.L50
.L51:
	lw	a5,-36(s0)
	lw	a5,112(a5)
	beqz	a5,.L52
	lw	a5,-36(s0)
	lw	a5,112(a5)
	j	.L50
.L52:
	lw	a5,-36(s0)
	lw	a5,108(a5)
	bnez	a5,.L53
	li	a1,128
	lw	a0,-36(s0)
	call	SHA224_256Finalize
.L53:
	sw	zero,-20(s0)
	j	.L54
.L55:
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
.L54:
	lw	a4,-20(s0)
	lw	a5,-44(s0)
	blt	a4,a5,.L55
	li	a5,0
.L50:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra, 0
	.size	SHA224_256ResultN, .-SHA224_256ResultN
	.section	.rodata
#	.align	2
#.LC0:
#	.string	"abc"
#	.text
#	.align	2
	.globl	main
#	.type	main, @function
main:
	addi	sp,sp,-192
	sw	ra,188(sp)
	sw	s0,184(sp)
	addi	s0,sp,192
	sw	a0,-180(s0)
	sw	a1,-184(s0)
#	lui	a5,%hi(.LC0)
#	addi	a5,a5,%lo(.LC0)
	
	la a5, .LC0
	
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L57
.L58:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L57:
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	add	a5,a4,a5
	lbu	a5,0(a5)
	bnez	a5,.L58
	addi	a5,s0,-140
	mv	a0,a5
	call	SHA256Reset
	addi	a5,s0,-140
	lw	a2,-20(s0)
	lw	a1,-24(s0)
	mv	a0,a5
	call	SHA256Input
	addi	a4,s0,-172
	addi	a5,s0,-140
	mv	a1,a4
	mv	a0,a5
	call	SHA256Result
	li	a5,0
	mv	a0,a5
	lw	ra,188(sp)
	lw	s0,184(sp)
	addi	sp,sp,192
	#jr	ra, 0
	.size	main, .-main
	.section	.sdata,"aw"
#	.align	2
#	.type	masks.1628, @object
#	.size	masks.1628, 8


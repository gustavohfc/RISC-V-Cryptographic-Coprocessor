	.file	"sha1_gcc.c"
	.option nopic
	.text
	.align	2
	.type	SHA1ProcessMessageBlock, @function
SHA1ProcessMessageBlock:
	addi	sp,sp,-400
	lbu	a1,35(a0)
	lbu	t3,34(a0)
	sw	s2,388(sp)
	lbu	t6,30(a0)
	lbu	t4,31(a0)
	lbu	t1,38(a0)
	lbu	a7,42(a0)
	lbu	a6,46(a0)
	lbu	s2,50(a0)
	sw	s0,396(sp)
	sw	s1,392(sp)
	sw	s3,384(sp)
	sw	s6,372(sp)
	lbu	s3,37(a0)
	lbu	s6,53(a0)
	sw	s7,368(sp)
	sw	s8,364(sp)
	lbu	s7,49(a0)
	lbu	s8,45(a0)
	sw	s9,360(sp)
	lbu	s1,39(a0)
	lbu	s9,41(a0)
	lbu	s0,43(a0)
	lbu	t2,47(a0)
	lbu	t0,51(a0)
	sw	s4,380(sp)
	sw	s5,376(sp)
	lbu	s4,32(a0)
	lbu	s5,33(a0)
	sw	s10,356(sp)
	sw	s11,352(sp)
	lbu	t5,36(a0)
	slli	t3,t3,24
	lbu	a2,40(a0)
	slli	a1,a1,16
	lbu	a3,44(a0)
	lbu	a4,48(a0)
	lbu	a5,52(a0)
	slli	t4,t4,16
	slli	t1,t1,24
	slli	a7,a7,24
	slli	a6,a6,24
	slli	s2,s2,24
	or	a1,a1,t3
	slli	t6,t6,24
	or	t6,t6,t4
	or	t3,a7,s8
	or	t4,t1,s9
	or	a7,s2,s6
	or	t1,a6,s7
	slli	s1,s1,16
	slli	s0,s0,16
	slli	t2,t2,16
	slli	t0,t0,16
	or	a1,a1,s3
	lbu	s3,60(a0)
	or	a6,t6,s5
	or	t4,t4,s1
	slli	t6,s4,8
	or	t3,t3,s0
	or	t1,t1,t2
	or	a7,a7,t0
	slli	t5,t5,8
	slli	a2,a2,8
	slli	a3,a3,8
	slli	a4,a4,8
	slli	a5,a5,8
	or	a6,a6,t6
	or	a1,a1,t5
	or	a2,t4,a2
	or	a3,t3,a3
	or	a4,t1,a4
	or	a5,a7,a5
	lbu	s2,54(a0)
	lbu	s11,57(a0)
	sw	a6,32(sp)
	sw	a1,36(sp)
	lbu	a7,55(a0)
	lbu	s1,58(a0)
	lbu	s0,62(a0)
	lbu	t2,66(a0)
	lbu	t0,70(a0)
	lbu	t6,74(a0)
	lbu	s10,61(a0)
	lbu	a6,59(a0)
	lbu	s9,65(a0)
	lbu	t5,63(a0)
	lbu	s8,69(a0)
	lbu	t4,67(a0)
	lbu	s7,73(a0)
	lbu	t3,71(a0)
	lbu	s6,77(a0)
	lbu	t1,75(a0)
	lbu	a1,78(a0)
	lbu	s5,56(a0)
	sw	s3,8(sp)
	sw	a2,40(sp)
	sw	a3,44(sp)
	sw	a4,48(sp)
	sw	a5,52(sp)
	lbu	s4,64(a0)
	lbu	s3,68(a0)
	slli	s1,s1,24
	sw	s4,12(sp)
	sw	s3,16(sp)
	lbu	s4,72(a0)
	lbu	s3,76(a0)
	slli	a6,a6,16
	or	s1,s1,s10
	or	s1,s1,a6
	slli	t6,t6,24
	lw	a6,8(sp)
	sw	s4,20(sp)
	sw	s3,24(sp)
	lbu	s4,81(a0)
	or	s6,t6,s6
	slli	t1,t1,16
	slli	s2,s2,24
	or	s2,s2,s11
	or	s6,s6,t1
	slli	a7,a7,16
	lw	t1,24(sp)
	or	a7,s2,a7
	slli	t2,t2,24
	slli	s2,a6,8
	lw	a6,12(sp)
	sw	s4,28(sp)
	or	t2,t2,s8
	slli	s0,s0,24
	slli	t0,t0,24
	slli	t4,t4,16
	lbu	s4,79(a0)
	or	s0,s0,s9
	or	t0,t0,s7
	or	t4,t2,t4
	slli	t5,t5,16
	slli	t2,t1,8
	slli	t3,t3,16
	lw	t1,28(sp)
	or	t3,t0,t3
	lbu	s3,80(a0)
	or	t5,s0,t5
	lw	t0,20(sp)
	slli	s0,a6,8
	lw	a6,16(sp)
	slli	a1,a1,24
	or	a1,a1,t1
	slli	s4,s4,16
	slli	a6,a6,8
	slli	t0,t0,8
	slli	s3,s3,8
	slli	t6,s5,8
	or	a1,a1,s4
	or	t4,t4,a6
	or	a1,a1,s3
	or	a6,s6,t2
	or	t6,a7,t6
	or	a7,t3,t0
	or	t1,s1,s2
	or	t5,t5,s0
	sw	a7,72(sp)
	sw	a6,76(sp)
	sw	a1,80(sp)
	lbu	a7,86(a0)
	lbu	a1,82(a0)
	lbu	a6,90(a0)
	sw	t5,64(sp)
	sw	t4,68(sp)
	lbu	s3,85(a0)
	lbu	s0,83(a0)
	lbu	s2,89(a0)
	lbu	t2,87(a0)
	sw	t6,56(sp)
	sw	t1,60(sp)
	lbu	s1,93(a0)
	lbu	t0,91(a0)
	lbu	t5,84(a0)
	lbu	t4,88(a0)
	lbu	t3,92(a0)
	slli	a1,a1,24
	slli	a7,a7,24
	slli	a6,a6,24
	slli	s0,s0,16
	or	a1,a1,s3
	or	a7,a7,s2
	slli	t2,t2,16
	or	a6,a6,s1
	slli	t0,t0,16
	or	a1,a1,s0
	slli	t4,t4,8
	slli	t3,t3,8
	slli	t5,t5,8
	or	a7,a7,t2
	or	a6,a6,t0
	or	a7,a7,t4
	or	a6,a6,t3
	or	a1,a1,t5
	sw	a1,84(sp)
	sw	a7,88(sp)
	sw	a6,92(sp)
	addi	t3,sp,32
	li	t4,16
	li	s0,79
.L2:
	lw	t2,32(t3)
	lw	t0,36(t3)
	lw	t5,40(t3)
	lw	s1,8(t3)
	lw	s3,0(t3)
	lw	s2,4(t3)
	xor	a1,a1,a2
	xor	a3,a3,a7
	xor	a4,a4,a6
	xor	a1,a1,t2
	xor	a3,a3,t0
	xor	a4,a4,t5
	xor	a4,a4,s1
	xor	a3,a3,s2
	xor	a1,a1,s3
	slli	a2,a3,1
	slli	s1,a1,1
	srli	a7,a3,31
	srli	a6,a4,31
	slli	a3,a4,1
	srli	a1,a1,31
	or	a7,a7,a2
	or	a6,a6,a3
	or	a1,a1,s1
	sw	a1,64(t3)
	sw	a7,68(t3)
	sw	a6,72(t3)
	addi	t4,t4,3
	mv	a2,a5
	mv	a3,t6
	mv	a4,t1
	addi	t3,t3,12
	mv	a5,t2
	mv	t6,t0
	mv	t1,t5
	bne	t4,s0,.L2
	lw	a4,316(sp)
	lw	a5,336(sp)
	lw	t2,0(a0)
	lw	t0,4(a0)
	xor	a5,a5,a4
	lw	a4,292(sp)
	lw	t6,8(a0)
	lw	t5,12(a0)
	xor	a5,a5,a4
	lw	a4,284(sp)
	lw	t4,16(a0)
	addi	s2,sp,112
	xor	a5,a5,a4
	slli	a4,a5,1
	srli	a5,a5,31
	or	a5,a4,a5
	sw	a5,348(sp)
	li	a5,1518501888
	addi	s0,sp,32
	mv	s1,t4
	mv	t1,t5
	mv	a6,t6
	mv	t3,t0
	mv	a3,t2
	addi	a7,a5,-1639
	j	.L3
.L7:
	mv	t1,a6
	mv	a3,a5
	mv	a6,a1
.L3:
	slli	a5,a3,5
	srli	a1,a3,27
	lw	s3,0(s0)
	mv	a4,a5
	not	a2,t3
	or	a5,a4,a1
	add	a5,a5,a7
	and	a1,t3,a6
	and	a4,a2,t1
	xor	a4,a4,a1
	add	a5,a5,s3
	srli	a2,t3,2
	slli	a1,t3,30
	add	a5,a4,a5
	addi	s0,s0,4
	add	a5,a5,s1
	or	a1,a1,a2
	mv	t3,a3
	mv	s1,t1
	bne	s2,s0,.L7
	li	s1,1859776512
	mv	a4,a5
	addi	t3,sp,112
	addi	s2,sp,192
	addi	s1,s1,-1119
	j	.L4
.L8:
	mv	a6,a1
	mv	a4,a5
	mv	a1,a7
.L4:
	slli	a2,a4,5
	mv	a7,a2
	srli	s0,a4,27
	xor	a5,a3,a1
	lw	s3,0(t3)
	or	a2,a7,s0
	add	a2,a2,s1
	xor	a5,a5,a6
	add	a5,a5,a2
	slli	a7,a3,30
	srli	a2,a3,2
	add	a5,a5,s3
	addi	t3,t3,4
	add	a5,a5,t1
	or	a7,a7,a2
	mv	a3,a4
	mv	t1,a6
	bne	s2,t3,.L8
	li	s1,-1894006784
	addi	s0,sp,192
	addi	s2,sp,272
	addi	s1,s1,-804
	mv	t3,a4
	j	.L5
.L9:
	mv	a1,a7
	mv	a5,a4
	mv	a7,t1
.L5:
	slli	a2,a5,5
	lw	s4,0(s0)
	mv	t1,a2
	srli	s3,a5,27
	or	a2,t1,s3
	xor	a3,a7,a1
	and	a3,a3,t3
	add	a2,a2,s1
	and	a4,a7,a1
	xor	a4,a3,a4
	add	a3,a2,s4
	slli	t1,t3,30
	srli	a2,t3,2
	add	a4,a4,a3
	addi	s0,s0,4
	add	a4,a4,a6
	or	t1,t1,a2
	mv	t3,a5
	mv	a6,a1
	bne	s2,s0,.L9
	li	s2,-899497984
	mv	a3,a4
	addi	s0,sp,272
	addi	t3,sp,352
	addi	s2,s2,470
	mv	a6,a5
	j	.L6
.L10:
	mv	a7,t1
	mv	a3,a5
	mv	t1,a2
.L6:
	slli	a4,a3,5
	mv	a2,a4
	srli	s1,a3,27
	xor	a5,a6,t1
	lw	s3,0(s0)
	or	a4,a2,s1
	add	a4,a4,s2
	xor	a5,a5,a7
	add	a5,a5,a4
	slli	a2,a6,30
	srli	a4,a6,2
	add	a5,a5,s3
	addi	s0,s0,4
	add	a5,a5,a1
	or	a2,a2,a4
	mv	a6,a3
	mv	a1,a7
	bne	t3,s0,.L10
	lw	s0,396(sp)
	add	a5,t2,a5
	add	a3,t0,a3
	add	t6,t6,a2
	add	t1,t5,t1
	add	a7,t4,a7
	sw	a5,0(a0)
	sw	a3,4(a0)
	sw	t6,8(a0)
	sw	t1,12(a0)
	sw	a7,16(a0)
	sh	zero,28(a0)
	lw	s1,392(sp)
	lw	s2,388(sp)
	lw	s3,384(sp)
	lw	s4,380(sp)
	lw	s5,376(sp)
	lw	s6,372(sp)
	lw	s7,368(sp)
	lw	s8,364(sp)
	lw	s9,360(sp)
	lw	s10,356(sp)
	lw	s11,352(sp)
	addi	sp,sp,400
	jr	ra
	.size	SHA1ProcessMessageBlock, .-SHA1ProcessMessageBlock
	.align	2
	.globl	SHA1Reset
	.type	SHA1Reset, @function
SHA1Reset:
	beqz	a0,.L16
	li	a5,1732583424
	addi	a5,a5,769
	sw	a5,0(a0)
	li	a5,-271732736
	addi	a5,a5,-1143
	sw	a5,4(a0)
	li	a5,-1732583424
	addi	a5,a5,-770
	sw	a5,8(a0)
	li	a5,271732736
	addi	a5,a5,1142
	sw	a5,12(a0)
	li	a5,-1009590272
	addi	a5,a5,496
	sw	zero,24(a0)
	sw	zero,20(a0)
	sh	zero,28(a0)
	sw	a5,16(a0)
	sw	zero,96(a0)
	sw	zero,100(a0)
	li	a0,0
	ret
.L16:
	li	a0,1
	ret
	.size	SHA1Reset, .-SHA1Reset
	.align	2
	.globl	SHA1Input
	.type	SHA1Input, @function
SHA1Input:
	beqz	a0,.L23
	addi	sp,sp,-48
	sw	s0,40(sp)
	sw	ra,44(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	s3,28(sp)
	mv	s0,a0
	li	a0,0
	beqz	a2,.L17
	beqz	a1,.L25
	lw	a5,96(s0)
	bnez	a5,.L32
	lw	a0,100(s0)
	bnez	a0,.L17
	add	s1,a1,a2
	li	s2,64
	li	s3,2
	j	.L22
.L34:
	lw	a5,20(s0)
	addi	a5,a5,1
	sw	a5,20(s0)
	bnez	a5,.L20
	sw	s3,100(s0)
.L21:
	addi	a1,a1,1
	beq	a1,s1,.L33
.L22:
	lh	a5,28(s0)
	addi	a4,a5,1
	slli	a4,a4,16
	srai	a4,a4,16
	sh	a4,28(s0)
	lbu	a3,0(a1)
	add	a5,s0,a5
	sb	a3,30(a5)
	lw	a3,24(s0)
	addi	a5,a3,8
	sw	a5,24(s0)
	bgtu	a3,a5,.L34
.L20:
	lw	a5,100(s0)
	bnez	a5,.L21
	bne	a4,s2,.L21
	mv	a0,s0
	sw	a1,12(sp)
	call	SHA1ProcessMessageBlock
	lw	a1,12(sp)
	addi	a1,a1,1
	bne	a1,s1,.L22
.L33:
	lw	a0,100(s0)
.L17:
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	addi	sp,sp,48
	jr	ra
.L25:
	li	a0,1
	j	.L17
.L23:
	li	a0,1
	ret
.L32:
	li	a5,3
	sw	a5,100(s0)
	li	a0,3
	j	.L17
	.size	SHA1Input, .-SHA1Input
	.align	2
	.globl	SHA1FinalBits
	.type	SHA1FinalBits, @function
SHA1FinalBits:
	beqz	a0,.L47
	addi	sp,sp,-16
	sw	s0,8(sp)
	sw	ra,12(sp)
	sw	s1,4(sp)
	mv	s0,a0
	li	a0,0
	beqz	a2,.L35
	lw	a0,100(s0)
	bnez	a0,.L35
	lw	a3,96(s0)
	bnez	a3,.L54
	li	a5,7
	bgtu	a2,a5,.L55
	lw	a5,24(s0)
	add	s1,a5,a2
	sw	s1,24(s0)
	bleu	a5,s1,.L40
	lw	a5,20(s0)
	addi	a5,a5,1
	sw	a5,20(s0)
	bnez	a5,.L40
	li	a3,2
.L40:
	lh	a4,28(s0)
	lui	a5,%hi(masks.1619)
	addi	a5,a5,%lo(masks.1619)
	add	a5,a2,a5
	lui	a0,%hi(markbit.1620)
	lbu	a6,0(a5)
	addi	a5,a0,%lo(markbit.1620)
	slli	a0,a4,16
	srli	a0,a0,16
	add	a2,a2,a5
	addi	a5,a0,1
	lbu	a2,0(a2)
	slli	a5,a5,16
	srai	a5,a5,16
	and	a1,a1,a6
	sw	a3,100(s0)
	sh	a5,28(s0)
	li	a3,55
	or	a1,a1,a2
	bgt	a4,a3,.L56
	add	a4,s0,a4
	sb	a1,30(a4)
.L46:
	li	a4,55
	bgt	a5,a4,.L45
	li	a2,55
	sub	a2,a2,a5
	slli	a2,a2,16
	addi	a5,a5,30
	srli	a2,a2,16
	add	a0,s0,a5
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,56
	sh	a5,28(s0)
.L45:
	lhu	a4,20(s0)
	lw	a5,20(s0)
	slli	a1,s1,16
	srli	a1,a1,16
	srli	a1,a1,8
	slli	a3,s1,8
	slli	a2,a4,8
	srli	a4,a4,8
	or	a2,a2,a4
	srli	a6,a5,24
	or	a4,a3,a1
	srli	a5,a5,16
	srli	a3,s1,24
	srli	s1,s1,16
	sb	a5,87(s0)
	mv	a0,s0
	sb	a6,86(s0)
	sh	a2,88(s0)
	sb	a3,90(s0)
	sh	a4,92(s0)
	sb	s1,91(s0)
	call	SHA1ProcessMessageBlock
	li	a2,64
	li	a1,0
	addi	a0,s0,30
	call	memset
	lw	a0,100(s0)
	li	a5,1
	sw	zero,20(s0)
	sw	zero,24(s0)
	sw	a5,96(s0)
.L35:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
.L56:
	add	a4,s0,a4
	sb	a1,30(a4)
	li	a4,63
	bgt	a5,a4,.L43
	li	a2,62
	sub	a2,a2,a0
	slli	a2,a2,16
	addi	a5,a5,30
	srli	a2,a2,16
	add	a0,s0,a5
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,64
	sh	a5,28(s0)
.L43:
	mv	a0,s0
	call	SHA1ProcessMessageBlock
	lh	a5,28(s0)
	lw	s1,24(s0)
	j	.L46
.L47:
	li	a0,1
	ret
.L54:
	li	a5,3
	sw	a5,100(s0)
	li	a0,3
	j	.L35
.L55:
	li	a5,4
	sw	a5,100(s0)
	li	a0,4
	j	.L35
	.size	SHA1FinalBits, .-SHA1FinalBits
	.align	2
	.globl	SHA1Result
	.type	SHA1Result, @function
SHA1Result:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	sw	s2,0(sp)
	beqz	a0,.L67
	beqz	a1,.L67
	lw	s2,100(a0)
	bnez	s2,.L57
	lw	a5,96(a0)
	mv	s1,a1
	mv	s0,a0
	beqz	a5,.L70
.L59:
	li	a5,0
	li	a0,20
.L65:
	andi	a3,a5,-4
	add	a3,s0,a3
	not	a4,a5
	lw	a3,0(a3)
	andi	a4,a4,3
	slli	a4,a4,3
	add	a2,s1,a5
	srl	a4,a3,a4
	sb	a4,0(a2)
	addi	a5,a5,1
	bne	a5,a0,.L65
.L57:
	lw	ra,12(sp)
	lw	s0,8(sp)
	mv	a0,s2
	lw	s1,4(sp)
	lw	s2,0(sp)
	addi	sp,sp,16
	jr	ra
.L67:
	lw	ra,12(sp)
	lw	s0,8(sp)
	li	s2,1
	mv	a0,s2
	lw	s1,4(sp)
	lw	s2,0(sp)
	addi	sp,sp,16
	jr	ra
.L70:
	lh	a4,28(a0)
	li	a2,55
	slli	a3,a4,16
	srli	a3,a3,16
	addi	a5,a3,1
	slli	a5,a5,16
	srai	a5,a5,16
	sh	a5,28(a0)
	ble	a4,a2,.L60
	add	a4,a0,a4
	li	a2,-128
	sb	a2,30(a4)
	li	a4,63
	bgt	a5,a4,.L61
	li	a2,62
	sub	a2,a2,a3
	slli	a2,a2,16
	addi	a5,a5,30
	srli	a2,a2,16
	add	a0,a0,a5
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,64
	sh	a5,28(s0)
.L61:
	mv	a0,s0
	call	SHA1ProcessMessageBlock
	lh	a5,28(s0)
.L64:
	li	a4,55
	bgt	a5,a4,.L63
	li	a2,55
	sub	a2,a2,a5
	slli	a2,a2,16
	addi	a5,a5,30
	srli	a2,a2,16
	add	a0,s0,a5
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,56
	sh	a5,28(s0)
.L63:
	lhu	a2,20(s0)
	lhu	a3,24(s0)
	lw	a4,20(s0)
	lw	a5,24(s0)
	slli	a0,a2,8
	slli	a1,a3,8
	srli	a2,a2,8
	srli	a3,a3,8
	or	a2,a0,a2
	srli	a6,a4,24
	or	a3,a1,a3
	srli	a4,a4,16
	srli	a1,a5,24
	srli	a5,a5,16
	sb	a5,91(s0)
	mv	a0,s0
	sb	a6,86(s0)
	sb	a4,87(s0)
	sh	a2,88(s0)
	sb	a1,90(s0)
	sh	a3,92(s0)
	call	SHA1ProcessMessageBlock
	li	a2,64
	li	a1,0
	addi	a0,s0,30
	call	memset
	li	a5,1
	sw	zero,20(s0)
	sw	zero,24(s0)
	sw	a5,96(s0)
	j	.L59
.L60:
	add	a4,a0,a4
	li	a3,-128
	sb	a3,30(a4)
	j	.L64
	.size	SHA1Result, .-SHA1Result
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a1,%hi(.LC0)
	addi	sp,sp,-128
	addi	a5,a1,%lo(.LC0)
	li	a3,1
	sw	ra,124(sp)
	sub	a3,a3,a5
.L72:
	add	a2,a3,a5
	addi	a5,a5,1
	lbu	a4,0(a5)
	bnez	a4,.L72
	li	a5,1732583424
	addi	a5,a5,769
	sw	a5,8(sp)
	li	a5,-271732736
	addi	a5,a5,-1143
	sw	a5,12(sp)
	li	a5,-1732583424
	addi	a5,a5,-770
	sw	a5,16(sp)
	li	a5,271732736
	addi	a5,a5,1142
	sw	a5,20(sp)
	li	a5,-1009590272
	addi	a5,a5,496
	addi	a1,a1,%lo(.LC0)
	addi	a0,sp,8
	sw	a5,24(sp)
	sw	zero,32(sp)
	sw	zero,28(sp)
	sh	zero,36(sp)
	sw	zero,104(sp)
	sw	zero,108(sp)
	call	SHA1Input
	lw	a5,108(sp)
	bnez	a5,.L83
	lw	a5,104(sp)
	beqz	a5,.L85
.L83:
	lw	ra,124(sp)
	li	a0,0
	addi	sp,sp,128
	jr	ra
.L85:
	lh	a5,36(sp)
	li	a2,55
	slli	a3,a5,16
	srli	a3,a3,16
	addi	a4,a3,1
	slli	a4,a4,16
	srai	a4,a4,16
	bgt	a5,a2,.L86
	addi	a3,sp,112
	add	a5,a3,a5
	sh	a4,36(sp)
	li	a4,-128
	sb	a4,-74(a5)
.L80:
	lh	a0,36(sp)
	li	a5,55
	bgt	a0,a5,.L79
	li	a2,55
	sub	a2,a2,a0
	slli	a2,a2,16
	addi	a5,sp,8
	srli	a2,a2,16
	addi	a0,a0,30
	add	a0,a5,a0
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,56
	sh	a5,36(sp)
.L79:
	lhu	a2,28(sp)
	lhu	a3,32(sp)
	lw	a4,28(sp)
	lw	a5,32(sp)
	slli	a0,a2,8
	slli	a1,a3,8
	srli	a2,a2,8
	srli	a3,a3,8
	or	a2,a0,a2
	srli	a6,a4,24
	or	a3,a1,a3
	srli	a4,a4,16
	srli	a1,a5,24
	addi	a0,sp,8
	srli	a5,a5,16
	sb	a6,94(sp)
	sb	a4,95(sp)
	sh	a2,96(sp)
	sb	a1,98(sp)
	sb	a5,99(sp)
	sh	a3,100(sp)
	call	SHA1ProcessMessageBlock
	j	.L83
.L86:
	addi	a2,sp,112
	add	a5,a2,a5
	li	a2,-128
	sb	a2,-74(a5)
	sh	a4,36(sp)
	li	a5,63
	bgt	a4,a5,.L77
	li	a2,62
	sub	a2,a2,a3
	slli	a2,a2,16
	addi	a5,sp,8
	addi	a4,a4,30
	srli	a2,a2,16
	add	a0,a5,a4
	addi	a2,a2,1
	li	a1,0
	call	memset
	li	a5,64
	sh	a5,36(sp)
.L77:
	addi	a0,sp,8
	call	SHA1ProcessMessageBlock
	j	.L80
	.size	main, .-main
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"abc"
	.section	.srodata,"a"
	.align	2
	.type	markbit.1620, @object
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
	.type	masks.1619, @object
	.size	masks.1619, 8
masks.1619:
	.byte	0
	.byte	-128
	.byte	-64
	.byte	-32
	.byte	-16
	.byte	-8
	.byte	-4
	.byte	-2
	.ident	"GCC: (GNU) 8.3.0"

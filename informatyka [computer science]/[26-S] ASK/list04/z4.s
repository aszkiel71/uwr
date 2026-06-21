	.file	"z4.c"
	.text
	.p2align 4
	.globl	converter
	.type	converter, @function
converter:
.LFB0:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	bswap	%eax
	ret
	.cfi_endproc
.LFE0:
	.size	converter, .-converter
	.p2align 4
	.globl	rot_left_5
	.type	rot_left_5, @function
rot_left_5:
.LFB1:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	roll	$5, %eax
	ret
	.cfi_endproc
.LFE1:
	.size	rot_left_5, .-rot_left_5
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

	.file	"c_test.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	" printf test on C%c some nums: %b %x %o %d %d and my name is still %s\n"
	.align 8
.LC1:
	.string	"_printf test on C%c some nums: %k %b %x %o %d %d and my name is still %s\n%d %s %x %d%%%c%b\n"
.LC2:
	.string	"love"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -36[rbp], 177782
	mov	DWORD PTR -32[rbp], -323398
	mov	DWORD PTR -28[rbp], 2975
	mov	DWORD PTR -24[rbp], 14
	mov	DWORD PTR -20[rbp], 24157
	mov	DWORD PTR -13[rbp], 1684106326
	mov	BYTE PTR -9[rbp], 0
	mov	edi, DWORD PTR -36[rbp]
	mov	esi, DWORD PTR -24[rbp]
	mov	edx, DWORD PTR -28[rbp]
	mov	eax, DWORD PTR -20[rbp]
	lea	rcx, -13[rbp]
	push	rcx
	mov	ecx, DWORD PTR -32[rbp]
	push	rcx
	mov	r9d, edi
	mov	r8d, esi
	mov	ecx, edx
	mov	edx, eax
	mov	esi, 33
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	rsp, 16
	mov	edi, DWORD PTR -36[rbp]
	mov	esi, DWORD PTR -24[rbp]
	mov	edx, DWORD PTR -28[rbp]
	mov	eax, DWORD PTR -20[rbp]
	push	127
	push	33
	push	100
	push	3802
	lea	rcx, .LC2[rip]
	push	rcx
	push	-1
	lea	rcx, -13[rbp]
	push	rcx
	mov	ecx, DWORD PTR -32[rbp]
	push	rcx
	mov	r9d, edi
	mov	r8d, esi
	mov	ecx, edx
	mov	edx, eax
	mov	esi, 33
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	_printf@PLT
	add	rsp, 64
	mov	edi, DWORD PTR -36[rbp]
	mov	esi, DWORD PTR -24[rbp]
	mov	edx, DWORD PTR -28[rbp]
	mov	eax, DWORD PTR -20[rbp]
	lea	rcx, -13[rbp]
	push	rcx
	mov	ecx, DWORD PTR -32[rbp]
	push	rcx
	mov	r9d, edi
	mov	r8d, esi
	mov	ecx, edx
	mov	edx, eax
	mov	esi, 33
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	rsp, 16
	mov	eax, 1
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
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

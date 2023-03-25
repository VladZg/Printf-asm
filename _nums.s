bits    64                                      ; x86-64 processor used
global _i2hex, _i2oct, _i2bin, _i2quat, i2dec
extern _memcpy

section .text
;------------------------------------------------
; _i2a - converting num from int to str format
;------------------------------------------------
; ENTRY:    ebx - int number to convert from
;           cl - base of converting: 2^c
; EXIT:     r13 - address of buffer with str
; EXPECTS:  None
; DESTROYS: r11, rbx
;------------------------------------------------
_i2a:
    push rsi
    push rdi

    mov rdi, nums_buf

    mov r11, 1
    shl r11, cl
    sub r11, 1          ; mask for % (mod 2^cl)

    cld
.next_symbol:
    mov eax, ebx
    and rax, r11
    mov al, hex_lttrs[rbx]
    stosb                   ; es:[edi++] = al
    shr ebx, cl             ; ebx /= 2^cl
    cmp ebx, 0
    jne .next_symbol

    mov rcx, rdi
    sub rcx, nums_buf
    pop rdi
    mov rsi, nums_buf
    call _memcpy
    pop rsi
    ret
;------------------------------------------------

;------------------------------------------------
; _i2dec -
;------------------------------------------------
; ENTRY:
; EXIT:
; EXPECTS:  None
; DESTROYS:
;------------------------------------------------
_i2dec:

    ret
;------------------------------------------------

;------------------------------------------------
; _i2oct -
;------------------------------------------------
; ENTRY:
; EXIT:
; EXPECTS:  None
; DESTROYS:
;------------------------------------------------
_i2oct:
    mov rcx, 3
    call _i2a
    ret
;------------------------------------------------

;------------------------------------------------
; _i2bin -
;------------------------------------------------
; ENTRY:
; EXIT:
; EXPECTS:  None
; DESTROYS:
;------------------------------------------------
_i2bin:
    mov rcx, 1
    call _i2a
    ret
;------------------------------------------------

;------------------------------------------------
; _i2quat -
;------------------------------------------------
; ENTRY:
; EXIT:
; EXPECTS:  None
; DESTROYS:
;------------------------------------------------
_i2bin:
    mov rcx, 2
    call _i2a
    ret
;------------------------------------------------

;------------------------------------------------
; _i2hex -
;------------------------------------------------
; ENTRY:    ebx = int number
; EXIT:     r13 - address of buffer with hex num
;           rcx - length of number in str format
; EXPECTS:  None
; DESTROYS: rcx
;------------------------------------------------
_i2hex:
    mov rcx, 4
    call _i2a
    ret
;------------------------------------------------

section .rodata
hex_lttrs:  db  "0123456789abcdef"

section .bss
nums_buf_size    equ 32             ; size of nums buffer
nums_buf resb    nums_buf_size      ; nums buffer

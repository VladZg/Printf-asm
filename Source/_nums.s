bits    64                                      ; x86-64 processor used
global _i2hex, _i2oct, _i2bin, _i2quat, _i2dec
extern _memcpy, _memcpy_reversed

section .text
;------------------------------------------------
; _i2a - converting num from int to str format
;------------------------------------------------
; ENTRY:    rdx - int number to convert from
;           rsi - address of source buffer
;           cl - base of converting: 2^c
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r11
;------------------------------------------------
_i2a:
    push rsi
    push rdi

    mov rdi, nums_buf

    mov r11, 1
    shl r11, cl
    dec r11                 ; mask for % (mod 2^cl)

    cld
.next_symbol:
    mov rax, rdx
    and rax, r11
    mov al, num_lttrs[rax]
    stosb                   ; es:[edi++] = al
    shr rdx, cl             ; ebx /= 2^cl
    cmp rdx, 0
    jne .next_symbol

    mov rcx, rdi
    sub rcx, nums_buf       ; length of num in buf
    mov rsi, rdi
    dec rsi                 ; address of end of num buf
    pop rdi                 ; restore rdi value
    call _memcpy_reversed
    pop rsi
    ret
;------------------------------------------------

;------------------------------------------------
; _i2dec - convers num from int to decimal str format
;------------------------------------------------
; ENTRY:    edx - int number to convert from
;           rsi - address of source buffer
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r9, r11
;------------------------------------------------
_i2dec:
    push rsi                ; saving pointer to fmt string

    cmp edx, 0
    jge .process_num

    mov al, '-'
    stosb                   ; es:[edi++] = al
    neg edx

.process_num:
    push rdi
    mov r9, 10              ; base of converting system
    mov rax, rdx            ; rdx = rax
    mov rdi, nums_buf       ; address of nums buffer

.next_symbol:
    xor rdx, rdx            ; rdx = 0
    div r9                  ; rax /= 10, rdx = rax % 10
    add dl, '0'             ; converting number to symbol
    mov [rdi], dl
    inc rdi
    cmp rax, 0
    jne .next_symbol

.cpy_buf:
    mov rcx, rdi
    sub rcx, nums_buf       ; length of num in buf
    mov rsi, rdi
    dec rsi                 ; address of end of num buf
    pop rdi                 ; restore pointer  to _printf buffer
    call _memcpy_reversed   ; copying num buffer to the end of _printf buffer
    pop rsi                 ; restoring pointer to fmt string
    ret
;------------------------------------------------

;------------------------------------------------
; _i2oct - convers num from int to octal str format
;------------------------------------------------
; ENTRY:    rdx - int number to convert from
;           rsi - address of source buffer
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r11
;------------------------------------------------
_i2oct:
    mov rcx, 3      ; base = 2^3 = 8
    call _i2a       ; convert integer to str in oct system
    ret
;------------------------------------------------

;------------------------------------------------
; _i2bin - convers num from int to binar str format
;------------------------------------------------
; ENTRY:    rdx - int number to convert from
;           rsi - address of source buffer
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r11
;------------------------------------------------
_i2bin:
    mov rcx, 1      ; base = 2^1 = 2
    call _i2a       ; convert integer to str in bin system
    ret
;------------------------------------------------

;------------------------------------------------
; _i2quat - convers num from int to quater str format
;------------------------------------------------
; ENTRY:    rdx - int number to convert from
;           rsi - address of source buffer
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r11
;------------------------------------------------
_i2quat:
    mov rcx, 2      ; base = 2^2 = 4
    call _i2a       ; convert integer to str in quat system
    ret
;------------------------------------------------

;------------------------------------------------
; _i2hex - convers num from int to hex str format
;------------------------------------------------
; ENTRY:    rdx - int number to convert from
;           rsi - address of source buffer
; EXIT:
; EXPECTS:  None
; DESTROYS: rax, rdx, r11
;------------------------------------------------
_i2hex:
    mov rcx, 4      ; base = 2^4 = 16
    call _i2a       ; convert integer to str in hex system
    ret
;------------------------------------------------

section .rodata
num_lttrs:  db  "0123456789abcdef"

section .bss
nums_buf_size    equ 32             ; size of nums buffer
nums_buf resb    nums_buf_size      ; nums buffer

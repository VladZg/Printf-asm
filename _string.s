bits    64                                                  ; x86-64 processor used
global _puts, _memcpy, _strlen, buf_print, _memcpy_reversed

section .text
;------------------------------------------------
; _puts - prints buffer of printf function in stdout
;------------------------------------------------
; ENTRY:    rdi - address of string
; EXIT:     None
; EXPECTS:  None
; DESTROYS: rax, rbx, rdi
;------------------------------------------------
_puts:
    mov rsi, rdi            ; rsi = rdi
    mov rdi, _puts_buf
    cld                     ; iterator increasing mode
.next_symbol:
    lodsb                   ; al = ds:[esi++]
    cmp al, 0               ; al == 0
    je .buf_print
    stosb                   ; ds:[edi++] = al
    jmp .next_symbol

.buf_print:
    mov al, 10                  ; al = '\n'
    stosb                       ; ds:[edi++] = al
    mov al, 0                   ; al = '\0'
    stosb                       ; ds:[edi++] = al
    mov rsi, _puts_buf          ; address of buf
    call buf_print
    ret
;------------------------------------------------

;------------------------------------------------
; buf_print - prints buffer of printf function in stdout
;------------------------------------------------
; ENTRY:    rsi - address of buffer to print
;           rdi - address of last symbol of buffer
; EXIT:     None
; EXPECTS:  None
; DESTROYS: rax, rsi, rdi
;------------------------------------------------
buf_print:
    mov rax, 0x01   ; fprintf function of syscall
    mov rdx, rdi
    sub rdx, rsi    ; length of buf
    mov rdi, 1      ; stdout stream of output
    syscall
    ret
;------------------------------------------------

;------------------------------------------------
; _strlen - strlen C analog, counts length of a string
;------------------------------------------------
; ENTRY:    rsi - address of string buffer
; EXIT:     rax - string length
; EXPECTS:  None
; DESTROYS: rax
;------------------------------------------------
_strlen:
    push rsi

.next_symbol:
    cmp byte [rsi], 0   ; str[i] == 0
    je .exit_strlen
    inc rsi
    jmp .next_symbol

.exit_strlen:
    mov rax, rsi
    pop rsi
    sub rax, rsi
	ret
;------------------------------------------------

;------------------------------------------------
; _memcpy - memcpy C analog, copies from source to dest
;------------------------------------------------
; ENTRY:    rsi - address of source buffer
;           rdi - address of destination buffer
;           rcx - number of copying symbols
; EXIT:     rdi - address of the symbol after last copied
; EXPECTS:  None
; DESTROYS: rdx, rsi
;------------------------------------------------
_memcpy:
	cmp rcx, 0
	jbe .exit_memcpy

.next_symbol:           ; while (rcx--) {
    movsb               ; ds:[edi++] = ds:[esi++]
    loop .next_symbol   ; }

.exit_memcpy:
	ret
;------------------------------------------------

;------------------------------------------------
; _memcpy_reversed - reversed memcpy, copies from reversed source to dest
;------------------------------------------------
; ENTRY:    rsi - address of the end of source buffer
;           rdi - address of destination buffer
;           rcx - number of copying symbols
; EXIT:     rdi - address of the symbol after last copied
; EXPECTS:  None
; DESTROYS: rdx, rsi
;------------------------------------------------
_memcpy_reversed:
	cmp rcx, 0
	jbe .exit_memcpy_reversed

.next_symbol:           ; while (rcx--) {
    movsb               ; ds:[edi++] = ds:[esi++]
    sub rsi, 2          ; rsi -= 2 (reversed order)
    loop .next_symbol   ; }

.exit_memcpy_reversed:
	ret
;------------------------------------------------

section .bss    ; not-initialized data

_puts_buf_size          equ 1024
_puts_buf       resb    _puts_buf_size

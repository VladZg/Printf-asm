section .text
global _start

_start: mov rsi, Msg
        mov rdx, MsgLen
        call _printf

        mov rax, 0x3C
        xor rdi, rdi
        syscall

;------------------------------------------------
; _printf - simple analog of standart printf
;
;------------------------------------------------
; ENTRY:    rsi - address of string
;           rdx - length of string
; EXIT:     None
; EXPECTS:  None
; DESTROYS: rax, rdi
;------------------------------------------------
_printf:        mov rax, 0x01
                mov rdi, 1
                syscall
                ret
;------------------------------------------------

section .data

Msg:    db  "Hello, here is my own printf!", 0x0A
MsgLen: equ $ - Msg

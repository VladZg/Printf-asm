extern  printf, _printf
global main

section .text

main:   push rbp
        mov rbp, rsp
        mov rdi, fmt
        mov rsi, orig_msg
        call printf             ; printf(fmt, msg)
        pop	rbp

        push rbp
        mov rbp, rsp
        mov rdi, fmt
        mov rsi, own_msg
        call _printf            ; _printf(fmt, msg)
        pop	rbp

        xor eax, eax            ; rax = 0
        ret                     ; exit(0)

section .data

fmt:            db  "%s!", 10, 0
orig_msg:       db  "printf test on asm", 0
own_msg:        db  "_printf test on asm", 0

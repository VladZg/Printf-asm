section .text
    default rel
    extern printf
    global main

main:
    push rbp

    mov	rdi, fmt
    mov	rsi, msg
    mov	rax, 0
    call printf wrt ..plt

    pop	rbp

    mov	rax, 0
    ret

section .data
    msg:    db  "printf test", 0
    fmt:    db  "%s!", 0x0A, 0

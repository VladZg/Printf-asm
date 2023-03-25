extern  printf, _printf, _assert, puts, _puts
global main

section .text

main:   push rbp
        mov rbp, rsp
        mov rdi, fmt
        mov rsi, 'w'
        mov rdx, orig_msg
        xor eax, eax
        call printf             ; printf(fmt, msg)
        pop rbp

        push rbp
        mov rbp, rsp
        mov rdi, fmt
        mov rsi, 'w'
        mov rdx, own_msg
        call _printf            ; _printf(fmt, msg)
        pop rbp

        ;push rbp
        ;mov rdi, puts_str
        ;call puts               ; _printf(fmt, msg)
        ;pop rbp

        ;push rbp
        ;mov rdi, _puts_str
        ;call _puts              ; _printf(fmt, msg)
        ;pop rbp

        ; call _assert

        xor eax, eax            ; rax = 0
        ret                     ; exit(0)

section .data

fmt:            db  "%c %s!", 10, 0
orig_msg:       db  "printf test on asm", 0
own_msg:        db  "_printf test on asm", 0
puts_str:       db  "string for puts", 0
_puts_str:      db  "string for _puts", 0
str:            db  "nakonecto stroka...", 0

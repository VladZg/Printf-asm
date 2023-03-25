extern  printf, _printf, _assert, puts, _puts
global main

section .text

main:   push rbp                ;
        mov rbp, rsp            ;
        mov r9d, oct_num        ;
	mov r8d, dec_pos_num    ;
        mov rcx, hex_num        ;
        mov rdi, fmt            ;
        mov rsi, 's'            ;
        mov rdx, orig_msg       ;
        xor eax, eax            ;
        call printf             ; printf(fmt, msg)
        pop rbp

        push rbp                ;
        mov rbp, rsp            ;
        mov r9d, oct_num        ;
	mov r8d, dec_pos_num    ;
        mov rcx, hex_num        ;
        mov rdi, fmt            ;
        mov rsi, 's'            ;
        mov rdx, own_msg        ;
        call _printf            ; _printf(fmt, msg)
        pop rbp

        ; call _assert

        xor eax, eax            ; rax = 0
        ret                     ; exit(0)

section .data

fmt:            db      "%cosat %s %x %d %o!", 10, 0
orig_msg:       db      " printf test on asm", 0
own_msg:        db      "_printf test on asm", 0
puts_str:       db      "string for puts", 0
_puts_str:      db      "string for _puts", 0
str:            db      "nakonecto stroka...", 0
hex_num         equ     0xF9B
oct_num         equ     2439
dec_pos_num     equ     -1820

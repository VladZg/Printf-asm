bits    64                                  ; x86-64 processor used
global _printf, _assert
extern _puts, _memcpy, _strlen, buf_print
extern _i2hex, _i2oct, _i2bin, _i2quat, _i2dec

section .text
;------------------------------------------------
; _printf - simple analog of standart printf
;------------------------------------------------
; ENTRY:    rdi - address of format string
;           arguments in cdecl format
; EXIT:     None
; EXPECTS:  None
; DESTROYS: rax, rbx, rdi, r10
;------------------------------------------------
_printf:
            pop r10         ; saving ret addr

            push r9         ; saving 5 argument
	        push r8         ; saving 4 argument
	        push rcx        ; saving 3 argument
	        push rdx        ; saving 2 argument
	        push rsi        ; saving 1 argument

            push rbp
            mov rbp, rsp
            push rax
            push rbx
            push rdi

            call __printf   ; __printf(fmt, args)

            pop rdi
            pop rbx
            pop rax
            pop rbp

            pop rsi
            pop rdx
            pop rcx
            pop r8
            pop r9
            ; add rsp, 8*5    ; pop all reg params

            push r10        ; putting ret addr in stack
            ret
;------------------------------------------------

;------------------------------------------------
; __printf - simple analog of printf, but all arguments are in stack
;------------------------------------------------
; ENTRY:    rdi - address of format string
;           stack filled with arguments
; EXIT:     None
; EXPECTS:  None
; DESTROYS: rax, rbx, rdi
;------------------------------------------------
__printf:
    ; mov rbp, rsp
    xor rbx, rbx            ; rbx = 0
    xor rax, rax            ; rax = 0
    mov rsi, rdi            ; rsi = rdi
    mov rdi, _printf_buf
    cld                     ; iterator increasing mode
.next_symbol:
    lodsb                   ; al = ds:[esi++]
    cmp al, "%"
    je .process_arg
    stosb                   ; ds:[edi++] = al
    cmp al, 0
    je .buf_print
;    cmp rdi, _printf_buf_end
;    jae .reset_buf
    jmp .next_symbol

.reset_buf:
    call reset_buf
    jmp .next_symbol

.process_arg:
    lodsb                   ; al = ds:[esi++]
    cmp al, '%'             ; if (al == '%') putc('%')
    je ._printf_perc

                            ; switch(al)
    cmp al, 'b'             ; if (al < 'b') default;
    jb ._printf_def

    cmp al, 'x'             ; if (al > 'x') default;
    ja ._printf_def

    inc rbx                 ; rbx++ <-- number of that format argument

    sub al, 'b'                         ; index = al - 'b'
    jmp _printf_swtch_tbl[rax * 8]      ; switch_table[index]

._printf_perc:
    mov al, '%'         ; al = '%'
    stosb               ; ds:[edi++] = al
    jmp .next_symbol

._printf_bin:
    mov rdx, [rbp + rbx * 8]
    call _i2bin
    jmp .next_symbol

._printf_char:
    mov rax, [rbp + rbx * 8]    ; char arhument
    stosb                       ; ds:[edi++] = al
    jmp .next_symbol

._printf_dec:
    mov rdx, [rbp + rbx * 8]
    call _i2dec
    jmp .next_symbol

._printf_oct:
    mov rdx, [rbp + rbx * 8]
    call _i2oct
    jmp .next_symbol

._printf_str:
    push rsi
    mov rsi, [rbp + rbx * 8]    ; address of string argument
    call _strlen                ; ax = strlen(str)
    mov rcx, rax                ; strlen
    call _memcpy
    pop rsi
    jmp .next_symbol

._printf_hex:
    mov rdx, [rbp + rbx * 8]
    call _i2hex
    jmp .next_symbol

._printf_def:
    ;sub rsi, 2
    ;movsb
    ;movsb
    call _assert
    jmp .next_symbol

.buf_print:
    mov rsi, _printf_buf        ; address of buf
    call buf_print
    ret
;------------------------------------------------

;------------------------------------------------
; reset_buf - prints _printf buffer and reset it
;------------------------------------------------
; ENTRY:    rdi - address of the end of buf
; EXIT:     rdi - address of the _printf_buf
; EXPECTS:  None
; DESTROYS: rax, rsi, rdi
;------------------------------------------------
reset_buf:
    mov rsi, _printf_buf
    call buf_print
    mov rdi, _printf_buf
    ret
;------------------------------------------------

section .rodata                         ; section of read-obly data

_printf_swtch_tbl:                          ; jump switch-table for _printf
                                            ; '%' = 37
                dq  __printf._printf_bin     ; 'b' = 98
                dq  __printf._printf_char    ; 'c' = 99
                dq  __printf._printf_dec     ; 'd' = 100
    times  (10) dq  __printf._printf_def     ; default case (x10)
                dq  __printf._printf_oct     ; 'o' = 111
    times  (3)  dq  __printf._printf_def     ; default case (x3)
                dq  __printf._printf_str     ; 's' = 115
    times  (4)  dq  __printf._printf_def     ; default case (x4)
                dq  __printf._printf_hex     ; 'x' = 120

section .bss                            ; section of non-initialized data
_printf_buf_size    equ 1024            ; size of _printf buffer
_printf_buf resb    _printf_buf_size    ; _printf buffer
_printf_buf_end     equ $ - 20

section .text
;------------------------------------------------
_assert:
        push rax
        push rdi
        push rsi
        push rdx

        mov rax, 0x01
        mov rdi, 1
        mov rsi, ass_msg
        mov rdx, ass_msg_len
        syscall

        pop rdx
        pop rsi
        pop rdi
        pop rax
        ret
;------------------------------------------------
section .rodata   ; assert read-only data
ass_msg:        db  "test like an assert...", 0x0A
ass_msg_len:    equ $ - ass_msg

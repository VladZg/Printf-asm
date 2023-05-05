bits    64                                  ; x86-64 processor instruction set used
global _printf, _assert
extern _puts, _memcpy, _strlen, buf_print
extern _i2hex, _i2oct, _i2bin, _i2quat, _i2dec
extern printf

section .text
;------------------------------------------------
; _printf - simple analog of standart printf
;------------------------------------------------
; ENTRY:    rdi - address of format string
;           arguments of printf in cdecl format
; EXIT:     None
; EXPECTS:  None
; DESTROYS: r10
;------------------------------------------------
_printf:
            pop r10         ; saving ret addr

            push r9         ; saving 5 argument
	        push r8         ; saving 4 argument
	        push rcx        ; saving 3 argument
	        push rdx        ; saving 2 argument
	        push rsi        ; saving 1 argument

            push rbp        ; saving other args
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

            push r10          ; putting ret addr in stack
            push rbp          ;
            mov rbp, rsp      ;
            add rbp, 8        ;
            call printf       ; printf(fmt, msg)
            pop rbp
            ; add rsp, 8*5    ; restoring rsp (poping _printfs params)

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
    xor rbx, rbx            ; rbx = 0
    xor rax, rax            ; rax = 0
    mov rsi, rdi            ; rsi = rdi
    mov rdi, _printf_buf
    cld                     ; iterator increasing mode
.next_symbol:
    call check_for_reset
    lodsb                   ; al = ds:[esi++]
    cmp al, "%"
    je .process_arg
    stosb                   ; ds:[edi++] = al
    cmp al, 0               ; al == 0
    je .buf_print
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

    inc rbx                     ; rbx++ <-- number of that format argument

    jmp _printf_swtch_tbl[(rax - 'b') * 8]      ; switch_table[index]

._printf_perc:                  ; %%
    mov al, '%'                 ; al = '%'
    stosb                       ; ds:[edi++] = al
    jmp .next_symbol

._printf_bin:                   ; %b
    mov rdx, [rbp + rbx * 8]    ; argument
    call _i2bin                 ; translate to bin
    jmp .next_symbol

._printf_char:                  ; %c
    mov rax, [rbp + rbx * 8]    ; argument
    stosb                       ; ds:[edi++] = al
    jmp .next_symbol

._printf_dec:                   ; %d
    mov rdx, [rbp + rbx * 8]    ; argument
    call _i2dec                 ; translate to dec
    jmp .next_symbol

._printf_oct:                   ; %o
    mov rdx, [rbp + rbx * 8]    ; argument
    call _i2oct                 ; translate to oct
    jmp .next_symbol

._printf_str:                   ; %s
    push rsi                    ; saving rsi
    ; mov r9, _printf_buf_end
    ; sub r9, rdi               ; length of empty _printf_buf
    mov rsi, [rbp + rbx * 8]    ; address of string argument
    call _strlen                ; ax = strlen(str)
    ; cmp eax, r9
    ; ja .reset_buf             ; if (ax > len) reset_buf()
    mov rcx, rax                ; strlen
    call _memcpy                ; copying str to _printf_buf
    pop rsi                     ; restoring rsi
    jmp .next_symbol

._printf_hex:                   ; %x
    mov rdx, [rbp + rbx * 8]    ; argument
    call _i2hex                 ; translate to hex
    jmp .next_symbol

._printf_def:                   ; default
    sub rsi, 2                  ; rsi -= 2 <-- setting rsi on %
    movsb                       ; ds:[rdi++] = ds:[rsi++]
    movsb                       ; ds:[rdi++] = ds:[rsi++]
    dec rbx                     ; counter of args not increasing
    ; call _assert
    jmp .next_symbol

.buf_print:
    mov rsi, _printf_buf        ; address of buf
    call buf_print              ; prints buffer of _printf
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

;------------------------------------------------
; ceck_for_reset - prints _printf buffer and reset it
;------------------------------------------------
; ENTRY:    rdi - address of the end of buf
; EXIT:     rdi - address of the _printf_buf
; EXPECTS:  None
; DESTROYS: rax, rsi, rdi
;------------------------------------------------
check_for_reset:
;    mov rsi, _printf_buf
;    call buf_print
;    mov rdi, _printf_buf
    ret
;------------------------------------------------

section .rodata                         ; section of read-obly data

_printf_swtch_tbl:                           ; jump switch-table for _printf
                                             ; '%' = 37 <-- not in jump table
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
ass_msg:        db  "assert message... something is wrong, isn't it?", 0x0A
ass_msg_len:    equ $ - ass_msg

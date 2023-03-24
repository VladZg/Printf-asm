bits 64

global _printf

section .rodata

prnt_swtch_tbl:                     ; jump switch-table for _printf
                                    ; '%' = 37
                dq  _printf_bin     ; 'b' = 98
                dq  _printf_char    ; 'c' = 99
                dq  _printf_dec     ; 'd' = 100
    times  (10) dq  _printf_empty
                dq  _printf_oct     ; 'o' = 111
    times  (3)  dq  _printf_empty
                dq  _printf_str     ; 's' = 115
    times  (4)  dq  _printf_empty
                dq  _printf_hex     ; 'x' = 120

section .text

;------------------------------------------------
; _printf - simple analog of standart printf
;------------------------------------------------
; ENTRY:    rsi - address of format string
;           arguments in cdecl format
; EXIT:     None
; EXPECTS:  None
; DESTROYS: ?
;------------------------------------------------
_printf:        ;
                call __printf
                ret
;------------------------------------------------

;------------------------------------------------
; __printf - simple analog of printf, but all arguments are in stack
;------------------------------------------------
; ENTRY:    rsi - address of format string
;           stack filled with arguments
; EXIT:     None
; EXPECTS:  None
; DESTROYS: ?
;------------------------------------------------
__printf:

_printf_bin:

_printf_char:

_printf_dec:

_printf_oct:

_printf_str:

_printf_hex:

_printf_empty:

            ret
;------------------------------------------------

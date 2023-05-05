# Implementation of standart C printf function

 In this project I've tried to make a simple analog of standart ``int printf(const char*, ...)`` function on assembler.

## Abilities:

 My own printf called ``_printf`` and it has the same format of arguments as a standart function.

 Created _printf supports the following format arguments:
 * ``%b``  - binary format on int
 * ``%c``  - char (symbol or number from 0 to 255)
 * ``%d``  - decimal format of int
 * ``%o``  - octal format of int
 * ``%s``  - string (ends with '\0')
 * ``%x``  - hex format of int
 * ``%%``  - "%%"

# Installing and using

 To call the ``_printf`` function from your C program you have to declare it as:

 ```C
    extern int _printf(const char*, ...);
 ```

 And then compile program with my library - files ``_nums.o``, ``_string.o``, ``_printf.o`` from ``./Object`` directory.

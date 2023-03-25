#include <stdio.h>
extern int _printf(const char*, ...);
extern int _puts(const char*);
extern int _strlen(const char*);

int main()
{
    _printf("_printf test on C%c and %x\n", '!', 0xA7);
    printf("printf test on C%c and %x\n", '!', 0xA7);
    _puts("_puts test on C");
    // printf("_strlen test on C: %d\n", _strlen("aboba"));

    return 1;
}

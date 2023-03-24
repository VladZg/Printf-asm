#include <stdio.h>
extern int _printf(const char*, ...);

int main()
{
    _printf("_printf test on C%c\n", '!');
    printf("printf test on C%c\n", '!');

    return 1;
}

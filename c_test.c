#include <stdio.h>
extern int _printf(const char*, ...);

int main()
{
    // _printf("_printf test on C%c\n", '!');
    // printf("printf test on C%c\n", '!');

    int num = 1005;
    char str[10] = {};
    itoa(num, str, 10);
    printf("%s\n", str);

    return 1;
}

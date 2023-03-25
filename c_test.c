#include <stdio.h>
extern int _printf(const char*, ...);
extern int _puts(const char*);
extern int _strlen(const char*);

int main()
{
    // int hex_num = 0xB9F;
    // int oct_num = 14;
    // char name[] = "Vlad";

    printf( " printf test on C%c some nums: %x %o %d %d. My name is still %s\n", '!', 0xB9F, 14, -10, 134, "Vlad");
    _printf("_printf test on C%c some nums: %x %o %d %d. My name is still %s\n", '!', 0xB9F, 14, -10, 134, "Vlad");

    return 1;
}

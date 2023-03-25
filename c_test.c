#include <stdio.h>
extern int _printf(const char*, ...);
extern int _puts(const char*);
extern int _strlen(const char*);

int main()
{
    int dec_pos_num = 177782 ;
    int dec_neg_num = -323398;
    int hex_num     = 0xB9F  ;
    int oct_num     = 14     ;
    int bin_num     = 24157  ;
    char name[]     = "Vlad" ;

    printf( " printf test on C%c some nums: %b %x %o %d %d and my name is still %s\n", '!', bin_num, hex_num, oct_num, dec_pos_num, dec_neg_num, name);
    _printf("_printf test on C%c some nums: %k %b %x %o %d %d and my name is still %s\n"
            "%d %s %x %d%%%c%b\n", '!', bin_num, hex_num, oct_num, dec_pos_num, dec_neg_num, name, -1, "love", 3802, 100, 33, 127);
    printf( " printf test on C%c some nums: %b %x %o %d %d and my name is still %s\n", '!', bin_num, hex_num, oct_num, dec_pos_num, dec_neg_num, name);

    return 1;
}

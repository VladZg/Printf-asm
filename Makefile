TARGET = ./Hello

all: assemble link # run

assemble:	# nasm -f elf64 -l $(TARGET).lst $(TARGET).s
	@nasm -f elf64 asm_test.s -l asm_test.lst
	@nasm -f elf64 _printf.s -l _printf.lst
	@nasm -f elf64 _string.s -l _string.lst
	@gcc -S c_test.c -o c_test.s

link:		# ld -s -o $(TARGET) $(TARGET).o
	@gcc -no-pie -s _string.o _printf.o asm_test.o -o asm_test
	@gcc -c c_test.c -o c_test.o
	@gcc -no-pie -s _string.o _printf.o c_test.o -o c_test

run_c:		# $(TARGET)
	@./c_test

run_asm:
	@./asm_test

clean:
	@rm -f *.o *.lst

TARGET = Hello

SRC_DIR = ./Source
OBJ_DIR = ./Object
LST_DIR = ./Listings

all: assemble link # run

assemble:	# nasm -f elf64 -l $(TARGET).lst $(TARGET).s
	nasm -f elf64 $(SRC_DIR)/asm_test.s -l $(LST_DIR)/asm_test.lst -o $(OBJ_DIR)/asm_test.o
	nasm -f elf64 $(SRC_DIR)/_printf.s -l $(LST_DIR)/_printf.lst -o $(OBJ_DIR)/_printf.o
	nasm -f elf64 $(SRC_DIR)/_string.s -l $(LST_DIR)/_string.lst -o $(OBJ_DIR)/_string.o
	nasm -f elf64 $(SRC_DIR)/_nums.s -l $(LST_DIR)/_nums.lst -o $(OBJ_DIR)/_nums.o
	gcc -S -masm=intel -Wno-format $(SRC_DIR)/c_test.c -o $(SRC_DIR)/c_test.s

link:		# ld -s -o $(TARGET) $(TARGET).o
	gcc -no-pie -s -Wno-format $(OBJ_DIR)/_nums.o $(OBJ_DIR)/_string.o $(OBJ_DIR)/_printf.o $(OBJ_DIR)/asm_test.o -o asm_test
	gcc -c $(SRC_DIR)/c_test.c -Wno-format -o $(OBJ_DIR)/c_test.o
	gcc -no-pie -s -Wno-format $(OBJ_DIR)/_string.o $(OBJ_DIR)/_nums.o $(OBJ_DIR)/_printf.o $(OBJ_DIR)/c_test.o -o c_test

run_c:		# $(TARGET)
	@./c_test

run_asm:
	@./asm_test

clean:
	@rm -f *.o *.lst

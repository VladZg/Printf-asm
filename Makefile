TARGET = ./Hello

all: assemble link run

assemble:
	nasm -f elf64 -l $(TARGET).lst $(TARGET).s

link:
	ld -s -o $(TARGET) $(TARGET).o


run:
	$(TARGET)

clean:
	@rm -f *.o *.lst

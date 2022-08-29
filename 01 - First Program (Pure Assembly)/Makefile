
#	The first target always is considered the default target (i.e., `make`)
default: run



#	Build the program
build:
	yasm -f elf64 -gdwarf2 main.asm -o main.o
	ld main.o -o main


#	Run the program
run:	build
	./main



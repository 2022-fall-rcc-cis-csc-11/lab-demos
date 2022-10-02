

# Compile and Link Variables
CPP := g++
CPP_FLAGS := -Wall -m64 -gdwarf-2 -std=c++17 -c
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2
LINKER := g++
LINKER_FLAGS := -Wall -m64 -gdwarf-2 -std=c++17 -no-pie


# Executable name
BIN_NAME := main
BIN := ./$(BIN_NAME)


run:	build
	@echo "Running program!"
	$(BIN)
.PHONY: run


build:	$(BIN)
.PHONY: build


$(BIN):	driver.o file_io.o
	$(LINKER) $(LINKER_FLAGS) *.o *.so -o "$@"


driver.o:	driver.cpp
	$(CPP) $(CPP_FLAGS) "$<" -o "$@"


file_io.o: file_io.asm
	$(ASM) $(ASM_FLAGS) "$<" -o "$@"


clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean









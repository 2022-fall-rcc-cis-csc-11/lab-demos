
CC := gcc
CC_FLAGS:= -Wall -m64 -gdwarf-2 -c

#
CPP := g++
CPP_FLAGS := -Wall -std=c++17 -m64 -gdwarf-2 -c

#
LINKER := g++
LINKER_FLAGS := -m64 -gdwarf-2 -no-pie -std=c++17


# Executable name
BIN_NAME := main
BIN := ./$(BIN_NAME)


run:	build
	@echo "Running program!"
	$(BIN)
.PHONY: run

debug:	build
	@echo "Debugging program!"
	gdb $(BIN) -x $(GDB_COMMANDS_FILE)

build:	$(BIN)
.PHONY: build


$(BIN):	driver.o inputter.o
	$(LINKER) $(LINKER_FLAGS) *.o -o "$@"


driver.o:	driver.cpp
	$(CPP) $(CPP_FLAGS) "$<" -o "$@"


inputter.o: inputter.c
	$(CC) $(CC_FLAGS) "$<" -o "$@"


clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean









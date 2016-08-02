# template makefile
#
OPTION = -Wall -O -std=c11 -pedantic
OP_DBG = -g
OP_LIB = -c
IFLAG  = -I .
LIBRARY = 
MACHINE =
CC = 

COMPILE = $(CC) $(OPTION) $(IFLAG) $(LIBRARY)
S_LIB_NAME = libX.a
D_LIB_NAME = libX.so


static:
	$(COMPILE) 
	ar r $(S_LIB_NAME) *.o
	rm *.o

dynamic:
	$(COMPILE) -fpic  
	$(CC) -shared -o $(D_LIB_NAME) *.o
	rm *.o


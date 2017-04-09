# makefile
#

S_LIB_NAME = libutils.a
D_LIB_NAME = libutils.so


CC = gcc
OPTION = -Wall -O -std=c11 -pedantic -c
COMPILE = $(CC) $(OPTION)


static:
	$(COMPILE) *.c
	ar r $(S_LIB_NAME) *.o
	rm *.o

dynamic:
	$(COMPILE) -fpic *.c
	$(CC) -shared -o $(D_LIB_NAME) *.o
	rm *.o


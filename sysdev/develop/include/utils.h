#ifndef _UTILS_
#define _UTILS_


#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>


#define		SUCCESS		true
#define		FAILURE		false
#define 	PRIVATE		static
#define 	INLINE		static inline


#define		SIZE_POINTER	sizeof(void*)
#define		SIZE_CHAR		sizeof(char)
#define		SIZE_INT		sizeof(int)
#define		SIZE_SHORT		sizeof(short)
#define		SIZE_LONG		sizeof(long)
#define 	SIZE_DOUBLE		sizeof(double)
#define 	SIZE_FLOAT		sizeof(float)

#define 	SIZE_BYTE		0x01
#define 	SIZE_WORD		0x02


typedef size_t 			Size;
typedef 	uint8_t 			Byte;
typedef	uint16_t			Word;
typedef 	uint32_t			Long;
typedef	unsigned long 	Ulong;


// secure memory alloc
//

void  default_err_handler();

void* def_malloc(Size x);
void* def_calloc(Size x, Size n);
void* def_realloc(void* p, Size x);

void* sec_malloc(Size size, void (*err_handle)());
void* sec_calloc(Size size, Size numb, void (*err_handle)());
void* sec_realloc(void* mem,  Size size, void (*err_handle)());


// generic swapping
//

void byte_swap(Byte* a, Byte* b);
void int_swap(int* a, int* b);
void gswap(void* a, void* b, Size size);


#endif


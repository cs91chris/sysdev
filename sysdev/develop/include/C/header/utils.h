#ifndef _UTILS_
#define _UTILS_


#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>


#define		SUCCESS		    true
#define		FAILURE		    false
#define 	PRIVATE		    static
#define 	INLINE		    static inline


#define		SIZE_POINTER	sizeof(void*)
#define		SIZE_CHAR		sizeof(char)
#define		SIZE_INT		sizeof(int)
#define		SIZE_SHORT		sizeof(short)
#define		SIZE_LONG		sizeof(long)
#define 	SIZE_DOUBLE		sizeof(double)
#define 	SIZE_FLOAT		sizeof(float)

#define 	SIZE_BYTE		0x01
#define 	SIZE_WORD		0x02


typedef size_t 			    Size;
typedef uint8_t 		    Byte;
typedef	uint16_t		    Word;
typedef uint32_t		    Long;
typedef	unsigned long 	    Ulong;

#endif

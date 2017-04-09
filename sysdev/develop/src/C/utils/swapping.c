#include <utils.h>


void byte_swap(Byte* a, Byte* b)
{
	Byte t = *a;
	*a = *b;
	*b = t;
}

void int_swap(int* a, int* b)
{
	int t = *a;
	*a = *b;
	*b = t;
}

void gswap(void* a, void* b, Size size)
{
	while(size--) 
	{
		byte_swap((Byte*)a + size, (Byte*)b + size);
	}
}


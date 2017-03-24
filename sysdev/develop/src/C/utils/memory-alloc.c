#include <utils.h>


void default_err_handler()
{
	puts("Memory alloc failed!");
	exit(FAILURE);
}


void* def_malloc(Size x) {
	return sec_malloc(x, default_err_handler);
}

void* def_calloc(Size x, Size n) {
	return sec_calloc(x, n, default_err_handler);
}

void* def_realloc(void* p, Size x) {
	return sec_realloc(p, x, default_err_handler);
}


void* sec_malloc(Size size, void (*err_handle)())
{
	void* block = malloc(size);

	if(block == NULL)
	{
		err_handle();
		return NULL;
	}

	return block;
}

void* sec_calloc(size_t size, Size numb, void (*err_handle)())
{
	void* block = calloc(size, numb);

	if(block == NULL)
	{
		err_handle();
		return NULL;
	}

	return block;
}

void* sec_realloc(void* mem, Size size, void (*err_handle)())
{
	void* block = realloc(mem, size);

	if(block == NULL)
	{
		err_handle();
		return NULL;
	}

	return block;
}



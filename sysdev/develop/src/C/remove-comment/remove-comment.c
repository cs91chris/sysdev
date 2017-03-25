#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE_CHAR sizeof(char)


const char* err_mess  = "\
run ./remove-comment <file-source> <file-destination>\n \
<file-source> != <file-destination> \
";

const char* help_mess = "\
\tIt can remove C and C++ comments in <file-source>\n \
\tand put the output on <file-destination>\n\n \
";

const char* err_load_mess  = "can not load file";
const char* err_write_mess = "can not write on file";
const char* err_alloc_mess = "can not allocate memory";


void quit_on_error(const char *message)
{
	fprintf(stderr, "Error: %s\n", message);
	exit(EXIT_FAILURE);
}

void* sec_realloc(void* mem, size_t size, const char* mess)
{
	void* block = realloc(mem, size);

	if(block == NULL)
	{
		quit_on_error(mess);
		return NULL;
	}

	return block;
}

FILE* open_stream(const char* path, const char* mode)
{
	FILE* stream = fopen(path, mode);

    if(stream == NULL)
		quit_on_error(err_load_mess);

	return stream;
}

char* get_file_content(FILE* stream)
{
	char c;
	size_t size = 0;
	char* buffer = NULL;


	while((c = getc(stream)) != EOF)
	{
		buffer = sec_realloc(buffer, size * SIZE_CHAR, err_alloc_mess);
		buffer[size] = c;
		size++;
	}

	buffer = sec_realloc(buffer, size * SIZE_CHAR, err_alloc_mess);
	buffer[size] = '\0';

	return buffer;
}

char* parse_file(const char* file)
{
	int idx = -1;
	size_t size = 0;
	char* parsed = NULL;


	while(file[++idx] != '\0')
	{
		if(file[idx] == '/')
			switch(file[idx+1])
			{
				case '/':
					while(file[idx] != '\n')
						idx++;
				break;

				case '*':
					idx++;

					while(file[idx++] != '\0')
					{
						if(file[idx] == '*' && file[idx+1] == '/')
						{
							idx += 2;
							idx += (file[idx+1] == '\n'); 
							break;
						}
					}
				break;
			}

		parsed = sec_realloc(parsed, size * SIZE_CHAR, err_alloc_mess);
		parsed[size] = file[idx];
		size++;
	}

	return parsed;
}


int main(int argc, char* argv[])
{
	FILE* input  = NULL;
	FILE* output = NULL;

	char* content = NULL;
	char* parsed  = NULL;

	size_t size = 0;

	const char* infile  = argv[1];
	const char* outfile = argv[2];


	if(argc > 1 && strcmp(argv[1], "help") == 0)
	{
		printf("%s\n%s", err_mess, help_mess);
		return EXIT_SUCCESS;
	}

	if(argc != 3 || strcmp(infile, outfile) == 0)
		quit_on_error(err_mess);


	input  = open_stream(infile,  "r");
	output = open_stream(outfile, "w");

	content = get_file_content(input);
	parsed  = parse_file(content);
	size    = strlen(parsed);

	if(fwrite(parsed, 1, size, output) != size)
		quit_on_error(err_write_mess);

	free(content);
	free(parsed);

	fclose(output);
	fclose(input);

	return EXIT_SUCCESS;
}


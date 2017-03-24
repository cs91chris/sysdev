#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void quit_on_error(const char *message)
{
	fprintf(stderr, "Error: %s\n", message);
	exit(EXIT_FAILURE);
}

FILE* open_stream(const char* path, const char* mode)
{
	FILE* stream = fopen(path, mode);

    if(stream == NULL)
		quit_on_error("can not load file");

	return stream;
}

char* get_file_content(FILE* stream)
{
	char c;
	size_t size = 0;
	char* buffer = NULL;


	while((c = getc(stream)) != EOF)
 	{
		buffer = realloc(buffer, size * sizeof(char));
 		buffer[size] = c;
		size++;
	}

	buffer = realloc(buffer, size * sizeof(char));
	buffer[size] = '\0';

	return buffer;
}

char* parse_file(const char* file)
{
	int i = -1;
	size_t size = 0;
	char* parsed = NULL;


	while(file[++i] != '\0')
	{
		if(file[i] == '/')
			switch(file[i+1])
			{
				case '/':
					while(file[++i] != '\n')
					/* NOP */;
				break;
				case '*':
					while(file[++i])
						if(file[i] == '*' && file[i+1] == '/')
						{
							i += 2;
							break;
						}
				break;
			}

		parsed = realloc(parsed, size * sizeof(char));
		parsed[size] = file[i];
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
	char* path    = NULL;

	size_t size = 0;


	if(argc > 1 && strcmp(argv[1], "help"))
	{
		printf("run ./remove-comment <file-source> <file-destination>\n");
		printf("it can remove C and C++ comments in <file-source>");
		printf("and put the output on <file-destination>"); 
		return EXIT_SUCCESS;
	}

	if(argc != 3 || strcmp(argv[1], argv[2]) == 0)
	{
		quit_on_error("run ./remove-comment <file-source> <file-destination>\n");
	}


	input  = open_stream(argv[1], "r");
	output = open_stream(path, "w");

	content = get_file_content(input);
	parsed  = parse_file(content);
	size    = strlen(parsed);

	if(fwrite(parsed, 1, size, output) != size)
	{
		quit_on_error("can not write on file");
	}

	fclose(output);
	fclose(input);
	free(content);
	free(parsed);
	free(path);

	return EXIT_SUCCESS;
}


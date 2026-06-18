#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
	if (argc != 3) {
		printf("Usage: string-trunc <length> <suffix>\n");
		return 1;
	}

	int length = atoi(argv[1]);
	if (length == 0) {
		printf("Usage: string-trunc <length> <suffix>\n");
		return 1;
	}
	char* suffix = argv[2];

	char buffer[length+5];
	memset(buffer, 0, sizeof(buffer));

	while(fgets(buffer, sizeof(buffer), stdin) != NULL) {

		// https://stackoverflow.com/questions/59847042/how-to-read-only-first-n-characters-from-each-line-in-c-language/59847195#59847195
		char* p = strchr(buffer, '\n');
		if (!p) {
			fscanf(stdin, "%*[^\n]\n");
		} else {
			*p = '\0';
		}

		if (strlen(buffer) >= length) {
			char truncated[length+5];
			memset(truncated, 0, sizeof(truncated));
			strncpy(truncated, buffer, length-strlen(suffix));
			printf("%s%s\n", truncated, suffix);
		} else {
			printf("%s\n", buffer);
		}
	}
}

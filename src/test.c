#include "dijkstra.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char const *argv[])
{
	long **result = gen_temp(10,5);
	long **first = gen_temp(5,5);
	long **second = gen_temp(5,5);

	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++) {
			first[i][j] = 1 * i * j;
			second[i][j] = 2 * i * j;
		}
	}

	memcpy(result,
			first,
			5 * sizeof(int*)
			);

	memcpy(result+5,
			second,
			5 * sizeof(int*)
			);

	for (int i =0; i < 10; i++) {
		for (int j =0; j < 5; j++) {
			printf("%d ", result[i][j]);
		}
		printf("\n");
	}

	return 0;
}
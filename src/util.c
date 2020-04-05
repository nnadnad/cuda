#include "util.h"


/**
 * write matrix of shortest distance from vertex i to j
 * @param graph 2D array 
 */
void write_result(long **m, int n, char filename[]) {

	FILE *outfile;

	printf("here we go, writing file again\n");
	outfile = fopen(filename,"w");
	printf("file %s opened\n", filename);
	if (outfile == NULL) {
		printf("Error!\n");
		exit(1);
	}

	printf("Writing output...\n");
	for (int i = 0; i < n; i++) {
		// printf("about to write row %d\n", i);
		for (int j = 0; j < n; j++) {
			fprintf(outfile, "%ld ", m[i][j]);
		}
		// printf("just write row %d\n", i);
		fprintf(outfile, "\n");
	}

	printf("Done.\n");

}
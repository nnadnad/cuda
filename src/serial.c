#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "dijkstra.h"
#include "util.h"





int main(int argc, char const *argv[])
{
	time_t start,end;
	
	if (argc > 1) {

		int n = atoi(argv[1]);
		printf("n: %d\n", n);

		// start timer
		start=clock(); 
		// generate graph
		long **graph = gen_graph(n);
		
		// result matrix
		long **result = gen_temp(n, n);

		for (int i = 0; i < n; i++) {
        	long *dist = dijkstra(graph, n, i);
        	result[i] = dist;
		}
		//end timer
		end=clock();

		//elapsed time
		float t = (float)(end-start)/CLOCKS_PER_SEC;
		printf("Elapsed time (in millisecond): %f", t*1000000);

		char filename[20];
		sprintf(filename, "./output_serial_%d", n);

		write_result(result, n, filename);
		
		free(result);
		free(graph);

	} else {
		printf("usage : serial [n]\n");
	}

	return 0;
}

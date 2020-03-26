#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "util.h"
#include "dijkstra.h"
#include "boolean.h"


static double get_micros(void) {
    struct timespec ts;
    timespec_get(&ts, TIME_UTC);
    return ((double)((long)ts.tv_sec * 1000000000L + ts.tv_nsec)/1000);
}


int main(int argc, char const *argv[])
{
	// int thread_count = strtol(argv[1], NULL, 10);
	int num_vertices = atoi(argv[2]);
	// int tid;

	// time
	double start_time, end_time, total_time;

	// generate graph and result matrix
	long **result = gen_temp(num_vertices, num_vertices);
	long **graph = gen_graph(num_vertices);

	long *temp = (long*) malloc(sizeof(long)*num_vertices);

	// init time
	total_time = 0;

	#pragma omp barrier
	
	// start time
	start_time = get_micros();

	// share the work to all the threads
	#pragma omp parallel for private(temp)
	for (int i = 0; i < num_vertices; i++) {
		// tid = omp_get_thread_num();
		// printf("i: %d, by the way i'm thread %d\n", i, tid);
		
		// get the shortest path from each vertex
		// get time execution


		temp = dijkstra(graph, num_vertices, i);

		// kalo barrier nya disini error
		end_time = get_micros();

		
		// put it in result
		// #pragma omp critical(result) 
		// {
		for (int j = 0; j < num_vertices; j++) {
			result[i][j] = temp[j];
		}
		// }

		total_time += end_time - start_time;
	}
		// #pragma omp barrier
		// total_time += end_time - start_time;

	char filename[20];
	sprintf(filename, "./output_parallel_%d", num_vertices);
	printf("about to write output file\n");
	write_result(result, num_vertices, filename);
	printf("done writing\n");
	printf("processing time: %0.04lf us ...\n",total_time);

	return 0;
}
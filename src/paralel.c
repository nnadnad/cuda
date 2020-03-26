#include "dijkstra.h"
#include "util.h"
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#include <string.h>


int main(int argc, char *argv[])
{
	int numprocs, rank;
	char processor_name[MPI_MAX_PROCESSOR_NAME];
	int name_len;

	int np = atoi(argv[1]);
	int numvertices = atoi(argv[2]);
	int chunk_size = ceil(numvertices/np);
	// printf("chunk_size : %d\n", chunk_size);
	// printf("np : %d\n", np);
	// printf("numvertices : %d\n", numvertices);


	MPI_Status Stat;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Get_processor_name(processor_name, &name_len);


	double start_time, finish_time;

	// generate graph
	// printf("about to generate our graph\n");
	long **graph = gen_graph(numvertices);

	// start the timer
	MPI_Barrier(MPI_COMM_WORLD);
	start_time = MPI_Wtime();


	// set chunk size and local src
	// int my_first_src = rank * ceil(numvertices/numprocs);
	// int my_last_src = my_first_src + chunk_size;
	int my_first_src = rank * chunk_size;
	// int my_last_src = if (my_first_src+chunk_size < numvertices)? my_first_src+chunk_size:;

	if (rank == 0) {
		printf("chunk_size : %d\n", chunk_size);
	}
	printf("i'm node %d, my_first_src: %d\n", rank, my_first_src);	
	// printf("i'm node %d, my_last_src: %d\n", rank, my_last_src);	



	// long **my_results = (long **) malloc(chunk_size * sizeof(long*));
	// allocate 2D array for local result
	// printf("initiate my result\n");
	long **my_results = gen_temp(chunk_size, numvertices);
	// printf("done initiating my result\n");

	// find shortest path from each src
	for (int i = 0; i+my_first_src < numvertices && i < chunk_size; i++) {
		// printf("i'm node %d and currently working on row %d \n", rank, i+my_first_src);
		long *dist = dijkstra(graph, numvertices, i+my_first_src);
		my_results[i] = dist;
	}
	// printf("hi i'm node %d and i'm done searching\n", rank);


	// TBD gathering data from these processes
	if ( rank == 0 ) { // gather data from other nodes
		long **result = gen_temp(numvertices, numvertices);
		// printf("generated empty result matrix\n");
		// long **temp = gen_temp(chunk_size, numvertices);
		long *temp = (long*) malloc(numvertices * sizeof(long));
		// printf("generated temp\n");

		memcpy(result,
				my_results,
				chunk_size*sizeof(long*));
		printf("copying temp to result\n");

		for (int i = 1; i < numprocs; i++) {
			printf("about to receive local result from node %d\n", i);

			for (int j = 0; j < chunk_size; j++) { // loop buat nerima tiap baris dari node lain
				MPI_Recv(temp,
						 numvertices*sizeof(long),
						 MPI_LONG,
						 i,
						 0,
						 MPI_COMM_WORLD,
						 MPI_STATUS_IGNORE);
				// for (int i=0;i<numvertices;i++) {
				// 	printf("%d ", temp[i]);
				// }
				// printf("\n");
				// printf("alamat result yang mau ditulis: result+ %d\n", (i*chunk_size)+(j*numvertices));
				// memcpy(result+((i*chunk_size)+(j*numvertices)),
				// 	    temp,
				// 	    chunk_size*sizeof(long));
				for (int k = 0; k < numvertices; k++) {
					result[i*chunk_size+j][k] = temp[k];
				}
					

			}

			printf("done receiving local result from node %d\n", i);

			// for (int i =0; i < chunk_size; i++) {
			// 	for (int j= 0 ; j < numvertices; j++){
			// 		printf("%ld ", temp[i][j]);
			// 	}
			// 	printf("\n");
			// }
			printf("copying local result from node %d to result\n", i);
				

		}

		// for (int i=0; i < numvertices; i++) {
		// 	printf("row %d\n", i);
		// 	for (int j = 0; j < numvertices; j++) {
		// 		printf("%d ", result[i][j]);
		// 	}
		// 	printf("\n");
		// }
		// 

		char filename[20];
		sprintf(filename, "./output_parallel_%d", numvertices);
		printf("about to write output file\n");
		write_result(result, numvertices, filename);
		printf("done writing\n");

		//free result (2d arr)
		for(int i = 0; i < numvertices; i++){	
			free(result[i]);
		}
		printf("freeing result\n");
		//free temp (1d arr)
		free(temp);
		printf("freeing temp\n");


	} else { // send my_results to master node
		printf("i'm node %d and i'm going to send my result to master\n", rank);
			for(int i = 0; i < chunk_size; i++) {
				MPI_Send(my_results[i],
						 chunk_size*sizeof(long),
						 MPI_LONG,
						 0,
						 0,
						 MPI_COMM_WORLD
						 );

			}
		printf("i'm node %d and i'm just sent my result to master\n", rank);
	}


	// printf("I'm process %d and the distance from vertex 1 to 2 is %d\n", 
	// rank, 
	// graph[0][1]);
	// 
	MPI_Barrier(MPI_COMM_WORLD);
	finish_time = MPI_Wtime();

	if (rank == 0) {
		printf("elapsed time : %.lf ms\n", (finish_time-start_time)*1000000);
	}
	
	
	//free my_results (2d arr)
	free(my_results);
	printf("freed my_results\n");
	//free graph (2d arr)
	free(graph);
	printf("freed graph\n");

	MPI_Finalize();


	return 0;
}
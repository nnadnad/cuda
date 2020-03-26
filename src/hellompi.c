#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc,char *argv[]) {
  int numtasks, rank;
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  int arr_size = 3;


  MPI_Status Stat;
  MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Get_processor_name(processor_name, &name_len);
  // printf("Hello from processor %s, task %d of %d, argv[1]: %s\n",
  // processor_name, rank, numtasks, argv[1]);
  // 
  
  int *result_arr = (int *) malloc(arr_size * numtasks * sizeof(int));
  // int **local_mat = (int **) malloc(arr_size * sizeof(int*));
  int *local_arr = (int *) malloc(arr_size * sizeof(int));
  
  // for (int i = 0; i < arr_size; i++) {
  //   local_mat = (int*) malloc(5 *sizeof(int));
  // }
  
  // for (int i = 0; i < r; i++) {
  //     for (int j = i; j < c; j++) {
  //       local_mat[i][j] = local_mat[j][i] = 0;
  //     }
  // }  

  for (int i = 0; i < arr_size; i++) {
    local_arr[i] = i*rank*3;
  }

  if (rank == 0) {
    // int **local_mat = (int **) malloc(arr_size * sizeof(int*));
    
    int *temp = (int *) malloc(arr_size * sizeof(int));
    


    // initiate result arr
    for (int i = 0; i < arr_size; i++) {
      result_arr[i] = local_arr[i];
    }

    // terima array dari tiap node
    for (int i = 1; i < numtasks; i++) {
      MPI_Recv( temp, 
              arr_size*sizeof(int), 
              MPI_INT, 
              i,
              0,
              MPI_COMM_WORLD,
              MPI_STATUS_IGNORE
              );
      // salin array ke result_arr
      // result_arr[i*arr_size] = temp;
      memcpy(result_arr+(arr_size*i),
             temp,
             arr_size* sizeof(int)
             );
      
      
      
      // for (int j = 0; j < arr_size && j+(rank*arr_size); j++) {
      //   result_arr[j+i*arr_size] = temp[j];
      // }
      // 
      // printf("array from node %d\n", i);
      // for(int j = 0; j < arr_size; j++) {
      //   printf("%d ", temp[j]);
      // }
      // printf("\n");
    }
  } else {
    MPI_Send( local_arr,
              arr_size*sizeof(int),
              MPI_INT,
              0,
              0,
              MPI_COMM_WORLD
              );
  }

  if (rank == 0) {
    printf("here is the array you ordered\n");
    for (int i=0; i<arr_size*numtasks; i++){
      printf("%d ", result_arr[i]);
    }
    printf("\n");
  }
  
  free(local_arr);
  free(result_arr);

  MPI_Finalize();
} 

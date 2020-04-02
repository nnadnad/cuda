#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define true 1
#define false 0


__device__
int min_distance(int dist[], int spt_set[], int n) {
    int min = INT_MAX, min_index;
    for (int v = 0; v < n; v++) {
        if (spt_set[v] == false && dist[v] <= min){
            min = dist[v], min_index = v;
        }
    }
    return min_index;
}

__device__
void dijkstra(int* graph, int* res, int src, int n) {
    // inisiasi ukuran matriks maksimal yang dibutuhkan sesuai testcase
    int dist[3000];
    int spt_set[3000];
    

    //init distance and spt_set
    for (int i = 0; i < n; i++) {
        dist[i] = INT_MAX;
        spt_set[i] = false;
    }

    // init distance dengan 0 semua
    dist[src] = 0;

    for (int count = 0; count < n - 1; count++) {
        int u = min_distance(dist, spt_set, n);
        spt_set[u] = true;
      for (int v = 0; v < n; v++) {
        if (!spt_set[v] && graph[u*n+v] && dist[u] != INT_MAX && dist[u] + graph[u*n+v] < dist[v]) {
            dist[v] = dist[u] + graph[u*n+v];
        }
      }
    }
    for (int i = 0; i < n; i++) {
        res[src*n + i] = dist[i];
    }
}

// random matriks dengan nim
__host__
void random_matriks(int* host_matrix, int num_nodes) {
    srand(13517074);
    // init distance
    for (int i = 0; i < num_nodes; i++) {
        for (int j = i; j < num_nodes; j++) {
            if (i == j) {
                host_matrix[i*num_nodes + j] = 0;
            } else {
                host_matrix[i*num_nodes + j] = rand() % 100;
                host_matrix[j*num_nodes + i] = host_matrix[i*num_nodes + j];
            }
        }
    }
}

__host__
void print_matriks(int* host_matrix, int num_nodes) {
    for (int i = 0; i < num_nodes; i++) {
        for (int j = 0; j < num_nodes; j++) {
            printf("%d\t", host_matrix[i*num_nodes + j]);
        }
        printf("\n");
    }
}

__global__
void solution (int* graph, int* result, int nodes_count) {
  // init source for check matriks
  /* gridDim: variabel yang berisi dimensi dari grid.
   * blockIdx: variabel yang berisi index block di mana thread ini berada.
   * blockDim: variabel yang berisi dimensi dari block.
   * threadIdx: variabel yang berisi index thread di dalam block. (untuk membedakan thread yang berada di block yang berbeda, gunakan blockIdx).*/
  int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < nodes_count) {
        dijkstra(graph, result, i, nodes_count);
    }
}

int main(int argc, char *argv[]) {
  int nodes_count = strtol(argv[2], NULL, 10);
  int num_thread = atoi(argv[1]);
  size_t size = nodes_count*nodes_count*sizeof(int);


  //cuda variabel for calculate time
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);


  // built in vaaribels
  int threads_per_block = num_thread;
  int blocks_in_grid = (nodes_count / threads_per_block) + 1;

  // Allocate memory on host
  int *host_matrix, *host_result_matrix;
  host_result_matrix = (int*)malloc(size);
  host_matrix = (int*)malloc(size);
  
  // Allocate memory on device
  int *device_matrix, *device_result_matrix;
  // check when the matrix allocation with the given size, it should not give an error
  cudaError_t err = cudaMalloc(&device_matrix, size);
  if(err != cudaSuccess) {
    printf("Error Device Matrix: %s\n", cudaGetErrorString(err));
  }
  err = cudaMalloc(&device_result_matrix, size);
  if(err != cudaSuccess) {
    printf("Error Device Result Matrix: %s\n", cudaGetErrorString(err));
  }
  
  // Random matrix
  random_matriks(host_matrix, nodes_count);
  // Copy data from host to device
  cudaMemcpy(device_matrix, host_matrix, size, cudaMemcpyHostToDevice);

  // start calucate and time
  cudaEventRecord(start);
  // run solution to find dijkstra
  solution<<< blocks_in_grid, threads_per_block >>>(device_matrix, device_result_matrix, nodes_count);
  cudaError_t errAsync = cudaDeviceSynchronize();
  if(errAsync != cudaSuccess) {
    printf("Error Async: %s\n", cudaGetErrorString(errAsync));
  }
  // Copy data from device to host
  cudaMemcpy(host_result_matrix, device_result_matrix, size, cudaMemcpyDeviceToHost);
  // stop
  cudaEventRecord(stop);

  cudaEventSynchronize(stop);
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  // hasil matriks dan waktu kalkuklasi nya
  printf("\n");
  printf("~=== Result Matrix ===~\n");
  print_matriks(host_result_matrix, nodes_count);
  printf("\ntime execution: %f microsecond(s)\n", milliseconds*1000);
  
  // free host memory
  free(host_matrix);
  free(host_result_matrix);
  
  // free device memory
  cudaFree(device_matrix);
  cudaFree(device_result_matrix);

  return 0;
}

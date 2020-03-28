#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define true 1
#define false 0


__device__
int minDistance(int dist[], int sptSet[], int num_vertex) {
  int min = INT_MAX, min_index;
  for (int v = 0; v < num_vertex; v++)
    if (sptSet[v] == false && dist[v] <= min)
      min = dist[v], min_index = v;
  return min_index;
}

__device__
void dijkstra(int* graph, int* res, int src, int num_vertex) {
  int dist[3000];
  int sptSet[3000];
  for (int i = 0; i < num_vertex; i++) 
    dist[i] = INT_MAX, sptSet[i] = false;

  dist[src] = 0;

  for (int count = 0; count < num_vertex - 1; count++) {
    int u = minDistance(dist, sptSet, num_vertex);

    sptSet[u] = true;

    for (int v = 0; v < num_vertex; v++)

      if (!sptSet[v] && graph[u*num_vertex+v] && dist[u] != INT_MAX
        && dist[u] + graph[u*num_vertex+v] < dist[v])
        dist[v] = dist[u] + graph[u*num_vertex+v];
  }

  for (int i = 0; i < num_vertex; i++)
    res[src*num_vertex + i] = dist[i];
}

__host__
void RandomMatrix(int* adj_matrix, int num_nodes) {
  srand(13517001);
  // init distance
  for (int i = 0; i < num_nodes; i++) {
    for (int j = i; j < num_nodes; j++) {
      if (i == j) {
        adj_matrix[i*num_nodes + j] = 0;
      } else {
          adj_matrix[i*num_nodes + j] = rand() % 100;
      adj_matrix[j*num_nodes + i] = adj_matrix[i*num_nodes + j];
      }
    }
  }
}

__host__
void PrintMatrix(int* adj_matrix, int num_nodes) {
  for (int i = 0; i < num_nodes; i++) {
    for (int j = 0; j < num_nodes; j++) 
      printf("%d\t", adj_matrix[i*num_nodes + j]);
    printf("\n");
  }
}

__global__
void debug(int x) {
  printf("DEBUG %d >>>\n", x);
}

__global__
void CalcDijkstra (int* graph, int* result, int nodes_count) {
  
  int i = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < nodes_count)
    dijkstra(graph, result, i, nodes_count);
}

int main(int argc, char *argv[]) {
  int nodes_count = strtol(argv[2], NULL, 10);
  int num_thread = atoi(argv[1]);
  size_t size = nodes_count*nodes_count*sizeof(int);
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  int threads_per_block = num_thread;
  int blocks_in_grid = (nodes_count/threads_per_block) +1;

  // Allocate memory on host
  int *adj_matrix, *result_matrix;
  result_matrix = (int*)malloc(size);
  adj_matrix = (int*)malloc(size);
  
  // Allocate memory on device
  int *dev_matrix, *dev_result;
  cudaError_t err = cudaMalloc(&dev_matrix, size);
  if(err != cudaSuccess) printf("Error Malloc 1: %s\n", cudaGetErrorString(err));
  err = cudaMalloc(&dev_result, size);
  if(err != cudaSuccess) printf("Error Malloc 2: %s\n", cudaGetErrorString(err));
  
  // Random matrix
  RandomMatrix(adj_matrix, nodes_count);
  
  printf("~=== Awal  ===~\n");
  PrintMatrix(adj_matrix, nodes_count);

  // Copy data from host to device
  cudaMemcpy(dev_matrix, adj_matrix, size, cudaMemcpyHostToDevice);
  
  // start
  cudaEventRecord(start);

  CalcDijkstra<<< blocks_in_grid, threads_per_block >>>(dev_matrix, dev_result, nodes_count);
  cudaError_t errAsync = cudaDeviceSynchronize();
  if(errAsync != cudaSuccess) printf("Error Async: %s\n", cudaGetErrorString(errAsync));

  // Copy data from device to host
  cudaMemcpy(result_matrix, dev_result, size, cudaMemcpyDeviceToHost);

  // stop
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  printf("\n");
  printf("~=== Hasil ===~\n");
  PrintMatrix(result_matrix, nodes_count);
  printf("\ntime: %f microsecond(s)\n", milliseconds*1000);
  
  // free host memory
  free(adj_matrix);
  free(result_matrix);
  
  // free device memory
  cudaFree(dev_matrix);
  cudaFree(dev_result);

  return 0;
}

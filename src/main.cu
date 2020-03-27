#include "header.h"
#include "dijkstra.cu"

int main(int argc, char *argv[]) {
    //variable
    int num_of_thread = atoi(argv[1]);
    int num_of_vertices = strtol(argv[2],NULL,10);
    size_t size = num_of_vertices * num_of_vertices * sizeof(int);
    int *adj_matrix, *result_matrix;
    int *dev_matrix, *dev_result;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    int threads_per_block = num_of_thread;
    int blocks_in_grid = ceil(float(num_of_vertices)/threads_per_block);
    // dim3 threads_per_block(num_of_thread, num_of_thread, 1);
    // dim3 blocks_in_grid(ceil( float(num_of_vertices) / threads_per_block.x ),
    //                     ceil( float(num_of_vertices) / threads_per_block.y ), 1 );
    // Allocate memory on host
    result_matrix = (int*)malloc(size);
    adj_matrix = (int*)malloc(size);
    
    // Allocate memory on device
    cudaMalloc(&dev_matrix, size);
    cudaMalloc(&dev_result, size);

    // Random matrix
    randMatriks(adj_matrix, num_of_vertices);
    // randMatriks(result_matrix, num_of_vertices);
    PrintMatriks(result_matrix, num_of_vertices);

    // printf("~=== Awal  ===~\n");
    PrintMatriks(adj_matrix, num_of_vertices);

    // Copy data from host to device
    cudaMemcpy(dev_matrix, adj_matrix, size, cudaMemcpyHostToDevice);
    
    // start
    cudaEventRecord(start);

    solution<<< blocks_in_grid, threads_per_block >>>(dev_matrix, dev_result, num_of_vertices);
    cudaDeviceSynchronize();

    // Copy data from device to host
    cudaMemcpy(result_matrix, dev_result, size, cudaMemcpyDeviceToHost);

    // stop
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    printf("\n");
    printf("~=== Hasil Matriks===~\n");
    PrintMatriks(result_matrix, num_of_vertices);
    printf("\ntime: %f microsecond(s)\n", milliseconds*1000);
    
    // free host memory
    free(adj_matrix);
    free(result_matrix);
    
    // free device memory
    cudaFree(dev_matrix);
    cudaFree(dev_result);

    return 0;
}
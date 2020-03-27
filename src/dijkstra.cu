#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>

#include "boolean.h"



/**
 * Get vertex index with minimum distance which not yet included
 * in spt_set
 * @param  dist    distance from origin vertex to vertex with that index
 * @param  spt_set a set denoting vertices included in spt_set
 * @param n number of vertices in the graph
 * @return         index of minimum distance not yet included in spt_set
 */
__device__ int min_distance_idx(long *dist, bool spt_set[], int n) {
	// Initialize min value 
    int min = INT_MAX, min_index; 
    for (int i = 0; i < n; i++) {
        if (spt_set[i] == false && dist[i] <= min) {
            min = dist[i];
            min_index = i;
        }
    } 
    return min_index; 
}

/**
 * generate a graph with n vertices
 * @param  n number of vertices
 * @param matriks matriks untuk isi hasil random angka
 */
__host__ void randMatriks(int *matriks, int n) {
    srand(13517074);

    // isi matriks dengan bilangan random
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (i == j) {
                matriks[i*n + j] = 0;
            } else {
                matriks[i*n + j] = matriks[j*n + i] = rand()%100;
            }
        }
    }
}

__host__ void PrintMatriks(int *matriks, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d\t", matriks[i*n + j]);
            printf("\n");
        }
    }
}

__device__ int dijkstra(int* graph, int src, int n) {
    // output array, contains shortest distance form src to every vertices
    int *dist = (int*)malloc(n*sizeof(int));
    
    // spt_set[i] is true if vertex i already included in the shortest path tree
    bool  spt_set[n];
    // int *spt_set = (int*)malloc(n*sizeof(int));
    
    // initialize dist and spt_set
    for (int i = 0; i < n; i++) {
        dist[i] = INT_MAX;
        spt_set[i] = false;
    }

    // init path searching
    dist[src] = 0;

    // find the shortest path for all vertices
    for (int i = 0; i < n - 1; i++) {

        // pick vertex with minimun distance from src
        // form spt_set not yet processed
        int processed_vertex = min_distance_idx(dist, spt_set, n);
        
        // mark vertex as processed
        spt_set[processed_vertex] = true;
        
        
        for (int v = 0; v < n; v++) {
            if (!spt_set[v] 
                && graph[processed_vertex*n + v] 
                && dist[processed_vertex] != INT_MAX
                && dist[processed_vertex] + graph[processed_vertex*n + v] < dist[v]) {
                    dist[v] = dist[processed_vertex] + graph[processed_vertex*n + v];
                }
        }
    }

    // save result
    int* result;
    result = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        result[i] = dist[i];
    }
    free(dist);
    free(spt_set);
    
    return result;
}

__global__ void solution(int *graph, int *result, int n) {
    int src = blockDim.x * blockIdx.x + threadIdx.x;

    if (src < n) {
        // alokasi memori
        int *matriks = (int*)malloc(n * sizeof(int));

        //hitung dijkstra
        matriks = dijkstra(graph, src, n);

        // calculate
        for (int i = 0; i < n; i++) {
            result[src*n + i] = matriks[i];
        }
        free(matriks);
    }
}



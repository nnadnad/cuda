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
void RandomMatrix(int* matriksAwal, int num_nodes) {
    srand(13517074);
    // init distance
    for (int i = 0; i < num_nodes; i++) {
        for (int j = i; j < num_nodes; j++) {
            if (i == j) {
                matriksAwal[i*num_nodes + j] = 0;
            } else {
                matriksAwal[i*num_nodes + j] = rand() % 100;
                matriksAwal[j*num_nodes + i] = matriksAwal[i*num_nodes + j];
            }
        }
    }
}

__host__
void PrintMatrix(int* matriksAwal, int num_nodes) {
    for (int i = 0; i < num_nodes; i++) {
        for (int j = 0; j < num_nodes; j++) {
            printf("%d\t", matriksAwal[i*num_nodes + j]);
            printf("\n");
        }
    }
}

__global__
void solution (int* graph, int* result, int nodes_count) {
  int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < nodes_count) {
        dijkstra(graph, result, i, nodes_count);
    }
}
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>

#include "boolean.h"
#define true 1
#define false 0


int min_distance_idx(long *dist, bool spt_set[], int n);
void randMatriks(int *matriks, int n);
void PrintMatriks(int *matriks, int n);
int dijkstra(int* graph, int src, int n);
void solution(int *graph, int *result, int n);
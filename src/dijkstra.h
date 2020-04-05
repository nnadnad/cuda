#ifndef DIJKSTRA_H
#define DIJKSTRA_H
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include "boolean.h"

/**
 * Get vertex index with minimum distance which not yet included
 * in spt_set
 * @param  dist    distance from origin vertex to vertex with that index
 * @param  spt_set a set denoting vertices included in spt_set
 * @return         index of minimum distance not yet included in spt_set
 */
int min_distance_idx(long dist[], bool spt_set[], int n);


/**
 * generate a graph with n vertices
 * @param  n number of vertices
 * @return   2D array, graph[i][j] = graph[j][i] = distance from vertex i to j
 */
long **gen_graph(int n);


/**
 * generate 2D array with dimension of r x c
 * @param  r number of rows
 * @param c number of columns
 * @return   2D array, all filled with zero
 */
long **gen_temp(int r, int c);

/**
 * 
 * @param graph [description]
 * @param n     [description]
 * @param src   [description]
 */
long *dijkstra(long **graph, int n, int src);


#endif
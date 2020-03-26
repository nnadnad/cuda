#ifndef UTIL_H
#define UTIL_H
#include <stdio.h>
#include <stdlib.h>

/**
 * write matrix of shortest distance from vertex i to j
 * @param m 2D array, m[i][j] = m[j][i] = shortest distance from vertex i to j
 * @param n     dimension of matrix m
 */
void write_result(long **m, int n, char filename[]);


#endif
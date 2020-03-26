#include "dijkstra.h"


/**
 * Get vertex index with minimum distance which not yet included
 * in spt_set
 * @param  dist    distance from origin vertex to vertex with that index
 * @param  spt_set a set denoting vertices included in spt_set
 * @param n number of vertices in the graph
 * @return         index of minimum distance not yet included in spt_set
 */
int min_distance_idx(long dist[], bool spt_set[], int n) {
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
 * @return   2D array, graph[i][j] = graph[j][i] = distance from vertex i to j
 */
long **gen_graph(int n) {
	// alokasi memori untuk matriks yang merepresentasikan graf
	long **result = (long **)malloc(n * sizeof(long *)); 
    for (int i = 0; i < n; i++) {
    	result[i] = (long *)malloc(n * sizeof(long)); 
    }    
  
    // isi matriks dengan bilangan random
    srand(13517122);
    
    for (int i = 0; i < n; i++) {
    	for (int j = i; j < n; j++) {
    		if (i == j) {
    			result[i][j] = 0;
    		} else {
    			result[i][j] = result[j][i] = rand();	
    		}
    		
    	}
    }
     
 	return result; 
}

long **gen_temp(int r, int c) {
	// alokasi memori untuk matriks yang merepresentasikan graf
	long **result = (long **)malloc(r * sizeof(long *)); 
	// printf("[gen_temp] initiate temp\n");
    for (int i = 0; i < r; i++) {
    	result[i] = (long *)malloc(c * sizeof(long)); 
    	// printf("[gen_temp] initiate each row in temp\n");
    }    
    
    for (int i = 0; i < r; i++) {
    	for (int j = 0; j < c; j++) {
    		// printf("[gen_temp] filling temp\n");
    		result[i][j] = 0;
    	}
    }
     
 	return result; 
}


long *dijkstra(long **graph, int n, int src) {

	// output array, contains shortest distance from src to every vertices
	long *dist = (long *) malloc (sizeof(long) * n);
	// spt_set[i] is true if vertex i already included in the shortest path tree
	bool spt_set[n];

	// initialize dist and spt_set
	for (int i = 0; i < n; i++) {
		dist[i] = INT_MAX;
		spt_set[i] = false;
	}

	// initiate path searching 
	dist[src] = 0;


	// find the shortest path for all vertices
	for (int i = 0; i < n; i++) {

		// pick vertex with minimum distance from src from spt_set not yet
		// processed
		int processed_vertex = min_distance_idx(dist, spt_set, n);

		// mark vertex as processed
		spt_set[processed_vertex] = true;

		for (int j = 0; j < n; j++) {
			// check vertices connected to processed_vertex not yet processed
			if (!spt_set[j] 
				&& graph[processed_vertex][j] != 0
				&& dist[processed_vertex] != INT_MAX 
				&& dist[processed_vertex] + graph[processed_vertex][j] < dist[j]) {

				dist[j] = dist[processed_vertex] + graph[processed_vertex][j];
			}
		}
	}

	return dist;
}
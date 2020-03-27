#include "header.h"
#include "dijkstra.cu"

int main(int argc, char *argv[]) {
    //variable
    int num_of_thread = atoi(argv[1]);
    int num_of_vertices = strtol(argv[2],NULL,10);
    size_t size = num_of_vertices * num_of_vertices * sizeof(int);

    return 0;
}
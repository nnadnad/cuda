serial: ./src/serial.c ./src/dijkstra.* ./src/util.*
	gcc ./src/serial.c ./src/dijkstra.c ./src/util.c -o ./bin/serial
	./bin/serial $(n)

parallel: ./src/paralel.c ./src/util.* ./src/dijkstra.*
	mpicc ./src/paralel.c ./src/util.c ./src/dijkstra.c -o ./bin/parallel
	mpirun -np $(np) --hostfile mpi_hostfile ./bin/parallel $(np) $(nv)

run_par: ./bin/parallel
	mpirun -np $(np) --hostfile mpi_hostfile ./bin/parallel $(np) $(nv)

hello_omp: ./src/hello_openmp.c
	gcc -g -Wall -fopenmp -o ./bin/hello_omp ./src/hello_openmp.c
	./bin/hello_omp $(nt)

parallel_omp: ./src/paralel_openmp.c
	gcc -g -Wall -fopenmp -o ./bin/parallel_omp ./src/paralel_openmp.c ./src/util.c ./src/dijkstra.c
	./bin/parallel_omp $(nt) $(nv)
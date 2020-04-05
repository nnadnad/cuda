NVCC = nvcc
DJ = ./main

run : compile bin/main
	@read -p "Thread, Nodes, Nama Output : " thread node output && bin/${DJ} $$thread $$node > output/$$output.txt

compile: src/main.cu
	${NVCC} -G -o bin/main src/main.cu

serial: ./src/serial.c ./src/dijkstra.* ./src/util.*
	gcc ./src/serial.c ./src/dijkstra.c ./src/util.c -o ./bin/serial
	./bin/serial $(n)

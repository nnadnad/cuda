NVCC = nvcc
DJ = ./main

run : compile bin/main
	@read -p "Thread, Nodes, Nama Output : " thread node output && bin/${DJ} $$thread $$node > output/$$output.txt

compile: src/dijkstra.cu
	${NVCC} -o bin/main src/dijkstra.cu src/main.cu

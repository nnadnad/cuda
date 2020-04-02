NVCC = nvcc
DJ = ./main

run : compile bin/main
	@read -p "Thread, Nodes, Nama Output : " thread node output && bin/${DJ} $$thread $$node > output/$$output.txt

compile: src/main.cu
	${NVCC} -G -o bin/main src/main.cu

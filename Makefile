# Define targets
.PHONY: all clean run_native run_wasm pull_cache

# Default target
all: run_native run_wasm


run_native:
	docker run --rm sangeetakakati/rust-matrix-native:latest
	docker run --rm sangeetakakati/tinygo-matrix-native:latest
	docker run --rm sangeetakakati/cpp-matrix-native:latest

run_wasm:
	docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm sangeetakakati/rust-matrix-wasm:wasm
	docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm sangeetakakati/tinygo-matrix-wasm:wasm
	docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm sangeetakakati/cpp-matrix-wasm:wasm

pull_cache:
	./pull+cache.sh

clean:
	docker rmi sangeetakakati/rust-matrix-native:latest
	docker rmi sangeetakakati/tinygo-matrix-native:latest
	docker rmi sangeetakakati/cpp-matrix-native:latest
	docker rmi sangeetakakati/rust-matrix-wasm:wasm
	docker rmi sangeetakakati/tinygo-matrix-wasm:wasm
	docker rmi sangeetakakati/cpp-matrix-wasm:wasm
	docker system prune -a -f


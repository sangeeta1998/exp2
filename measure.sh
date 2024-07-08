#!/bin/bash

# Build the native container
echo "Building native container..."
docker build -t sangeetakakati/rust-matrix-native:latest ./serverless_rust

# Build the Wasm container
echo "Building Wasm container..."
docker buildx build --platform wasi/wasm -t sangeetakakati/rust-matrix-wasm:latest ./serverless_wasm

# Pull the images (ensure latest is used)
echo "Pulling the native container image..."
docker pull sangeetakakati/rust-matrix-native:latest

echo "Pulling the Wasm container image..."
docker pull sangeetakakati/rust-matrix-wasm:latest

# Get the image sizes
native_size=$(docker images sangeetakakati/rust-matrix-native:latest --format "{{.Size}}")
wasm_size=$(docker images sangeetakakati/rust-matrix-wasm:latest --format "{{.Size}}")

# Measure native container startup time and execution time
echo "Measuring native container performance..."
start_time=$(date +%s%3N)
docker run --rm sangeetakakati/rust-matrix-native:latest > native_output.txt
end_time=$(date +%s%3N)
startup_time_native=$((end_time - start_time))
execution_time_native=$(grep "Time taken:" native_output.txt | awk '{print $3}')

# Measure Wasm container startup time and execution time using wasmtime
echo "Measuring Wasm container performance..."
start_time=$(date +%s%3N)
docker run --rm --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm sangeetakakati/rust-matrix-wasm:latest > wasm_output.txt
end_time=$(date +%s%3N)
startup_time_wasm=$((end_time - start_time))
execution_time_wasm=$(grep "Time taken:" wasm_output.txt | awk '{print $3}')

# Output the results
echo "Native container size: ${native_size}"
echo "Wasm container size: ${wasm_size}"
echo "Native container startup time: ${startup_time_native} ms"
echo "Wasm container startup time: ${startup_time_wasm} ms"
echo "Native container execution time: ${execution_time_native}"
echo "Wasm container execution time: ${execution_time_wasm}"


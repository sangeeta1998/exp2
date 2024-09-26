#!/bin/bash

# Function to detect system architecture
detect_architecture() {
    local arch=$(uname -m)
    case $arch in
        x86_64)
            echo "amd64"
            ;;
        aarch64)
            echo "arm64"
            ;;
        *)
            echo "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
}

# Function to measure execution time using the 'time' command
measure_execution_time() {
    image=$1
    runtime=$2
    platform=$3
    container_name="test_container"

    # Print a clear separator
    echo -e "\n============================================"
    echo "Running $image with $runtime"
    echo "--------------------------------------------"

    # Remove the image to ensure cold start
    docker rmi -f $image

    # Measure execution time
    if [ -z "$runtime" ]; then
        # For native containers
        time docker run --name $container_name --rm $image 
        echo -e "--------------------------------------------"
        echo "Execution for $image (native) completed"
    else
        # For Wasm containers with specific runtime
        time docker run --runtime=$runtime --platform=$platform --name $container_name --rm $image
        echo -e "--------------------------------------------"
        echo "Execution for $image with $runtime completed"
    fi
}

# Detect current system architecture
arch=$(detect_architecture)

# Define image names with appropriate architecture tags
rust_native_image="sangeetakakati/rust-matrix-native:latest"
tinygo_native_image="sangeetakakati/tinygo-matrix-native:latest"
rust_wasm_image="sangeetakakati/rust-matrix-wasm:wasm"
tinygo_wasm_image="sangeetakakati/tinygo-matrix-wasm:wasm"

# Measure execution time for each runtime
measure_execution_time "$rust_native_image" "" "$arch"
measure_execution_time "$rust_wasm_image" "io.containerd.wasmtime.v2" "wasm"
#measure_execution_time "$rust_wasm_image" "io.containerd.wasmedge.v1" "wasm"
#measure_execution_time "$rust_wasm_image" "io.containerd.wasmer.v1" "wasm"

measure_execution_time "$tinygo_native_image" "" "$arch"
measure_execution_time "$tinygo_wasm_image" "io.containerd.wasmtime.v2" "wasm"
#measure_execution_time "$tinygo_wasm_image" "io.containerd.wasmedge.v1" "wasm"
#measure_execution_time "$tinygo_wasm_image" "io.containerd.wasmer.v1" "wasm"

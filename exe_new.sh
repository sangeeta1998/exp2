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
    container_name="test_container_$(date +%s%N)" # Unique container name based on timestamp
    fresh_pull=$4

    echo -e "\n============================================"
    echo "Running $image with $runtime (Fresh Pull: $fresh_pull)"
    echo "--------------------------------------------"

    if [ "$fresh_pull" = true ]; then
        # Force remove the image before pulling
        echo "Removing image $image to force fresh pull..."
        docker rmi -f $image 2>/dev/null || true

        # Measure image pull time
        start_time=$(date +%s%N)
        if [[ $image == *"wasm"* ]]; then
            docker pull --platform wasm $image
        else
            docker pull $image
        fi
        end_time=$(date +%s%N)
        image_pull_time=$((($end_time - $start_time) / 1000000))
        echo "Image Pull Time: $image_pull_time ms"
    else
        image_pull_time=0
        echo "Skipping image pull for cached image: $image"
    fi

    # Measure container startup and application execution time
    start_time=$(date +%s%N)
    if [ -z "$runtime" ]; then
        # For native containers
        docker run --name $container_name --rm $image &
    else
        # For Wasm containers with specific runtime
        docker run --runtime=$runtime --platform=$platform --name $container_name --rm $image &
    fi
    container_pid=$!
    wait $container_pid
    end_time=$(date +%s%N)
    container_execution_time=$((($end_time - $start_time) / 1000000))
    echo "Container Execution Time: $container_execution_time ms"

    # Since the container is removed automatically, no need to call docker rm
    echo -e "--------------------------------------------"
    echo "Execution for $image completed"

    # Log total execution time
    total_time=$(($image_pull_time + $container_execution_time))
    echo "Total Execution Time: $total_time ms" | tee -a execution_time.log
}

# Detect current system architecture
arch=$(detect_architecture)

# Define image names with appropriate architecture tags
rust_native_image="sangeetakakati/rust-matrix-native:latest"
tinygo_native_image="sangeetakakati/tinygo-matrix-native:latest"
cpp_native_image="sangeetakakati/cpp-matrix-native:latest"
cpp_wasm_image="sangeetakakati/cpp-matrix-wasm:wasm"
rust_wasm_image="sangeetakakati/rust-matrix-wasm:wasm"
tinygo_wasm_image="sangeetakakati/tinygo-matrix-wasm:wasm"

# Measure execution time with forced fresh pull
echo -e "\nTesting with forced fresh pull:"
measure_execution_time "$rust_native_image" "" "$arch" true
measure_execution_time "$rust_wasm_image" "io.containerd.wasmtime.v2" "wasm" true

measure_execution_time "$tinygo_native_image" "" "$arch" true
measure_execution_time "$tinygo_wasm_image" "io.containerd.wasmtime.v2" "wasm" true

measure_execution_time "$cpp_native_image" "" "$arch" true
measure_execution_time "$cpp_wasm_image" "io.containerd.wasmtime.v2" "wasm" true

# Measure execution time using cached images (skip removal)
echo -e "\nTesting with cached images:"
# First, we check if the images are cached
if [[ "$(docker images -q $rust_native_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $rust_native_image"
    measure_execution_time "$rust_native_image" "" "$arch" false
else
    echo "Image not found in cache: $rust_native_image"
fi

if [[ "$(docker images -q $rust_wasm_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $rust_wasm_image"
    measure_execution_time "$rust_wasm_image" "io.containerd.wasmtime.v2" "wasm" false
else
    echo "Image not found in cache: $rust_wasm_image"
fi

if [[ "$(docker images -q $tinygo_native_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $tinygo_native_image"
    measure_execution_time "$tinygo_native_image" "" "$arch" false
else
    echo "Image not found in cache: $tinygo_native_image"
fi

if [[ "$(docker images -q $tinygo_wasm_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $tinygo_wasm_image"
    measure_execution_time "$tinygo_wasm_image" "io.containerd.wasmtime.v2" "wasm" false
else
    echo "Image not found in cache: $tinygo_wasm_image"
fi

if [[ "$(docker images -q $cpp_native_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $cpp_native_image"
    measure_execution_time "$cpp_native_image" "" "$arch" false
else
    echo "Image not found in cache: $cpp_native_image"
fi

if [[ "$(docker images -q $cpp_wasm_image 2> /dev/null)" != "" ]]; then
    echo "Using cached image for $cpp_wasm_image"
    measure_execution_time "$cpp_wasm_image" "io.containerd.wasmtime.v2" "wasm" false
else
    echo "Image not found in cache: $cpp_wasm_image"
fi


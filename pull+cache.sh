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

    # Print a clear separator
    echo -e "\n============================================"
    echo "Running $image with $runtime (Fresh Pull: $fresh_pull)"
    echo "--------------------------------------------"

    if [ "$fresh_pull" = true ]; then
        # Force remove the image to ensure fresh pull
        echo "Removing image $image to force fresh pull..."
        docker rmi $image 2>/dev/null || true
    fi

    # Measure image pull time
    start_time=$(date +%s%N)
    
    if [[ "$image" == *"wasm"* ]]; then
        # Pull Wasm image using --platform wasm
        if ! docker pull --platform wasm $image; then
            echo "Failed to pull wasm image $image"
            exit 1
        fi
    else
        # Pull native image without specifying platform
        if ! docker pull $image; then
            echo "Failed to pull image $image"
            exit 1
        fi
    fi
    
    end_time=$(date +%s%N)
    image_pull_time=$((($end_time - $start_time) / 1000000))
    echo "Image Pull Time: $image_pull_time ms"

    # Measure container startup and application execution time
    echo "Starting container..."
    {
        if [ -z "$runtime" ]; then
            # For native containers
            /usr/bin/time -v docker run --name $container_name --rm $image
        else
            # For Wasm containers with specific runtime
            echo "Running Wasm container with runtime: $runtime"
            /usr/bin/time -v docker run --runtime=$runtime --platform=$platform --name $container_name --rm $image
        fi
    } 2>&1 | tee -a execution_time.log

    # Check if the container executed successfully
    if [ $? -ne 0 ]; then
        echo "Container execution failed for $image"
        exit 1
    fi

    # Measure container execution time (Wall Clock)
    end_time=$(date +%s%N)
    container_execution_time=$((($end_time - start_time) / 1000000))  # Total time taken for both pull and execution
    echo "Container Execution Time (Wall Clock): $container_execution_time ms"

    # Since the container is removed automatically, no need to call docker rm
    echo -e "--------------------------------------------"
    echo "Execution for $image completed"

    # Log total execution time
    total_time=$(($image_pull_time + $container_execution_time))
    echo "Total Execution Time: $total_time ms"
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
for image in "$rust_native_image" "$rust_wasm_image" "$tinygo_native_image" "$tinygo_wasm_image" "$cpp_native_image" "$cpp_wasm_image"; do
    if [[ "$(docker images -q $image 2> /dev/null)" != "" ]]; then
        echo "Using cached image for $image"
        # For cached Wasm images, specify the runtime and platform
        if [[ "$image" == *"wasm"* ]]; then
            measure_execution_time "$image" "io.containerd.wasmtime.v2" "wasm" false
        else
            measure_execution_time "$image" "" "$arch" false
        fi
    else
        echo "Image not found in cache: $image"
    fi
done

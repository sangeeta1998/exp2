#!/bin/bash

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


measure_startup_time() {
    image=$1
    runtime=$2
    platform=$3
    container_name="test_container"

    # Measure the cold start time
    if [ -z "$runtime" ]; then
        # For native containers
        { time (docker run --name $container_name --rm $image > /dev/null); } 2>&1 | grep real
    else
        # For Wasm containers
        { time (docker run --runtime=$runtime --platform=$platform --name $container_name --rm $image > /dev/null); } 2>&1 | grep real
    fi
}

measure_multiple_times() {
    image=$1
    runtime=$2
    platform=$3
    runs=$4

    echo "Measuring startup time for $image with $runs repetitions..."
    total_time=0

    for i in $(seq 1 $runs); do
        echo "Run $i:"
        result=$(measure_startup_time $image $runtime $platform)
        echo "$result"

        # Extract time in seconds, replace comma with dot, and remove 's'
        time_in_seconds=$(echo $result | awk '{print $2}' | sed 's/,/./g' | cut -d'm' -f2 | sed 's/s//')
        total_time=$(echo "$total_time + $time_in_seconds" | bc)
    done

    avg_time=$(echo "scale=3; $total_time / $runs" | bc)
    echo "Average startup time for $image: ${avg_time}s"
}

arch=$(detect_architecture)

rust_native_image="sangeetakakati/rust-matrix-native:$arch"
tinygo_native_image="sangeetakakati/tinygo-matrix-native:$arch"
rust_wasm_image="sangeetakakati/rust-matrix-wasm:wasm"
tinygo_wasm_image="sangeetakakati/tinygo-matrix-wasm:wasm"

#Repeats 
measure_multiple_times "$rust_native_image" "" "" 3
measure_multiple_times "$rust_wasm_image" "io.containerd.wasmtime.v1" "wasm" 3
measure_multiple_times "$tinygo_native_image" "" "" 3
measure_multiple_times "$tinygo_wasm_image" "io.containerd.wasmtime.v1" "wasm" 3

#!/bin/bash

measure_native_rust() {
    trials=5
    architectures=("amd64" "arm64")

    echo "Measuring Native Rust..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_cache_time=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi sangeetakakati/rust-matrix-native:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/rust-matrix-native:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            pull_time=$((main_start_time - script_start_time))
            total_pull_time=$((total_pull_time + pull_time))
            echo "Rust Trial $i (Pull, $arch): Startup Time = $pull_time ms"
        done

        for i in $(seq 1 $trials); do
            # Ensuring the image is pulled
            docker pull sangeetakakati/rust-matrix-native:$arch > /dev/null 2>&1

            # Cold start time from cache
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/rust-matrix-native:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            cache_time=$((main_start_time - script_start_time))
            total_cache_time=$((total_cache_time + cache_time))
            echo "Rust Trial $i (Cache, $arch): Startup Time = $cache_time ms"
        done

        echo "Average Rust cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average Rust cold start time from cache ($arch): $((total_cache_time / trials)) ms"
    done
}

measure_wasm() {
    trials=5
    architectures=("amd64" "arm64" "wasm")

    echo "Measuring Wasm..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_cache_time=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            if [ "$arch" == "wasm" ]; then
                main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            else
                main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=linux/$arch --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            fi
            pull_time=$((main_start_time - script_start_time))
            total_pull_time=$((total_pull_time + pull_time))
            echo "Wasm Trial $i (Pull, $arch): Startup Time = $pull_time ms"
        done

        for i in $(seq 1 $trials); do
            # Ensuring the image is pulled
            docker pull sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1

            # Cold start time from cache
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            if [ "$arch" == "wasm" ]; then
                main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            else
                main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=linux/$arch --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            fi
            cache_time=$((main_start_time - script_start_time))
            total_cache_time=$((total_cache_time + cache_time))
            echo "Wasm Trial $i (Cache, $arch): Startup Time = $cache_time ms"
        done

        echo "Average Wasm cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average Wasm cold start time from cache ($arch): $((total_cache_time / trials)) ms"
    done
}

measure_native_rust
measure_wasm


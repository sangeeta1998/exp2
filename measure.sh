#!/bin/bash

measure_rust() {
    trials=5
    total_pull_time=0
    total_cache_time=0

    echo "Measuring Rust..."

    for i in $(seq 1 $trials); do
        # Cold start time from pull
        docker rmi sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --rm sangeetakakati/rust-matrix-native:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        pull_time=$((main_start_time - script_start_time))
        total_pull_time=$((total_pull_time + pull_time))
        echo "Rust Trial $i (Pull): Startup Time = $pull_time ms"
    done

    for i in $(seq 1 $trials); do
        # Ensuring the image is pulled
        docker pull sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1

        # Cold start time from cache
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --rm sangeetakakati/rust-matrix-native:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        cache_time=$((main_start_time - script_start_time))
        total_cache_time=$((total_cache_time + cache_time))
        echo "Rust Trial $i (Cache): Startup Time = $cache_time ms"
    done

    echo "Average Rust cold start time from pull: $((total_pull_time / trials)) ms"
    echo "Average Rust cold start time from cache: $((total_cache_time / trials)) ms"
}

measure_wasm() {
    trials=5
    total_pull_time=0
    total_cache_time=0

    echo "Measuring Wasm..."

    for i in $(seq 1 $trials); do
        # Cold start time from pull
        docker rmi sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        pull_time=$((main_start_time - script_start_time))
        total_pull_time=$((total_pull_time + pull_time))
        echo "Wasm Trial $i (Pull): Startup Time = $pull_time ms"
    done

    for i in $(seq 1 $trials); do
        # Ensuring the image is pulled
        docker pull sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1

        # Cold start time from cache
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        cache_time=$((main_start_time - script_start_time))
        total_cache_time=$((total_cache_time + cache_time))
        echo "Wasm Trial $i (Cache): Startup Time = $cache_time ms"
    done

    echo "Average Wasm cold start time from pull: $((total_pull_time / trials)) ms"
    echo "Average Wasm cold start time from cache: $((total_cache_time / trials)) ms"
}

measure_rust
measure_wasm


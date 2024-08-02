#!/bin/bash

measure_rust() {
    trials=5
    total_pull_time=0
    total_cache_time=0

    for i in $(seq 1 $trials); do
        docker rmi sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1  #cold start time from pull
        start_time=$(date +%s%3N)
        docker run --rm sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1
        end_time=$(date +%s%3N)
        pull_time=$((end_time - start_time))
        total_pull_time=$((total_pull_time + pull_time))

        # Ensuring
        docker pull sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1

        start_time=$(date +%s%3N)  # Measure cold start time from cache
        docker run --rm sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1
        end_time=$(date +%s%3N)
        cache_time=$((end_time - start_time))
        total_cache_time=$((total_cache_time + cache_time))

        echo "Rust Trial $i: Pull time = $pull_time ms, Cache time = $cache_time ms"
    done

    echo "Average Rust cold start time from pull: $((total_pull_time / trials)) ms"
    echo "Average Rust cold start time from cache: $((total_cache_time / trials)) ms"
}

measure_wasm() {
    trials=5
    total_pull_time=0
    total_cache_time=0

    for i in $(seq 1 $trials); do
        #cold start time from pull
        docker rmi sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1
        start_time=$(date +%s%3N)
        docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1
        end_time=$(date +%s%3N)
        pull_time=$((end_time - start_time))
        total_pull_time=$((total_pull_time + pull_time))

        #Ensuring
        docker pull sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1

        #cold start time from cache
        start_time=$(date +%s%3N)
        docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/rust-matrix-wasm:latest > /dev/null 2>&1
        end_time=$(date +%s%3N)
        cache_time=$((end_time - start_time))
        total_cache_time=$((total_cache_time + cache_time))

        echo "Wasm Trial $i: Pull time = $pull_time ms, Cache time = $cache_time ms"
    done

    echo "Average Wasm cold start time from pull: $((total_pull_time / trials)) ms"
    echo "Average Wasm cold start time from cache: $((total_cache_time / trials)) ms"
}

measure_rust
measure_wasm

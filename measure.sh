#!/bin/bash

measure_rust() {
    trials=5
    total_pull_time=0
    total_cache_time=0

    for i in $(seq 1 $trials); do
        # Measure cold start time from pull
        docker rmi sangeetakakati/rust-serverless:latest > /dev/null 2>&1
        start_time=$(date +%s%3N)
        docker run --rm sangeetakakati/rust-serverless > /dev/null 2>&1
        end_time=$(date +%s%3N)
        total_pull_time=$((total_pull_time + end_time - start_time))

        # Measure cold start time from cache
        start_time=$(date +%s%3N)
        docker run --rm sangeetakakati/rust-serverless > /dev/null 2>&1
        end_time=$(date +%s%3N)
        total_cache_time=$((total_cache_time + end_time - start_time))
    done

    echo "Average Rust cold start time from pull: $((total_pull_time / trials)) ms"
    echo "Average Rust cold start time from cache: $((total_cache_time / trials)) ms"
}

measure_wasm() {
    trials=5
    total_wasm_time=0
    wasm_file="serverless_wasm/target/wasm32-wasi/release/serverless_wasm.wasm"

    for i in $(seq 1 $trials); do
        start_time=$(date +%s%3N)
        if [ -f "$wasm_file" ]; then
            /home/kakati/.wasmtime/bin/wasmtime "$wasm_file" > /dev/null 2>&1
        else
            echo "Error: Wasm module not found at $wasm_file"
            return 1
        fi
        end_time=$(date +%s%3N)
        total_wasm_time=$((total_wasm_time + end_time - start_time))
    done

    echo "Average Wasm cold start time: $((total_wasm_time / trials)) ms"
}

# Measure time
measure_rust
measure_wasm


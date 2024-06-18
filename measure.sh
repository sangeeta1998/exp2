#!/bin/bash


measure_rust() {
    # Measure cold start time from pull
    start_time=$(date +%s%3N)
    docker run --rm sangeetakakati/rust-serverless
    end_time=$(date +%s%3N)
    echo "Rust cold start time from pull: $(($end_time - $start_time)) ms"

    # Cold start time from cache
    start_time=$(date +%s%3N)
    docker run --rm sangeetakakati/rust-serverless
    end_time=$(date +%s%3N)
    echo "Rust cold start time from cache: $(($end_time - $start_time)) ms"
}


measure_wasm() {
    start_time=$(date +%s%3N)
    wasm_file="serverless_wasm/target/wasm32-wasi/release/serverless_wasm.wasm"
    if [ -f "$wasm_file" ]; then
        /home/kakati/.wasmtime/bin/wasmtime "$wasm_file"
    else
        echo "Error: Wasm module not found at $wasm_file"
    fi
    end_time=$(date +%s%3N)
    echo "Wasm cold start time: $(($end_time - $start_time)) ms"
}

# Measure time
measure_rust
measure_wasm

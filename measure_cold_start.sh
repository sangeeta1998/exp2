#!/bin/bash

# Function to measure cold start time for Rust binary
measure_rust() {
    start_time=$(date +%s%3N)
    docker run --rm rust-serverless
    end_time=$(date +%s%3N)
    echo "Rust cold start time: $(($end_time - $start_time)) ms"
}

# Function to measure cold start time for Wasm module
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



# Measure cold start times
measure_rust
measure_wasm


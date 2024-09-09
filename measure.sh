#!/bin/bash
# using docker

# detect the host architecture
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

measure_native_rust() {
    local arch=$1
    trials=10

    echo "Measuring Native Rust for $arch..."

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
}

measure_native_tinygo() {
    local arch=$1
    trials=10

    echo "Measuring Native TinyGo for $arch..."

    total_pull_time=0
    total_cache_time=0

    for i in $(seq 1 $trials); do
        # Cold start time from pull
        docker rmi sangeetakakati/tinygo-matrix-native:$arch > /dev/null 2>&1
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/tinygo-matrix-native:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
        pull_time=$((main_start_time - script_start_time))
        total_pull_time=$((total_pull_time + pull_time))
        echo "TinyGo Trial $i (Pull, $arch): Startup Time = $pull_time ms"
    done

    for i in $(seq 1 $trials); do
        # Ensuring the image is pulled
        docker pull sangeetakakati/tinygo-matrix-native:$arch > /dev/null 2>&1

        # Cold start time from cache
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"
        main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/tinygo-matrix-native:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
        cache_time=$((main_start_time - script_start_time))
        total_cache_time=$((total_cache_time + cache_time))
        echo "TinyGo Trial $i (Cache, $arch): Startup Time = $cache_time ms"
    done

    echo "Average TinyGo cold start time from pull ($arch): $((total_pull_time / trials)) ms"
    echo "Average TinyGo cold start time from cache ($arch): $((total_cache_time / trials)) ms"
}

measure_wasm_rust() {
    trials=10
    architectures=("wasm")

    echo "Measuring Wasm Rust..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_cache_time=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            pull_time=$((main_start_time - script_start_time))
            total_pull_time=$((total_pull_time + pull_time))
            echo "Rust Wasm Trial $i (Pull, $arch): Startup Time = $pull_time ms"
        done

        for i in $(seq 1 $trials); do
            # Ensuring the image is pulled
            docker pull sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1

            # Cold start time from cache
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            cache_time=$((main_start_time - script_start_time))
            total_cache_time=$((total_cache_time + cache_time))
            echo "Rust Wasm Trial $i (Cache, $arch): Startup Time = $cache_time ms"
        done

        echo "Average Rust Wasm cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average Rust Wasm cold start time from cache ($arch): $((total_cache_time / trials)) ms"
    done
}

measure_wasm_tinygo() {
    trials=10
    architectures=("wasm")

    echo "Measuring Wasm TinyGo..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_cache_time=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi sangeetakakati/tinygo-matrix-wasm:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/tinygo-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            pull_time=$((main_start_time - script_start_time))
            total_pull_time=$((total_pull_time + pull_time))
            echo "TinyGo Wasm Trial $i (Pull, $arch): Startup Time = $pull_time ms"
        done

        for i in $(seq 1 $trials); do
            # Ensuring the image is pulled
            docker pull sangeetakakati/tinygo-matrix-wasm:$arch > /dev/null 2>&1

            # Cold start time from cache
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/tinygo-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            cache_time=$((main_start_time - script_start_time))
            total_cache_time=$((total_cache_time + cache_time))
            echo "TinyGo Wasm Trial $i (Cache, $arch): Startup Time = $cache_time ms"
        done

        echo "Average TinyGo Wasm cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average TinyGo Wasm cold start time from cache ($arch): $((total_cache_time / trials)) ms"
    done
}


host_arch=$(detect_architecture)

#native all
measure_native_rust $host_arch
measure_native_tinygo $host_arch

# wasm
measure_wasm_rust
measure_wasm_tinygo


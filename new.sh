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
    total_create_time=0
    total_start_time=0
    total_startup_time=0

    for i in $(seq 1 $trials); do
        # 1. Cold start time from pull
        docker rmi -f sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1

        pull_start=$(date +%s%3N)
        docker pull sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1
        pull_end=$(date +%s%3N)
        pull_time=$((pull_end - pull_start))
        total_pull_time=$((total_pull_time + pull_time))
        echo "Rust Trial $i (Pull, $arch): Pull Time = $pull_time ms"

        # 2. Container creation time
        create_start=$(date +%s%3N)
        container_id=$(docker create --platform=linux/$arch sangeetakakati/rust-matrix-native:latest)
        create_end=$(date +%s%3N)
        create_time=$((create_end - create_start))
        total_create_time=$((total_create_time + create_time))
        echo "Rust Trial $i (Pull, $arch): Container Creation Time = $create_time ms"

        # 3. Container start time
        start_start=$(date +%s%3N)
        docker start $container_id > /dev/null 2>&1
        start_end=$(date +%s%3N)
        start_time=$((start_end - start_start))
        total_start_time=$((total_start_time + start_time))
        echo "Rust Trial $i (Pull, $arch): Container Start Time = $start_time ms"

        # 4. startup time (when the main function starts)
        startup_start_time=$(date +%s%3N)
        main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/rust-matrix-native:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        startup_time=$((main_start_time - startup_start_time))
        total_startup_time=$((total_startup_time + startup_time))
        echo "Rust Trial $i (Pull, $arch): startup Time = $startup_time ms"
    done

    echo "Average Rust cold start time from pull ($arch): $((total_pull_time / trials)) ms"
    echo "Average Rust container creation time ($arch): $((total_create_time / trials)) ms"
    echo "Average Rust container start time ($arch): $((total_start_time / trials)) ms"
    echo "Average Rust startup time ($arch): $((total_startup_time / trials)) ms"
}

measure_native_tinygo() {
    local arch=$1
    trials=10

    echo "Measuring Native TinyGo for $arch..."

    total_pull_time=0
    total_create_time=0
    total_start_time=0
    total_startup_time=0

    for i in $(seq 1 $trials); do
        # 1. Cold start time from pull
        docker rmi -f sangeetakakati/tinygo-matrix-native:latest > /dev/null 2>&1

        pull_start=$(date +%s%3N)
        docker pull sangeetakakati/tinygo-matrix-native:latest > /dev/null 2>&1
        pull_end=$(date +%s%3N)
        pull_time=$((pull_end - pull_start))
        total_pull_time=$((total_pull_time + pull_time))
        echo "TinyGo Trial $i (Pull, $arch): Pull Time = $pull_time ms"

        # 2. Container creation time
        create_start=$(date +%s%3N)
        container_id=$(docker create --platform=linux/$arch sangeetakakati/tinygo-matrix-native:latest)
        create_end=$(date +%s%3N)
        create_time=$((create_end - create_start))
        total_create_time=$((total_create_time + create_time))
        echo "TinyGo Trial $i (Pull, $arch): Container Creation Time = $create_time ms"

        # 3. Container start time
        start_start=$(date +%s%3N)
        docker start $container_id > /dev/null 2>&1
        start_end=$(date +%s%3N)
        start_time=$((start_end - start_start))
        total_start_time=$((total_start_time + start_time))
        echo "TinyGo Trial $i (Pull, $arch): Container Start Time = $start_time ms"

        # 4. startup time (when the main function starts)
        startup_start_time=$(date +%s%3N)
        main_start_time=$(docker run --platform=linux/$arch --rm sangeetakakati/tinygo-matrix-native:latest 2>&1 | grep "Main function started at:" | awk '{print $5}')
        startup_time=$((main_start_time - startup_start_time))
        total_startup_time=$((total_startup_time + startup_time))
        echo "TinyGo Trial $i (Pull, $arch): startup Time = $startup_time ms"
    done

    echo "Average TinyGo cold start time from pull ($arch): $((total_pull_time / trials)) ms"
    echo "Average TinyGo container creation time ($arch): $((total_create_time / trials)) ms"
    echo "Average TinyGo container start time ($arch): $((total_start_time / trials)) ms"
    echo "Average TinyGo startup time ($arch): $((total_startup_time / trials)) ms"
}

measure_wasm_rust() {
    trials=10
    architectures=("wasm")

    echo "Measuring Wasm Rust..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_create_time=0
        total_start_time=0
        total_startup_time=0

        for i in $(seq 1 $trials); do
            # 1. Cold start time from pull
            docker rmi -f sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1

            pull_start=$(date +%s%3N)
            docker pull --platform wasm sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1
            pull_end=$(date +%s%3N)
            pull_time=$((pull_end - pull_start))
            total_pull_time=$((total_pull_time + pull_time))
            echo "Rust Wasm Trial $i (Pull, $arch): Pull Time = $pull_time ms"

            # 2. Container creation time
            create_start=$(date +%s%3N)
            container_id=$(docker create --runtime=io.containerd.wasmtime.v1 --platform=wasm sangeetakakati/rust-matrix-wasm:$arch)
            create_end=$(date +%s%3N)
            create_time=$((create_end - create_start))
            total_create_time=$((total_create_time + create_time))
            echo "Rust Wasm Trial $i (Pull, $arch): Container Creation Time = $create_time ms"

            # 3. Container start time
            start_start=$(date +%s%3N)
            docker start $container_id > /dev/null 2>&1
            start_end=$(date +%s%3N)
            start_time=$((start_end - start_start))
            total_start_time=$((total_start_time + start_time))
            echo "Rust Wasm Trial $i (Pull, $arch): Container Start Time = $start_time ms"

            # 4. startup time (when the main function starts)
            startup_start_time=$(date +%s%3N)
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            startup_time=$((main_start_time - startup_start_time))
            total_startup_time=$((total_startup_time + startup_time))
            echo "Rust Wasm Trial $i (Pull, $arch): startup Time = $startup_time ms"
        done

        echo "Average Rust Wasm cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average Rust Wasm container creation time ($arch): $((total_create_time / trials)) ms"
        echo "Average Rust Wasm container start time ($arch): $((total_start_time / trials)) ms"
        echo "Average Rust Wasm startup time ($arch): $((total_startup_time / trials)) ms"
    done
}

measure_wasm_tinygo() {
    trials=10
    architectures=("wasm")

    echo "Measuring Wasm TinyGo..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_pull_time=0
        total_create_time=0
        total_start_time=0
        total_startup_time=0

        for i in $(seq 1 $trials); do
            # 1. Cold start time from pull
            docker rmi -f sangeetakakati/tinygo-matrix-wasm:$arch > /dev/null 2>&1

            pull_start=$(date +%s%3N)
            docker pull --platform wasm sangeetakakati/tinygo-matrix-wasm:$arch > /dev/null 2>&1
            pull_end=$(date +%s%3N)
            pull_time=$((pull_end - pull_start))
            total_pull_time=$((total_pull_time + pull_time))
            echo "TinyGo Wasm Trial $i (Pull, $arch): Pull Time = $pull_time ms"

            # 2. Container creation time
            create_start=$(date +%s%3N)
            container_id=$(docker create --runtime=io.containerd.wasmtime.v1 --platform=wasm sangeetakakati/tinygo-matrix-wasm:$arch)
            create_end=$(date +%s%3N)
            create_time=$((create_end - create_start))
            total_create_time=$((total_create_time + create_time))
            echo "TinyGo Wasm Trial $i (Pull, $arch): Container Creation Time = $create_time ms"

            # 3. Container start time
            start_start=$(date +%s%3N)
            docker start $container_id > /dev/null 2>&1
            start_end=$(date +%s%3N)
            start_time=$((start_end - start_start))
            total_start_time=$((total_start_time + start_time))
            echo "TinyGo Wasm Trial $i (Pull, $arch): Container Start Time = $start_time ms"

            # 4. startup time (when the main function starts)
            startup_start_time=$(date +%s%3N)
            main_start_time=$(docker run --runtime=io.containerd.wasmtime.v1 --platform=wasm --rm sangeetakakati/tinygo-matrix-wasm:$arch 2>&1 | grep "Main function started at:" | awk '{print $5}')
            startup_time=$((main_start_time - startup_start_time))
            total_startup_time=$((total_startup_time + startup_time))
            echo "TinyGo Wasm Trial $i (Pull, $arch): startup Time = $startup_time ms"
        done

        echo "Average TinyGo Wasm cold start time from pull ($arch): $((total_pull_time / trials)) ms"
        echo "Average TinyGo Wasm container creation time ($arch): $((total_create_time / trials)) ms"
        echo "Average TinyGo Wasm container start time ($arch): $((total_start_time / trials)) ms"
        echo "Average TinyGo Wasm startup time ($arch): $((total_startup_time / trials)) ms"
    done
}

architecture=$(detect_architecture)

# Measure cold start times for different containers
measure_native_rust $architecture
measure_native_tinygo $architecture
measure_wasm_rust
measure_wasm_tinygo

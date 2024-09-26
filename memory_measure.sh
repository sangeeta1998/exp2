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
    trials=1

    echo "Measuring Native Rust for $arch..."

    total_pull_time=0
    total_memory_usage=0

    for i in $(seq 1 $trials); do
        # Cold start time from pull
        docker rmi -f sangeetakakati/rust-matrix-native:latest > /dev/null 2>&1
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"

        # Measure time and memory usage with /usr/bin/time
        /usr/bin/time -v docker run --platform=linux/$arch --rm sangeetakakati/rust-matrix-native:latest 2>&1 | tee output_native_rust.log

        # Extract the memory usage (Maximum resident set size)
        memory_usage=$(grep "Maximum resident set size" output_native_rust.log | awk '{print $6}')
        echo "Rust Trial $i (Pull, $arch): Memory Usage = $memory_usage KB"
        total_memory_usage=$((total_memory_usage + memory_usage))
    done

    echo "Average Rust memory usage ($arch): $((total_memory_usage / trials)) KB"
}

measure_native_tinygo() {
    local arch=$1
    trials=1

    echo "Measuring Native TinyGo for $arch..."

    total_pull_time=0
    total_memory_usage=0

    for i in $(seq 1 $trials); do
        # Cold start time from pull
        docker rmi -f sangeetakakati/tinygo-matrix-native:latest > /dev/null 2>&1
        script_start_time=$(date +%s%3N)
        echo "Script start time: ${script_start_time} ms"

        # Measure time and memory usage with /usr/bin/time
        /usr/bin/time -v docker run --platform=linux/$arch --rm sangeetakakati/tinygo-matrix-native:latest 2>&1 | tee output_native_tinygo.log

        # Extract the memory usage (Maximum resident set size)
        memory_usage=$(grep "Maximum resident set size" output_native_tinygo.log | awk '{print $6}')
        echo "TinyGo Trial $i (Pull, $arch): Memory Usage = $memory_usage KB"
        total_memory_usage=$((total_memory_usage + memory_usage))
    done

    echo "Average TinyGo memory usage ($arch): $((total_memory_usage / trials)) KB"
}

measure_wasm_rust() {
    trials=1
    architectures=("wasm")

    echo "Measuring Wasm Rust..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_memory_usage=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi -f sangeetakakati/rust-matrix-wasm:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"

            # Measure time and memory usage with /usr/bin/time
            /usr/bin/time -v docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm --rm sangeetakakati/rust-matrix-wasm:$arch 2>&1 | tee output_wasm_rust.log

            # Extract the memory usage (Maximum resident set size)
            memory_usage=$(grep "Maximum resident set size" output_wasm_rust.log | awk '{print $6}')
            echo "Rust Wasm Trial $i (Pull, $arch): Memory Usage = $memory_usage KB"
            total_memory_usage=$((total_memory_usage + memory_usage))
        done

        echo "Average Rust Wasm memory usage ($arch): $((total_memory_usage / trials)) KB"
    done
}

measure_wasm_tinygo() {
    trials=1
    architectures=("wasm")

    echo "Measuring Wasm TinyGo..."

    for arch in "${architectures[@]}"; do
        echo "Architecture: $arch"
        total_memory_usage=0

        for i in $(seq 1 $trials); do
            # Cold start time from pull
            docker rmi -f sangeetakakati/tinygo-matrix-wasm:$arch > /dev/null 2>&1
            script_start_time=$(date +%s%3N)
            echo "Script start time: ${script_start_time} ms"

            # Measure time and memory usage with /usr/bin/time
            /usr/bin/time -v docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm --rm sangeetakakati/tinygo-matrix-wasm:$arch 2>&1 | tee output_wasm_tinygo.log

            # Extract the memory usage (Maximum resident set size)
            memory_usage=$(grep "Maximum resident set size" output_wasm_tinygo.log | awk '{print $6}')
            echo "TinyGo Wasm Trial $i (Pull, $arch): Memory Usage = $memory_usage KB"
            total_memory_usage=$((total_memory_usage + memory_usage))
        done

        echo "Average TinyGo Wasm memory usage ($arch): $((total_memory_usage / trials)) KB"
    done
}

host_arch=$(detect_architecture)

# Measure native memory usage
measure_native_rust $host_arch
measure_native_tinygo $host_arch

# Measure Wasm memory usage
measure_wasm_rust
measure_wasm_tinygo

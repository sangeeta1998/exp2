 # Performs matrix multiplication on two randomly generated 500x500 matrices

Measurement script:

Trials=5

Removes the Docker image to ensure the next run will need to pull the image from the registry. Start_time and end time records in milliseconds.

Measure_wasm function performs similar steps but uses a different Docker image and runtime settings wasmtime.

# Build and run:

```cargo build --release --target wasm32-wasi```

# For multi architectures:

```docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=true" --tag sangeetakakati/rust-matrix-native:arch --builder default .```

```docker buildx build --platform wasi/wasm,linux/amd64,linux/arm64  --output "type=image,push=true" --tag sangeetakakati/rust-matrix-wasm:arch --builder default .```

# For separate tags:

```rust-matrix-native```

docker buildx build --platform linux/amd64 --tag sangeetakakati/rust-matrix-native:amd64 --output "type=image,push=true" --builder default .

docker buildx build --platform linux/arm64 --tag sangeetakakati/rust-matrix-native:arm64 --output "type=image,push=true" --builder default .

docker run --platform=linux/amd64 --rm sangeetakakati/rust-matrix-native:amd64

docker run --platform=linux/arm64 --rm sangeetakakati/rust-matrix-native:arm64

```rust-matrix-wasm```

docker buildx build --platform wasi/wasm --tag sangeetakakati/rust-matrix-wasm:wasm --output "type=image,push=true" --builder default .

docker run --runtime=io.containerd.wasmtime.v1   --platform=wasi/wasm   sangeetakakati/rust-matrix-wasm:wasm

```tinygo-matrix-wasm```

docker buildx build --platform wasi/wasm --tag sangeetakakati/tinygo-matrix-wasm:wasm --output "type=image,push=true" --builder default .

docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm --rm sangeetakakati/tinygo-matrix-wasm:wasm

```tinygo-matrix-native```

docker buildx build --platform linux/amd64 -t sangeetakakati/tinygo-matrix-native:amd64 --push .

docker run --rm sangeetakakati/tinygo-matrix-native:amd64

docker buildx build --platform linux/arm64 -t sangeetakakati/tinygo-matrix-native:arm64 --push .

docker run --rm sangeetakakati/tinygo-matrix-native:arm64

# Using ctr

```rust```

sudo ctr images pull --platform linux/amd64 docker.io/sangeetakakati/rust-matrix-native:amd64

sudo ctr run --rm --platform linux/amd64 docker.io/sangeetakakati/rust-matrix-native:amd64 mycontainer

Similarly for arm64

sudo ctr images pull --platform wasi/wasm docker.io/sangeetakakati/rust-matrix-wasm:wasm

sudo ctr run --rm --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm docker.io/sangeetakakati/rust-matrix-wasm:wasm mycontainer

```tinygo```

sudo ctr images pull --platform linux/amd64 docker.io/sangeetakakati/tinygo-matrix-native:amd64

sudo ctr run --rm --platform linux/amd64 docker.io/sangeetakakati/tinygo-matrix-native:amd64 mycontainer

Similarly for arm64

sudo ctr images pull --platform wasi/wasm docker.io/sangeetakakati/tinygo-matrix-wasm:wasm

sudo ctr run --rm --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm docker.io/sangeetakakati/tinygo-matrix-wasm:wasm mycontainer


# Optimising wasm

```cargo install wasm-opt --locked```

```wasm-opt -O3 -o target/wasm32-wasi/release/serverless_wasm_optimized.wasm target/wasm32-wasi/release/serverless_wasm.wasm```

List the sizes now:

```ls -lh serverless_wasm.wasm serverless_wasm_optimized.wasm```


# Build for all archs 

[Reference](https://developers.redhat.com/articles/2023/11/03/how-build-multi-architecture-container-images#)

docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=true" --tag sangeetakakati/rust-matrix-native:latest --builder default .

docker buildx build \
  --platform linux/amd64,linux/arm64,wasi/wasm \
  --tag sangeetakakati/rust-matrix-wasm:amd64 \
  --tag sangeetakakati/rust-matrix-wasm:arm64 \
  --tag sangeetakakati/rust-matrix-wasm:wasm \
  --output "type=image,push=true" \
  --builder default .

# With one tag for all

docker buildx build \
  --platform linux/amd64,linux/arm64,wasi/wasm \
  --tag sangeetakakati/rust-matrix-wasm:latest \
  --output "type=image,push=true" \
  --builder default .




# Verify the manifest list
docker manifest inspect sangeetakakati/rust-matrix-wasm:arch

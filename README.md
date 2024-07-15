 # Performs matrix multiplication on two randomly generated 500x500 matrices

Measurement script:

Trials=5

Removes the Docker image to ensure the next run will need to pull the image from the registry. Start_time and end time records in milliseconds.

Measure_wasm function performs similar steps but uses a different Docker image and runtime settings wasmtime.

# Build and run:

```cargo build --release --target wasm32-wasi```

kakati@UNI3R9TBK3:~/exp2/serverless_wasm$ ```docker buildx build --platform wasi/wasm -t sangeetakakati/rust-matrix-wasm .```

```docker run  --runtime=io.containerd.wasmtime.v1   --platform=wasi/wasm   sangeetakakati/rust-matrix-wasm```

For multi architectures:

```docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=true" --tag sangeetakakati/rust-matrix-native:arch --builder default .```

```docker buildx build --platform wasi/wasm,linux/amd64,linux/arm64  --output "type=image,push=true" --tag sangeetakakati/rust-matrix-wasm:arch --builder default .```


# Run the WASM image
docker run --platform=wasi/wasm --runtime=io.containerd.wasmtime.v1 --rm sangeetakakati/rust-matrix-wasm:arch

# Run the Linux AMD64 image
docker run --platform=linux/amd64 --rm sangeetakakati/rust-matrix-wasm:arch

# Run the Linux ARM64 image
docker run --platform=linux/arm64 --rm sangeetakakati/rust-matrix-wasm:arch

# Verify the manifest list
docker manifest inspect sangeetakakati/rust-matrix-wasm:arch

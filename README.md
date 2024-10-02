

Measurement script:

Removes the Docker image to ensure the next run will need to pull the image from the registry. Start_time and end time records in milliseconds.

Measure_wasm function performs similar steps but uses a different Docker image and runtime settings wasmtime.

# Build and run:

```cargo build --release --target wasm32-wasi```

```tinygo build -o serverless_tinygo.wasm -target=wasi -opt=2 main.go```

```wasm-opt -O3 -o serverless_tinygo_optimized.wasm serverless_tinygo.wasm```

# For multi architectures:

```docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=true" --tag sangeetakakati/rust-matrix-native:arch --builder default .```

```docker buildx build --platform wasi/wasm,linux/amd64,linux/arm64  --output "type=image,push=true" --tag sangeetakakati/rust-matrix-wasm:arch --builder default .```

```docker run --platform=linux/arm64 --rm sangeetakakati/rust-matrix-native:latest```

Similarly, using amd64

```rust-matrix-wasm```

docker buildx build --platform wasm --tag sangeetakakati/rust-matrix-wasm:wasm --output "type=image,push=true" --builder default .

docker run --runtime=io.containerd.wasmtime.v2   --platform=wasm   sangeetakakati/rust-matrix-wasm:wasm

```tinygo-matrix-wasm```

docker buildx build --platform wasm --tag sangeetakakati/tinygo-matrix-wasm:wasm --output "type=image,push=true" --builder default .

docker run --runtime=io.containerd.wasmtime.v2 --platform=wasm --rm sangeetakakati/tinygo-matrix-wasm:wasm



#For errors, try using platform wasm instead of wasi/wasm:
```docker buildx build --platform wasm -t sangeetakakati/tinygo-matrix-wasm:trial --output "type=image,push=true" --builder default .```

Or,
Try to remove the platform wasi/wasm32 from the build process as for some reason, docker will not recognize it. After doing that and pushing the image to docker hub it can be run like this:

```docker run --rm --runtime io.containerd.runtime.wasmtime.v1 sangeetakakati/tinygo-matrix-wasm:wasm```

For some reason running a wasmtime module using ctr directly is not working, although it can run a spin app. But it works using docker, which in turn uses containerd.



# Using ctr

```rust```

sudo ctr images pull --platform linux/amd64 docker.io/sangeetakakati/rust-matrix-native:amd64

sudo ctr run --rm --platform linux/amd64 docker.io/sangeetakakati/rust-matrix-native:amd64 mycontainer

Similarly for arm64

sudo ctr images pull --platform wasi/wasm docker.io/sangeetakakati/rust-matrix-wasm:wasm

sudo ctr run --rm --runtime=io.containerd.wasmtime.v2 --platform=wasi/wasm docker.io/sangeetakakati/rust-matrix-wasm:wasm mycontainer

```tinygo```

sudo ctr images pull --platform linux/amd64 docker.io/sangeetakakati/tinygo-matrix-native:amd64

sudo ctr run --rm --platform linux/amd64 docker.io/sangeetakakati/tinygo-matrix-native:amd64 mycontainer

Similarly for arm64

sudo ctr images pull --platform wasi/wasm docker.io/sangeetakakati/tinygo-matrix-wasm:wasm

sudo ctr run --rm --runtime=io.containerd.wasmtime.v2 --platform=wasi/wasm docker.io/sangeetakakati/tinygo-matrix-wasm:wasm mycontainer


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



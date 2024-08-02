 Performs matrix multiplication on two randomly generated 500x500 matrices

Measurement script:

Trials=5

Removes the Docker image to ensure the next run will need to pull the image from the registry. Start_time and end time records in milliseconds.

Measure_wasm function performs similar steps but uses a different Docker image and runtime settings wasmtime.

Build and run:

```cargo build --release --target wasm32-wasi```

kakati@UNI3R9TBK3:~/exp2/serverless_wasm$ ```docker buildx build --platform wasi/wasm -t sangeetakakati/rust-matrix-wasm .```

```docker run  --runtime=io.containerd.wasmtime.v1   --platform=wasi/wasm   sangeetakakati/rust-matrix-wasm```

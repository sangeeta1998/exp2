FROM debian:buster-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget ca-certificates xz-utils

# Download and install Wasmtime
RUN wget https://github.com/bytecodealliance/wasmtime/releases/download/v0.33.0/wasmtime-v0.33.0-x86_64-linux.tar.xz && \
    tar -xvf wasmtime-v0.33.0-x86_64-linux.tar.xz && \
    mv wasmtime-v0.33.0-x86_64-linux/wasmtime /usr/local/bin/ && \
    rm -rf wasmtime-v0.33.0-x86_64-linux*

# Set working directory
WORKDIR /usr/src/myapp

# Copy Wasm file
COPY target/wasm32-wasi/release/serverless_wasm.wasm .

# Set environment variable for verbose logging (optional)
ENV WABT_LOG=WARN

# Set the entry point to run the Wasm file using Wasmtime
ENTRYPOINT ["wasmtime", "serverless_wasm.wasm"]


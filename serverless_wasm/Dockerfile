# Use Debian Buster as the base image
FROM debian:buster-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget ca-certificates xz-utils

# Download and install Wasmtime
RUN wget https://github.com/bytecodealliance/wasmtime/releases/download/v0.33.0/wasmtime-v0.33.0-x86_64-linux.tar.xz && \
    tar -xvf wasmtime-v0.33.0-x86_64-linux.tar.xz && \
    mv wasmtime-v0.33.0-x86_64-linux/wasmtime /usr/local/bin && \
    rm -rf wasmtime-v0.33.0-x86_64-linux*

# Set the working directory
WORKDIR /usr/src/myapp

# Copy the WebAssembly module into the image
COPY target/wasm32-wasi/release/serverless_wasm.wasm .

# Add a script to run the Wasm module
RUN echo -e '#!/bin/bash\n\
echo "Starting Wasm module..."\n\
/usr/local/bin/wasmtime serverless_wasm.wasm\n\
echo "Finished Wasm module."' > run.sh

# Ensure correct line endings and make the script executable
RUN sed -i 's/\r$//' run.sh && chmod +x run.sh

# Set the entry point to the script
ENTRYPOINT ["./run.sh"]


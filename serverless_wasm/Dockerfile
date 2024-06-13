# Use a WebAssembly binary tools image to run the Wasm module
FROM webassembly/wabt

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the built Wasm module into the container
COPY target/wasm32-wasi/release/serverless_wasm.wasm .

# Set the entrypoint to run the Wasm module using wasm-interp
ENTRYPOINT ["wasm-interp", "--run-all-exports", "serverless_wasm.wasm"]


FROM scratch
COPY target/wasm32-wasi/release/serverless_wasm_optimized.wasm /serverless_wasm.wasm
ENTRYPOINT ["/serverless_wasm.wasm"]

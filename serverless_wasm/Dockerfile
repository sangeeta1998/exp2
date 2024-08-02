FROM scratch
COPY target/wasm32-wasi/release/serverless_wasm.wasm /serverless_wasm.wasm
ENTRYPOINT ["/serverless_wasm.wasm"]

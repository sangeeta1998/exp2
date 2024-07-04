FROM scratch
COPY wasmtime /usr/local/bin/wasmtime
COPY serverless_wasm.wasm /serverless_wasm.wasm
ENTRYPOINT ["/usr/local/bin/wasmtime", "/serverless_wasm.wasm"]


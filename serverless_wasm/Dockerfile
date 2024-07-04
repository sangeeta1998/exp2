FROM ubuntu:latest
COPY wasmtime /usr/local/bin/wasmtime

COPY serverless_wasm.wasm /serverless_wasm.wasm

ENTRYPOINT ["/usr/local/bin/wasmtime", "/serverless_wasm.wasm"]

#### copied the wasmtime binary to the current directory to ensure it is included in the build context.
##using ubuntu because wasmtime binary shows missing and required shared libraries or is incompatible  naybe because scratch has no libraries or tools

Run:
''' /.measure_cold_start.sh '''

Example output: 
''' Time elapsed in expensive_function() is: 49ns
Handler result: 499500
Rust cold start time: 691 ms
Wasm cold start time: 8 ms '''

Comparison of Implementations:
# Functionality:

Both implementations simulate the same computational task using a loop to sum numbers from 0 to 999 ((0..1000).fold(0, |acc, x| acc + x)).
They both measure the elapsed time using Instant::now() to provide feedback on the execution duration.

# Build and Deployment:

The Rust serverless function is compiled into a native binary inside a Docker container (rust:latest base image).
The Wasm module is compiled into a Wasm binary (serverless_wasm.wasm) using the target wasm32-wasi, which is then executed using Wasmtime.

# Execution Environment:

Rust serverless function: Runs in a Docker container with potentially higher startup time due to containerization overhead.
Wasm module: Runs directly in the Wasmtime runtime, which generally has lower startup time compared to containerized environments.

# Comparison:

In this case, the loop summing from 0 to 999. Both Rust and Wasm implementations simulate the same computational task and measure execution time. However, differences in their deployment (Docker vs. Wasmtime) and execution environment (containerized vs. Wasm runtime) can be considered when interpreting the results of their cold start times.


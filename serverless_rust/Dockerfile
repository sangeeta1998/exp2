# Use the official Rust image to build the application
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the source code into the container
COPY . .

# Build the application in release mode
RUN cargo build --release

# Use a smaller base image to run the application
FROM debian:buster-slim

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/myapp/target/release/serverless_rust /usr/local/bin/serverless_rust

# Set the entrypoint to run the binary
CMD ["serverless_rust"]


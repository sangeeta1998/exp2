# Dockerfile for Rust application with Ubuntu base image

# Build stage
FROM rust:latest as builder

WORKDIR /usr/src/myapp

# Copy the Cargo files and build dependencies
COPY Cargo.lock Cargo.toml ./

# Build the application
COPY src/ ./src/
RUN cargo build --release

# Final stage
FROM ubuntu:latest

WORKDIR /usr/src/myapp

# Install necessary libraries or dependencies
RUN apt-get update && apt-get install -y \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/myapp/target/release/serverless_rust /usr/local/bin/serverless_rust

# Command to run the binary when the container starts
CMD ["serverless_rust"]


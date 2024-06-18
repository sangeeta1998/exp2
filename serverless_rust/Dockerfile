<<<<<<< HEAD
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
=======

FROM rust:latest as builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo build --release

FROM debian:buster-slim

WORKDIR /usr/src/myapp

COPY --from=builder /usr/src/myapp/target/release/serverless_rust /usr/local/bin/serverless_rust

>>>>>>> a0bb1e7a835874ab850f4fbea7d8b2492ee3efb6
CMD ["serverless_rust"]


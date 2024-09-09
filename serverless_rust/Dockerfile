# Stage 1: Build the Rust binary
FROM rust:latest as builder
WORKDIR /usr/src/myapp

COPY Cargo.toml Cargo.lock ./
COPY src/ ./src/
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release --target x86_64-unknown-linux-musl

# Stage 2: Create a minimal image with the binary
FROM alpine:latest
WORKDIR /usr/local/bin

RUN apk --no-cache add ca-certificates

COPY --from=builder /usr/src/myapp/target/x86_64-unknown-linux-musl/release/serverless_rust .

RUN chmod +x /usr/local/bin/serverless_rust

CMD ["./serverless_rust"]

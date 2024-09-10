# First, build stage
FROM rust:alpine as builder
WORKDIR /usr/src/myapp

# Installing necessary build dependencies, got error for c runtime initialisation files using alpine
RUN apk add --no-cache musl-dev gcc

COPY Cargo.toml Cargo.lock ./
RUN cargo fetch
COPY src/ ./src/
RUN cargo build --release

# Runtime stage
FROM alpine:latest
WORKDIR /usr/local/bin

# Copying built binary from the builder stage
COPY --from=builder /usr/src/myapp/target/release/serverless_rust .

CMD ["./serverless_rust"]


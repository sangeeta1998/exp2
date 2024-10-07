# Build Stage
FROM rust:alpine AS builder
WORKDIR /usr/src/myapp
RUN apk add --no-cache musl-dev gcc
COPY Cargo.toml Cargo.lock ./
RUN cargo fetch
COPY src/ ./src/
RUN cargo build --release

# Runtime Stage
FROM scratch
COPY --from=builder /usr/src/myapp/target/release/serverless_rust /serverless_rust

CMD ["/serverless_rust"]

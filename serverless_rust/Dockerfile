# First, build stage
FROM rust:alpine as builder
WORKDIR /usr/src/myapp

# Installing necessary build dependencies
RUN apk add --no-cache musl-dev gcc upx binutils

COPY Cargo.toml Cargo.lock ./
RUN cargo fetch
COPY src/ ./src/
RUN cargo build --release

# Strip and compress the binary
RUN strip /usr/src/myapp/target/release/serverless_rust
#RUN upx /usr/src/myapp/target/release/serverless_rust

# Runtime stage
FROM scratch
COPY --from=builder /usr/src/myapp/target/release/serverless_rust /serverless_rust

CMD ["/serverless_rust"]


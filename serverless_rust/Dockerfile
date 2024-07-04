#First, build stage
FROM rust:latest as builder
WORKDIR /usr/src/myapp

COPY Cargo.toml Cargo.lock ./
COPY src/ ./src/
RUN cargo build --release

# Runtime stage
FROM ubuntu:latest
WORKDIR /usr/local/bin

RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

#Copying built binary from stage1
COPY --from=builder /usr/src/myapp/target/release/serverless_rust .

CMD ["./serverless_rust"]


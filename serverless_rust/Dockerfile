FROM rust:alpine

WORKDIR /usr/src/myapp
RUN apk add --no-cache musl-dev gcc

COPY Cargo.toml Cargo.lock ./
RUN cargo fetch
COPY src/ ./src/
RUN cargo build --release

CMD ["/usr/src/myapp/target/release/serverless_rust"]

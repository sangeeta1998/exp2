
FROM rust:latest as builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo build --release

FROM debian:buster-slim

WORKDIR /usr/src/myapp

COPY --from=builder /usr/src/myapp/target/release/serverless_rust /usr/local/bin/serverless_rust

CMD ["serverless_rust"]


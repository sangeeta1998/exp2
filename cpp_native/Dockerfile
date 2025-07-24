# Build Stage
FROM alpine:latest AS builder
WORKDIR /usr/src/app

RUN apk add --no-cache clang make libc-dev
COPY matrix.cpp ./matrix.cpp
RUN clang++ matrix.cpp -o matrix -static -O3

# Runtime Stage
FROM scratch
COPY --from=builder /usr/src/app/matrix /matrix
CMD ["/matrix"]

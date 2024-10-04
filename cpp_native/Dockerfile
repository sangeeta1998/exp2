# Build Stage
FROM gcc:latest AS builder
WORKDIR /usr/src/app

COPY matrix.cpp ./matrix.cpp
RUN g++ matrix.cpp -o matrix -static -O2

# Runtime Stage
FROM scratch
COPY --from=builder /usr/src/app/matrix /matrix
CMD ["/matrix"]


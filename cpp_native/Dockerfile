# Build Stage
FROM alpine:latest AS builder
WORKDIR /usr/src/app

# Install necessary packages
RUN apk add --no-cache g++ make

COPY matrix.cpp ./matrix.cpp
RUN g++ matrix.cpp -o matrix -static -O2

# Runtime Stage
FROM scratch
COPY --from=builder /usr/src/app/matrix /matrix
CMD ["/matrix"]

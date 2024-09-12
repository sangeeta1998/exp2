# Build stage
FROM tinygo/tinygo:latest AS build

WORKDIR /app
COPY main.go .

# Build the Go program using TinyGo with optimizations
RUN tinygo build -opt=2 -o /app/serverless_tinygo main.go

# Strip debugging information from the binary
RUN strip /app/serverless_tinygo

# Runtime stage
FROM scratch
COPY --from=build /app/serverless_tinygo /serverless_tinygo

ENTRYPOINT ["/serverless_tinygo"]

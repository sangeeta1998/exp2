FROM tinygo/tinygo:latest

WORKDIR /app
COPY main.go .

# Build the Go program using TinyGo with optimizations
RUN tinygo build -opt=2 -o /app/serverless_tinygo main.go

ENTRYPOINT ["/app/serverless_tinygo"]


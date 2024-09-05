# Use the latest TinyGo image which supports multiple platforms
FROM tinygo/tinygo:latest AS build

WORKDIR /app
COPY main.go .

# Build the Go program using TinyGo
RUN tinygo build -o /app/serverless_tinygo main.go

# Create a minimal runtime image
FROM scratch
COPY --from=build /app/serverless_tinygo /serverless_tinygo
ENTRYPOINT ["/serverless_tinygo"]


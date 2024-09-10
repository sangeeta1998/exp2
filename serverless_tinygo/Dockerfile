# Using the latest TinyGo image which supports multiple platforms
FROM tinygo/tinygo:latest AS build

WORKDIR /app
COPY main.go .

# Building the Go program using TinyGo (using opt2 to because for rust we used release mode)
RUN tinygo build -opt=2 -o /app/serverless_tinygo main.go

# Create a minimal runtime image
FROM scratch
COPY --from=build /app/serverless_tinygo /serverless_tinygo
ENTRYPOINT ["/serverless_tinygo"]


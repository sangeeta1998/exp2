#using scratch
FROM golang:1.21 AS build
WORKDIR /app
COPY main.go .

RUN go build -o serverless_tinygo main.go

FROM scratch
COPY --from=build /app/serverless_tinygo /serverless_tinygo
ENTRYPOINT ["/serverless_tinygo"]


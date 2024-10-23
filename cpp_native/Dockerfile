FROM alpine:latest
WORKDIR /usr/src/app

RUN apk add --no-cache clang make libc-dev
COPY matrix.cpp ./matrix.cpp
RUN clang++ matrix.cpp -o matrix -static -O3

CMD ["/usr/src/app/matrix"]


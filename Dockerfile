FROM alpine:edge
WORKDIR /app
ADD ./build/linux/x64/release/bundle/namer .
CMD ["./app/namer"]

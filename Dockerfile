FROM bufbuild/buf:1.28.1 as buf
FROM golang:1.21-alpine

RUN apk add --no-cache git curl make

# Install protoc plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.33 \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3 \
 && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.19 \
 && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.19

ENV PATH="/go/bin:${PATH}"

COPY --from=buf /usr/local/bin/buf /usr/local/bin/buf

WORKDIR /app
COPY . .

ENTRYPOINT ["buf"]
CMD ["generate"]

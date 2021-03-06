FROM golang:alpine

WORKDIR /

COPY . .

EXPOSE 11500

ENTRYPOINT ["go", "build"]
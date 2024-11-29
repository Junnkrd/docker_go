# Use a imagem de compilação do Go
FROM golang:alpine as builder

RUN apk add --no-cache upx

WORKDIR /app


COPY . .

# Desabilita CGO (C Go) e Remove informações de depuração e símbolos de string do binário
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o main .

# Comprimir o binário usando upx 
RUN upx --best main

# Use uma imagem base mínima
FROM scratch


COPY --from=builder /app/main /main


ENTRYPOINT ["/main"]


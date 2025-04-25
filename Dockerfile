FROM golang:1.24.2-alpine3.21 AS builder

WORKDIR /app
COPY . /app
RUN CGO_ENABLED=0 go build .

FROM alpine:3.21

RUN apk add --no-cache curl jq wget

WORKDIR /app
COPY --from=builder /app/glance .
COPY --from=builder /app/entrypoint.sh .

RUN chmod +x /app/entrypoint.sh

HEALTHCHECK --timeout=10s --start-period=60s --interval=60s \
  CMD wget --spider -q http://localhost:8080/api/healthz

EXPOSE 8080/tcp
VOLUME [ "/app/config" ]

ENTRYPOINT ["/app/entrypoint.sh"]

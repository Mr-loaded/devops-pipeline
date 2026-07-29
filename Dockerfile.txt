# Step 1: Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o app main.go

# Step 2: Final minimal stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]
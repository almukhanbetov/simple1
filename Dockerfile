# syntax=docker/dockerfile:1
FROM golang:1.24 AS builder

# 2. Рабочая директория внутри контейнера
WORKDIR /app
# 3. Копируем go.mod и go.sum и качаем зависимости
COPY go.mod go.sum ./
RUN go mod download
# 4. Копируем исходники и собираем бинарник
COPY . .
RUN go build -o app
# 5. Финальный образ на базе Ubuntu (минимальный)
FROM ubuntu:24.04
# Устанавливаем зависимости (если нужны)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем собранное приложение из билдера
COPY --from=builder /app/app .

# Открываем порт, если нужно (не обязательно, но полезно)
EXPOSE 8185

# Запускаем приложение
CMD ["./app"]

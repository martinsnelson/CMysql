# ── Stage 1: Build ──────────────────────────────────────────────────
FROM alpine:3.20 AS builder

RUN apk add --no-cache gcc musl-dev mariadb-connector-c-dev

WORKDIR /app
COPY include/ include/
COPY src/ src/

# DB_HOST padrão aponta para o serviço "db" definido no docker-compose
ARG DB_HOST=db
RUN sed -i "s/#define DB_HOST \"localhost\"/#define DB_HOST \"${DB_HOST}\"/" include/config.h

RUN mkdir -p output && gcc src/main.c src/conexao.c \
    -I /usr/include/mysql \
    -I include \
    -L /usr/lib \
    -lmariadb \
    -o output/cmysql

# ── Stage 2: Runtime ────────────────────────────────────────────────
FROM alpine:3.20 AS runtime

RUN apk add --no-cache mariadb-connector-c

WORKDIR /app
COPY --from=builder /app/output/cmysql ./output/cmysql

CMD ["./output/cmysql"]

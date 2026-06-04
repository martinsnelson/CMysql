#!/bin/bash

# Entra na pasta raiz do projeto
cd "$(dirname "$0")/.."

# Caminhos padrão do MariaDB/MySQL no Linux (Debian/Ubuntu)
MARIADB_INC="/usr/include/mariadb"
MARIADB_LIB="/usr/lib"

# Verifica se os headers do MariaDB estão instalados
if [ ! -d "$MARIADB_INC" ]; then
    echo "[ERRO] Headers do MariaDB não encontrados em $MARIADB_INC"
    echo "       Instale com: sudo apt install libmariadb-dev"
    exit 1
fi

echo "[BUILD] Compilando..."
gcc src/main.c src/conexao.c \
    -I "$MARIADB_INC" \
    -I include \
    -L "$MARIADB_LIB" \
    -lmariadb \
    -o output/cmysql

if [ $? -ne 0 ]; then
    echo "[ERRO] Compilação falhou."
    exit 1
fi

echo "[OK] Compilação concluída."
echo "[RUN] Executando..."
./output/cmysql
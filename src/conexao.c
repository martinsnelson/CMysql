#include <stdio.h>
#include <stdlib.h>
#include "conexao.h"
#include "config.h" // Inclui as macros DB_HOST, DB_USER, etc.

MYSQL* conectar_banco() {
    // Inicializa a estrutura do MySQL
    MYSQL *conn = mysql_init(NULL);

    if (conn == NULL) {
        fprintf(stderr, "Erro ao inicializar a API do MySQL.\n");
        return NULL;
    }

    // Abre a conexão usando as constantes que você definiu no config.h
    if (mysql_real_connect(conn, DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT, NULL, 0) == NULL) {
        fprintf(stderr, "Erro de conexão com o banco: %s\n", mysql_error(conn));
        mysql_close(conn); // Limpa a memória se falhar
        return NULL;
    }

    return conn;
}

void fechar_conexao(MYSQL *conn) {
    if (conn != NULL) {
        mysql_close(conn);
    }
}
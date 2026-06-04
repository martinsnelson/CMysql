#ifndef CONEXAO_H
#define CONEXAO_H

#include <mysql.h>

MYSQL* conectar_banco();
void fechar_conexao(MYSQL *conn);

#endif

#include <stdio.h>
#include <stdlib.h>
#include "mysql.h"
#include "conexao.h"

int main() {
    printf("Iniciando o sistema...\n");

    // 1. Tenta conectar ao banco de dados usando o seu módulo
    MYSQL *conn = conectar_banco();

    // 2. Verifica se a conexão deu certo
    if (conn != NULL) {
        printf("Conexao estabelecida com sucesso via modulo!\n");

        // ========================================================
        // A lógica do seu programa vai aqui.
        // Exemplo: Fazer um SELECT, INSERT, exibir menus, etc.
        // ========================================================

        // 3. Quando o programa terminar tudo, fecha a conexão
        fechar_conexao(conn);
        printf("Conexao encerrada. Sistema finalizado.\n");
        
    } else {
        // Cai aqui se a senha estiver errada, servidor offline, etc.
        printf("Falha critica: O sistema nao pode acessar o banco de dados.\n");
        return EXIT_SUCCESS;
    }
}
#ifndef CONFIG_H
#define CONFIG_H

// Defina aqui as credenciais do seu banco de dados
// Usar "127.0.0.1" (TCP) em vez de "localhost" (Unix socket) para conectar ao MySQL via Docker
#define DB_HOST "127.0.0.1"
#define DB_USER "root"
#define DB_PASS ""
#define DB_NAME "empresa"
#define DB_PORT 3306 // Porta padrão do MySQL

#endif

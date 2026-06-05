# CMYSQL - Conexão C/C++ com MySQL

Um projeto em C/C++ que se conecta a um banco de dados MySQL/MariaDB, compilável no **Windows** (MSYS2), **Linux** e via **Docker**.

> Para instalação do zero, veja o [Guia de Instalação](INSTALL.md).

## Ambiente

| Plataforma | Compilador | Biblioteca |
|---|---|---|
| Windows | GCC via MSYS2 UCRT64 | `mingw-w64-ucrt-x86_64-libmariadbclient` |
| Linux | GCC (sistema) | `libmariadb-dev` (apt) |
| Docker | GCC dentro do container | `libmariadb-dev` (Alpine) |

## Pré-requisitos

- MySQL/MariaDB rodando em `localhost:3306`
- Credenciais configuradas em `include/config.h`
- Dependências instaladas — veja [INSTALL.md](INSTALL.md)

## Como Compilar e Rodar

### Windows — Script automático (recomendado)

```cmd
config\win_config.bat
```

### Windows — Manualmente

```cmd
set PATH=C:\msys64\ucrt64\bin;%PATH%
gcc src\main.c src\conexao.c -I C:\msys64\ucrt64\include\mariadb -I include -L C:\msys64\ucrt64\lib -lmariadb -o output\cmysql.exe
output\cmysql.exe
```

### Linux — Script automático (recomendado)

```bash
bash config/linux_config.sh
```

### Linux — Manualmente

```bash
gcc src/main.c src/conexao.c -I /usr/include/mariadb -I include -L /usr/lib -lmariadb -o output/cmysql
./output/cmysql
```

### Docker — Build e execução

```bash
docker-compose up --build
```

O serviço `db` (MySQL 8.0) sobe automaticamente com o banco `empresa`. O serviço `app` aguarda o MySQL estar saudável antes de iniciar.

Para parar:

```bash
docker-compose down
```

### Docker — Debug remoto (VS Code)

```bash
docker-compose -f docker-compose.debug.yml up --build -d
```

Depois pressione `F5` e escolha **Docker Debug**. O VS Code conecta via gdbserver na porta `2345`.

Para encerrar o ambiente de debug:

```bash
docker-compose -f docker-compose.debug.yml down
```

> Também disponível via **Terminal → Run Task → Docker: Up / Docker: Debug Up**

### No VS Code

- **Build:** `Ctrl+Shift+B`
- **Rodar/Depurar:** `F5`

## Estrutura

```
cmysql/
├── include/
│   ├── conexao.h            - Interface das funções de conexão
│   └── config.h             - Credenciais do banco de dados
├── src/
│   ├── main.c               - Entrada do programa
│   └── conexao.c            - Implementação da conexão MySQL
├── config/
│   ├── win_config.bat       - Build e execução no Windows
│   └── linux_config.sh      - Build e execução no Linux
├── output/
│   └── cmysql.exe           - Executável gerado (Windows)
├── .vscode/
│   ├── c_cpp_properties.json
│   ├── tasks.json
│   └── launch.json
├── Dockerfile               - Build + runtime (multi-stage)
├── Dockerfile.debug         - Build com gdbserver para debug remoto
├── docker-compose.yml       - App + MySQL (produção)
├── docker-compose.debug.yml - App com gdbserver + MySQL (debug)
├── INSTALL.md
└── README.md
```

## Erros Comuns

**"Unknown database 'empresa'"**
→ Crie o banco: `CREATE DATABASE empresa;` no MySQL

**"Can't connect to MySQL server"**
→ Inicie o MySQL e verifique as credenciais em `include/config.h`

**"libmariadb.dll not found"** (Windows)
→ Use `config\win_config.bat` ou adicione `C:\msys64\ucrt64\bin` ao PATH

**Headers do MariaDB não encontrados** (Linux)
→ Instale com `sudo apt install libmariadb-dev`

---

**Status:** Pronto para compilar

> Preview deste arquivo no VS Code: `Ctrl+Shift+V`
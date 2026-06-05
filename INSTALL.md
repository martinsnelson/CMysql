# Guia de Instalação — CMYSQL

Guia completo para configurar o ambiente, instalar dependências e rodar o projeto do zero.

- [Windows](#windows)
- [Linux](#linux)
- [Docker](#docker)

---

# Windows

## 1. Pré-requisitos

- Windows 10/11 (64-bit)
- MySQL rodando localmente (ex.: [WAMP](https://www.wampserver.com/) ou [MySQL Community Server](https://dev.mysql.com/downloads/mysql/))
- Banco de dados existente (configure em `include/config.h`)

---

## 2. Instalar o MSYS2

O MSYS2 fornece o compilador GCC e as bibliotecas via gerenciador de pacotes `pacman`.

**2.1** Acesse [https://www.msys2.org](https://www.msys2.org) e baixe o instalador `msys2-x86_64-*.exe`.

**2.2** Execute o instalador e mantenha o caminho padrão: `C:\msys64`.

**2.3** Ao final da instalação, o terminal **UCRT64** abrirá automaticamente. Atualize os pacotes base:

```bash
pacman -Syu
```

> Se o terminal fechar após a atualização, abra novamente via **Iniciar → MSYS2 UCRT64** e rode `pacman -Su` para concluir.

---

## 3. Instalar GCC e MariaDB Connector/C

Abra o terminal **MSYS2 UCRT64** e rode:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S mingw-w64-ucrt-x86_64-make
pacman -S mingw-w64-ucrt-x86_64-libmariadbclient
```

Confirme com `Y` quando solicitado.

**Verificar instalação:**

```bash
gcc --version
```

---

## 4. Configurar credenciais do banco de dados

Edite `include/config.h` com as credenciais do seu MySQL:

```c
#define DB_HOST "localhost"
#define DB_USER "root"
#define DB_PASS ""        // senha do MySQL
#define DB_NAME "empresa"    // banco que deve existir
#define DB_PORT 3306
```

Para criar o banco caso não exista:

```sql
CREATE DATABASE empresa CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

Para criar a tabela caso não exista:
```sql
USE empresa;

CREATE TABLE pessoa ( id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100) NOT NULL, descricao TEXT ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

---

## 5. Build e execução

### Via script (recomendado)

Abra o `cmd.exe` na raiz do projeto em config/ e rode:

```cmd
win_config.bat
```

O script faz tudo automaticamente:
1. Adiciona `C:\msys64\ucrt64\bin` ao PATH
2. Compila `src\main.c` + `src\conexao.c` com GCC
3. Gera `output\cmysql.exe`
4. Executa o programa

### Via terminal manualmente

```cmd
set PATH=C:\msys64\ucrt64\bin;%PATH%
gcc src\main.c src\conexao.c -I C:\msys64\ucrt64\include\mariadb -I include -L C:\msys64\ucrt64\lib -lmariadb -o output\cmysql.exe
output\cmysql.exe
```

---

## 6. Configurar no VS Code

### 6.1 Instalar extensão C/C++ (obrigatória para debug)

A extensão **C/C++** da Microsoft fornece o tipo de depurador `cppdbg`. **Sem ela o `F5` não funciona.**

- Pressione `Ctrl+Shift+X`
- Pesquise **C/C++** (publisher: Microsoft, id: `ms-vscode.cpptools`)
- Clique em **Install** e reinicie o VS Code

### 6.2 Instalar GDB (obrigatório para debug)

Abra o terminal **MSYS2 UCRT64** e rode:

```bash
pacman -S mingw-w64-ucrt-x86_64-gdb
```

Verificar:

```bash
gdb --version
```

### 6.3 IntelliSense — `.vscode/c_cpp_properties.json`

Já configurado no projeto. Aponta para:
- `include/` — headers do projeto
- `C:/msys64/ucrt64/include/mariadb` — headers do MariaDB

### 6.4 Build no VS Code

Pressione `Ctrl+Shift+B` para compilar (tarefa definida em `.vscode/tasks.json`).

### 6.5 Rodar e depurar no VS Code

Com a extensão C/C++ e o GDB instalados, pressione `F5`. Serão exibidas duas opções:

- **Run Bat Win** — compila via `config\win_config.bat` e depura
- **Run GCC** — compila com `gcc -g` direto (recomendado para breakpoints)

> A flag `-g` já está configurada na task **Build CMYSQL (sem bat)** — usada pelo **Run GCC**.

---

## 7. Estrutura do projeto

```
cmysql/
├── include/
│   ├── conexao.h       - Interface das funções de conexão
│   └── config.h        - Credenciais do banco de dados
├── src/
│   ├── main.c          - Entrada do programa
│   └── conexao.c       - Implementação da conexão MySQL
├── config/
│   ├── win_config.bat  - Build e execução no Windows
│   └── linux_config.sh - Build e execução no Linux
├── output/
│   └── cmysql.exe      - Executável gerado (Windows)
├── .vscode/
│   ├── c_cpp_properties.json
│   ├── tasks.json
│   └── launch.json
└── README.md
```

---

## 8. Erros comuns

| Erro | Causa | Solução |
|------|-------|---------|
| `mysql.h: No such file or directory` | MariaDB Connector não instalado | `pacman -S mingw-w64-ucrt-x86_64-libmariadbclient` |
| `libmariadb.dll not found` | `C:\msys64\ucrt64\bin` fora do PATH | Usar `config\win_config.bat` |
| `Unknown database 'test'` | Banco não existe no MySQL | `CREATE DATABASE test;` no MySQL |
| `Can't connect to MySQL server` | MySQL não está rodando | Iniciar WAMP ou MySQL |
| `[ERRO] Compilacao falhou` | Caminho do MSYS2 diferente de `C:\msys64` | Ajustar caminhos em `config\win_config.bat` |
---

# Linux

## 1. Pré-requisitos

- Ubuntu/Debian (ou derivado)
- MySQL ou MariaDB rodando em `localhost:3306`
- Um banco de dados existente (configurado em `include/config.h`)

---

## 2. Instalar GCC, GDB e MariaDB Connector/C

```bash
sudo apt update
sudo apt install gcc gdb libmariadb-dev
```

**Verificar instalação:**

```bash
gcc --version
gdb --version
```

---

## 3. Configurar credenciais do banco de dados

Edite `include/config.h` com as credenciais do seu MySQL:

```c
#define DB_HOST "localhost"
#define DB_USER "root"
#define DB_PASS ""        // senha do MySQL
#define DB_NAME "empresa"    // banco que deve existir
#define DB_PORT 3306
```

Para criar o banco caso não exista:

```sql
CREATE DATABASE empresa CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

Para criar a tabela caso não exista:

```sql
USE empresa;

CREATE TABLE pessoa ( id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100) NOT NULL, descricao TEXT ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

---

## 4. Build e execução

### Via script (recomendado)

Na raiz do projeto, rode:

```bash
bash config/linux_config.sh
```

O script faz tudo automaticamente:
1. Verifica se os headers do MariaDB estão instalados
2. Compila `src/main.c` + `src/conexao.c` com GCC
3. Gera `output/cmysql`
4. Executa o programa

### Via terminal manualmente

```bash
gcc src/main.c src/conexao.c -I /usr/include/mariadb -I include -L /usr/lib -lmariadb -o output/cmysql
./output/cmysql
```

---

## 5. Configurar no VS Code

### 5.1 Instalar extensão C/C++ (obrigatória para debug)

A extensão **C/C++** da Microsoft fornece o tipo de depurador `cppdbg`. **Sem ela o `F5` não funciona.**

- Pressione `Ctrl+Shift+X`
- Pesquise **C/C++** (publisher: Microsoft, id: `ms-vscode.cpptools`)
- Clique em **Install**

> No WSL2, instale a extensão **dentro do WSL** (a aba "WSL: Ubuntu" no painel de extensões), não apenas no host Windows.

### 5.2 Build no VS Code

Pressione `Ctrl+Shift+B` e selecione **Build CMYSQL Linux**.

### 5.3 Rodar e depurar no VS Code

Com a extensão C/C++ e o GDB instalados, pressione `F5` e selecione **Run Linux**.

---

## 6. Erros comuns

| Erro | Causa | Solução |
|------|-------|---------|
| `mysql.h: No such file or directory` | libmariadb-dev não instalado | `sudo apt install libmariadb-dev` |
| `error while loading shared libraries: libmariadb.so` | Biblioteca não encontrada | `sudo ldconfig` |
| `Unknown database 'empresa'` | Banco não existe | `CREATE DATABASE empresa;` no MySQL |
| `Can't connect to MySQL server` | MySQL não está rodando | `sudo systemctl start mysql` |

---

# Docker

Sobe o MySQL e compila/executa a aplicação em containers — sem instalar GCC ou MySQL na máquina host.

## 1. Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado (Windows ou Linux)
- Credenciais configuradas em `include/config.h` (usuário, senha, nome do banco)

> O host do banco de dados (`DB_HOST`) é configurado automaticamente para `db` (nome do serviço no compose) durante o build da imagem.

---

## 2. Build e execução

Na raiz do projeto:

```bash
docker-compose up --build
```

O que acontece:
1. Sobe o serviço `db` (MySQL 8.0) com o banco `empresa` criado automaticamente
2. Aguarda o MySQL ficar saudável (healthcheck)
3. Compila a aplicação dentro de um container Debian e gera o binário
4. Executa o binário na imagem de runtime

Para parar e remover os containers:

```bash
docker-compose down
```

### Via VS Code

**Terminal → Run Task → Docker: Up** — sobe tudo em background com logs no terminal.

**Terminal → Run Task → Docker: Down** — derruba os containers.

---

## 3. Debug remoto no VS Code

O `Dockerfile.debug` compila com `-g` e inicia `gdbserver` na porta `2345`, aguardando conexão do VS Code.

**Passo 1** — Sobe o ambiente de debug:

```bash
docker-compose -f docker-compose.debug.yml up --build -d
```

Ou via VS Code: **Terminal → Run Task → Docker: Debug Up**

**Passo 2** — Pressione `F5` e escolha **Docker Debug**.

O VS Code conecta ao gdbserver via `localhost:2345`. Breakpoints e inspeção de variáveis funcionam normalmente. Os caminhos de source dentro do container (`/app/`) são mapeados para a raiz do workspace.

**Passo 3** — Ao terminar, encerre o ambiente:

```bash
docker-compose -f docker-compose.debug.yml down
```

Ou via VS Code: **Terminal → Run Task → Docker: Debug Down**

---

## 4. Erros comuns

| Erro | Causa | Solução |
|------|-------|---------|
| `Cannot connect to Docker daemon` | Docker Desktop não está rodando | Iniciar o Docker Desktop |
| `port 3306 already in use` | MySQL local já está usando a porta | Parar o MySQL local ou mudar a porta no `docker-compose.yml` |
| `Connection refused` no debug | Container ainda subindo | Aguardar alguns segundos e tentar `F5` novamente |
| `gdbserver` não encontrado | Imagem de debug não foi reconstruída | `docker-compose -f docker-compose.debug.yml build --no-cache` |

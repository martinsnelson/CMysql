@echo off
:: Vai para a raiz do projeto (um nivel acima de config/)
cd /d "%~dp0.."

:: Adiciona ucrt64/bin ao PATH antes de tudo (GCC precisa de ld, as, etc.)
set PATH=C:\msys64\ucrt64\bin;%PATH%

:: Caminhos do MSYS2 UCRT64
set MARIADB_INC=C:\msys64\ucrt64\include\mariadb
set MARIADB_LIB=C:\msys64\ucrt64\lib

echo [BUILD] Compilando...
gcc.exe src\main.c src\conexao.c -I "%MARIADB_INC%" -I include -L "%MARIADB_LIB%" -lmariadb -o output\cmysql.exe

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Compilacao falhou.
    pause
    exit /b 1
)

echo [OK] Compilacao concluida.
echo [RUN] Executando...
output\cmysql.exe

pause
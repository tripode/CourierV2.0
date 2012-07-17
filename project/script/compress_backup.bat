f:
cd F:\Original Courrier\project\db

set FECHA=%DATE% %TIME%
set FECHA=%FECHA:/=%
set FECHA=%FECHA::=-%
set FECHA=%FECHA:.=-%
rar.exe a compress_backup\"%FECHA%".rar backup\

del /Q backup\

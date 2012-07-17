@echo off
set PGPASSWORD=postgres
pg_dump.exe -i -h localhost -p 5432 -U postgres -F c -b -v -f "F:\Original Courrier\project\db\backup\respaldo.backup" currier_production_db

set FECHA=%DATE% %TIME%
set FECHA=%FECHA:/=%
set FECHA=%FECHA::=-%
set FECHA=%FECHA:.=-%
ren "F:\Original Courrier\project\db\backup\respaldo.backup" "%FECHA%".backup
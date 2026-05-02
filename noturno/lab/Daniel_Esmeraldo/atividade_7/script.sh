#!/bin/bash

echo Buscando arquivos com permissão 777... > relatorio.txt
find /home -perm 777 >> relatorio.txt 2>/dev/null
echo Buscando arquivos com permissão setuid... >> relatorio.txt
find / -perm /4000 >> relatorio.txt 2>/dev/null
echo Buscando usuários com UID 0... >> relatorio.txt 
awk -F: '$3 == 0 { print $1 }' /etc/passwd >> relatorio.txt 2>/dev/null

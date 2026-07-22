#!/bin/bash

cat > config.txt << EOF
SERVIDOR=localhost
# Configurações do Banco de Dados
BANCO=producao
# Porta de acesso
PORTA=8080
TIMEOUT=30
# Modo de debug
DEBUG=false
# Limite de conexões
MAX_CONN=100
EOF

sed 's/localhost/192.168.1.1/' config.txt
sed '/^#/d' config.txt
sed -n '5,10p' config.txt
sed 's/^/SISTEMA_/' config.txt

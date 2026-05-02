#!/bin/bash
# Script de configuração do sistema
# Autor: Atividade V - Estudos Linux

# Configureções de rede
SERVIDOR="localhost"
PORTA="8080"
PROTOCOLO="http"

# Configurações de banco de dados
DB_HOST="localhost"
DB_USER="admin"
DB_PASS="senha123"
DB_NAME="meubanco"

# Configurações de logging
LOG_DIR="/var/log/myapp"
LOG_LEVEL="INFO"
MAX_LOG_SIZE="10MB"

# Configurações de timeout
CONNECTION_TIMEOUT=30
READ_TIMEOUT=60
WRITE_TIMEOUT=30

# Configurações de cache
CACHE_ENABLED="true"
CACHE_TTL=3600
CACHE_SIZE="256MB"

echo "Configurações carregadas com sucesso!"

#!/bin/sh
# Define um PATH completo para garantir que todos os comandos sejam encontrados
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# Executa o script de descoberta e salva o JSON em um arquivo
/usr/local/bin/ipsec_discovery.sh > /tmp/ipsec_status.json

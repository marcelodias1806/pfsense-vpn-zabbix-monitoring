#!/bin/sh
# Este script retorna o status e tempo online para um túnel específico
if [ -z "$1" ]; then
    echo "Tunnel parameter missing"
    exit 1
fi

# Filtra o túnel desejado a partir da saída do ipsec status
ipsec status 2>/dev/null | grep "$1" | grep "ESTABLISHED" | head -n 1

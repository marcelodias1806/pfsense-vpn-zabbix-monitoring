#!/bin/sh
if [ -z "$1" ]; then
    echo "Tunnel parameter missing"
    exit 1
fi
# Retorna somente o tempo online do túnel (extraído da linha ESTABLISHED)
ipsec status 2>/dev/null | grep "$1" | grep "ESTABLISHED" | sed -n 's/.*ESTABLISHED \([^,]* ago\).*/\1/p' | head -n 1

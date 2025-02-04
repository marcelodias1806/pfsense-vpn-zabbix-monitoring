#!/bin/sh
# ipsec_onlinetime.sh: Retorna o valor do campo {#ONLINE_TIME} para um túnel específico,
# lido do arquivo JSON gerado pelo cron.
#
# Uso: ipsec_onlinetime.sh <nome_do_tunel>
#
# Exemplo: ipsec_onlinetime.sh con3

# Define um PATH completo para garantir que os comandos sejam encontrados
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# Verifica se o parâmetro do túnel foi passado
if [ -z "$1" ]; then
    echo "Parâmetro do túnel não informado."
    exit 1
fi

# Define o caminho do arquivo JSON
FILE="/tmp/ipsec_status.json"

if [ ! -f "$FILE" ]; then
    echo "Arquivo $FILE não encontrado."
    exit 1
fi

# Lê o conteúdo do arquivo e remove quebras de linha
JSON=$(tr -d '\n' < "$FILE")

# Utiliza sed para extrair o valor do campo {#ONLINE_TIME} para o túnel informado.
ONLINETIME=$(echo "$JSON" | sed -n 's/.*{"{#TUNNEL}":"'"$1"'".*"{#ONLINE_TIME}":"\([^"]*\)".*/\1/p')

if [ -z "$ONLINETIME" ]; then
    echo "Túnel $1 não encontrado ou valor não disponível."
    exit 1
fi

echo "$ONLINETIME"

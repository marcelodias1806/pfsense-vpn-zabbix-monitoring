#!/bin/sh
# ipsec_status.sh: Retorna o valor do campo {#STATUS} para um túnel específico,
# lido do arquivo JSON gerado pelo cron.
#
# Uso: ipsec_status.sh <nome_do_tunel>
#
# Exemplo: ipsec_status.sh con3

# Define um PATH completo para garantir que os comandos sejam encontrados
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# Verifica se o parâmetro do túnel foi passado
if [ -z "$1" ]; then
    echo "Parâmetro do túnel não informado."
    exit 1
fi

# Define o caminho do arquivo JSON (ajuste se necessário)
FILE="/tmp/ipsec_status.json"

if [ ! -f "$FILE" ]; then
    echo "Arquivo $FILE não encontrado."
    exit 1
fi

# Lê o conteúdo do arquivo e remove quebras de linha
JSON=$(tr -d '\n' < "$FILE")

# Utiliza sed para extrair o valor do campo {#STATUS} para o túnel informado.
# A expressão procura por um objeto JSON cujo campo "{#TUNNEL}" seja igual a $1 e extrai o valor de "{#STATUS}".
STATUS=$(echo "$JSON" | sed -n 's/.*{"{#TUNNEL}":"'"$1"'".*"{#STATUS}":"\([^"]*\)".*/\1/p')

if [ -z "$STATUS" ]; then
    echo "Túnel $1 não encontrado ou valor não disponível."
    exit 1
fi

echo "$STATUS"

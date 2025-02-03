# pfsense-vpn-zabbix-monitoring
# pfSense VPNs monitoring with Zabbix

#!/bin/sh
# Script de Low-Level Discovery (LLD) para túneis IPsec
# Este script executa "ipsec status", filtra os túneis ESTABLISHED
# e retorna um JSON com os dados de cada túnel.

# Executa o comando e armazena a saída
ipsec_output=`ipsec status 2>/dev/null`

# Se não houver retorno, emite um JSON vazio
if [ -z "$ipsec_output" ]; then
    echo '{"data":[]}'
    exit 0
fi

# Cria um arquivo temporário para manipular as linhas (evita problemas com pipes)
tmpfile=`mktemp /tmp/ipsec.XXXXXX` || exit 1
echo "$ipsec_output" | grep "ESTABLISHED" > "$tmpfile"

# Inicia o JSON
echo '{"data":['

first=1
# Lê cada linha processada
while IFS= read -r line
do
    # Exemplo de linha:
    # con3[515490]: ESTABLISHED 41 minutes ago, 192.168.10.1[179.1.134.75]...144.236.214.177[144.236.214.177]

    # Extrai o identificador do túnel (remove os dois pontos e espaços extras)
    tunnel=`echo "$line" | awk -F'[' '{print $1}' | sed 's/://g' | sed 's/^ *//;s/ *$//'`
    
    # Como a linha contém "ESTABLISHED", o status é "Online"
    status="Online"
    
    # Extrai o tempo online (entre "ESTABLISHED " e a vírgula)
    tempo_online=`echo "$line" | sed -n 's/.*ESTABLISHED \([^,]* ago\).*/\1/p'`
    
    # Se não for o primeiro item, insere uma vírgula
    if [ $first -eq 0 ]; then
        echo ","
    fi
    first=0
    
    # Imprime o objeto JSON para este túnel.
    # Note que as macros de LLD do Zabbix precisam estar no formato {#MACRO}
    echo "{\"{#TUNNEL}\":\"$tunnel\", \"{#STATUS}\":\"$status\", \"{#ONLINE_TIME}\":\"$tempo_online\"}"
done < "$tmpfile"

# Remove o arquivo temporário
rm -f "$tmpfile"

# Fecha o JSON
echo ']}'

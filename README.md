# Monitoramento de Túneis IPsec com Zabbix e pfSense/FreeBSD

Este repositório contém um conjunto de scripts e configurações para monitorar túneis IPsec em ambientes pfSense/FreeBSD utilizando o Zabbix. A solução utiliza **UserParameters** e **Low-Level Discovery (LLD)** do Zabbix para coletar informações individualizadas de cada túnel, permitindo a criação de itens, gráficos e triggers específicos para cada conexão.

## Funcionalidades

- **Coleta de Informações dos Túneis IPsec:**  
  Executa o comando `ipsec status` para extrair os túneis ativos, status ("Online") e o tempo de conexão (ex.: "41 minutes ago").

- **Descoberta de Túneis via LLD:**  
  Um script em shell gera um JSON no padrão LLD do Zabbix, que permite a descoberta automática dos túneis e criação de itens dinâmicos para monitoramento individual.

- **Itens e Triggers Individuais:**  
  Possibilidade de configurar itens protótipos para cada túnel (status e tempo online) e criar triggers que alertem caso algum túnel fique offline ou apresente problemas.

## Pré-requisitos

- **pfSense/FreeBSD:**  
  O ambiente deve ter o IPsec configurado e o comando `ipsec status` disponível.

- **Zabbix Agent:**  
  Versão compatível com UserParameters e LLD (o script foi testado em ambientes FreeBSD/pfSense).

- **Permissões:**  
  Os scripts devem ter permissões de execução e o usuário que executa o Zabbix Agent (geralmente `zabbix`) precisa ter acesso para executar os scripts e comandos necessários.

## Arquivos e Estrutura

- **`/usr/local/bin/ipsec_discovery.sh`:**  
  Script em shell que executa o comando `ipsec status`, extrai as informações dos túneis IPsec e gera um JSON no formato LLD.  
  **Exemplo de saída JSON:**
  ```json
  {
    "data": [
      { "{#TUNNEL}": "con3", "{#STATUS}": "Online", "{#ONLINE_TIME}": "41 minutes ago" },
      { "{#TUNNEL}": "con9", "{#STATUS}": "Online", "{#ONLINE_TIME}": "11 minutes ago" },
      { "{#TUNNEL}": "con4", "{#STATUS}": "Online", "{#ONLINE_TIME}": "6 hours ago" }
    ]
  }

## Script Auxiliar
   Script auxiliar que, quando chamado com o identificador do túnel, retorna a linha do comando ipsec status correspondente, permitindo extrair o status completo.
   - **`/usr/local/bin/ipsec_status.sh:`:**

   Script auxiliar que retorna somente o tempo online do túnel especificado.
   - **`/usr/local/bin/ipsec_onlinetime.sh:`:**

## Configuração do Zabbix Agent
   Copie os scripts para um diretório acessível (por exemplo, /usr/local/bin/) e torne-os executáveis:

   - **`chmod +x /usr/local/bin/ipsec_discovery.sh`:**
   - **`chmod +x /usr/local/bin/ipsec_status.sh`:**
   - **`chmod +x /usr/local/bin/ipsec_onlinetime.sh`:**

   Edite o arquivo de configuração do Zabbix Agent (ex.: /etc/zabbix/zabbix_agentd.conf) e adicione os seguintes UserParameters:

   **Descoberta dos túneis IPsec**
   - **`UserParameter=ipsec.discovery,/usr/local/bin/ipsec_discovery.sh`:**

   **Status completo do túnel (usado para itens protótipos)**
   - **`UserParameter=ipsec.tunnel.status[*],/usr/local/bin/ipsec_status.sh "$1"`:**

   **Tempo online do túnel**
   - **`UserParameter=ipsec.tunnel.onlinetime[*],/usr/local/bin/ipsec_onlinetime.sh "$1"`:**

   **Reinicie o Zabbix Agent para aplicar as alterações:**
   - **`service zabbix_agentd restart`:**

## Configuração no Zabbix Frontend
   ## Crie uma Regra de Descoberta:
   #### Navegue até Configuration → Hosts e selecione o host monitorado.
   #### Em Discovery rules, crie uma nova regra com:
   #### Name: Descoberta de Túneis IPsec
   #### Type: Zabbix agent (ou Zabbix agent (active))
   #### Key: ipsec.discovery
   #### Update interval: (ex.: 60 segundos)
   #### Keep lost resources period: (ex.: 7 dias)
   #### Crie Itens Protótipos para cada túnel:

## Status do Túnel:
   #### Name: IPsec - Status do túnel {#TUNNEL}
   #### Key: ipsec.tunnel.status[{#TUNNEL}]
   #### Tipo de Informação: Texto
   #### Tempo Online:
   #### Name: IPsec - Tempo Online do túnel {#TUNNEL}
   #### Key: ipsec.tunnel.onlinetime[{#TUNNEL}]
   #### Tipo de Informação: Texto
   #### Crie Triggers (opcional): \
   
   ### Por exemplo, crie um trigger para alertar se o status do túnel não contiver "Online":

   - **` {Nome_do_Host:ipsec.tunnel.status[{#TUNNEL}].str(Online)}=0`:**


#### Contribuições
#### Sinta-se à vontade para abrir issues ou enviar pull requests para melhorar os scripts ou a documentação. Qualquer sugestão é bem-vinda!

#### Autor: Marcelo Dias
   ##### Instagram: @binbash.sh 
   ##### LinkedIn: https://www.linkedin.com/in/mdiasx/ 

##### Licença: Este projeto é licenciado sob a MIT License. 


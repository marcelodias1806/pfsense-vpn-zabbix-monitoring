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

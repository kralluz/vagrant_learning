# Usar Ubuntu como imagem base
FROM ubuntu:20.04

# Definir variáveis para evitar prompts durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualizar repositórios e instalar dependências
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    perl \
    isc-dhcp-server \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários para o DHCP
RUN mkdir -p /etc/dhcp /var/lib/dhcp /var/run/dhcpd

# Criar o arquivo dhcpd.leases vazio
RUN touch /var/lib/dhcp/dhcpd.leases

# Copiar o arquivo de configuração padrão
COPY dhcpd.conf /etc/dhcp/dhcpd.conf

# Expor a porta padrão do DHCP
EXPOSE 67/udp

# Definir o comando padrão para iniciar o servidor DHCP
CMD ["dhcpd", "-4", "-f", "-cf", "/etc/dhcp/dhcpd.conf"]

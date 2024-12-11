# README

**Administração de Redes de Computadores**

- **Instituição**: IF Goiano - Campus Ceres
- **Curso**: Bacharelado em Sistemas de Informação
- **Disciplina**: Administração de Redes de Computadores
- **Alunos**: Carlos Henrique e Luiz Felipe
- **Professor**: Roitier

---

## Objetivo

O objetivo deste trabalho é provisionar duas máquinas virtuais (VMs) utilizando o Vagrant:

- **Server**: Configurado para fornecer serviços DHCP, DNS, FTP, Samba e NFS.
- **Client**: Configurado para obter IP via DHCP, utilizar o DNS configurado no servidor e acessar os serviços FTP, Samba e NFS.

Este guia ajuda a preparar o ambiente, explica cada parte do arquivo Vagrantfile e descreve como testar os serviços implementados.

## Preparação do Ambiente

1. **Pré-requisitos**:
   - Certifique-se de que o Vagrant e o VirtualBox estão instalados em seu sistema.
     - Para instalar o Vagrant: [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads)
     - Para instalar o VirtualBox: [https://www.virtualbox.org/](https://www.virtualbox.org/)
     - **Recomendação**: Utilize a versão 6.1 do VirtualBox para maior compatibilidade.

2. **Verificação da Instalação**:
   - Execute os comandos abaixo para verificar se os softwares estão instalados corretamente:
     ```bash
     vagrant --version
     vboxmanage --version
     ```

3. **Preparar o Ambiente**:
   - Crie um diretório para o projeto:
     ```bash
     mkdir meu_projeto
     cd meu_projeto
     ```
   - Inicialize o Vagrant no diretório:
     ```bash
     vagrant init
     ```
   - Substitua o arquivo `Vagrantfile` gerado pelo fornecido.
   - No terminal, execute:
     ```bash
     vagrant up
     ```
   - Este comando inicializa e configura as máquinas virtuais conforme especificado no `Vagrantfile`.

---

## Estrutura do Vagrantfile

### Configuração da Máquina Virtual Server

1. **Definição da VM Server**:
   ```ruby
   config.vm.define "server" do |server|
   ```
   Define a máquina virtual chamada "server".

2. **Sistema Operacional**:
   ```ruby
   server.vm.box = "ubuntu/bionic64"
   ```
   Utiliza o Ubuntu 18.04 LTS como sistema operacional.

3. **Hostname**:
   ```ruby
   server.vm.hostname = "dhcp-bind-server"
   ```
   Define o hostname como "dhcp-bind-server".

4. **Rede Privada**:
   ```ruby
   server.vm.network "private_network", ip: "192.168.56.1", virtualbox__intnet: "dhcp_network"
   ```
   Configura uma rede privada com o IP fixo `192.168.56.1` e integra a interface de rede na rede "dhcp_network".

5. **Provedor VirtualBox**:
   ```ruby
   server.vm.provider "virtualbox" do |vb|
       vb.name = "dhcp-bind-server"
   end
   ```
   Define o nome da VM no VirtualBox como "dhcp-bind-server".

6. **Provisionamento do Sistema**:
   ```ruby
   server.vm.provision "shell", inline: <<-SHELL
   ```
   Executa comandos shell para provisionar a máquina com os serviços ISC-DHCP-Server, BIND9, FTP, Samba e NFS.

### Configuração do ISC-DHCP-Server

- **Atualização de pacotes**:
  ```bash
  sudo apt-get update
  ```
  Atualiza os pacotes do sistema.

- **Instalação do servidor DHCP**:
  ```bash
  sudo apt-get install -y isc-dhcp-server
  ```
  Instala o serviço ISC-DHCP-Server.

- **Configuração do arquivo `/etc/dhcp/dhcpd.conf`**:
  Define a faixa de IPs, roteador e servidor DNS para a rede:
  ```bash
  subnet 192.168.56.0 netmask 255.255.255.0 {
      range 192.168.56.10 192.168.56.100;
      option routers 192.168.56.1;
      option domain-name-servers 192.168.56.1;
  }
  ```

- **Habilitação e reinício do serviço**:
  ```bash
  sudo systemctl restart isc-dhcp-server
  sudo systemctl enable isc-dhcp-server
  ```

### Configuração do BIND9

- **Instalação do BIND9**:
  ```bash
  sudo apt-get install -y bind9 bind9utils bind9-doc
  ```

- **Configuração das opções do BIND9**:
  Edita o arquivo `/etc/bind/named.conf.options` para permitir consultas e configurar encaminhadores:
  ```bash
  options {
      listen-on { any; };
      allow-query { any; };
      forwarders {
          8.8.8.8;
          8.8.4.4;
      };
  };
  ```

- **Criação de uma zona DNS**:
  Adiciona a zona "example.local" no arquivo `/etc/bind/named.conf.local` e configura o arquivo de zona correspondente.

- **Verificação e reinício**:
  Verifica a configuração e reinicia o serviço:
  ```bash
  sudo named-checkconf
  sudo named-checkzone example.local /etc/bind/db.example.local
  sudo systemctl restart bind9
  sudo systemctl enable bind9
  ```

### Testes do Lado do Servidor

#### Verificar o serviço DHCP
- Confirme que o serviço DHCP está ativo:
  ```bash
  sudo systemctl status isc-dhcp-server
  ```
- Verifique os leases de IP no arquivo de log:
  ```bash
  cat /var/lib/dhcp/dhcpd.leases
  ```

#### Verificar o serviço DNS
- Teste uma consulta DNS local:
  ```bash
  dig @192.168.56.1 example.local
  ```

---

### Configuração da Máquina Virtual Client

1. **Definição da VM Client**:
   ```ruby
   config.vm.define "client" do |client|
   ```
   Define a máquina virtual chamada "client".

2. **Rede Privada (DHCP)**:
   - Configura a interface de rede para obter IP via DHCP:
     ```ruby
     client.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp_network"
     ```

3. **Provisionamento da Máquina Client**:
   - Atualiza pacotes e instala utilitários de rede necessários para acessar os serviços FTP, Samba e NFS:
     ```bash
     sudo apt-get update
     sudo apt-get install -y dnsutils ftp samba-client nfs-common
     ```

### Testes do Lado do Cliente

#### Verificar o serviço DHCP
- Obtenha o IP atribuído automaticamente:
  ```bash
  ip addr show
  ```

#### Verificar o serviço DNS
- Teste a resolução de nomes:
  ```bash
  dig example.local
  ```

#### Testar acesso FTP
- Conecte ao servidor FTP:
  ```bash
  ftp 192.168.56.1
  ```

#### Testar acesso Samba
- Liste os compartilhamentos Samba disponíveis:
  ```bash
  smbclient -L //192.168.56.1
  ```

#### Testar acesso NFS
- Monte um diretório NFS compartilhado:
  ```bash
  sudo mount 192.168.56.1:/path/to/share /mnt
  ```

---

## Conclusão

Com as instruções acima, os serviços ISC-DHCP-Server, BIND9, FTP, Samba e NFS foram configurados e testados com sucesso em máquinas virtuais provisionadas pelo Vagrant. Caso ocorram problemas, revise as configurações e logs de cada serviço.

### Referências e Documentações
- [Documentação do Vagrant](https://www.vagrantup.com/docs)
- [Documentação do ISC-DHCP-Server](https://manpages.ubuntu.com/manpages/bionic/en/man8/dhcpd.8.html)
- [Documentação do BIND9](https://bind9.readthedocs.io/en/latest/)
- [Documentação do FTP (vsftpd)](https://security.appspot.com/vsftpd.html)
- [Documentação do Samba](https://www.samba.org/samba/docs/)
- [Documentação do NFS](https://wiki.linux-nfs.org/wiki/index.php/Main_Page)

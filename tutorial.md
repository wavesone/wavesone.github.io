---
layout: page
title: Tutorial
---

# Tutorial de configuração de um Full Node "Nó Completo" (gerador de blocos) WAVES!


### Para começar você precisa ter uma VPS (_servidor virtal privado_) com no mínimo 4GB de memoria RAM, 40GB de SSD e ter 1000 WAVES ou mais (_só é necessário ter 1000 WAVES se você for gerar blocos, caso contrario não é necessário_).

### Existem vários provedores de servidores virtuais privados (VPS), mas atenção não use qualquer provedor para rodar coisas criticas como um full node waves, pois se o provedor não for confiável você pode ter seus fundos roubados ou sua VPS não terá eficiência.

#### Veja esta pequena lista de alguns provedores de VPS:
* [https://skysilk.com](https://skysilk.com)(_tem o melhor custo beneficio e diversas configurações_).
* [https://namecheap.com](https://namecheap.com) (_aceita bitcoin como método de pagamento e possui outros serviços_)
* [https://aws.amazon.com/pt/ec2](https://aws.amazon.com/pt/ec2) (_mais flexível_).
* [https://www.vultr.com](https://www.vultr.com) (_aceita bitcoin como método de pagamento_).
* [https://www.digitalocean.com](https://www.digitalocean.com) (_mais popular_)
* [https://contabo.com](https://contabo.com) (_ótimo custo beneficio mas poucas opções de pagamento_).

#### Escolha o que melhor lhe atender.

### Como exemplo vou usar uma VPS com 4GB de memoria RAM e 60GB de SSD e sistema operacional Debian 9.

#### Depois de ter comprado a VPS e ter feito o primeiro acesso VPS precisaremos executar alguns comandos no terminal, como: adicionar um novo usuário, instalar os pacotes necessários para o software waves, instalar e configurar o nó waves e um firewall para a VPS.

#### Primeiro vamos atualizar os pacotes do sistema operacional e instalar os pacotes necessários pra waves funcionar.
`apt update -y`

`apt full-upgrade -y`

`apt install sudo default-jdk default-jre default-jre-headless htop screen iptables iptables-persistent -y`

#### Agora vamos adicionar um novo usuário pra evitar usar a conta raiz (_root_), pois é muito perigoso. Escolha uma senha muito forte sempre algo aleatório acima de 16 caracteres incluindo letras, maiúscula e minuscula, números e símbolos, ou se você achar mais comodo gere uma _SEED_ na _waves wallet_ e use ela como senha vai ser ate mais seguro pois sera uma senha aleatória.
![](https://raw.githubusercontent.com/wavesone/wavesone.github.io/master/public/img/seedcomosenha.png)

#### Adicionando nova conta de usuário.
`adduser nomedeusuario`

#### Adicionar seu usuário ao grupo sudo para ter privilégios da conta root.
`adduser nomedeusuario sudo`

#### Vamos reiniciar a VPS.
`reboot`

### Faça login na sua VPS usando o seu novo usuário criado anteriormente.

### Usaremos o editor de texto nano para manipular os arquivos de texto. para salvar qualquer alteração feita nos arquivos abertos de o comando `CTRL-x` digite `S` e pressione a tecla `Enter` as alterações feitas serão salvas e o arquivo fechado. Sempre que fizer alguma alteração em arquivos de texto, _salve_ e _feche_ o arquivo! 

#### Agora vamos desativar o login do root SSH no Linux. O acesso root ao SSH deve ser desativado em todos os casos no Linux, a fim de reforçar a segurança do seu servidor. Neste arquivo, procure a linha `PermitRootLogin yes` e troque `yes` por `no`.
`sudo nano /etc/ssh/sshd_config`

#### Depois de fazer as alterações acima, salve e feche o arquivo e reinicie o daemon SSH rodando o comando abaixo.
`sudo systemctl restart sshd`

### Existem duas formas de instalar o software WAVES, a primeira é através do pacote debian `.DEB` que só serve para Debian e seus derivados e a segunda é através do binário java `.JAR` que serve para qualquer outra distribuição GNU/Linux.

#### Vamos baixar e instalar a WAVES através do pacote debian `.DEB`
`wget https://github.com/wavesplatform/Waves/releases/download/v0.15.4/waves_0.15.4_all.deb`

`sudo dpkg -i waves_0.15.4_all.deb`

#### O arquivo de configuração do pacote `.DEB`fica localizado em `/etc/waves/waves.conf` e com esse comando você abre o arquivo de configuração do nó (muito cuidado para não errar nada ao realizar as modificações).
`sudo nano /etc/waves/waves.conf`

#### A partir da versão `0.13.4` alguns parâmetros adicionais devem ser configurados, se você está instalando a partir do pacote  `.DEB` você precisa seguir os passos logo abaixo:

#### Encontre a linha `# Blockchain settings` e logo acima dela adicione:
```
 # New blocks generator settings
  miner {
    # Enable/disable block generation
    enable = yes

    # Required number of connections (both incoming and outgoing) to attempt block generation. Setting this value to 0
    # enables "off-line generation".
    quorum = 3

    # Enable block generation only in the last block is not older the given period of time
    #interval-after-last-block-then-generation-is-allowed = 1d

    # Interval between microblocks
    micro-block-interval = 5s

    # Mininmum time interval between blocks
    minimal-block-generation-offset = 1001ms

    # Max amount of transactions in key block
    max-transactions-in-key-block = 0

    # Max amount of transactions in micro block
    max-transactions-in-micro-block = 255

    # Miner references the best microblock which is at least this age
    min-micro-block-age = 6s
  }
```

#### Para iniciar o nó use o comando:
`sudo systemctl start waves.service`

#### Para parar o nó use o comando:
`sudo systemctl stop waves.service`

#### Para reiniciar o nó use o comando:
`sudo systemctl restart waves.service`

#### Para ver o progresso do nó e se tudo está ocorrendo bem use o comando:
`journalctl -u waves.service -f`

#### Para visualizar os logs do nó instalado a partir do pacote `.DEB` ou seja os registros do que está acontecendo:
`sudo nano /var/lib/waves/data/LOG`

#### Para monitorar o uso de CPU e memoria do seu nó na sua VPS use o comando:
`htop`

#### Todos os dados gerados pelo seu nó instalado a partir do pacote `.DEB` como: wallet, logs e o blockchain serão encontrados na pasta `/var/lib/waves/`.


### Vamos baixar e instalar a WAVES através do binário java `.JAR`
`wget https://github.com/wavesplatform/Waves/releases/download/v0.15.4/waves-all-0.15.4.jar`

#### Baixe o arquivo de configuração completo a partir do meu github:
`wget https://raw.githubusercontent.com/wavesone/wavesone.github.io/master/public/conf/waves-mainnet.conf`

#### Nesse procedimento algumas coisas são diferentes como os comandos para iniciar e para o nó, arquivo de configuração e a pasta de dados gerados pelo nó, então siga os procedimentos descritos abaixo.

#### Com esse comando você abre o arquivo de configuração do nó (muito cuidado para não errar nada ao realizar as modificações).
`nano waves-mainnet.conf`

#### Para iniciar o nó vamos usar o `screen` para criar uma tela alternativa para iniciar e parar o nó.

#### Comando para iniciar o nó:
`screen -d -S wavesd -m java -Xmx3072M -jar waves-all-0.15.4.jar waves-mainnet.conf`

#### Depois de iniciar o nó para voltar ao terminal digite `Ctrl-a` e `Ctrl-d`.

#### Para voltar a tela do screen onde iniciou o nó e ver o progresso do dele, use o comando:
`screen -x wavesd`

#### Para parar o nó use `Ctrl-c` e para voltar ao terminal use `Ctrl-a` e `Ctrl-d`.

#### Para visualizar os logs do nó ou seja os registros do que está acontecendo:
`nano waves/log/waves.log`

#### Todos os dados gerados pelo seu nó como: wallet, logs e o blockchain serão encontrados na pasta `$HOME/waves/`.

#### Para monitorar o uso de CPU e memoria do seu nó na sua VPS use o comando:
`htop`

### Depois que você baixar a versão mais recente do waves-lite-client.
`https://github.com/wavesplatform/WavesGUI/releases`

#### Para o pacote `.DEB` abra o arquivo de configuração:
`sudo nano /etc/waves/waves.conf` 

#### Para o pacote `.JAR` abra o arquivo de configuração:
`sudo nano waves-mainnet.conf` 

#### Você deve criar uma nova _senha_ assim como fez quando criou um [usuário para acessar a sua vps](#agora-vamos-adicionar-um-novo-usu%C3%A1rio-pra-evitar-usar-a-conta-raiz-root-pois-%C3%A9-muito-perigoso-escolha-uma-senha-muito-forte-sempre-algo-aleat%C3%B3rio-acima-de-16-caracteres-incluindo-letras-mai%C3%BAscula-e-minuscula-n%C3%BAmeros-e-s%C3%ADmbolos-ou-se-voc%C3%AA-achar-mais-comodo-gere-uma-seed-na-waves-wallet-e-use-ela-como-senha-vai-ser-ate-mais-seguro-pois-sera-uma-senha-aleat%C3%B3ria).

```
    # Password to protect wallet file
    password = "sua-senha-para-proteger-o-arquivo-de-carteira"
```

#### Você deve criar uma conta e ir na aba _backup_ para pegar a sua seed codificada em base58.
![](https://raw.githubusercontent.com/wavesone/wavesone.github.io/master/public/img/seedcodificadabase58.png)

#### Agora vamos inserir está _SEED_ codificada em base58 (se não for a seed codificada em base58 não vai funcionar), procure pela linha seguinte `# seed = "sua-seed-codificada-em-base58"`, descomentar a linha eliminando o caractere `# ` antes dela e coloque sua SEED codificada dentro das aspas.
```
    # Wallet seed as BASE58 string
    seed = "sua-seed-codificada-em-base58"
```

#### Atenção! A carteira é uma parte crítica do seu nó. Melhor criar seu arquivo em um local seguro e protegido. Não esqueça de fazer o backup do arquivo da sua carteira. É recomendado remover a SEED do arquivo de configuração imediatamente após o início do nó. Se um invasor obtiver acesso a essa sequência de descendência, ele terá acesso a todos os seus fundos em todos os seus endereços!

#### Usando o parâmetro `node-name` poderia ser usado para definir o nome do seu nó visível para outros participantes da rede P2P. Para habilitar o `node-name` basta descomentar o parâmetro `# node-name = "My MAINNET node"` (eliminar o caractere `#`) e alterar. 
```
    # Node name to send during handshake. Comment this string out to set random node name.
    node-name = "nome-do-meu-node"
```

#### Descomente a linha `# bind-address = "0.0.0.0"` eliminando o caractere `#` e em `0.0.0.0` você deve colocar o IP da sua VPS.
```
    # Network address
    bind-address = "0.0.0.0"
```

#### Usando o parâmetro `declared-address`, você pode definir o endereço IP externo e o número da porta do nó. É necessário para trabalhar por trás do NAT na maioria das instalações na nuvem, onde a máquina não faz interface direta com o endereço externo. Se você não especificá-lo, seu nó se conectará à rede P2P, mas não ouvirá as conexões de entrada para que outros  consigam se conectar. Outros nós estarão conectando ao seu nó usando esses dados.

#### Descomentar a linha `# declared-address = "1.2.3.4:6868"` eliminando o caractere `#` e em `1.2.3.4` você deve colocar o IP da sua VPS.
```
    # String with IP address and port to send as external address during handshake. Could be set automatically if uPnP is enabled.
    declared-address = "1.2.3.4:6868"
```

### Só falta iniciar o nó e esperar ele sincronizar toda a blockchain, que demora em media 8 horas (mas isso depende muito da sua VPS, internet, memoria e processamento melhor podem tornar a sincronização mais rápida).

### Agora você precisa configurar a REST API do nó, ou seja uma interface para executar chamadas RPC no nó.

#### Atenção! Para melhor segurança, não altere `bind-address = "127.0.0.1"`se você não sabe o que está fazendo! Para acesso externo, você deve usar o módulo proxy_pass do Nginx ou o encaminhamento de porta SSH (no no tutorial usarei encaminhamento de porta SSH).

#### Antes de ativar a REST API, na configuração do nó devemos realizar alguns procedimentos antes.

#### Para habilitar a REST API mude o parâmetro `no` para `yes`.
```
    # Enable/disable node's REST API
    enable = no
```

##### Reinicie o nó para aplicar as mudanças.

#### Agora vamos fazer uma conexão SSH no seu nó mas com um redirecionamento da REST API para a sua maquina local, assim você pode criar um novo hash com segurança, pois a conexão da sua maquina com o nó está sendo toda criptografada.

#### No seu computador pessoal abra o terminal e digite:
`ssh seu_nome_de_usuario@ip_da_sua_vps -L 6869:localhost:6869`

#### Agora vamos configurar o parâmetro `api-key-hash`  para definir o hash da sua chave de API. A chave da API é usada para proteger as chamadas de métodos críticos da API. Procure por:
```
    # Hash of API key string
    api-key-hash = "H6nsiifwYKYEx6YzYD7woP1XCn72RVvx6tC1zjjLXqsu"
```

#### Para configurar um novo api-key-hash, abra no navegador do seu computador o endereço:
[http://localhost:6869](http://localhost:6869)

#### Para criar um novo api-key-hash voce precisa criar uma nova senha assim como fez quando criou um [usuário para acessar a sua vps](#agora-vamos-adicionar-um-novo-usu%C3%A1rio-pra-evitar-usar-a-conta-raiz-root-pois-%C3%A9-muito-perigoso-escolha-uma-senha-muito-forte-sempre-algo-aleat%C3%B3rio-acima-de-16-caracteres-incluindo-letras-mai%C3%BAscula-e-minuscula-n%C3%BAmeros-e-s%C3%ADmbolos-ou-se-voc%C3%AA-achar-mais-comodo-gere-uma-seed-na-waves-wallet-e-use-ela-como-senha-vai-ser-ate-mais-seguro-pois-sera-uma-senha-aleat%C3%B3ria)
#### Insira o `api-key-hash` atual que é `H6nsiifwYKYEx6YzYD7woP1XCn72RVvx6tC1zjjLXqsu` no campo em branco e clique em `Explore`, Procure a sessao `utils` parâmetro `hash/secure` no campo `message`, coloque sua senha e clique no botão `Try it out!` para obter o hash da sua senha.
![](//raw.githubusercontent.com/wavesone/wavesone.github.io/master/public/img/apikeyhash.png)

#### Troque o hash que está na configuração do nó pelo o hash que você acabou de gerar.
```
    # Hash of API key string
    api-key-hash = "hash-gerado-baseado-na-sua-senha"
```

##### Depois de realizar o procedimento, reinicie seu nó e veja se ele inicia sem erros.

#### Se você não for fazer nada que precise realizar chamadas RPC no seu nó a REST API pode ser desativada.
#### Exemplo de uma chama RPC:
`curl -X GET --header 'Accept: application/json' --header 'X-API-Key: H6nsiifwYKYEx6YzYD7woP1XCn72RVvx6tC1zjjLXqsu' 'http://localhost:6869/activation/status'`

#### Lembre-se de que nesse parâmetro você deve fornecer o hash da chave da API, mas durante as chamadas REST você deve fornecer a própria chave da API.

#### Como sabemos algumas funcionalidades são implementadas na waves através de algumas votações, e isso você faz adicionando os números das funcionalidades no parâmetro de votação na configuração do nó.
```
  features {
    supported = []
  }
```

#### Dentro do `[ ]` você deve colocar os números das funcionalidades que deseja habilitar separados por virgula, veja o exemplo do modelo abaixo:
```
  features {
    supported = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  }
```

#### Reinicie o nó para aplicar as mudanças

### Depois que o nó estiver 100% sincronizado vamos configurar um firewall básico para proteger seu servidor VPS.

#### Verifique as regras que estão ativas no momento.
`sudo iptables -L`

### Para simplificar a configuração do firewall use esse script para automatizar o procedimento.

#### Baixe e execute o script
`wget https://raw.githubusercontent.com/wavesone/wavesone.github.io/master/public/sh/iptables-conf.sh`

`chmod +x iptables-conf.sh`

`sudo ./iptables-conf.sh`

#### Verifique novamente se as novas regras estão ativadas.
`sudo iptables -L`

#### Se tudo ocorreu bem basta tornar as regras permanentes.
`sudo iptables-save > /etc/iptables/rules.v4`

## Pronto seu nó está configurado e seguro e pronto para gerar blocos.

### Só mais algumas dicas.

#### Atualizando o nó para a versão mais recente no Linux

#### Primeiro de tudo, você precisa verificar o último lançamento do Waves. e escolha a versão mais recente da Mainnet.

1. #### Faça o download do arquivo .DEB 
`wget https://github.com/wavesplatform/Waves/releases/download/X.Y.Z/waves_X.Y.Z_all.deb`

2. #### Pare o Nó executando o seguinte comando:
`sudo systemctl stop waves`

3. #### Depois de parar o nó, execute o seguinte comando para exportar blocos existentes para um arquivo binário:
`sudo -u waves exporter /etc/waves/waves.conf /usr/share/waves/mainnet`

4. #### Remova a pasta de dados:
`sudo rm -rdf /var/lib/waves/data`

5. #### Instale a nova versão do nó:
`sudo dpkg -i waves_X.Y.Z_all.deb`

6. #### Importe blocos do arquivo binário:
`sudo -u waves importer /etc/waves/waves.conf /usr/share/waves/mainnet-[some height]`

7. #### Após a importação, inicie o nó:
`sudo systemctl start waves`

8. #### Não se esqueça de remover arquivos blockchain binários se você não precisar deles mais:
`sudo rm -rf /usr/share/waves/mainnet-alturadoblocosalvo`


#### Aqui você pode verificar como está a saúde do seu nó olhando o site:
[http://dev.pywaves.org](http://dev.pywaves.org)

#### Aqui você vera a lista de nós, e pode verificar a saúde deles, se estão sincronizando corretamente, se tem alguma bifurcação, se a porta p2p está aberta ou matcher está habilitado.
[http://dev.pywaves.org/nodes](http://dev.pywaves.org/nodes)

#### Aqui você pode ver os principais geradores de blocos e outras opções como a performance de geração de blocos, saldo de cada pool, recompensas ganhas, quantos blocos cada um gerou e etc...
[http://dev.pywaves.org/generators-monthly](http://dev.pywaves.org/generators-monthly)

#### Aqui você pode ver as pools que estão ativas tentando gerar blocos, o saldo de cada uma, leasers e quantidade de waves alocada por eles para as pools e etc...
[http://dev.pywaves.org/lpos](http://dev.pywaves.org/lpos)

#### Aqui você pode ver o que está sendo ativado na rede ou o que está em votação para ativação.
[http://dev.pywaves.org/activation](http://dev.pywaves.org/activation)


## Se você seguiu todos os passos certamente não teve problemas ou duvidas, mas se tiver algum problema ou duvida não exite em perguntar.
* * *

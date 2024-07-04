# QuickClassEval
### Project designed for Practicing TDD (Test-Driven Development) and BDD (Behavior-Driven Development)

## Description
QuickClassEval is a management program that enables students to evaluate their past and current classes using forms generated by their department coordinators. It is designed to streamline the process of collecting and analyzing student feedback to enhance the quality of education.

## Configuração de Ambiente Guiada - Debian-Based OS
Este guia fornece as instruções necessárias para configurar o ambiente de desenvolvimento para o projeto, incluindo a instalação das versões apropriadas de Ruby e Rails e suas dependências.

### Ruby - Dependências:
Será necessário ter o Ruby instalado na versão: ruby "3.1.2".

Primeiramente:
#### Atualize a lista de pacotes:
    sudo apt-get update

#### Instale as seguintes dependências:
    cd
    git clone https://github.com/excid3/asdf.git ~/.asdf
    echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
    echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
    echo 'legacy_version_file = yes' >> ~/.asdfrc
    echo 'export EDITOR="code --wait"' >> ~/.bashrc
    exec $SHELL

#### Adicione os seguintes Plugins:
    asdf plugin add ruby
    asdf plugin add nodejs

#### Instale a versão do Ruby necessária:
    asdf install ruby 3.1.2
    asdf global ruby 3.1.2

#### Atualize suas gems:
    gem update --system

#### Confirme a instalação:
    which ruby
    ruby -v

Após esses passos, você deve ver algo como:
#### Verificação da instalação:
    /usr/bin/ruby
    ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux-gnu]

Caso contrário, recomendo verificar o log de erros e ler a documentação oficial da linguagem.

### Rails - Dependências:
Já para instalar o Rails na versão 7.1.3.4, execute o seguinte comando:

#### Instale a versão do Rails:
    gem install rails -v 7.1.3.4

#### Confirme a instalação:
    rails -v

Após esses passos, você deve ver algo como:
#### Verificação da instalação:
    Rails 7.1.3.4

Caso contrário, recomendo depuração do log de erros e leitura da documentação oficial do framework.

Com isso, tendo todos os passos funcionado corretamente, o seu ambiente de desenvolvimento está pronto para iniciar a configuração do projeto.

## Configuração das Gems:
Após clonar o repositório do sistema, navegue até a raiz do diretório e rode o comando:

### Instalar as gems do projeto:
    bundle install

Você verá um log de instalação seguido de um resumo das gems instaladas.

## Configuração do banco de dados:
Após a correta instalação das gems. Iremos fazer as migrações para a criação do Banco de Dados.

#### Comando Rails para Criação do banco de dados:
    Rails db:migrate

Você verá uma série de mensagens sobre a criação das tabelas e relacionamentos.

Com isso, você está pronto para povoar o Banco de Dados com as informações mínimas para o sitema funcionar. Isto deve ser feito com:
#### Comando Rails para Preencher o banco de dados:
    Rails db:seed

Sempre que quiser voltar para a versão inicial do sistema, rode o comando:
#### Comando Rails para reiniciar o Banco de Dados:
    Rails db:reset

Após isso, você poderá rodar o projeto com comando:
#### Comando para iniciar o projeto:
    Rails server

Caso tenha seguido à risca todos os passos supracitados, você verá o servidor rodando na porta:
#### URL local do sistema:    
    http://127.0.0.1:3000

E terá um usuário administrador cadastrado:
#### Usuário Administrador:
    Login: coordenador@gmail.com
    Senha: TOKEN_587

Assim, você estará pronto para testar a aplicação.

OBS: Esses são os usuários que você irá conseguir cadastrar no sistema após importar os dados e enviar o email de cadastro:
#### Usuários do sistema cadastráveis:
    [
    {
        "email": "teste@gmail.com"
    },
    {
        "email": "vanessa@gmail.com"
    },
    {
        "email": "bubu@gmail.com"
    },
    {
        "email": "vini@gmail.com"
    },
    {
        "email": "leo@gmail.com"
    },
    {
        "email": "fer@gmail.com"
    }
]

Todos possuem a mesma chave de cadastro: TOKEN_587

## Testes
Para executar o cucumber, basta rodar
### cucumber
    cucumber features

Para rodar os testes em Rspec, execute o comando:
### Rspec
    sudo rspec  
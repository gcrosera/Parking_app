Como Rodar o Projeto
Backend:

1. Requisitos: Java 11+, Maven, Banco de Dados H2 ou DB2.
2. Passos:
    - Clone o repositório.
    - Abra o projeto na IDE
    - Rode a classe parkingSearchApplication em: 
Parking_app-main\parking_search\src\main\java\br\com\challenge\parkingSearch
   - Tornar o Backend visível para o Frontend usando o LocalTunnel, Instale o Localtunnel globalmente (exige o NodeJS).
   - Abra o CMD, digite "lt --port 8080". Após o link ser gerado, abra-o no navegador, abaixo conseguirá obserar outro link em azul, basta clicar nele e copiar a senha que vai estar na página, volte a página anterior e cole no campo password. e clique no botão "Click to submit". Após esses passos o nosso backend estará visível.
Agora basta copiar o link da pagina que apareceu o acesso negado.


Frontend:
1. Requisitos: Flutter SDK.
2. Passos:
    - Clone o repositório.
    - Instale as dependências com flutter pub get.
    - Com o link copiado entraremos no arquivo lib/components/ApiUrl e trocaremos o link da variável baseUrl, (excluindo a barra que virá ao final). Salve as alterações.
    - Agora basta abrir a classe main do projeto e selecionar o dispositivo que será usado para rodar a aplicação, funciona tanto para o Chrome quanto para o Emulador.
    - Rode a aplicação e usufrua da nossa solução!

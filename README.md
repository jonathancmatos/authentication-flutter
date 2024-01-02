#  Flutter Authentication

## Descrição

Este projeto é uma aplicação de estudo que demonstra implementações avançadas de autenticação, incluindo JWT (JSON Web Token), login social e autenticação por biometria. Ele oferece uma base sólida para o desenvolvimento de aplicativos seguros e modernos, incorporando práticas recomendadas para autenticação em plataformas móveis.

## Funcionalidades Principais

1. **Autenticação com JWT:** Utiliza tokens JWT para autenticação, garantindo a segurança e a integridade das comunicações entre o cliente e o servidor.

2. **Login Social:** Permite aos usuários realizar o login através de provedores de autenticação social populares, como Google, Facebook ou Twitter. Isso proporciona uma experiência de login simplificada e amplia as opções de acesso.

3. **Autenticação por Biometria:** Integra funcionalidades de autenticação biométrica (por exemplo, leitor de impressão digital ou reconhecimento facial) para oferecer uma camada adicional de segurança e conveniência aos usuários.

## Pré-requisitos

Antes de começar a utilizar este projeto, certifique-se de ter o Flutter e o Dart instalados em sua máquina. Além disso, configure as credenciais necessárias para os provedores de autenticação social (Google, Facebook, Twitter) conforme documentação específica.

#### Atenção: E necessário ter uma API que suporte autenticação com JWT.
Exemplo de API para Autenticação com JWT:

- [API Exemplo JWT](https://github.com/jonathancmatos/api-tokenization-php): Uma API básica em PHP para autenticação com JWT. Certifique-se de ajustar conforme necessário para refletir a estrutura e os requisitos específicos da sua API.

## Configuração

1. **Clone este repositório:**

    ```bash
    git clone https://github.com/jonathancmatos/authentication-flutter.git
    cd authentication-flutter
    ```

2. **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3. **Configuração dos Provedores de Autenticação Social:**

    - Siga as instruções da documentação do Flutter para configurar as credenciais de autenticação social. Geralmente, isso envolve a criação de projetos nas plataformas correspondentes e a obtenção de chaves de API.

4. **Execução do Projeto:**

    ```bash
    flutter run
    ```

## Uso

1. Abra o aplicativo no emulador ou em um dispositivo físico.

2. Explore as diferentes opções de autenticação disponíveis, incluindo login com JWT, autenticação social e autenticação por biometria.

3. Integre e adapte o código conforme necessário para atender às necessidades específicas do seu projeto.


## Demonstração

https://github.com/jonathancmatos/authentication-flutter/assets/37823427/8fbc0c53-1978-4409-9882-05c951293138


## Licença

Este projeto é distribuído sob a licença [MIT](LICENSE).



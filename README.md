# Desafio Técnico - mLabs

**Autor**: Pedro Rodrigues Pereira

## 📋 1. Descrição

Este projeto é uma API de gerenciamento de estacionamento que permite registrar a entrada e saída de veículos, realizar pagamentos de reservas e consultar o histórico de reservas de um veículo. A API foi desenvolvida utilizando Node.js e Express, e segue as melhores práticas de desenvolvimento de APIs RESTful.

## 🚀 2. Funcionalidades

- **Registro de Entrada**: Permite registrar a entrada de um veículo no estacionamento.
- **Pagamento de Reserva**: Permite realizar o pagamento de uma reserva de estacionamento.
- **Registro de Saída**: Permite registrar a saída de um veículo do estacionamento.
- **Consulta de Histórico**: Permite consultar o histórico de reservas de um veículo através de sua placa.

## ⚙ 3. Como rodar o projeto

### 3.1 Pré-requisitos

- [Ruby](https://www.ruby-lang.org/en/) 3.0+
- [Rails](https://rubyonrails.org/) 7.0+
- [Docker](https://www.docker.com/) (Opcional)

### 3.2 Instalação

* Primeiro é necessário instalar o Rails Blundler, para isso utilize o gem:
```bash
$ gem install blunder 
```

* Após possuir o blunder e o repositório baixado, podemos executar os seguintes comandos:
```bash
$ cd parking-api/
$ bundle install
```

### 3.3 Rodando o projeto
* Com a instalação de dependências finalizada, podemos rodar o servidor de desenvolvimento através do Rails:
```bash
$ rails server
```

## 🌐 4. Endpoints

### 4.1 Autenticação
Endepoints de Autenticação para uso da API.

#### POST /register

* **Descrição**: Registra um novo usuário
* **Body**:
    ```json
    {
        "username": "testuser",
        "password": "testpass"
    }
    ```
* **Validações**:
    - `username`: Obrigatório, deve ser único, mínimo de 3 caracteres.
    - `password`: Obrigatório, mínimo de 6 caracteres.

* **cURL**:
    ```bash
    curl --request POST \
        --url http://localhost:3000/register \
        --header 'Content-Type: application/json' \
        --data '{
            "username": "testuser",
            "password": "testpass"
        }'
    ```

#### POST /login

* **Descrição**: Realiza login de um usuário e retorna um token de autentição válido por 24 horas.
* **Body**:
    ```json
    {
        "username": "testuser",
        "password": "testpass"
    }
    ```
* **Validações**:
    - `username`: Obrigatório.
    - `password`: Obrigatório.

* **cURL**:
    ```bash
    curl --request POST \
        --url http://localhost:3000/login \
        --header 'Content-Type: application/json' \
        --data '{
            "username": "testuser",
            "password": "testpass"
        }'
    ```

### 4.2 Parking API

#### POST /parking

* **Descrição**: Registra a entrada de um veículo no estacionamento.
* **Body**:
    ```json
    {
        "plate": "ABC-1234"
    }
    ```
* **Validações**:
    - `plate`: Obrigatório, deve seguir o formato de placa de veículo (ex: ABC-1234).

* **cURL**:
    ```bash
    curl --request POST \
        --url http://localhost:3000/parking \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Bearer <your_token>' \
        --data '{
            "plate": "ABC-1234"
        }'
    ```

#### PUT /parking/:id/pay

* **Descrição**: Realiza o pagamento de uma reserva de estacionamento.
* **Validações**:
    - `id`: Obrigatório, deve ser um ID de reserva válido.

* **cURL**:
    ```bash
    curl --request PUT \
        --url http://localhost:3000/parking/<reservation_id>/pay \
        --header 'Authorization: Bearer <your_token>'
    ```

#### PUT /parking/:id/out

* **Descrição**: Registra a saída de um veículo do estacionamento.
* **Validações**:
    - `id`: Obrigatório, deve ser um ID de reserva válido.

* **cURL**:
    ```bash
    curl --request PUT \
        --url http://localhost:3000/parking/<reservation_id>/out \
        --header 'Authorization: Bearer <your_token>'
    ```

#### GET /parking/:plate

* **Descrição**: Consulta o histórico de reservas de um veículo através de sua placa.
* **Validações**:
    - `plate`: Obrigatório, deve seguir o formato de placa de veículo (ex: ABC-1234).

* **cURL**:
    ```bash
    curl --request GET \
        --url http://localhost:3000/parking/ABC-1234 \
        --header 'Authorization: Bearer <your_token>'
    ```

## 📝 5. Licença
Esse projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

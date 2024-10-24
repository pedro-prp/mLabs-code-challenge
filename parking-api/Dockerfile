# Use a imagem oficial do Ruby
FROM ruby:3.2.5

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Crie e defina o diretório de trabalho na imagem
WORKDIR /app

# Copie o Gemfile e o Gemfile.lock para instalar as dependências primeiro (cache eficiente)
COPY Gemfile Gemfile.lock ./

# Instale as gems
RUN bundle install

# Copie o restante do código do projeto para dentro do container
COPY . .

# Precompile os assets (caso haja) e prepare o ambiente
RUN bundle exec rails db:migrate

# Expõe a porta do servidor Rails
EXPOSE 3000

# Comando para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]

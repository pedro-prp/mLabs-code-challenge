class User < ApplicationRecord
  has_secure_password

  validates :username, presence: { message: "O campo username não pode ser vazio" }, uniqueness: { message: "Nome de usuário já existente. Por favor escolha outro" }
  validates :password, presence: { message: "O campo password não pode ser vazio" }
end

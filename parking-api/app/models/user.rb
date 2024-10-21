class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: {message: "Nome de usuário já existente. Por favor escolha outro"}

end

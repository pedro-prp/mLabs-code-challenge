class AuthController < ApplicationController
  def login
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = encode_token(user.id)

      render json: { token: token, message: "Login realizado com sucesso. Token válido por 24 horas" }, status: :ok
    else
      render json: { error: "Nome de usuário ou senha incorretos" }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)

    if user.save
      render json: { message: "Seu usuário foi criado com sucesso" }, status: :created
    else
      errors = user.errors.messages
      formatted_errors = errors.transform_keys(&:to_s)
      render json: { errors: formatted_errors }, status: :unprocessable_entity
    end
  end

  private

  def encode_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end

  def user_params
    params.permit(:username, :password)
  end
end


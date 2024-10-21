class ApplicationController < ActionController::API
  def hello
    render json: { message: 'Hello, World!' }
  end

  def authorize_request
    @current_user = User.find_by(id: decoded_token["user_id"]) if decoded_token
    unless @current_user
      render json: { error: "Usuário não autorizado. Verifique seu token" }, status: :unauthorized
    end
  end

  private

  def decoded_token
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ")[1]

      begin
        decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
        return decoded_token
      rescue JWT::DecodeError
        return nil
      end
    end
  end
end

class ApplicationController < ActionController::API
  def hello
    render json: { message: 'Hello, World!' }
  end

  def authorize_request
    @current_user = User.find(decoded_token[:user_id]) if decoded_token
    render json: { "error": "Usuário não autorizado. Verifique seu token"}, status: :unauthorized unless @current_user
  end


  private

  def decoded_token
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ")[1]

      begin
        decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]

        puts decoded_token
        
        return decoded_token
      
      rescue JWT::DecodeError
        return nil
      end
    end
  end

end

require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest

  setup do
    @right_user = users(:right_user)
    @wrong_user = users(:wrong_user)

    @register_params = { username: "test-user", password: "testpass" }
    @register_already_params = { username: @right_user.username, password: @right_user.password }
    @register_blank_pass_params = { username: "test-blank-pass", password: "" }
    @register_blank_user_params = { username: "", password: "test-blank-user" }
  end

  test "Should create a user" do
    post register_url, params: @register_params

    assert_response :created

    response_body = JSON.parse(@response.body)

    assert_includes response_body["message"], "Seu usuário foi criado com sucesso"
  end

  test "Should not create user with already taken username" do
    post register_url, params: @register_already_params

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    assert_includes response_body["errors"]["username"].first, "Nome de usuário já existente. Por favor escolha outro"
  end

  test "Should not create a user with blank password" do
    post register_url, params: @register_blank_pass_params
    
    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    puts response_body

    assert_includes response_body["errors"]["password"], "O campo password não pode ser vazio"
  end

  test "Should not create a user with blank username" do
    post register_url, params: @register_blank_user_params

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    puts response_body

    assert_includes response_body["errors"]["username"], "O campo username não pode ser vazio"
  end
end

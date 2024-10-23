require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(username: "test-user", password: "test-password")
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @headers = { "Authorization": "Bearer #{@token}" }

    @right_parking_data = { plate: "ABC-1234" }
    @wrong_parking_data = { plate: "TESTWRONG" }

  end

  test "should create parking reservation" do
    assert_difference("Parking.count", 1) do
      post parking_index_url, params: { parking:  @right_parking_data}, headers: @headers 
    end

    assert_response :created
    response_body = JSON.parse(@response.body)

    assert_includes response_body['message'], "Entrada do veículo #{@right_parking_data[:plate]} registrada com sucesso"
    assert_equal response_body['reservation_number'], Parking.last.id
  end

  test "should not create parking with plate wrong format" do
    assert_difference("Parking.count", 0) do
      post parking_index_url, params: { parking: @wrong_parking_data }, headers: @headers
    end

    assert_response :unprocessable_entity
    response_body = JSON.parse(@response.body)

    assert_includes response_body['errors']['plate'].first, "Formato invalído para o campo plate. Utilize AAA-9999"

  end
end

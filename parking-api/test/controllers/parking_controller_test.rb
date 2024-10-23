require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(username: "test-user", password: "test-password")
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @headers = { "Authorization": "Bearer #{@token}" }

    @right_parking_data = { plate: "ABC-1234" }
    @wrong_parking_data = { plate: "TESTWRONG" }

    @no_payment_parking = parkings(:no_payment_parking)
    @paid_parking = parkings(:paid_parking)
    @paid_and_out_parking = parkings(:paid_and_out_parking)

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

  test "should create just a unique active parking" do

    unique_plate = "AAA-1234"

    assert_difference("Parking.count", 1) do
      post parking_index_url, params: { parking: { plate: unique_plate } }, headers: @headers
    end

    assert_difference("Parking.count", 0) do
      post parking_index_url, params: { parking: { plate: unique_plate }}, headers: @headers
    end

    assert_response :unprocessable_entity
    response_body  = JSON.parse(@response.body)

    assert_includes response_body['errors']['plate'].first, "Já existe um registro em aberto para a seguinte placa #{unique_plate}"
  end

  test "should pay a active parking" do
    put pay_parking_url(@no_payment_parking.id), headers: @headers

    assert_response :ok

    response_body = JSON.parse(@response.body)

    assert_includes response_body['message'], "Pagamento referente a reserva #{@no_payment_parking.id} realizado com sucesso"
  end

  test "should not pay a already paid parking" do
    put pay_parking_url(@paid_parking.id), headers: @headers

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    assert_includes response_body['message'], "O pagamento referente a reserva #{@paid_parking.id} já foi realizado"
  end

  test "should not found a valid reservation" do
    put pay_parking_url("12345"), headers: @headers

    assert_response :not_found

    response_body = JSON.parse(@response.body)

    assert_includes response_body['error'], "reserva não encontrada"
  end
end

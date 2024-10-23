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
    @history_parking_1 = parkings(:history_parking_1)
  end

  test "should create parking reservation" do
    assert_difference("Parking.count", 1) do
      post parking_index_url, params: { parking:  @right_parking_data }, headers: @headers
    end

    assert_response :created
    response_body = JSON.parse(@response.body)

    assert_includes response_body["message"], "Entrada do veículo #{@right_parking_data[:plate]} registrada com sucesso"
    assert_equal response_body["reservation_number"], Parking.last.id
  end

  test "should not create parking with plate wrong format" do
    assert_difference("Parking.count", 0) do
      post parking_index_url, params: { parking: @wrong_parking_data }, headers: @headers
    end

    assert_response :unprocessable_entity
    response_body = JSON.parse(@response.body)

    assert_includes response_body["errors"]["plate"].first, "Formato invalído para o campo plate. Utilize AAA-9999"
  end

  test "should create just a unique active parking" do
    unique_plate = @no_payment_parking.plate

    assert_difference("Parking.count", 0) do
      post parking_index_url, params: { parking: { plate: unique_plate } }, headers: @headers
    end

    assert_response :unprocessable_entity
    response_body  = JSON.parse(@response.body)

    assert_includes response_body["errors"]["plate"].first, "Já existe um registro em aberto para a seguinte placa #{unique_plate}"
  end

  test "should pay a active parking" do
    put pay_parking_url(@no_payment_parking.id), headers: @headers

    assert_response :ok

    response_body = JSON.parse(@response.body)

    assert_includes response_body["message"], "Pagamento referente a reserva #{@no_payment_parking.id} realizado com sucesso"
  end

  test "should not pay a already paid parking" do
    put pay_parking_url(@paid_parking.id), headers: @headers

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    assert_includes response_body["message"], "O pagamento referente a reserva #{@paid_parking.id} já foi realizado"
  end

  test "should not found a valid reservation in payment" do
    put pay_parking_url("12345"), headers: @headers

    assert_response :not_found

    response_body = JSON.parse(@response.body)

    assert_includes response_body["error"], "reserva não encontrada"
  end

  test "should set out to a parking" do
    put out_parking_url(@paid_parking.id), headers: @headers

    assert_response :ok

    response_body = JSON.parse(@response.body)

    assert_includes response_body["message"], "Saída referente a reserva #{@paid_parking.id} realizada com sucesso"
  end

  test "should not set out a already left parking" do
    put out_parking_url(@paid_and_out_parking.id), headers: @headers

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    assert_includes response_body["error"], "A saída referente a reserva #{@paid_and_out_parking.id} já foi realizada"
  end

  test "should not set out a not paid parking" do
    put out_parking_url(@no_payment_parking.id), headers: @headers

    assert_response :unprocessable_entity

    response_body = JSON.parse(@response.body)

    assert_includes response_body["error"], "Saída não registrada. Pagamento da reserva #{@no_payment_parking.id} se encontra pendente"
  end

  test "should not found a reservation in out process" do
    put out_parking_url("12345"), headers: @headers

    assert_response :not_found

    response_body = JSON.parse(@response.body)

    assert_includes response_body["error"], "reserva não encontrada"
  end

  test "should get a history of plate" do
    history_parking_url = "/parking/#{@history_parking_1.plate}"

    get history_parking_url, headers: @headers

    assert_response :ok

    response_body = JSON.parse(@response.body)

    assert_equal response_body.length, 2
    assert_includes response_body.map { |parking| parking["id"] }, @history_parking_1.id
  end

  test "should not found a plate in history" do
    history_parking_url = "/parking/TES7123"

    get history_parking_url, headers: @headers

    assert_response :not_found

    response_body = JSON.parse(@response.body)

    assert_includes response_body["error"], "Não foi encontrado nenhum registro para a seguinte placa: TES7123."
  end

  test "should check response keys format" do
    history_parking_url = "/parking/#{@history_parking_1.plate}"

    get history_parking_url, headers: @headers

    response_body = JSON.parse(@response.body)

    expected_keys = [ "id", "left", "paid", "time" ]

    assert_equal expected_keys.sort, response_body.first.keys.sort
  end
end

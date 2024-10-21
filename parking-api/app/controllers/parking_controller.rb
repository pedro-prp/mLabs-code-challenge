class ParkingController < ApplicationController
  # POST /parking
  def create
    parking = Parking.new(parking_params)

    parking.in_time = Time.now
    parking.has_left = false
    parking.paid = false

    if parking.save
      render json: {reservation_number: parking.id, in_time: parking.in_time, message: "Entrada do veículo #{parking.plate} registrada com sucesso"}, status: :created 
    else
      errors = parking.errors.messages
      formatted_errors = errors.transform_keys(&:to_s)
      render json: {errors: formatted_errors}, status: :unprocessable_entity
    end
  end

  # PUT /parking/:id/pay
  def pay
    begin
      parking = Parking.find(params[:id])

      if parking.paid
        render json: {message: "O pagamento referente a reserva #{parking.id} já foi realizado"}, status: :unprocessable_entity
      else
        elapsed_time = calculate_elapsed_time(parking)
        minute_rate = 0.30
        payment_price = calculate_payment_price(elapsed_time, minute_rate)

        parking.update(paid: true, elapsed_time: elapsed_time, payment_price: payment_price) 

        render json: {elapsed_time: elapsed_time, payment_price: payment_price, message: "Pagamento referente a reserva #{parking.id} realizado com sucesso"}, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "reserva não encontrada"}, status: :not_found
    end
  end


  private

  def parking_params
    params.require(:parking).permit(:plate)
  end

  def calculate_elapsed_time(parking)
    elapsed_time = (Time.now - parking.in_time)
    elapsed_time = (elapsed_time / 60).to_i

    return elapsed_time
  end

  # Calcula o valor do pagamento de acordo com o tempo de permanência
  def calculate_payment_price(elapsed_time, minute_rate)
    case elapsed_time
    when 0..15
      return 10.00
    when 16..59
      return elapsed_time * minute_rate
    else
      return elapsed_time * (minute/2)
    end
  end

end
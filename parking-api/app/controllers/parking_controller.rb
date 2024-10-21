class ParkingController < ApplicationController
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

  def pay
    parking = Parking.find(params[:id])

    if parking.paid
      render json: {message: "O pagamento referente a reserva #{parking.id} já foi realizado"}, status: :unprocessable_entity
    else
      elapsed_time = calculate_elapsed_time(parking)
      parking.update(paid: true, elapsed_time: elapsed_time) 

      render json: {elapsed_time: elapsed_time, message: "Pagamento referente a reserva #{parking.id} realizado com sucesso"}, status: :ok
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

end
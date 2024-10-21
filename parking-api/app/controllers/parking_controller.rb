class ParkingController < ApplicationController
  def create
    parking = Parking.new(parking_params)

    parking.in_time = Time.now
    parking.has_left = false
    parking.paid = false

    if parking.save
      render json: {id: parking.id, in_time: parking.in_time, message: "Entrada do veículo #{parking.plate} registrada com sucesso"}, status: :created 
    else
      errors = parking.errors.messages
      formatted_errors = errors.transform_keys(&:to_s)
      render json: {errors: formatted_errors}, status: :unprocessable_entity
    end
  end

  private
  def parking_params
    params.require(:parking).permit(:plate)
  end

end
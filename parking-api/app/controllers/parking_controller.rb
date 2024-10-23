class ParkingController < ApplicationController
  before_action :authorize_request

  # POST /parking
  def create
    parking = Parking.new(parking_params)

    parking.in_time = Time.now
    parking.has_left = false
    parking.paid = false

    if parking.save
      render json: { reservation_number: parking.id, in_time: parking.in_time, message: "Entrada do veículo #{parking.plate} registrada com sucesso" }, status: :created
    else
      errors = parking.errors.messages
      formatted_errors = errors.transform_keys(&:to_s)
      render json: { errors: formatted_errors }, status: :unprocessable_entity
    end
  end

  # PUT /parking/:id/pay
  def pay
    begin
      parking = Parking.find(params[:id])

      if parking.paid
        render json: { message: "O pagamento referente a reserva #{parking.id} já foi realizado" }, status: :unprocessable_entity
      else
        minute_rate = 0.30

        elapsed_time = calculate_elapsed_time(parking)
        payment_price = calculate_payment_price(elapsed_time, minute_rate)

        parking.update(paid: true, elapsed_time: elapsed_time, payment_price: payment_price)

        render json: { elapsed_time: elapsed_time, payment_price: payment_price, message: "Pagamento referente a reserva #{parking.id} realizado com sucesso" }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "reserva não encontrada" }, status: :not_found
    end
  end

  # PUT /parking/:id/out
  def out
    begin
      parking = Parking.find(params[:id])

      if !parking.paid
        return render json: { error: "Saída não registrada. Pagamento da reserva #{parking.id} se encontra pendente" }, status: :unprocessable_entity
      end

      if parking.has_left
        return render json: { error: "A saída referente a reserva #{parking.id} já foi realizada" }, status: :unprocessable_entity
      end

      out_time = Time.now

      if parking.update(has_left: true, out_time: out_time)
        render json: { message: "Saída referente a reserva #{parking.id} realizada com sucesso", reservation_number: parking.id, out_time: out_time }, status: :ok
      else
        render json: { error: "Erro ao processar saída da reserva #{parking.id}" }
      end


    rescue ActiveRecord::RecordNotFound
      render json: { error: "reserva não encontrada" }, status: :not_found
    end
  end

  # GET /parking/:plate
  def history
    plate = params[:plate].upcase

    parkings = Parking.where(plate: plate)

    if parkings.any?
      render json: parkings.map { |parking| format_history_object(parking) }
    else
      render json: { error: "Não foi encontrado nenhum registro para a seguinte placa: #{plate}." }
    end
  end

  private

  def parking_params
    params.require(:parking).permit(:plate)
  end

  # Calcula o tempo de permanência do veículo
  def calculate_elapsed_time(parking)
    elapsed_time = (Time.now - parking.in_time)
    elapsed_time = (elapsed_time / 60).to_i

    elapsed_time
  end

  # Calcula o valor do pagamento de acordo com o tempo de permanência
  def calculate_payment_price(elapsed_time, minute_rate)
    case elapsed_time
    when 0..15
      10.00
    when 16..59
      elapsed_time * minute_rate
    else
      elapsed_time * (minute_rate/2)
    end
  end

  # Formata saída do histórico de reservas
  def format_history_object(parking)
    {
      id: parking.id,
      time: "#{parking.elapsed_time} minutes",
      paid: parking.paid,
      left: parking.has_left
    }
  end
end

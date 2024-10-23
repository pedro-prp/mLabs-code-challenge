class Parking < ApplicationRecord
  validates :plate, presence: true, format: { with: /\A[A-Z]{3}-\d{4}\z/, message: "Formato invalído para o campo plate. Utilize AAA-9999" }

  validate :unique_plate_in_parking, on: :create

  def unique_plate_in_parking
    if Parking.where(plate: plate, has_left: false).exists?
      errors.add(:plate, "Já existe um registro em aberto para a seguinte placa #{plate}")
    end
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
end

class Parking < ApplicationRecord
  validates :plate, presence: true, format: { with: /\A[A-Z]{3}-\d{4}\z/, message: 'Formato invalído para o campo plate. Utilize AAA-9999' }

  validate :unique_plate_in_parking, on: :create

  def unique_plate_in_parking
    if Parking.where(plate: plate, has_left: false).exists?
      errors.add(:plate, "Já existe um registro em aberto para a seguinte placa #{plate}")
    end
  end
end

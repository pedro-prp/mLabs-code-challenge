class Parking < ApplicationRecord
  validates :plate, presence: true, format: { with: /\A[A-Z]{3}-\d{4}\z/, message: 'Formato invalído para o campo plate. Utilize AAA-9999' }
end

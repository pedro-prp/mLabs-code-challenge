class AddPaymentPriceToParking < ActiveRecord::Migration[7.2]
  def change
    add_column :parkings, :payment_price, :decimal
  end
end

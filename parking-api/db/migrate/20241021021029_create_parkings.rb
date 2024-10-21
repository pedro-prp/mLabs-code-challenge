class CreateParkings < ActiveRecord::Migration[7.2]
  def change
    create_table :parkings do |t|
      t.string :plate
      t.boolean :paid
      t.boolean :left
      t.datetime :in_time
      t.datetime :out_time

      t.timestamps
    end
  end
end

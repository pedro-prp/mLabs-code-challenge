class AddElapsedTimeToParkings < ActiveRecord::Migration[7.2]
  def change
    add_column :parkings, :elapsed_time, :integer
  end
end

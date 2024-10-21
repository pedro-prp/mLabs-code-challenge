class RenameFieldLeftParking < ActiveRecord::Migration[7.2]
  def change
    rename_column :parkings, :left, :has_left
  end
end

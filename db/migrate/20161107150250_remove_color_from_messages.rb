class RemoveColorFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :color
  end
end

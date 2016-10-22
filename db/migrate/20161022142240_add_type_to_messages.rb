class AddTypeToMessages < ActiveRecord::Migration[5.0]
  def change
  	add_column :messages, :chat_type, :string
  end
end

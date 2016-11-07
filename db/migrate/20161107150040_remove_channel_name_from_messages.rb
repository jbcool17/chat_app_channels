class RemoveChannelNameFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :channel_name
  end
end

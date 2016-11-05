class ChangeChatTypeToChannelName < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :chat_type, :channel_name
  end
end

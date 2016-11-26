module App
  class Chat

    def self.write_data(time, message, user_id, channel_id)
      Message.create date: time,
                      message: message,
                      user_id: user_id,
                      channel_id: channel_id
    end

  end
end

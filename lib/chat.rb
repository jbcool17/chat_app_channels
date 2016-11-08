module App
  class Chat

    def self.write_data(time, message, user_id, channel_id)
      Message.create date: time,
                      message: message,
                      user_id: user_id,
                      channel_id: channel_id
    end

    def self.get_color
      @colors = User.colors
      color = '#%06x' % (rand * 0xffffff)

      while ((@colors.include?(color)) || (color.scan(/\d/).map(&:to_i).min < 5) ) do
        color = '#%06x' % (rand * 0xffffff)
      end

      color
    end

  end
end

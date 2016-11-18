module App
  class Chat

    def self.write_data(time, message, user_id, channel_id)
      Message.create date: time,
                      message: message,
                      user_id: user_id,
                      channel_id: channel_id
    end

    def self.get_color
      color = '#%06x' % (rand * 0xffffff)
      min_color_num = color.scan(/\d/).map(&:to_i).min || 0

      while ( User.colors.include?(color) ||  min_color_num < 4 ) do
        color = '#%06x' % (rand * 0xffffff)
        min_color_num = color.scan(/\d/).map(&:to_i).min || 0
      end

      color
    end

  end
end

module App
  class Chat

    def self.write_data(time, user, message, color='#D3D3D3', channel_name)
      Message.create date: time,
                      user: user,
                      message: message,
                      color: color,
                      channel_name: channel_name
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

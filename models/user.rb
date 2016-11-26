class User < ActiveRecord::Base
  has_many :messages
  has_many :channels, through: :messages

  before_create :get_color

  def self.colors
    User.all.collect { |u| u.color }
  end

  private

  def get_color
    color = '#%06x' % (rand * 0xffffff)
    min_color_num = color.scan(/\d/).map(&:to_i).min || 0

    while ( User.colors.include?(color) ||  min_color_num < 5 ) do
      color = '#%06x' % (rand * 0xffffff)
      min_color_num = color.scan(/\d/).map(&:to_i).min || 0
    end

    self.color = color
  end
end

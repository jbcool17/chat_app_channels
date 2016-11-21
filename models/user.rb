class User < ActiveRecord::Base
  has_many :messages
  has_many :channels, through: :messages

  # validates :color, uniqueness: true

  def self.colors
    User.all.collect { |u| u.color }
  end
end

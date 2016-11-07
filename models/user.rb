class User < ActiveRecord::Base
  has_many :messages

  # validates :name, presence: true
  validates :color, uniqueness: true

  def self.colors
    User.all.collect { |u| u.color }
  end
end

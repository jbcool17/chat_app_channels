class Channel < ActiveRecord::Base
  has_many :messages

  validates :name, uniqueness: true

  def self.get_messages_for_channel(name)
    messages = Channel.find_by(name: name).messages

    messages.map { |m| { date: m.date, message: m.message, user: m.user.name, color: m.user.color }}
  end
end

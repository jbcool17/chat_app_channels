class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  # validates :user, presence: true

  # def self.live
  #   Message.where(chat_type: 'live')
  # end

  # def self.manual
  #   Message.where(chat_type: 'manual')
  # end

  # def self.websockets
  #   Message.where(chat_type: 'websockets')
  # end
end

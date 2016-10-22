class Message < ActiveRecord::Base
  validates_presence_of :user

  def self.live
  	Message.where(chat_type: 'live')
  end

  def self.manual
  	Message.where(chat_type: 'manual')
  end

  def self.websockets
  	Message.where(chat_type: 'websockets')
  end
end
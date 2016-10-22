class Message < ActiveRecord::Base
  validates_presence_of :user
end
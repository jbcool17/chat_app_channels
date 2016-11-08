class Channel < ActiveRecord::Base
  has_many :messages

  validates :name, uniqueness: true

end

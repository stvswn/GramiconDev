class Interaction < ActiveRecord::Base
  has_many :messages
  has_one :rating
  belongs_to :message
  
  attr_accessible :message_id # interaction initiating message
end
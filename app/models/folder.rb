class Folder < ActiveRecord::Base
  has_many :messages
  attr_accessible :name
  before_save :ensure_name

  validates :user_id, :presence => true

  def ensure_name
    self.name = "unnamed folder" if self.name.blank?
  end

  # def to_param
  #   "#{self.id}-#{self.name}"
  # end

end

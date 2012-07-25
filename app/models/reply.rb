class Reply < Message
  attr_accessible :title
  belongs_to :responded_to, :class_name => 'Message'

  validates :responded_to_id, :presence => true
  validate :can_reply
  before_save :set_interaction

  def set_interaction
    if !interaction_id
      puts "NO INTERATCION"
      self.interaction_id = Message.find(self.responded_to_id).interaction.id
    end
  end

  private
  def can_reply
     errors.add(:responded_to_id, "has already expired") unless self.responded_to.can_reply?
  end

end
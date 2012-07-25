class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  # belongs_to :thread
  belongs_to :folder
  has_one :reply, :foreign_key => 'responded_to_id'
  belongs_to :interaction

  default_scope :order => 'created_at DESC'

  before_save :folder_id_filter
  before_save :set_interaction
  after_create :set_interaction_message

  validates :recipient_id, :sender_id, :body, :credits, :presence => true 
  # validates :responded_to_id, :presence => false 
  validates :credits, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => 1000000000 }

  attr_accessible :title, :body, :recipient_id, :folder_id #:thread_id, 


  state_machine :state, :initial => :new do
    after_transition :on => :send_off, :do => :deduct_credits_from_sender
    after_transition :on => :open_it, :do => :credit_recipient
    after_transition :on => :dismiss, :do => :credit_back_to_sender
    after_transition :on => :expire, :do => :credit_back_to_sender

    event :send_off do
      transition :new => :sent
    end

    event :open_it do
      transition [:sent, :held] => :opened
    end

    event :hold do
      transition :sent => :held
    end

    event :dismiss do
      transition [:sent, :held] => :dismissed
    end

    event :expire do
      transition [:sent, :held] => :expired
    end

  end

  def deduct_credits_from_sender
    transaction = CreditTransaction.new(:amount => 0-credits, :action => 'deduct_credits_from_sender' )
    transaction.user_id    = sender_id
    transaction.message_id = id
    transaction.save!
  end

  def credit_recipient
    if !claim_expired?
      transaction = CreditTransaction.new(:amount => credits, :action => 'credit_recipient' )
      transaction.user_id    = recipient_id
      transaction.message_id = id
      transaction.save!
    end
  end

  def credit_back_to_sender
    transaction = CreditTransaction.new(:amount => credits, :action => 'credit_back_to_sender' )
    transaction.user_id    = sender_id
    transaction.message_id = id
    transaction.save!
  end

  def set_interaction
    if !interaction_id && !is_reply?
      self.interaction_id = Interaction.create(:message_id => self.id).id
    end
  end

  def set_interaction_message
    if interaction_id && !interaction.message_id
      self.interaction.update_attributes(:message_id => self.id)
      self.interaction.save
    end
  end

  def claim_expired?
    claim_expiry_time.past?
  end

  def claim_expiry_time
    expiry_time = created_at + 1000000.seconds
  end

  def replied_to?
    reply
  end

  def reply_expired?
    reply_expiry_time.past?
  end

  def reply_expiry_time
    created_at + 500000.seconds
  end

  def folder_id_filter
    self.folder_id = nil if self.folder_id == 0
  end

  def unclaimed?
    !opened?
  end

  def rating
    interaction.rating if interaction
  end

  def is_reply?
    type=="Reply"
  end

  def can_reply?
    if type=="Message"
      if reply_expired? && !replied_to?
        return false
      end
    end
    return true
  end

end

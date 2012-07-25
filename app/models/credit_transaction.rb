class CreditTransaction < ActiveRecord::Base
	belongs_to :user
  attr_accessible :amount, :action

  after_create :update_user

  def update_user
  	self.user.credits = self.user.credits + self.amount 
  	self.user.save
  end

end

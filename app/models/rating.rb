class Rating < ActiveRecord::Base
  attr_accessible :user_id, :interaction_id, :rater_id, :value
  belongs_to :interaction
  belongs_to :user
  after_create :reload_ratingcache

  scope :positive, where(Rating.arel_table[:value].eq(true))
  scope :negative, where(Rating.arel_table[:value].eq(false))


  def reload_ratingcache
    self.user.rating_percentage
  end

end

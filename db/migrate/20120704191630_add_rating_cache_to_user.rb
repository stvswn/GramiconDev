class AddRatingCacheToUser < ActiveRecord::Migration
  def change
    add_column :users, :ratingcache, :integer
  end
end

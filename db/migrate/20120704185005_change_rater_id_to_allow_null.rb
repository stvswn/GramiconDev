class ChangeRaterIdToAllowNull < ActiveRecord::Migration
  def up
    change_column :ratings, :rater_id, :integer, :null => true
  end

  def down
    change_column :ratings, :rater_id, :integer, :null => false
  end
end

class RenameMessageIdToInteractionIdInRatings < ActiveRecord::Migration
  def up
    rename_column :ratings, :message_id, :interaction_id
  end

  def down
    rename_column :ratings, :interaction_id, :message_id
  end
end

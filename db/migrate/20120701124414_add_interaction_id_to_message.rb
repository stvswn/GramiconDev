class AddInteractionIdToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :interaction_id, :integer
  end
end

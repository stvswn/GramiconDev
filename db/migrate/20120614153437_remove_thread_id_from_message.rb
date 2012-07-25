class RemoveThreadIdFromMessage < ActiveRecord::Migration
  def up
  	remove_column :messages, :thread_id
  end

  def down
  	add_column :messages, :thread_id, :integer
  end
end

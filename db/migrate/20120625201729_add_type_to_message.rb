class AddTypeToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :type, :string, :null => false, :default => 'Message'
  	add_column :messages, :responded_to_id, :integer
  end
end

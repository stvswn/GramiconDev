class AddStateToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :state, :string, :null => false, :default => 'new'
    add_index :messages, :state
  end
end

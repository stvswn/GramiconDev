class AddCreditsToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :credits, :integer, :null => false, :default => 0
    add_index :messages, :credits
  end
end

class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :body, :null => false
      t.integer :sender_id, :null => false
      t.integer :recipient_id, :null => false
      t.integer :thread_id, :null => false
      t.integer :folder_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end

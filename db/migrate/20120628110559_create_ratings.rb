class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id, :null => false
      t.integer :message_id, :null => false
      t.integer :rater_id, :null => false
      t.boolean :value
      t.timestamps
    end

    add_index :ratings, :user_id
    add_index :ratings, :value
  end

  def self.down
    drop_table :ratings
  end
end

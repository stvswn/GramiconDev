class CreateInteraction < ActiveRecord::Migration
  def up
    create_table :interactions do |t|
      t.integer :message_id
      t.timestamps
    end
  end

  def down
    drop_table :interactions
  end
end

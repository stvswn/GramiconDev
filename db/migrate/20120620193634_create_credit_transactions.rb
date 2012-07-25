class CreateCreditTransactions < ActiveRecord::Migration
  def self.up
    create_table :credit_transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.integer :message_id
      t.string :action
      t.timestamps
    end

    add_index :credit_transactions, :user_id
  end

  def self.down
    drop_table :credit_transactions
  end
end

class CreateUserTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_transactions, id: :uuid do |t|
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.string :type_of
      t.string :receiver, null: true
      t.integer :amount
      t.string :code

      t.timestamps
    end
  end
end

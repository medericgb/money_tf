class CreateAgencyTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :agency_transactions, id: :uuid do |t|
      t.references :agency, null: false, foreign_key: true, type: :uuid
      t.string :type_of
      t.string :sender, null: true
      t.string :receiver, null: true
      t.integer :amount, null: :false
      t.integer :fee, default: 0
      t.string :code

      t.timestamps
    end
  end
end

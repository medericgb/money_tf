class CreateCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :costs, id: :uuid do |t|
      t.references :agency, null: false, foreign_key: true, type: :uuid
      t.integer :amount

      t.timestamps
    end
  end
end

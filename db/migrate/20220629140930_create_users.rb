class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end

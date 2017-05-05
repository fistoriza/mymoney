class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.string :entry
      t.integer :amount
      t.timestamps
    end
  end
end

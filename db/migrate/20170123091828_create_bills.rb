class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.date :invoice_date
      t.string :customer_name
      t.string :brand_manager
      t.string :narration
      t.integer :amount
      t.string :reference

      t.timestamps null: false
    end
  end
end

class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :amount
      t.string :reference
      t.date :collection_date
      t.integer :bill_id

      t.timestamps null: false
    end
  end
end

class CreateDiaperPurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :diaper_purchases do |t|
      t.date :purchased_at, null: false
      t.string :size, null: false
      t.integer :quantity, null: false
      t.string :brand
      t.text :notes

      t.timestamps
    end

    add_index :diaper_purchases, :purchased_at
    add_index :diaper_purchases, :size
  end
end

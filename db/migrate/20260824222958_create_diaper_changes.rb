class CreateDiaperChanges < ActiveRecord::Migration[8.1]
  def change
    create_table :diaper_changes do |t|
      t.datetime :occurred_at, null: false
      t.string :size, null: false
      t.text :notes

      t.timestamps
    end

    add_index :diaper_changes, :occurred_at
    add_index :diaper_changes, :size
  end
end

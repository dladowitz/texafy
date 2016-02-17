class CreateCheckedVariations < ActiveRecord::Migration
  def change
    create_table :checked_variations do |t|
      t.string :letters
      t.integer :position

      t.timestamps null: false
    end
  end
end

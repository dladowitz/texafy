class AddEntriesToCheckedVariations < ActiveRecord::Migration
  def change
    add_column :checked_variations, :entries, :integer
  end
end

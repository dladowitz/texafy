class CreateAcademics < ActiveRecord::Migration
  def change
    create_table :academics do |t|
      t.string :uta_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :employee_title
      t.string :role
      t.string :student_level
      t.string :college
      t.string :major
      t.string :phone

      t.timestamps null: false
    end
  end
end

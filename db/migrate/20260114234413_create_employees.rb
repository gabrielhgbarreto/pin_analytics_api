class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email
      t.string :corporate_email, null: false
      t.string :gender
      t.string :generation
      t.string :location
      t.string :tenure

      t.references :department, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
  end
end

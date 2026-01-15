class CreateDepartments < ActiveRecord::Migration[8.1]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.string :kind
      t.string :ancestry, index: true 

      t.timestamps
    end
  end
end

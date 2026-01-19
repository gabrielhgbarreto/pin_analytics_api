class AddUniqueIndexToDepartments < ActiveRecord::Migration[8.1]
  def change
    add_index :departments, [:name, :ancestry], unique: true, nulls_not_distinct: true
  end
end

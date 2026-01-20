class AddUniqueIndexToJobs < ActiveRecord::Migration[8.1]
  def change
    add_index :jobs, [ :title, :function_name ], unique: true
  end
end

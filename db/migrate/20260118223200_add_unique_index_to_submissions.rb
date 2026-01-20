class AddUniqueIndexToSubmissions < ActiveRecord::Migration[8.1]
  def change
    add_index :submissions, [ :employee_id, :responded_at ], unique: true
  end
end

class ChangeTenureToIntegerInEmployees < ActiveRecord::Migration[8.1]
  def change
    change_column :employees, :tenure, :integer, using: 'tenure::integer'
  end
end

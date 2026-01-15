class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :function_name, null: false

      t.timestamps
    end
  end
end

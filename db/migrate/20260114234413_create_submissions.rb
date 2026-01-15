class CreateSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :submissions do |t|
      t.datetime :responded_at, null: false
      t.string :snapshot_department_name
      t.string :snapshot_job_title

      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end

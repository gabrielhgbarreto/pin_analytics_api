class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.string :category
      t.string :question_type, null: false
      t.boolean :active, default: true
      
      t.timestamps
    end
  end
end

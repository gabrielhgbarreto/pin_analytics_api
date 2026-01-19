class AddUniqueIndexToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_index :questions, :text, unique: true
  end
end

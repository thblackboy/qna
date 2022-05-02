class CreateQuestionSubscribers < ActiveRecord::Migration[6.1]
  def change
    create_table :question_subscribers do |t|

      t.references :question, null: false, foreign_key: true
      t.references :subscriber, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

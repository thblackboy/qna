class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :voter, null: false, foreign_key: {to_table: :users}
      t.belongs_to :votable, polymorphic: true
      t.integer :value

      t.timestamps
    end
  end
end

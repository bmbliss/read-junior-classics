class CreateChildren < ActiveRecord::Migration[7.1]
  def change
    create_table :children do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :grade_level

      t.timestamps
    end
  end
end

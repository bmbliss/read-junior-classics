class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.integer :min_grade
      t.integer :max_grade
      t.text :description

      t.timestamps
    end
  end
end

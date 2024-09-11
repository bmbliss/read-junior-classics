class CreateLiteraryWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :literary_works do |t|
      t.string :title
      t.string :author
      t.string :work_type
      t.text :description

      t.timestamps
    end
  end
end

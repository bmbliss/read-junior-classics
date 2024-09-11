class CreateProgramItems < ActiveRecord::Migration[7.1]
  def change
    create_table :program_items do |t|
      t.references :program, null: false, foreign_key: true
      t.references :literary_work, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end

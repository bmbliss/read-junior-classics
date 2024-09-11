class CreateReadingEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :reading_entries do |t|
      t.references :child, null: false, foreign_key: true
      t.references :literary_work, null: false, foreign_key: true
      t.string :status
      t.date :date_read
      t.text :notes

      t.timestamps
    end
  end
end

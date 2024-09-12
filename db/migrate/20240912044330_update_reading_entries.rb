class UpdateReadingEntries < ActiveRecord::Migration[7.1]
  def change
    add_reference :reading_entries, :program_enrollment, null: false, foreign_key: true
    add_column :reading_entries, :rating, :integer
    remove_reference :reading_entries, :child, foreign_key: true
  end
end

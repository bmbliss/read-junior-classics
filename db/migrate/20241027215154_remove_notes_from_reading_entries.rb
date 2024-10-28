class RemoveNotesFromReadingEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :reading_entries, :notes, :text
  end
end

class RemoveProgramFromReadingEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :reading_entries, :program_id
  end
end

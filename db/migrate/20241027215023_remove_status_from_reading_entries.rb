class RemoveStatusFromReadingEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :reading_entries, :status, :integer
  end
end

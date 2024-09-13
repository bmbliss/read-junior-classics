class AddStatusToReadingEntries < ActiveRecord::Migration[7.0]
  def change
    remove_column :reading_entries, :status
    add_column :reading_entries, :status, :integer, default: 0
  end
end

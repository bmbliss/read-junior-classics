class AddUniqueIndexToReadingEntries < ActiveRecord::Migration[7.2]
  def change
    # First remove any duplicates
    ReadingEntry.group(:literary_work_id, :reader_type, :reader_id)
               .having('count(*) > 1')
               .pluck(:literary_work_id, :reader_type, :reader_id)
               .each do |work_id, reader_type, reader_id|
      entries = ReadingEntry.where(
        literary_work_id: work_id,
        reader_type: reader_type,
        reader_id: reader_id
      ).order(updated_at: :desc)
      
      # Keep the most recently updated entry
      keep_entry = entries.first
      entries.where.not(id: keep_entry.id).destroy_all
    end

    # Add the unique index
    add_index :reading_entries, [:literary_work_id, :reader_type, :reader_id], 
              unique: true,
              name: 'index_reading_entries_uniqueness'
  end
end

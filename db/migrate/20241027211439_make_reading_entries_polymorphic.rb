class MakeReadingEntriesPolymorphic < ActiveRecord::Migration[7.2]
  def change
    remove_reference :reading_entries, :child
    add_reference :reading_entries, :reader, polymorphic: true
  end
end

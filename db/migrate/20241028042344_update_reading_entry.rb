class UpdateReadingEntry < ActiveRecord::Migration[7.2]
  def up
    # First update existing records with null ratings
    execute <<-SQL
      UPDATE reading_entries 
      SET rating = 0 
      WHERE rating IS NULL
    SQL

    change_table :reading_entries do |t|
      # Make rating required
      t.change :rating, :integer, null: false
      
      # Make reader polymorphic association required
      t.change :reader_type, :string, null: false
      t.change :reader_id, :bigint, null: false
      
      # Make date_read required and default to current date
      t.change :date_read, :datetime, null: false, default: -> { 'CURRENT_DATE' }
    end
  end

  def down
    change_table :reading_entries do |t|
      t.change :rating, :integer, null: true
      t.change :reader_type, :string, null: true
      t.change :reader_id, :bigint, null: true
      t.change :date_read, :date, null: true, default: nil
    end
  end
end

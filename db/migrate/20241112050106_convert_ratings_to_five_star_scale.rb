class ConvertRatingsToFiveStarScale < ActiveRecord::Migration[7.2]
  def up
    # First, create a temporary backup of current ratings
    add_column :reading_entries, :old_rating, :integer

    # Backup current ratings
    execute <<-SQL
      UPDATE reading_entries 
      SET old_rating = rating 
      WHERE rating IS NOT NULL
    SQL

    # Convert ratings from 10 to 5 scale (rounding up)
    execute <<-SQL
      UPDATE reading_entries 
      SET rating = CEIL(CAST(rating AS DECIMAL) / 2)
      WHERE rating IS NOT NULL
    SQL
  end

  def down
    # Convert ratings back to 10 scale
    execute <<-SQL
      UPDATE reading_entries 
      SET rating = old_rating
      WHERE old_rating IS NOT NULL
    SQL

    remove_column :reading_entries, :old_rating
  end
end

class AddEstimatedReadingTimeToLiteraryWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :literary_works, :estimated_reading_time, :integer, default: 0
  end
end

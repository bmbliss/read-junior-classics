class Collection < ApplicationRecord
  has_and_belongs_to_many :literary_works

  def total_reading_time
    total_min = literary_works.sum(:estimated_reading_time)
    total_hours = (total_min / 60).floor
    total_minutes = total_min % 60
    "#{total_hours} hr #{total_minutes} min"
  end
end

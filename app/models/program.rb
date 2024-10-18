class Program < ApplicationRecord
  has_many :program_items
  has_many :literary_works, through: :program_items
  
  validates :name, presence: true
  validates :recommended_grade, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }

  def total_reading_time
    total_min = literary_works.sum(:estimated_reading_time)
    total_hours = (total_min / 60).floor
    total_minutes = total_min % 60
    "#{total_hours} hr #{total_minutes} min"
  end
end

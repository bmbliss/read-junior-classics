class Program < ApplicationRecord
  has_many :program_items
  
  validates :name, presence: true
  validates :min_grade, :max_grade, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }
end

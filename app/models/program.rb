class Program < ApplicationRecord
  has_many :program_items
  has_many :literary_works, through: :program_items
  
  validates :name, presence: true
  validates :recommended_grade, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }
end

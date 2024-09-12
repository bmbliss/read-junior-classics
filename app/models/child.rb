class Child < ApplicationRecord
  belongs_to :user
  has_many :program_enrollments
  has_many :reading_entries, through: :program_enrollments
  
  validates :name, presence: true
  validates :grade_level, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }
end

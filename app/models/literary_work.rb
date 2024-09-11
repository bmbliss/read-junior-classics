class LiteraryWork < ApplicationRecord
  has_many :reading_entries
  
  validates :title, presence: true
  validates :work_type, presence: true
end

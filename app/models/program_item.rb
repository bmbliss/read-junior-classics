class ProgramItem < ApplicationRecord
  belongs_to :program
  belongs_to :literary_work

  # validates :order, presence: true, numericality: { greater_than_or_equal_to: 1 }
end

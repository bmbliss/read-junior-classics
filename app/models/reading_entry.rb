class ReadingEntry < ApplicationRecord
  belongs_to :program_enrollment
  belongs_to :literary_work
  has_one :child, through: :program_enrollment
  has_one :user, through: :child

  enum status: { in_progress: 0, completed: 1 }

  scope :completed, -> { where(status: :completed) }

  validates :status, presence: true
  validates :date_read, presence: true
  validates :rating, inclusion: { in: 1..10 }, allow_nil: true
end

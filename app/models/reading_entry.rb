class ReadingEntry < ApplicationRecord
  belongs_to :reader, polymorphic: true
  belongs_to :literary_work
  belongs_to :program, optional: true  # Optional because you might read works outside of programs

  validates :status, presence: true
  validates :date_read, presence: true
  validates :rating, inclusion: { in: 1..10 }, allow_nil: true
end

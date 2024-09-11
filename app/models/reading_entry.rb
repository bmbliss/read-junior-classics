class ReadingEntry < ApplicationRecord
  belongs_to :child
  belongs_to :literary_work

  validates :status, presence: true
  validates :date_read, presence: true
end

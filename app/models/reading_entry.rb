class ReadingEntry < ApplicationRecord
  belongs_to :reader, polymorphic: true
  belongs_to :literary_work

  validates :date_read, presence: true
  validates :rating, inclusion: { in: 1..10 }

  before_validation :set_default_date_read

  private

  def set_default_date_read
    self.date_read ||= Date.current
  end
end

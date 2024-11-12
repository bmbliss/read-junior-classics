class ReadingEntry < ApplicationRecord
  belongs_to :reader, polymorphic: true
  belongs_to :literary_work

  validates :date_read, presence: true
  validates :rating, inclusion: { in: 1..5 }
  validates :literary_work_id, uniqueness: { scope: [:reader_type, :reader_id],
    message: "has already been rated by this reader" }

  before_validation :set_default_date_read

  private

  def set_default_date_read
    self.date_read ||= Date.current
  end
end

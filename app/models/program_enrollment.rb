class ProgramEnrollment < ApplicationRecord
  belongs_to :child
  belongs_to :program
  has_many :reading_entries

  validates :child_id, uniqueness: { scope: :program_id, message: "is already enrolled in this program" }

  def progress_percentage
    total_works = program.literary_works.count
    completed_works = reading_entries.where(status: 'completed').count
    (completed_works.to_f / total_works * 100).round
  end
end

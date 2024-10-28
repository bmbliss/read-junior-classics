class Child < ApplicationRecord
  belongs_to :user
  has_many :reading_entries, as: :reader
  has_many :read_works, through: :reading_entries, source: :literary_work
  
  validates :name, presence: true
  validates :grade_level, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }

  def programs_with_progress
    Program.joins(literary_works: :reading_entries)
          .where(reading_entries: { reader: self })
          .distinct
  end

  def progress_in_program(program)
    total_works = program.literary_works.count
    return 0 if total_works.zero?

    completed_works = reading_entries
      .joins(literary_work: :program_items)
      .where(program_items: { program_id: program.id })
      .distinct
      .count(:literary_work_id)

    (completed_works.to_f / total_works * 100).round
  end

  def recent_readings_for_program(program, limit: 5)
    reading_entries
      .joins(literary_work: :program_items)
      .where(program_items: { program_id: program.id })
      .order(date_read: :desc)
      .limit(limit)
  end
end

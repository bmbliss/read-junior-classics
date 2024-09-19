class LiteraryWork < ApplicationRecord
  has_and_belongs_to_many :collections
  has_many :reading_entries
  has_many :program_items
  has_many :programs, through: :program_items
  
  validates :title, presence: true
  validates :work_type, presence: true
  
  enum work_type: {
    story: 0,
    poem: 1,
    essay: 2,
    fairy_tale: 3,
    myth: 4,
    legend: 5,
    folk_tale: 6,
    biography: 7,
    historical_account: 8,
    other: 9
  }

  def self.without_collections
    left_outer_joins(:collections).where(collections: { id: nil })
  end

  def average_rating
    reading_entries.where.not(rating: nil).average(:rating)&.round(1) || 0
  end

  def total_ratings
    reading_entries.where.not(rating: nil).count
  end
end

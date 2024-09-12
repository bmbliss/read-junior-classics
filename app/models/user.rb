class User < ApplicationRecord
  include ReviseAuth::Model

  has_many :children
  has_many :program_enrollments, through: :children
  has_many :reading_entries, through: :program_enrollments
end

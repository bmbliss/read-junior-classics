class User < ApplicationRecord
  include ReviseAuth::Model

  has_many :children, dependent: :destroy
  has_many :reading_entries, as: :reader
  has_many :read_works, through: :reading_entries, source: :literary_work
end

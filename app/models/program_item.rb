class ProgramItem < ApplicationRecord
  belongs_to :program
  belongs_to :literary_work
end

class User < ApplicationRecord
  include ReviseAuth::Model

  has_many :children
end

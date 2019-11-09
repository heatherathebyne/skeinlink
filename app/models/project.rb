class Project < ApplicationRecord
  belongs_to :craft
  has_many_attached :images
end

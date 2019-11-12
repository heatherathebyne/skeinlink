class Project < ApplicationRecord
  belongs_to :craft
  has_many_attached :images
  has_many :journal_entries
end

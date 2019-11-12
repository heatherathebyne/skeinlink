class Project < ApplicationRecord
  CRAFT_TYPE_MAPPING = { 1 => 'knitting', 2 => 'crocheting', 3 => 'weaving', 4 => 'spinning' }.freeze

  belongs_to :craft
  has_many_attached :images
  has_many :journal_entries
end

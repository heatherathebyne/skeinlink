class PatternPublisher < ApplicationRecord
  audited

  has_many :pattern_pattern_publishers
  has_many :patterns, through: :pattern_pattern_publishers
end

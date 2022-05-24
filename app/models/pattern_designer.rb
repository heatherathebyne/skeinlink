class PatternDesigner < ApplicationRecord
  audited

  has_many :pattern_pattern_designers
  has_many :patterns, through: :pattern_pattern_designers
end

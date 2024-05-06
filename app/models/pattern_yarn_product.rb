class PatternYarnProduct < ApplicationRecord
  audited

  has_one :pattern
  has_one :yarn_product
end

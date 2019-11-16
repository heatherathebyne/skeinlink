# Yarn is a reserved word these days
class YarnProduct < ApplicationRecord
  belongs_to :yarn_company
  has_many :colorways, inverse_of: :yarn_product
  validates :name, presence: true
end

class Colorway < ApplicationRecord
  belongs_to :yarn_product
  has_many :stash_yarns, inverse_of: :colorway
  validates :name, :yarn_product, presence: true
end

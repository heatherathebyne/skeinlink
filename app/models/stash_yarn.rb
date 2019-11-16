class StashYarn < ApplicationRecord
  belongs_to :yarn_product, optional: true
  belongs_to :colorway, optional: true
  belongs_to :user
  has_one_attached :image
  validates :name, presence: true
end

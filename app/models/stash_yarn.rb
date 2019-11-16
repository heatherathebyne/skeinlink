class StashYarn < ApplicationRecord
  belongs_to :yarn_product
  belongs_to :colorway
  belongs_to :user
  validates :name, :user, presence: true
end

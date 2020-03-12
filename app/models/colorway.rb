class Colorway < ApplicationRecord
  include ImageTools

  belongs_to :yarn_product
  has_many :stash_yarns, inverse_of: :colorway
  has_one_attached :image
  validates :name, :yarn_product, presence: true

  def default_image_owner
    yarn_product.yarn_company.name
  end
end

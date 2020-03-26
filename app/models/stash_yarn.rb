class StashYarn < ApplicationRecord
  include YarnWeight
  include ImageTools

  belongs_to :yarn_product, optional: true
  belongs_to :colorway, optional: true
  belongs_to :user
  has_one_attached :image
  validate :has_a_name_or_product
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                     size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }

  def name
    yarn_product.try(:name) || super
  end

  def colorway_name
    colorway.try(:name) || super
  end

  def weight_name
    yarn_product.try(:common_weight) || common_weight
  end

  def default_image_owner
    user.name
  end

  private

  def has_a_name_or_product
    unless name || yarn_product
      errors.add(:name, 'or yarn must be selected')
    end
  end
end

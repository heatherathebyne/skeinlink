class StashYarn < ApplicationRecord
  YARN_MAKER_SELF = 1
  YARN_MAKER_UNKNOWN = 2

  include YarnWeight
  include ImageTools

  audited

  belongs_to :yarn_product, optional: true
  belongs_to :colorway, optional: true
  belongs_to :user
  has_one_attached :image
  validate :has_a_name_or_product
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                    size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }
  validates :other_maker_type, inclusion: { in: 0..2 }, allow_nil: true

  def name
    yarn_product.try(:name_with_company) || super
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

  def self_made?
    other_maker_type == 1
  end

  def maker_unknown?
    other_maker_type == 2
  end

  private

  def has_a_name_or_product
    unless name || yarn_product
      errors.add(:name, 'or yarn must be selected')
    end
  end
end

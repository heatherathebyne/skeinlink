# Yarn is a reserved word these days
class YarnProduct < ApplicationRecord
  include YarnWeight
  include ImageTools

  acts_as_taggable_on :fiber_content

  belongs_to :yarn_company, optional: true
  has_many :colorways, inverse_of: :yarn_product
  has_one_attached :image
  validates :name, presence: true
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                     size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }

  def name_with_company
    "#{yarn_company.try(:name)} #{name}"
  end

  def default_image_owner
    yarn_company.name
  end
end

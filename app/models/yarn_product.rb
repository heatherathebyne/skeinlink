# Yarn is a reserved word these days
class YarnProduct < ApplicationRecord
  include YarnWeight
  include ImageTools

  belongs_to :yarn_company, optional: true
  has_many :colorways, inverse_of: :yarn_product
  has_one_attached :image
  validates :name, presence: true
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                     size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }

  before_save :replace_image_filename

  def name_with_company
    "#{yarn_company.try(:name)} #{name}"
  end
end

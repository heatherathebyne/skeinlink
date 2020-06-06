# Yarn is a reserved word these days
class YarnProduct < ApplicationRecord
  include YarnWeight
  include ImageTools

  audited

  acts_as_taggable_on :fiber_content

  belongs_to :yarn_company, optional: true # y tho
  has_many :colorways, inverse_of: :yarn_product
  has_one_attached :image
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                     size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }

  def name_with_company
    if yarn_company&.name
      "#{yarn_company.name} #{name}"
    else
      name
    end
  end

  def default_image_owner
    yarn_company_name
  end

  def yarn_company_name
    yarn_company&.name || ''
  end
end

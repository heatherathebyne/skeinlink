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

  before_save :fix_referral_link

  scope :newest, -> { order id: :desc }
  scope :oldest, -> { order id: :asc }
  scope :yarn_name_a_z, -> { order name: :asc }
  scope :yarn_name_z_a, -> { order name: :desc }
  scope :yarn_maker_name_a_z, -> {
    left_outer_joins(:yarn_company).includes(:yarn_company)
      .order('yarn_companies.name ASC, yarn_products.name ASC')
  }
  scope :yarn_maker_name_z_a, -> {
    left_outer_joins(:yarn_company).includes(:yarn_company)
      .order('yarn_companies.name DESC, yarn_products.name DESC')
  }

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

  private

  def fix_referral_link
    self.referral_link = ::Addressable::URI.heuristic_parse(referral_link).to_s
  end
end

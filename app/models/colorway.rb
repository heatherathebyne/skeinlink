class Colorway < ApplicationRecord
  include ImageTools

  audited

  belongs_to :yarn_product
  has_many :stash_yarns, inverse_of: :colorway
  has_one_attached :image
  validates :yarn_product, presence: true
  validates :name, uniqueness: { scope: :yarn_product_id, case_sensitive: false }, unless: -> { name.blank? }
  validates :number, uniqueness: { scope: :yarn_product_id, case_sensitive: false }, unless: -> { number.blank? }
  validate :name_or_number_present

  def default_image_owner
    yarn_product.yarn_company_name
  end

  def name_with_number
    [number, name].join(' ').strip
  end

  private

  def name_or_number_present
    errors.add(:name, 'Please add either a Name or a Number') unless name.present? || number.present?
  end
end

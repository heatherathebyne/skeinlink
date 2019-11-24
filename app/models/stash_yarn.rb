class StashYarn < ApplicationRecord
  include YarnWeight

  belongs_to :yarn_product, optional: true
  belongs_to :colorway, optional: true
  belongs_to :user
  has_one_attached :image
  validate :has_a_name_or_product

  def name
    yarn_product.try(:name_with_company) || super
  end

  def weight_name
    yarn_product.try(:common_weight) || common_weight
  end

  private

  def has_a_name_or_product
    unless name || yarn_product
      errors.add(:name, 'or yarn must be selected')
    end
  end
end

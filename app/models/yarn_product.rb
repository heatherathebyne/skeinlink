# Yarn is a reserved word these days
class YarnProduct < ApplicationRecord
  belongs_to :yarn_company, optional: true
  has_many :colorways, inverse_of: :yarn_product
  has_one_attached :image
  validates :name, presence: true

  def name_with_company
    "#{yarn_company.try(:name)} #{name}"
  end
end

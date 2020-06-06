class YarnCompany < ApplicationRecord
  audited

  has_many :yarn_products, inverse_of: :yarn_company
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

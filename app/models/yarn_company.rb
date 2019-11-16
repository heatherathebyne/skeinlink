class YarnCompany < ApplicationRecord
  has_many :yarn_products, inverse_of: :yarn_company
  validates :name, presence: true
end

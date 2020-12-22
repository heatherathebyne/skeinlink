class YarnCompany < ApplicationRecord
  audited

  has_many :yarn_products, inverse_of: :yarn_company
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_save :fix_referral_link

  private

  def fix_referral_link
    self.referral_link = ::Addressable::URI.heuristic_parse(referral_link).to_s
  end
end

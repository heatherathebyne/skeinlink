class Pattern < ApplicationRecord
  include ImageTools

  audited

  has_one :user
  has_many :pattern_pattern_designers
  has_many :pattern_designers, through: :pattern_pattern_designers
  has_many :pattern_pattern_publishers
  has_many :pattern_publishers, through: :pattern_pattern_publishers
  has_many :pattern_yarn_products
  has_many :yarn_products, through: :pattern_yarn_products
  has_many :pattern_projects
  has_many :projects, through: :pattern_projects
end

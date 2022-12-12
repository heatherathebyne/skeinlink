class StashYarn < ApplicationRecord
  YARN_MAKER_SELF = 1
  YARN_MAKER_UNKNOWN = 2

  include YarnWeight
  include ImageTools

  audited

  belongs_to :yarn_product, optional: true
  belongs_to :colorway, optional: true
  belongs_to :user
  has_one_attached :image
  has_many :stash_usages
  has_many :projects, through: :stash_usages

  validate :has_a_name_or_product
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif],
                                    message: 'is not a PNG, JPG, or GIF image' },
                    size: { less_than: 15.megabytes,
                            message: 'Whoa, that image is too big! Try one that is smaller than 15 MB.' }
  validates :other_maker_type, inclusion: { in: 0..2 }, allow_nil: true
  validates :dye_lot, length: { maximum: 255 }

  scope :newest, -> { order id: :desc }
  scope :oldest, -> { order id: :asc }

  scope :sort_by_yarn_name_asc, -> {
    select(
      'stash_yarns.*, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name '\
      'END) AS sortable_name'
    )
      .left_outer_joins(:yarn_product)
      .includes(yarn_product: :yarn_company)
      .order('sortable_name ASC')
  }

  scope :sort_by_yarn_name_desc, -> {
    select(
      'stash_yarns.*, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name '\
      'END) AS sortable_name'
    )
      .left_outer_joins(:yarn_product)
      .includes(yarn_product: :yarn_company)
      .order('sortable_name DESC')
  }

  # Sort first by maker name, then by yarn product name,
  # interleaving stash without yarn product as if it was a maker name
  scope :sort_by_yarn_maker_name_asc, -> {
    select(
      'stash_yarns.*, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name '\
      'END) AS sortable_name, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_companies.name '\
      'END) AS maker_name'
    )
      .left_outer_joins(yarn_product: :yarn_company)
      .includes(yarn_product: :yarn_company)
      .order('maker_name ASC, sortable_name ASC')
  }

  scope :sort_by_yarn_maker_name_desc, -> {
    select(
      'stash_yarns.*, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name '\
      'END) AS sortable_name, '\
      '(CASE '\
        'WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_companies.name '\
      'END) AS maker_name'
    )
      .left_outer_joins(yarn_product: :yarn_company)
      .includes(yarn_product: :yarn_company)
      .order('maker_name DESC, sortable_name DESC')
  }

  def name
    yarn_product.try(:name_with_company) || super
  end

  def colorway_name
    colorway.try(:name) || super
  end

  def weight_name
    yarn_product.try(:common_weight) || common_weight
  end

  def default_image_owner
    user.name
  end

  def self_made?
    other_maker_type == 1
  end

  def maker_unknown?
    other_maker_type == 2
  end

  def total_yardage
    if yarn_product.try(:skein_yards) && skein_quantity
      yarn_product.skein_yards * skein_quantity
    else
      super
    end
  end

  private

  def has_a_name_or_product
    unless name || yarn_product
      errors.add(:name, 'or yarn must be selected')
    end
  end
end

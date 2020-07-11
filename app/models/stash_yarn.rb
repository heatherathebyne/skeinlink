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

  validate :has_a_name_or_product
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                    size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }
  validates :other_maker_type, inclusion: { in: 0..2 }, allow_nil: true
  validates :dye_lot, length: { maximum: 255 }

  scope :newest, -> { order id: :desc }
  scope :oldest, -> { order id: :asc }

  scope :yarn_name_a_z, -> {
    select(
      'stash_yarns.id, stash_yarns.yarn_product_id, stash_yarns.colorway_id, stash_yarns.user_id, '\
      'stash_yarns.name, stash_yarns.colorway_name, stash_yarns.purchase_date, '\
      'stash_yarns.purchased_at_name, stash_yarns.purchase_price, stash_yarns.skein_quantity, '\
      'stash_yarns.total_yardage, stash_yarns.created_at, stash_yarns.updated_at, '\
      'stash_yarns.notes, stash_yarns.handspun, stash_yarns.weight_id, '\
      'stash_yarns.other_maker_type, stash_yarns.dye_lot, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name END) AS name'
    )
      .from('stash_yarns LEFT OUTER JOIN yarn_products ON yarn_products.id = stash_yarns.yarn_product_id')
      .includes({ yarn_product: :yarn_company })
      .includes(:colorway)
      .with_attached_image
      .order('name ASC') # this exact string ensures we count yarn product name in the sort
  }

  scope :yarn_name_z_a, -> {
    select(
      'stash_yarns.id, stash_yarns.yarn_product_id, stash_yarns.colorway_id, stash_yarns.user_id, '\
      'stash_yarns.name, stash_yarns.colorway_name, stash_yarns.purchase_date, '\
      'stash_yarns.purchased_at_name, stash_yarns.purchase_price, stash_yarns.skein_quantity, '\
      'stash_yarns.total_yardage, stash_yarns.created_at, stash_yarns.updated_at, '\
      'stash_yarns.notes, stash_yarns.handspun, stash_yarns.weight_id, '\
      'stash_yarns.other_maker_type, stash_yarns.dye_lot, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name END) AS name'
    )
      .from('stash_yarns LEFT OUTER JOIN yarn_products ON yarn_products.id = stash_yarns.yarn_product_id')
      .includes({ yarn_product: :yarn_company })
      .includes(:colorway)
      .with_attached_image
      .order('name DESC') # this exact string ensures we count yarn product name in the sort
  }

  # Sort first by maker name, then by yarn product name,
  # interleaving stash without yarn product as if it was a maker name
  scope :yarn_maker_name_a_z, -> {
    select(
      'stash_yarns.id, stash_yarns.yarn_product_id, stash_yarns.colorway_id, stash_yarns.user_id, '\
      'stash_yarns.name, stash_yarns.colorway_name, stash_yarns.purchase_date, '\
      'stash_yarns.purchased_at_name, stash_yarns.purchase_price, stash_yarns.skein_quantity, '\
      'stash_yarns.total_yardage, stash_yarns.created_at, stash_yarns.updated_at, '\
      'stash_yarns.notes, stash_yarns.handspun, stash_yarns.weight_id, '\
      'stash_yarns.other_maker_type, stash_yarns.dye_lot, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name END) AS name, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_companies.name END) AS maker_name'
    )
      .from('stash_yarns LEFT OUTER JOIN yarn_products ON yarn_products.id = stash_yarns.yarn_product_id LEFT OUTER JOIN yarn_companies ON yarn_companies.id = yarn_products.yarn_company_id')
      .includes({ yarn_product: :yarn_company })
      .includes(:colorway)
      .with_attached_image
      .order('maker_name ASC, name ASC') # this exact string ensures we count yarn product name in the sort
  }

  scope :yarn_maker_name_z_a, -> {
    select(
      'stash_yarns.id, stash_yarns.yarn_product_id, stash_yarns.colorway_id, stash_yarns.user_id, '\
      'stash_yarns.name, stash_yarns.colorway_name, stash_yarns.purchase_date, '\
      'stash_yarns.purchased_at_name, stash_yarns.purchase_price, stash_yarns.skein_quantity, '\
      'stash_yarns.total_yardage, stash_yarns.created_at, stash_yarns.updated_at, '\
      'stash_yarns.notes, stash_yarns.handspun, stash_yarns.weight_id, '\
      'stash_yarns.other_maker_type, stash_yarns.dye_lot, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_products.name END) AS name, '\
      '(CASE WHEN stash_yarns.yarn_product_id IS NULL THEN stash_yarns.name ELSE yarn_companies.name END) AS maker_name'
    )
      .from('stash_yarns LEFT OUTER JOIN yarn_products ON yarn_products.id = stash_yarns.yarn_product_id LEFT OUTER JOIN yarn_companies ON yarn_companies.id = yarn_products.yarn_company_id')
      .includes({ yarn_product: :yarn_company })
      .includes(:colorway)
      .with_attached_image
      .order('maker_name DESC, name DESC') # this exact string ensures we count yarn product name in the sort
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

  private

  def has_a_name_or_product
    unless name || yarn_product
      errors.add(:name, 'or yarn must be selected')
    end
  end
end

class Project < ApplicationRecord
  CRAFT_TYPE_MAPPING = { 1 => 'knitting', 2 => 'crocheting', 3 => 'weaving', 4 => 'spinning' }.freeze

  include ImageTools

  audited

  belongs_to :craft
  has_many_attached :images
  has_many :journal_entries
  belongs_to :user
  has_many :stash_usages
  has_many :stash_yarns, through: :stash_usages

  validates :images, content_type: { in: [:png, :jpg, :jpeg, :gif], message: 'is not a PNG, JPG, or GIF image' },
                     size: { less_than: 15.megabytes, message: "Whoa, that image is too big! Try one that is smaller than 15 MB." }
  validates :name, presence: true

  scope :newest, -> { order id: :desc }
  scope :oldest, -> { order id: :asc }
  scope :name_a_z, -> { order name: :asc }
  scope :name_z_a, -> { order name: :desc }

  serialize :image_order, Array

  def self.public_for_user(user_id)
    where(user_id: user_id, publicly_visible: true)
  end

  def default_image_owner
    user.name
  end
end

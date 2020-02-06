class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :trackable, :timeoutable, :validatable

  has_many :projects

  validates :name, :active, presence: true

  def superadmin?
    role_superadmin
  end

  def admin?
    role_admin || role_superadmin
  end

  def maintainer?
    role_maintainer || role_admin || role_superadmin
  end

  def moderator?
    role_moderator || role_admin || role_superadmin
  end

  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    active ? super : 'This account is inactive.'
  end
end

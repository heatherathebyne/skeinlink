class User < ApplicationRecord
  audited except: [:encrypted_password, :reset_password_token, :confirmation_token, :unlock_token,
                   :remember_created_at]

  devise :database_authenticatable, :rememberable, :recoverable, :lockable,
         :trackable, :timeoutable, :validatable, :confirmable

  has_many :projects
  has_many :stash_yarns
  has_many :patterns

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

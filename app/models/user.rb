class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :trackable, :timeoutable, :validatable

  has_many :projects

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
end

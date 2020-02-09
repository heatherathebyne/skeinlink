class YarnProductPolicy < ApplicationPolicy
  def create?
    user.maintainer?
  end

  def update?
    user.maintainer?
  end
end

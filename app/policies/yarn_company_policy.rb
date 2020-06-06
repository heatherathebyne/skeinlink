class YarnCompanyPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    return true if user.maintainer?
    record_age = Time.current - record.created_at
    record.created_by == user.id && record_age <= 8.days
  end

  def edit_referral_links?
    user.maintainer?
  end
end

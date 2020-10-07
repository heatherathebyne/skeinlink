class StashUsagePolicy < ApplicationPolicy
  def create?
    user.projects.where(id: record.project_id).any? && user.stash_yarns.where(id: record.stash_yarn_id).any?
  end

  def destroy?
    create?
  end
end

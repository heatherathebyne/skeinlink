module ApplicationHelper
  def current_users_project?
    @project.user_id == current_user.id
  end

  def belongs_to_current_user?(something)
    return false unless current_user and something.user_id
    current_user.id == something.user_id
  end
end

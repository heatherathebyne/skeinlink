module ApplicationHelper
  def current_users_project?
    @project.user_id == current_user.id
  end
end

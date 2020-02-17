module ApplicationHelper
  def current_users_project?
    @project.user_id == current_user.id
  end

  def belongs_to_current_user?(something)
    return false unless current_user and something.user_id
    current_user.id == something.user_id
  end

  def image_attribution_notice
    'Please only upload images which you own or which you have received permission to use :)'
  end
end

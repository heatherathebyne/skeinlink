module ApplicationHelper
  def current_users_project?
    @project.user_id == current_user.id
  end

  def belongs_to_current_user?(something)
    return false unless current_user and something.user_id
    current_user.id == something.user_id
  end

  def image_attribution(image)
    attribution_string = if image.attribution.blank?
                           "#{image.created_at.year} #{image&.record&.default_image_owner}"
                         else
                           image.attribution
                         end
    content_tag('small', "image ©#{attribution_string}", class: 'text-muted')
  end
end

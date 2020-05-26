class ApplicationController < ActionController::Base
  require 'mini_magick'
  include Pundit

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def require_superadmin
    unless current_user.superadmin?
      flash[:alert] = 'Hey now, that\'s superadmin territory!'
      redirect_back fallback_location: root_path, allow_other_host: false
      return
    end
  end

  def require_admin
    unless current_user.admin?
      flash[:alert] = 'Hey now, that\'s admin territory!'
      redirect_back fallback_location: root_path, allow_other_host: false
      return
    end
  end

  def require_maintainer
    unless current_user.maintainer?
      flash[:alert] = 'Only maintainers can change this.'
      redirect_back fallback_location: root_path, allow_other_host: false
      return
    end
  end

  def require_moderator
    throw :abort unless current_user.moderator?
  end

  def user_not_authorized
    flash[:alert] = "Sorry, but you don't have permission to do that."
    redirect_back fallback_location: root_path, allow_other_host: false
  end
end

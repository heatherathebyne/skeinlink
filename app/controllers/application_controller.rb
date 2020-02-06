class ApplicationController < ActionController::Base
  require 'mini_magick'
  include Pundit

  before_action :authenticate_user!

  private

  def require_superadmin
    unless current_user.superadmin?
      flash[:alert] = 'Hey now, that\'s superadmin territory!'
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def require_admin
    unless current_user.admin?
      flash[:alert] = 'Hey now, that\'s admin territory!'
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def require_maintainer
    throw :abort unless current_user.maintainer?
  end

  def require_moderator
    throw :abort unless current_user.moderator?
  end
end
